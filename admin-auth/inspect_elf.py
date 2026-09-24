import struct

with open(r'原始工具/SZ50_AIR一键破解/file/webui/cgi-bin/traffic.cgi', 'rb') as f:
    data = f.read()

e_shoff = struct.unpack_from('<Q', data, 0x28)[0]
e_shentsize, e_shnum, e_shstrndx = struct.unpack_from('<HHH', data, 0x3a)

sections = []
for i in range(e_shnum):
    offset = e_shoff + i * e_shentsize
    sh_name, sh_type, sh_flags, sh_addr, sh_offset, sh_size, sh_link, sh_info, sh_addralign, sh_entsize = struct.unpack_from('<IIQQQQIIQQ', data, offset)
    sections.append({'name_idx': sh_name, 'type': sh_type, 'offset': sh_offset, 'size': sh_size, 'link': sh_link, 'info': sh_info, 'entsize': sh_entsize})

shstr = sections[e_shstrndx]
shstr_data = data[shstr['offset']:shstr['offset']+shstr['size']]

dynstr_sec = None
for s in sections:
    s['name'] = shstr_data[s['name_idx']:].split(b'\x00')[0].decode('ascii', 'ignore')
    if s['name'] == '.dynstr':
        dynstr_sec = s

if dynstr_sec:
    dynstr_data = data[dynstr_sec['offset']:dynstr_sec['offset']+dynstr_sec['size']]
    print('--- DYNSTR symbols ---')
    for s in dynstr_data.split(b'\x00'):
        if s:
            print(s.decode('ascii', 'ignore'))
