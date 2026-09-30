"""Generate approximate C from the package-specific PE binaries with RetDec.

Set RETDEC_EXE to an ASCII-only path to retdec-decompiler.exe. On this machine,
RetDec also needs RETDEC_DLL_DIR for OpenSSL 1.1. Never executes input drivers.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import tempfile
import time
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parents[1] / "原始工具" / "SZ50_AIR一键破解" / "紫光驱动"
OUTPUT = HERE / "recovered_c"
REPORT = HERE / "decompilation_report.json"
TARGETS = [
    "Drivers/amd64/rdavcom.sys",
    "Drivers/amd64/sprdvcom.sys",
    "Drivers/amd64/sprdvmdm.sys",
    "Drivers/i386/rdavcom.sys",
    "Drivers/i386/sprdvcom.sys",
    "Drivers/i386/sprdvmdm.sys",
    "DriverSetup.exe",
    "DriverUninstall32.exe",
    "DriverUninstall64.exe",
]
SELECTIVE_RANGES = {
    # Full MFC-linked EXEs are too large for a useful one-pass result. These
    # ranges cover the vendor code that calls SetupAPI removal functions.
    "DriverUninstall32.exe": "0x401000-0x403000",
    "DriverUninstall64.exe": "0x140001000-0x140004000",
}


def select_targets(group: str) -> list[str]:
    if group == "drivers":
        return [target for target in TARGETS if target.endswith(".sys")]
    if group == "programs":
        return [target for target in TARGETS if target.endswith(".exe")]
    return TARGETS


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--group", choices=("all", "drivers", "programs"), default="all")
    parser.add_argument("--force", action="store_true", help="Regenerate outputs that already exist")
    args = parser.parse_args()

    executable = os.environ.get("RETDEC_EXE") or shutil.which("retdec-decompiler.exe")
    if not executable or not Path(executable).is_file():
        raise SystemExit("Set RETDEC_EXE to retdec-decompiler.exe")
    environment = os.environ.copy()
    if environment.get("RETDEC_DLL_DIR"):
        environment["PATH"] = environment["RETDEC_DLL_DIR"] + os.pathsep + environment.get("PATH", "")
    work_root = environment.get("RETDEC_WORKDIR")

    OUTPUT.mkdir(exist_ok=True)
    (HERE / "decompilation_logs").mkdir(exist_ok=True)
    report = json.loads(REPORT.read_text(encoding="utf-8")) if REPORT.exists() else {}
    for existing in report.values():
        existing.setdefault("scope", "whole binary")
    REPORT.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    for relative in select_targets(args.group):
        source = SOURCE / relative
        name = relative.replace("/", "_")
        selected_range = SELECTIVE_RANGES.get(relative)
        destination = OUTPUT / (source.stem + "_core.c" if selected_range else name + ".c")
        digest = hashlib.sha256(source.read_bytes()).hexdigest()
        if destination.exists() and not args.force and report.get(relative, {}).get("input_sha256") == digest:
            print(f"SKIP {relative}: existing output", flush=True)
            continue

        print(f"DECOMPILE {relative}", flush=True)
        started = time.monotonic()
        with tempfile.TemporaryDirectory(prefix="unisoc_retdec_", dir=work_root) as temporary:
            stage = Path(temporary)
            staged_input = stage / ("input" + source.suffix.lower())
            staged_output = stage / "output.c"
            shutil.copyfile(source, staged_input)
            try:
                command = [executable, "--cleanup", "--silent"]
                if selected_range:
                    command += ["--select-ranges", selected_range, "--select-decode-only"]
                else:
                    command += ["--keep-unreachable-funcs"]
                command += ["-o", str(staged_output), str(staged_input)]
                result = subprocess.run(
                    command,
                    cwd=stage,
                    env=environment,
                    capture_output=True,
                    text=True,
                    errors="replace",
                    timeout=180 if selected_range or source.suffix.lower() == ".sys" else 600,
                    check=False,
                )
                log = result.stdout + "\n" + result.stderr
                status = "ok" if result.returncode == 0 and staged_output.exists() else "failed"
                if status == "ok":
                    code = staged_output.read_text(encoding="utf-8", errors="replace")
                    prefix = (
                        "// APPROXIMATE DECOMPILATION, NOT ORIGINAL UNISOC SOURCE.\n"
                        + f"// Input: {relative}; SHA-256: {digest}\n"
                        + (f"// Selected address range: {selected_range}; other functions omitted.\n" if selected_range else "")
                        + "// Function names, types, control flow, and constants may be inaccurate.\n\n"
                    )
                    destination.write_text(prefix + code, encoding="utf-8", newline="\n")
            except subprocess.TimeoutExpired as error:
                log = f"RetDec timed out after {error.timeout} seconds\n"
                status = "timeout"
            except Exception as error:
                log = f"{type(error).__name__}: {error}\n"
                status = "error"

        log_path = HERE / "decompilation_logs" / (name + ".log")
        log_path.write_text(log, encoding="utf-8", newline="\n")
        entry = {
            "status": status,
            "input_sha256": digest,
            "seconds": round(time.monotonic() - started, 2),
            "output": str(destination.relative_to(HERE).as_posix()) if status == "ok" else None,
            "output_bytes": destination.stat().st_size if status == "ok" else None,
            "scope": f"selected range {selected_range}" if selected_range else "whole binary",
            "function_definitions_estimate": len(re.findall(r"(?m)^\w[\w\s*]*\b(?:function_[0-9a-f]+|entry_point)\s*\([^;]*\)\s*\{", destination.read_text(encoding="utf-8"))) if status == "ok" else None,
            "log": str(log_path.relative_to(HERE).as_posix()),
        }
        report[relative] = entry
        REPORT.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"{status.upper()} {relative}: {entry['seconds']}s, {entry['output_bytes']} bytes", flush=True)


if __name__ == "__main__":
    main()
