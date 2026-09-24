import capstone
from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM
import struct

with open(r'原始工具/SZ50_AIR一键破解/file/webui/cgi-bin/traffic.cgi', 'rb') as f:
    data = f.read()

# Let's find the text section.
# ELF64 header:
e_entry = struct.unpack_from('<Q', data, 0x18)[0]
print('Entry point:', hex(e_entry))

# Disassemble from entry point or scan for functions
md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)

# In ELF, load address for PIE is typically 0x0
# Let's find BL (branch with link) or SVC or decryption routines
# Also let's find strings in data section
# Let's inspect the first 4096 bytes around entry or code
for i in range(0x800, min(0x3000, len(data)), 4):
    chunk = data[i:i+16]
    # let's look for loops or xor
    pass

print('Ready to analyze code')
