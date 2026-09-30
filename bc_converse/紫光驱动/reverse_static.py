"""Static, reproducible inspection of the bundled UNISOC Windows drivers.

Requires Python 3, lief, and GNU objdump on PATH. Does not execute input files.
Run from anywhere: python reverse_static.py
"""

from __future__ import annotations

import csv
import gzip
import hashlib
import json
import re
import shutil
import subprocess
import tempfile
from collections import defaultdict
from pathlib import Path

import lief


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parents[1] / "原始工具" / "SZ50_AIR一键破解" / "紫光驱动"
PE_SUFFIXES = {".exe", ".dll", ".sys"}
HARDWARE_ID = re.compile(r"USB\\VID_[0-9A-F]{4}&PID_[0-9A-F]{4}(?:&MI_[0-9A-F]{2})?", re.I)
ASCII_STRING = re.compile(rb"[\x20-\x7e]{6,}")
WIDE_STRING = re.compile(rb"(?:[\x20-\x7e]\x00){6,}")
PDB_PATH = re.compile(rb"[A-Za-z]:\\[^\x00\r\n]{5,200}?\.pdb", re.I)


def decode_inf(data: bytes) -> str:
    if data.startswith((b"\xff\xfe", b"\xfe\xff")):
        return data.decode("utf-16")
    for encoding in ("utf-8-sig", "gb18030", "cp1252"):
        try:
            return data.decode(encoding)
        except UnicodeDecodeError:
            continue
    return data.decode("latin1")


def pe_information(data: bytes) -> dict:
    binary = lief.PE.parse(list(data))
    if binary is None:
        raise ValueError("LIEF could not parse PE image")
    imports = {
        library.name: [entry.name or f"ordinal:{entry.ordinal}" for entry in library.entries]
        for library in binary.imports
    }
    pdb_paths = [match.decode("ascii", "replace") for match in PDB_PATH.findall(data)]
    return {
        "machine": binary.header.machine.name,
        "entrypoint_rva": f"0x{binary.optional_header.addressof_entrypoint:x}",
        "image_base": f"0x{binary.optional_header.imagebase:x}",
        "sections": [
            {
                "name": section.name,
                "virtual_address": f"0x{section.virtual_address:x}",
                "virtual_size": section.virtual_size,
                "raw_size": section.size,
            }
            for section in binary.sections
        ],
        "imports": imports,
        "exports": [entry.name for entry in binary.get_export().entries] if binary.has_exports else [],
        "pdb_paths_embedded": list(dict.fromkeys(pdb_paths)),
        "has_embedded_signature": bool(binary.has_signatures),
    }


def useful_strings(data: bytes) -> list[str]:
    binary = lief.PE.parse(list(data))
    if binary is None:
        return []
    ordered = []
    seen = set()
    for section in binary.sections:
        content = bytes(section.content)
        for pattern, encoding in ((ASCII_STRING, "ascii"), (WIDE_STRING, "utf-16le")):
            for match in pattern.finditer(content):
                string = match.group().decode(encoding, "replace").strip()
                if not 6 <= len(string) <= 250 or string in seen:
                    continue
                seen.add(string)
                ordered.append(string)
    return ordered


def read_hardware_ids(path: Path) -> list[dict]:
    rows = []
    section = ""
    for raw_line in decode_inf(path.read_bytes()).splitlines():
        line = raw_line.split(";", 1)[0].strip()
        if line.startswith("[") and line.endswith("]"):
            section = line[1:-1]
            continue
        if "=" not in line:
            continue
        left, right = [part.strip() for part in line.split("=", 1)]
        install_section = right.split(",", 1)[0].strip()
        for hardware_id in HARDWARE_ID.findall(right):
            rows.append(
                {
                    "inf": path.name,
                    "model_section": section,
                    "device_description_token": left,
                    "install_section": install_section,
                    "hardware_id": hardware_id.upper(),
                }
            )
    return rows


def disassemble(path: Path, relative: Path, plain: bool) -> None:
    # GNU objdump on this Windows machine cannot open a non-ASCII input path.
    # Copy to a short temporary ASCII path, analyze it, then discard the copy.
    with tempfile.TemporaryDirectory(prefix="unisoc_pe_") as temporary:
        staged = Path(temporary) / ("input" + path.suffix.lower())
        shutil.copyfile(path, staged)
        result = subprocess.run(
            ["objdump", "-d", "-M", "intel", "--no-show-raw-insn", str(staged)],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            check=False,
        )
        if result.returncode:
            raise RuntimeError(f"objdump failed for {relative}: {result.stderr[:500]}")
    header = (
        f"; Static disassembly: {relative.as_posix()}\n"
        f"; Addresses are as reported by objdump. No original symbols or C source are implied.\n"
    )
    text = header + result.stdout.replace(str(staged), relative.as_posix())
    target = HERE / "disassembly" / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    with gzip.open(str(target) + ".asm.gz", "wt", encoding="utf-8", newline="\n") as output:
        output.write(text)
    if plain:
        target.with_suffix(target.suffix + ".asm").write_text(text, encoding="utf-8", newline="\n")


def main() -> None:
    if not SOURCE.is_dir():
        raise SystemExit(f"Input directory not found: {SOURCE}")
    (HERE / "strings").mkdir(exist_ok=True)
    inventory = []
    pe_data = {}
    hardware_ids = []
    disassembled = []
    for path in sorted(p for p in SOURCE.rglob("*") if p.is_file()):
        relative = path.relative_to(SOURCE)
        data = path.read_bytes()
        record = {
            "path": relative.as_posix(),
            "size_bytes": len(data),
            "sha256": hashlib.sha256(data).hexdigest(),
            "kind": path.suffix.lower().lstrip(".") or "no extension",
        }
        inventory.append(record)
        if path.suffix.lower() == ".inf":
            hardware_ids.extend(read_hardware_ids(path))
        if path.suffix.lower() not in PE_SUFFIXES:
            continue
        pe_data[relative.as_posix()] = pe_information(data)
        # DPInst and coinstaller DLLs are redistributable dependencies. Analyze
        # their metadata; focus code recovery on package-specific binaries.
        is_target = path.suffix.lower() == ".sys" or path.name.startswith(("DriverSetup", "DriverUninstall"))
        if not is_target:
            continue
        strings_path = HERE / "strings" / relative
        strings_path.parent.mkdir(parents=True, exist_ok=True)
        strings_path.with_suffix(strings_path.suffix + ".txt").write_text(
            "\n".join(useful_strings(data)) + "\n", encoding="utf-8"
        )
        plain = path.name == "DriverSetup.exe" or (
            relative.parts[0] == "Drivers" and relative.parts[1] == "amd64"
        )
        disassemble(path, relative, plain)
        disassembled.append(relative.as_posix())

    with (HERE / "inventory.csv").open("w", encoding="utf-8-sig", newline="") as output:
        writer = csv.DictWriter(output, fieldnames=list(inventory[0]))
        writer.writeheader()
        writer.writerows(inventory)
    (HERE / "pe_metadata.json").write_text(
        json.dumps(pe_data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    fields = ["inf", "model_section", "device_description_token", "install_section", "hardware_id"]
    with (HERE / "hardware_ids.csv").open("w", encoding="utf-8-sig", newline="") as output:
        writer = csv.DictWriter(output, fieldnames=fields)
        writer.writeheader()
        writer.writerows(hardware_ids)
    summary = defaultdict(int)
    for row in hardware_ids:
        summary[row["inf"]] += 1
    print(f"Inspected {len(inventory)} files, {len(pe_data)} PE files.")
    print(f"INF hardware-ID rows: {dict(summary)}")
    print(f"Disassembled: {len(disassembled)} package-specific binaries.")


if __name__ == "__main__":
    main()
