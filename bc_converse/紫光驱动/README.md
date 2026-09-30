# 紫光驱动包静态逆向记录

分析对象：`../../原始工具/SZ50_AIR一键破解/紫光驱动/`。本目录是分析产物，不是原厂源码。分析只读取了文件，没有运行安装程序、卸载程序或驱动，也没有修改系统驱动。

## 结论

这是一套 **Windows 主机侧 USB 驱动安装包**，不是 SZ50 AIR 设备里运行的 Linux 固件。原目录共 25 个文件：4 个 INF、4 个 CAT、15 个 PE 二进制文件、1 个 XML 和 1 个 REG。INF 和 XML 本身是可读的安装规则；EXE、DLL、SYS 为编译后的机器码。本目录现已生成反汇编和 C 风格反编译结果，但**无法精确恢复原厂 C/C++ 工程**。

| 安装组件 | 静态证据 | 功能判断 |
| --- | --- | --- |
| ADB 接口 | `sprdadb.inf` 中 `Include = winusb.inf`、`AddService = WinUSB`、`ServiceBinary = %12%\WinUSB.sys` | 使用 Windows 的 WinUSB；本包没有独立的 `sprdadb.sys` |
| USB 串口 | `sprdvcom.inf` 中 `AddService=sprdvcom`，对应 `sprdvcom.sys` | 提供展锐设备的 AT、DIAG、LOG 等串口接口 |
| RDA 串口 | `rdavcom.inf` 中 `AddService=rdavcom`，对应 `rdavcom.sys` | 匹配 `USB\VID_0525&PID_A4A7` |
| USB Modem | `sprdvmdm.inf` 中 `LowerFilters=sprdvmdm`，对应 `sprdvmdm.sys` | 作为调制解调器设备的下层过滤驱动 |

这些匹配关系由 INF 的 Models 和安装节声明。Windows 会用设备硬件 ID 查找匹配的 INF，详见 [Microsoft 的 INF Models 文档](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/inf-models-section)。

## 已提取的代码与数据

| 文件或目录 | 内容 |
| --- | --- |
| `disassembly/` | 3 个安装/卸载 EXE 与 6 个自定义 SYS 的 x86/x64 汇编；全部有 `.asm.gz`，`DriverSetup.exe` 和 3 个 amd64 SYS 另有可直接打开的 `.asm` |
| `strings/` | 上述 9 个文件的 ASCII 和 UTF-16LE 可打印字符串，已排除 PE 文件末尾的签名数据 |
| `pe_metadata.json` | 15 个 PE 的架构、入口 RVA、节、导入/导出函数、内嵌 PDB 路径以及是否存在内嵌签名 |
| `hardware_ids.csv` | 从 4 个 INF 提取的 USB VID/PID/接口号、描述 token 与安装节 |
| `inventory.csv` | 25 个输入文件的相对路径、大小和 SHA-256，可用于确认分析对应的版本 |
| `reverse_static.py` | 可重复运行的静态提取脚本；需要 Python、LIEF 和 GNU objdump |
| `recovered_c/` | RetDec 5.0 生成的 6 个 SYS 和 `DriverSetup.exe` 的 C 风格伪代码，以及 2 个卸载器的核心地址范围伪代码；每份文件头都标注源文件和 SHA-256 |
| `decompilation_report.json`、`decompilation_logs/` | 各二进制的处理状态、恢复范围、耗时和原始工具输出 |
| `decompile_to_c.py` | 可复现的 RetDec 批处理脚本；需要本地 RetDec 5.0 和相应运行库 |
| `函数索引.md` | 安装、卸载和 KMDF 初始化等可定位函数的文件行号及证据 |

`hardware_ids.csv` 按 INF 原始条目保留 x86、amd64 等节，因此存在重复 ID。去重后，`rdavcom.inf`、`sprdadb.inf`、`sprdvcom.inf`、`sprdvmdm.inf` 分别包含 **1、77、428、45** 个硬件 ID。这说明安装包覆盖许多展锐产品型号；不能仅凭目录名称认定所有 ID 都属于 SZ50 AIR。

## 安装与卸载程序的行为线索

`dpinst.xml` 明确列出四个待安装包：`sprdadb.inf`、`sprdvcom.inf`、`sprdvmdm.inf`、`rdavcom.inf`。它还设置了 `legacyMode`、`suppressAddRemovePrograms`、`deleteBinaries`、`forceIfDriverIsNotBetter` 等选项。`config.reg` 为 4 个 `UsbFlags` 项配置了 `IgnoreHWSerNum`；本次没有执行该注册表文件。

`DriverSetup.exe` 中可以找到 `DPInst32.exe`、`DPInst64.exe`、管理员权限声明；导入表中有 `CreateProcessW` 和 `WaitForSingleObject`。在 `recovered_c/DriverSetup.exe.c` 中，还能看到一个条件分支分别选取 `\\DPInst32.exe` 与 `\\DPInst64.exe`，证实它至少具有选择安装器的逻辑。反编译器给该分支及辅助函数分配的是地址式临时名称，因此架构判断的具体实现、何时应用 `config.reg`、错误及退出码处理仍需逐函数核对。

`DriverUninstall32.exe` 和 `DriverUninstall64.exe` 导入 `SetupDiGetClassDevsW`、`SetupDiEnumDeviceInfo`、`SetupDiCallClassInstaller`、`SetupUninstallOEMInfW`。字符串中还出现 `VID_1782`、`VID_0525`、`VID_18D1&PID_4EE7`、多个 `sprd*.sys` 文件名及 `uninstall.log`。两份 `recovered_c/DriverUninstall*_core.c` 均实际包含设备枚举、类安装器调用和 OEM INF 卸载调用，因此可确认相关代码路径存在；具体删除条件、调用顺序和所有异常分支仍需人工校验。

## `.sys` 驱动的内部线索

三种 SYS 均提供 i386 和 amd64 版本，导入 `WDFLDR.SYS` 与 `ntoskrnl.exe`。三个 INF 都声明 `KmdfLibraryVersion = 1.9`，与 KMDF 驱动结构吻合。[Microsoft 的 WDF 文档](https://learn.microsoft.com/en-us/windows-hardware/drivers/wdf/differences-between-wdm-and-kmdf)说明驱动通过入口和回调处理设备及 I/O 事件。

二进制内能看到 `USBCOMM_DEVICE_CONTEXT`、`USBCOMM_BULK_REQUEST_CONTEXT`、`PortName`、`SERIALCOMM`、`SprdVendorRequest`、`UsbEnableZLP` 等字符串。INF 将 `VendorRequestTimeoutValue`、`SprdVendorRequest`、`CdcControlLineState`、`UseContinuousRead`、`RxFifoSize`、`BulkInBufSize`、`UsbEnableZLP` 写为设备配置项。其中 `sprdvcom.sys` 包含 `\Device\sprd_usbcomm_serial`，`sprdvmdm.sys` 包含 `\Device\sprd_usbcomm_modem`。这些是功能线索；具体回调、缓冲区生命周期和 USB 请求处理还不能仅靠字符串确认。

驱动二进制内嵌的 PDB **路径**指向 `smartphoneport/serial`、`smartphoneport/modem`、`smartphoneport/rdaserial` 等原工程目录，但包内没有相应 `.pdb` 文件。6 个 SYS 的 PE 元数据均显示存在内嵌签名；本次未验证证书链或签名有效性。

还有一个版本差异值得保留：4 个 INF 的 `DriverVer` 均为 **10/14/2020, 4.20.42.134**，而 3 种 amd64 SYS 资源字符串中的 `FileVersion` 为 **4.19.38.134**。这只是两个字段的客观差异，不能单凭它判断驱动包是否有问题。

## 代码恢复的边界

`disassembly/*.asm` 是机器码反汇编，地址与指令真实来自文件，但没有原厂函数名、变量名和注释。`.asm.gz` 可用 7-Zip 解压。安装器和驱动可能含编译器运行时代码，直接把整份汇编当作原厂业务逻辑会产生误判。

当前可较可靠地复原 **设备匹配规则、安装组件关系、程序入口、导入 API 和部分行为线索**。`recovered_c/*.c` 是 RetDec 从机器码推断的 C 风格表示：函数名大多是地址、类型可能错误，部分控制流有工具警告；这些文件**不能直接当作可编译或功能等价的驱动源码**。要提高准确度，需要结合 PDB（如果以后能找到）、人工核对汇编，以及隔离环境中的行为验证。

卸载器与大量 MFC 运行时代码静态链接。`DriverUninstall32.exe` 的整文件反编译运行 600 秒后超时；64 位版本的整文件运行因资源开销而中止。随后根据反汇编中 `SetupUninstallOEMInfW` 与 `SetupDi*` 的调用地址，只对 x86 的 `0x401000–0x403000` 和 x64 的 `0x140001000–0x140004000` 生成了核心范围伪代码。因此两个 `_core.c` 文件**不覆盖整个卸载器**。x86 整文件超时记录保留在 `decompilation_logs/DriverUninstall32.exe.full-timeout.log`。

## 复现

在项目根目录执行：

```powershell
python bc_converse/紫光驱动/reverse_static.py
```

脚本只读取原始目录，临时拷贝 PE 到 ASCII 路径以兼容当前 GNU objdump，结束后清理临时文件。它会重写本目录的 CSV、JSON、字符串和汇编产物，不会安装或执行任何驱动文件。

C 风格反编译需要将 RetDec 5.0 的 `retdec-decompiler.exe` 放在 **ASCII 路径**并设置 `RETDEC_EXE`；若运行时缺少 OpenSSL 1.1 DLL，设置 `RETDEC_DLL_DIR` 指向它所在目录。可选的 `RETDEC_WORKDIR` 指向有足够空间且路径只含 ASCII 的临时目录。随后执行：

```powershell
$env:RETDEC_EXE = 'C:\Tools\retdec\bin\retdec-decompiler.exe'
$env:RETDEC_WORKDIR = 'C:\Temp'
python bc_converse/紫光驱动/decompile_to_c.py
```

脚本默认跳过已经成功生成且输入哈希未变的文件；加 `--force` 可重新生成。反编译器的使用方式见 [RetDec 官方说明](https://github.com/avast/retdec#use)。
