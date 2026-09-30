; Static disassembly: Drivers/amd64/sprdvcom.sys
; Addresses are as reported by objdump. No original symbols or C source are implied.

Drivers/amd64/sprdvcom.sys:     file format pei-x86-64


Disassembly of section .text:

0000000000011000 <.text>:
	...
   11008:	mov    QWORD PTR [rsp+0x8],rbx
   1100d:	push   rdi
   1100e:	sub    rsp,0x50
   11012:	mov    rbx,rdx
   11015:	xor    edx,edx
   11017:	mov    rdi,rcx
   1101a:	lea    r8d,[rdx+0x20]
   1101e:	lea    rcx,[rsp+0x30]
   11023:	call   0x152c0
   11028:	and    QWORD PTR [rsp+0x28],0x0
   1102e:	mov    rcx,QWORD PTR [rip+0x7e73]        # 0x18ea8
   11035:	lea    rax,[rip+0xfa0]        # 0x11fdc
   1103c:	xor    r9d,r9d
   1103f:	mov    r8,rbx
   11042:	mov    QWORD PTR [rsp+0x38],rax
   11047:	lea    rax,[rip+0x32]        # 0x11080
   1104e:	mov    rdx,rdi
   11051:	mov    QWORD PTR [rsp+0x40],rax
   11056:	lea    rax,[rsp+0x30]
   1105b:	mov    DWORD PTR [rsp+0x30],0x20
   11063:	mov    QWORD PTR [rsp+0x20],rax
   11068:	call   QWORD PTR [rip+0x7552]        # 0x185c0
   1106e:	mov    rbx,QWORD PTR [rsp+0x60]
   11073:	add    rsp,0x50
   11077:	pop    rdi
   11078:	ret
   11079:	int3
   1107a:	int3
   1107b:	int3
   1107c:	int3
   1107d:	int3
   1107e:	int3
   1107f:	int3
   11080:	mov    rdx,rcx
   11083:	mov    rcx,QWORD PTR [rip+0x7e1e]        # 0x18ea8
   1108a:	rex.W jmp QWORD PTR [rip+0x753f]        # 0x185d0
   11091:	int3
   11092:	int3
   11093:	int3
   11094:	int3
   11095:	int3
   11096:	int3
   11097:	int3
   11098:	mov    QWORD PTR [rsp+0x8],rbx
   1109d:	mov    QWORD PTR [rsp+0x10],rsi
   110a2:	push   rdi
   110a3:	sub    rsp,0x20
   110a7:	mov    r8,QWORD PTR [rip+0x70d2]        # 0x18180
   110ae:	mov    rdi,rdx
   110b1:	mov    rsi,rcx
   110b4:	mov    rdx,rcx
   110b7:	mov    rcx,QWORD PTR [rip+0x7dea]        # 0x18ea8
   110be:	call   QWORD PTR [rip+0x77ac]        # 0x18870
   110c4:	mov    rcx,QWORD PTR [rip+0x7ddd]        # 0x18ea8
   110cb:	mov    rdx,rsi
   110ce:	mov    rbx,rax
   110d1:	call   QWORD PTR [rip+0x7951]        # 0x18a28
   110d7:	test   al,al
   110d9:	je     0x110e2
   110db:	mov    eax,0xc0000001
   110e0:	jmp    0x110ff
   110e2:	mov    rcx,QWORD PTR [rip+0x7dbf]        # 0x18ea8
   110e9:	or     DWORD PTR [rbx+0x10],0x1
   110ed:	mov    r8,rdi
   110f0:	mov    rdx,rsi
   110f3:	mov    QWORD PTR [rbx+0x8],rdi
   110f7:	call   QWORD PTR [rip+0x791b]        # 0x18a18
   110fd:	xor    eax,eax
   110ff:	mov    rbx,QWORD PTR [rsp+0x30]
   11104:	mov    rsi,QWORD PTR [rsp+0x38]
   11109:	add    rsp,0x20
   1110d:	pop    rdi
   1110e:	ret
   1110f:	int3
   11110:	int3
   11111:	int3
   11112:	int3
   11113:	int3
   11114:	int3
   11115:	int3
   11116:	int3
   11117:	int3
   11118:	mov    QWORD PTR [rsp+0x8],rbx
   1111d:	push   rdi
   1111e:	sub    rsp,0x20
   11122:	mov    r8,QWORD PTR [rip+0x7057]        # 0x18180
   11129:	mov    rdi,rcx
   1112c:	mov    rdx,rcx
   1112f:	mov    rcx,QWORD PTR [rip+0x7d72]        # 0x18ea8
   11136:	call   QWORD PTR [rip+0x7734]        # 0x18870
   1113c:	mov    rbx,rax
   1113f:	test   BYTE PTR [rax+0x10],0x1
   11143:	jne    0x11149
   11145:	xor    eax,eax
   11147:	jmp    0x11170
   11149:	mov    rcx,QWORD PTR [rip+0x7d58]        # 0x18ea8
   11150:	mov    rdx,rdi
   11153:	call   QWORD PTR [rip+0x78c7]        # 0x18a20
   11159:	test   eax,eax
   1115b:	js     0x11170
   1115d:	mov    ecx,DWORD PTR [rbx+0x10]
   11160:	test   cl,0x1
   11163:	je     0x11170
   11165:	and    ecx,0xfffffffe
   11168:	and    QWORD PTR [rbx+0x8],0x0
   1116d:	mov    DWORD PTR [rbx+0x10],ecx
   11170:	mov    rbx,QWORD PTR [rsp+0x30]
   11175:	add    rsp,0x20
   11179:	pop    rdi
   1117a:	ret
   1117b:	int3
   1117c:	int3
   1117d:	int3
   1117e:	int3
   1117f:	int3
   11180:	int3
   11181:	int3
   11182:	int3
   11183:	int3
   11184:	mov    rax,rsp
   11187:	mov    QWORD PTR [rax+0x10],rdx
   1118b:	mov    QWORD PTR [rax+0x18],r8
   1118f:	mov    QWORD PTR [rax+0x20],r9
   11193:	push   rbx
   11194:	sub    rsp,0x50
   11198:	and    DWORD PTR [rax-0x30],0x0
   1119c:	lea    r8,[rax-0x20]
   111a0:	lea    rdx,[rax-0x18]
   111a4:	xor    r9d,r9d
   111a7:	mov    rbx,rcx
   111aa:	mov    QWORD PTR [rax-0x38],0x7fff
   111b2:	call   0x15128
   111b7:	mov    r11d,eax
   111ba:	test   eax,eax
   111bc:	js     0x111f5
   111be:	mov    r9,QWORD PTR [rsp+0x68]
   111c3:	mov    rdx,QWORD PTR [rsp+0x38]
   111c8:	mov    rcx,QWORD PTR [rsp+0x40]
   111cd:	and    QWORD PTR [rsp+0x30],0x0
   111d3:	lea    rax,[rsp+0x70]
   111d8:	lea    r8,[rsp+0x30]
   111dd:	mov    QWORD PTR [rsp+0x20],rax
   111e2:	call   0x15078
   111e7:	mov    r11d,eax
   111ea:	movzx  eax,WORD PTR [rsp+0x30]
   111ef:	add    ax,ax
   111f2:	mov    WORD PTR [rbx],ax
   111f5:	mov    eax,r11d
   111f8:	add    rsp,0x50
   111fc:	pop    rbx
   111fd:	ret
   111fe:	int3
   111ff:	int3
   11200:	int3
   11201:	int3
   11202:	int3
   11203:	int3
   11204:	mov    QWORD PTR [rsp+0x18],rbx
   11209:	push   rbp
   1120a:	push   rsi
   1120b:	push   rdi
   1120c:	push   r13
   1120e:	push   r15
   11210:	sub    rsp,0x180
   11217:	mov    rdi,rcx
   1121a:	mov    rdx,rcx
   1121d:	mov    rcx,QWORD PTR [rip+0x7c84]        # 0x18ea8
   11224:	call   QWORD PTR [rip+0x7656]        # 0x18880
   1122a:	xor    edx,edx
   1122c:	mov    r8d,0x1f8
   11232:	mov    rcx,rdi
   11235:	mov    rsi,rax
   11238:	call   0x152c0
   1123d:	mov    rcx,rdi
   11240:	mov    QWORD PTR [rdi],rsi
   11243:	mov    BYTE PTR [rdi+0x68],0xff
   11247:	call   0x11b58
   1124c:	mov    ecx,DWORD PTR [rdi+0x1d0]
   11252:	mov    QWORD PTR [rdi+0x148],rcx
   11259:	mov    ebp,0x1
   1125e:	lea    rcx,[rdi+0xb0]
   11265:	mov    r8b,bpl
   11268:	xor    edx,edx
   1126a:	call   QWORD PTR [rip+0x5dd8]        # 0x17048
   11270:	xor    r11d,r11d
   11273:	lea    rax,[rip+0x2836]        # 0x13ab0
   1127a:	mov    QWORD PTR [rsp+0x40],r11
   1127f:	mov    QWORD PTR [rsp+0x48],r11
   11284:	mov    QWORD PTR [rsp+0x50],r11
   11289:	lea    r13d,[rbp+0x37]
   1128d:	lea    ebx,[rbp+0x17]
   11290:	lea    rcx,[rsp+0x58]
   11295:	xor    edx,edx
   11297:	mov    r8,r13
   1129a:	mov    QWORD PTR [rsp+0x48],rax
   1129f:	mov    DWORD PTR [rsp+0x40],ebx
   112a3:	mov    BYTE PTR [rsp+0x50],bpl
   112a8:	call   0x152c0
   112ad:	mov    rax,QWORD PTR [rdi]
   112b0:	mov    rcx,QWORD PTR [rip+0x7bf1]        # 0x18ea8
   112b7:	lea    r9,[rdi+0x38]
   112bb:	lea    r8,[rsp+0x58]
   112c0:	lea    rdx,[rsp+0x40]
   112c5:	mov    QWORD PTR [rsp+0x78],rax
   112ca:	mov    DWORD PTR [rsp+0x58],r13d
   112cf:	mov    DWORD PTR [rsp+0x70],ebp
   112d3:	mov    DWORD PTR [rsp+0x74],ebp
   112d7:	call   QWORD PTR [rip+0x72bb]        # 0x18598
   112dd:	mov    r11d,eax
   112e0:	test   eax,eax
   112e2:	jne    0x113bc
   112e8:	xor    eax,eax
   112ea:	lea    rcx,[rsp+0x58]
   112ef:	mov    r8,r13
   112f2:	mov    QWORD PTR [rsp+0x40],rax
   112f7:	mov    QWORD PTR [rsp+0x48],rax
   112fc:	mov    QWORD PTR [rsp+0x50],rax
   11301:	lea    rax,[rip+0x2b80]        # 0x13e88
   11308:	xor    edx,edx
   1130a:	mov    DWORD PTR [rsp+0x40],ebx
   1130e:	mov    QWORD PTR [rsp+0x48],rax
   11313:	mov    BYTE PTR [rsp+0x50],bpl
   11318:	call   0x152c0
   1131d:	mov    rax,QWORD PTR [rdi]
   11320:	mov    rcx,QWORD PTR [rip+0x7b81]        # 0x18ea8
   11327:	lea    r9,[rdi+0x30]
   1132b:	lea    r8,[rsp+0x58]
   11330:	lea    rdx,[rsp+0x40]
   11335:	mov    QWORD PTR [rsp+0x78],rax
   1133a:	mov    DWORD PTR [rsp+0x58],r13d
   1133f:	mov    DWORD PTR [rsp+0x70],ebp
   11343:	mov    DWORD PTR [rsp+0x74],ebp
   11347:	call   QWORD PTR [rip+0x724b]        # 0x18598
   1134d:	mov    r11d,eax
   11350:	test   eax,eax
   11352:	jne    0x113bc
   11354:	xor    eax,eax
   11356:	lea    rcx,[rsp+0x58]
   1135b:	mov    r8,r13
   1135e:	mov    QWORD PTR [rsp+0x40],rax
   11363:	mov    QWORD PTR [rsp+0x48],rax
   11368:	mov    QWORD PTR [rsp+0x50],rax
   1136d:	lea    rax,[rip+0x1cf4]        # 0x13068
   11374:	xor    edx,edx
   11376:	mov    DWORD PTR [rsp+0x40],ebx
   1137a:	mov    QWORD PTR [rsp+0x48],rax
   1137f:	mov    BYTE PTR [rsp+0x50],bpl
   11384:	call   0x152c0
   11389:	mov    rax,QWORD PTR [rdi]
   1138c:	mov    rcx,QWORD PTR [rip+0x7b15]        # 0x18ea8
   11393:	lea    r9,[rdi+0x40]
   11397:	lea    r8,[rsp+0x58]
   1139c:	lea    rdx,[rsp+0x40]
   113a1:	mov    QWORD PTR [rsp+0x78],rax
   113a6:	mov    DWORD PTR [rsp+0x58],r13d
   113ab:	mov    DWORD PTR [rsp+0x70],ebp
   113af:	mov    DWORD PTR [rsp+0x74],ebp
   113b3:	call   QWORD PTR [rip+0x71df]        # 0x18598
   113b9:	mov    r11d,eax
   113bc:	test   r11d,r11d
   113bf:	jne    0x117d2
   113c5:	lea    ebx,[r11+0x20]
   113c9:	lea    rcx,[rsp+0xf0]
   113d1:	xor    edx,edx
   113d3:	mov    r8,rbx
   113d6:	call   0x152c0
   113db:	and    DWORD PTR [rsp+0x108],0x0
   113e3:	lea    rax,[rip+0x1a3a]        # 0x12e24
   113ea:	lea    rcx,[rsp+0x110]
   113f2:	mov    r8,r13
   113f5:	xor    edx,edx
   113f7:	mov    QWORD PTR [rsp+0xf8],rax
   113ff:	mov    DWORD PTR [rsp+0xf0],ebx
   11406:	mov    BYTE PTR [rsp+0x104],bpl
   1140e:	mov    DWORD PTR [rsp+0x100],0x64
   11419:	call   0x152c0
   1141e:	mov    rax,QWORD PTR [rdi]
   11421:	mov    rcx,QWORD PTR [rip+0x7a80]        # 0x18ea8
   11428:	lea    r9,[rdi+0x8]
   1142c:	lea    r8,[rsp+0x110]
   11434:	lea    rdx,[rsp+0xf0]
   1143c:	mov    QWORD PTR [rsp+0x130],rax
   11444:	mov    DWORD PTR [rsp+0x110],r13d
   1144c:	mov    DWORD PTR [rsp+0x128],ebp
   11453:	mov    DWORD PTR [rsp+0x12c],ebp
   1145a:	call   QWORD PTR [rip+0x77b0]        # 0x18c10
   11460:	mov    r11d,eax
   11463:	test   eax,eax
   11465:	jne    0x117d2
   1146b:	lea    rcx,[rsp+0x58]
   11470:	mov    r8,r13
   11473:	xor    edx,edx
   11475:	call   0x152c0
   1147a:	mov    rax,QWORD PTR [rip+0x6d27]        # 0x181a8
   11481:	mov    rcx,QWORD PTR [rip+0x7a20]        # 0x18ea8
   11488:	mov    QWORD PTR [rsp+0x88],rax
   11490:	mov    rax,QWORD PTR [rdi]
   11493:	lea    r9,[rdi+0xa8]
   1149a:	lea    rdx,[rsp+0x58]
   1149f:	xor    r8d,r8d
   114a2:	mov    DWORD PTR [rsp+0x58],r13d
   114a7:	mov    QWORD PTR [rsp+0x78],rax
   114ac:	mov    DWORD PTR [rsp+0x70],ebp
   114b0:	mov    DWORD PTR [rsp+0x74],ebp
   114b4:	call   QWORD PTR [rip+0x751e]        # 0x189d8
   114ba:	mov    r11d,eax
   114bd:	test   eax,eax
   114bf:	jne    0x11546
   114c5:	mov    r8,QWORD PTR [rip+0x6cdc]        # 0x181a8
   114cc:	mov    rdx,QWORD PTR [rdi+0xa8]
   114d3:	mov    rcx,QWORD PTR [rip+0x79ce]        # 0x18ea8
   114da:	call   QWORD PTR [rip+0x7390]        # 0x18870
   114e0:	mov    rcx,QWORD PTR [rdi]
   114e3:	mov    r8,r13
   114e6:	lea    rbx,[rax+0x8]
   114ea:	mov    QWORD PTR [rax],rcx
   114ed:	lea    rcx,[rsp+0x58]
   114f2:	and    QWORD PTR [rbx],0x0
   114f6:	xor    edx,edx
   114f8:	call   0x152c0
   114fd:	mov    rax,QWORD PTR [rdi]
   11500:	and    QWORD PTR [rsp+0x30],0x0
   11506:	mov    rcx,QWORD PTR [rip+0x799b]        # 0x18ea8
   1150d:	mov    QWORD PTR [rsp+0x78],rax
   11512:	mov    eax,DWORD PTR [rdi+0x1d4]
   11518:	lea    rdx,[rsp+0x58]
   1151d:	mov    r9d,0x6d6f6355
   11523:	xor    r8d,r8d
   11526:	mov    QWORD PTR [rsp+0x28],rbx
   1152b:	mov    DWORD PTR [rsp+0x58],r13d
   11530:	mov    DWORD PTR [rsp+0x70],ebp
   11534:	mov    QWORD PTR [rsp+0x20],rax
   11539:	mov    DWORD PTR [rsp+0x74],ebp
   1153d:	call   QWORD PTR [rip+0x72dd]        # 0x18820
   11543:	mov    r11d,eax
   11546:	test   r11d,r11d
   11549:	jne    0x117d2
   1154f:	lea    ebx,[r11+0x58]
   11553:	lea    rcx,[rsp+0x90]
   1155b:	xor    edx,edx
   1155d:	mov    r8,rbx
   11560:	call   0x152c0
   11565:	mov    rcx,QWORD PTR [rip+0x793c]        # 0x18ea8
   1156c:	lea    rax,[rip+0x2501]        # 0x13a74
   11573:	mov    QWORD PTR [rsp+0xd0],rax
   1157b:	lea    rax,[rip+0x2412]        # 0x13994
   11582:	lea    r15,[rip+0x242b]        # 0x139b4
   11589:	mov    QWORD PTR [rsp+0xd8],rax
   11591:	lea    rax,[rdi+0x10]
   11595:	lea    r8,[rsp+0x90]
   1159d:	xor    r9d,r9d
   115a0:	mov    rdx,rsi
   115a3:	mov    DWORD PTR [rsp+0x90],ebx
   115aa:	mov    QWORD PTR [rsp+0x20],rax
   115af:	mov    DWORD PTR [rsp+0x98],0x2
   115ba:	mov    DWORD PTR [rsp+0x94],0x3
   115c5:	mov    QWORD PTR [rsp+0xc8],r15
   115cd:	call   QWORD PTR [rip+0x710d]        # 0x186e0
   115d3:	mov    r11d,eax
   115d6:	test   eax,eax
   115d8:	jne    0x117d2
   115de:	lea    rcx,[rsp+0x90]
   115e6:	mov    r8,rbx
   115e9:	xor    edx,edx
   115eb:	call   0x152c0
   115f0:	mov    rcx,QWORD PTR [rip+0x78b1]        # 0x18ea8
   115f7:	lea    rax,[rip+0x2476]        # 0x13a74
   115fe:	mov    QWORD PTR [rsp+0xd0],rax
   11606:	lea    rax,[rip+0x2387]        # 0x13994
   1160d:	lea    r8,[rsp+0x90]
   11615:	mov    QWORD PTR [rsp+0xd8],rax
   1161d:	lea    rax,[rdi+0x18]
   11621:	xor    r9d,r9d
   11624:	mov    rdx,rsi
   11627:	mov    DWORD PTR [rsp+0x90],ebx
   1162e:	mov    DWORD PTR [rsp+0x98],0x2
   11639:	mov    QWORD PTR [rsp+0x20],rax
   1163e:	mov    DWORD PTR [rsp+0x94],0x3
   11649:	mov    QWORD PTR [rsp+0xc8],r15
   11651:	call   QWORD PTR [rip+0x7089]        # 0x186e0
   11657:	mov    r11d,eax
   1165a:	test   eax,eax
   1165c:	jne    0x117d2
   11662:	lea    rcx,[rsp+0x90]
   1166a:	mov    r8,rbx
   1166d:	xor    edx,edx
   1166f:	call   0x152c0
   11674:	mov    rcx,QWORD PTR [rip+0x782d]        # 0x18ea8
   1167b:	or     DWORD PTR [rsp+0xe0],0xffffffff
   11683:	lea    rax,[rip+0x21f2]        # 0x1387c
   1168a:	lea    r8,[rsp+0x90]
   11692:	xor    r9d,r9d
   11695:	mov    QWORD PTR [rsp+0xa8],rax
   1169d:	lea    rax,[rip+0x2258]        # 0x138fc
   116a4:	mov    rdx,rsi
   116a7:	mov    QWORD PTR [rsp+0xb0],rax
   116af:	lea    rax,[rip+0x23be]        # 0x13a74
   116b6:	mov    DWORD PTR [rsp+0x90],ebx
   116bd:	mov    QWORD PTR [rsp+0xd0],rax
   116c5:	lea    rax,[rip+0x1a00]        # 0x130cc
   116cc:	mov    DWORD PTR [rsp+0x98],0x2
   116d7:	mov    QWORD PTR [rsp+0xb8],rax
   116df:	lea    rax,[rip+0x22ae]        # 0x13994
   116e6:	mov    BYTE PTR [rsp+0x9d],bpl
   116ee:	mov    QWORD PTR [rsp+0xd8],rax
   116f6:	lea    rax,[rsp+0x1b8]
   116fe:	mov    DWORD PTR [rsp+0x94],0x2
   11709:	mov    QWORD PTR [rsp+0x20],rax
   1170e:	mov    QWORD PTR [rsp+0xc8],r15
   11716:	call   QWORD PTR [rip+0x6fc4]        # 0x186e0
   1171c:	mov    r11d,eax
   1171f:	test   eax,eax
   11721:	jne    0x117d2
   11727:	lea    rcx,[rsp+0x148]
   1172f:	mov    r8,r13
   11732:	xor    edx,edx
   11734:	call   0x152c0
   11739:	mov    rax,QWORD PTR [rdi]
   1173c:	mov    rcx,QWORD PTR [rdi+0x148]
   11743:	mov    QWORD PTR [rsp+0x168],rax
   1174b:	lea    rdx,[rsp+0x1b0]
   11753:	lea    rax,[rdi+0x150]
   1175a:	mov    QWORD PTR [rsp+0x30],rdx
   1175f:	mov    QWORD PTR [rsp+0x28],rax
   11764:	mov    QWORD PTR [rsp+0x20],rcx
   11769:	mov    rcx,QWORD PTR [rip+0x7738]        # 0x18ea8
   11770:	lea    rdx,[rsp+0x148]
   11778:	mov    r9d,0x6d6f6355
   1177e:	xor    r8d,r8d
   11781:	mov    DWORD PTR [rsp+0x148],r13d
   11789:	mov    DWORD PTR [rsp+0x160],ebp
   11790:	mov    DWORD PTR [rsp+0x164],ebp
   11797:	call   QWORD PTR [rip+0x7083]        # 0x18820
   1179d:	mov    r11d,eax
   117a0:	test   eax,eax
   117a2:	jne    0x117d2
   117a4:	mov    rcx,QWORD PTR [rdi+0x148]
   117ab:	mov    rax,QWORD PTR [rsp+0x1b0]
   117b3:	mov    QWORD PTR [rdi+0x128],rax
   117ba:	mov    QWORD PTR [rdi+0x130],rax
   117c1:	mov    QWORD PTR [rdi+0x138],rax
   117c8:	add    rax,rcx
   117cb:	mov    QWORD PTR [rdi+0x140],rax
   117d2:	mov    eax,r11d
   117d5:	mov    rbx,QWORD PTR [rsp+0x1c0]
   117dd:	add    rsp,0x180
   117e4:	pop    r15
   117e6:	pop    r13
   117e8:	pop    rdi
   117e9:	pop    rsi
   117ea:	pop    rbp
   117eb:	ret
   117ec:	int3
   117ed:	int3
   117ee:	int3
   117ef:	int3
   117f0:	int3
   117f1:	int3
   117f2:	int3
   117f3:	int3
   117f4:	mov    r11,rsp
   117f7:	mov    QWORD PTR [r11+0x10],rbx
   117fb:	mov    QWORD PTR [r11+0x18],rsi
   117ff:	mov    QWORD PTR [r11+0x20],rdi
   11803:	push   r12
   11805:	sub    rsp,0x2c0
   1180c:	mov    rax,QWORD PTR [rip+0x68ed]        # 0x18100
   11813:	xor    rax,rsp
   11816:	mov    QWORD PTR [rsp+0x2b0],rax
   1181e:	mov    rbx,rcx
   11821:	lea    rcx,[r11-0x216]
   11828:	xor    esi,esi
   1182a:	xor    edx,edx
   1182c:	mov    r8d,0xfe
   11832:	mov    WORD PTR [rsp+0xb0],si
   1183a:	call   0x152c0
   1183f:	lea    rax,[rsp+0x1b0]
   11847:	lea    edi,[rsi+0x38]
   1184a:	lea    rcx,[rsp+0x70]
   1184f:	mov    r12d,0x100
   11855:	mov    r8,rdi
   11858:	xor    edx,edx
   1185a:	mov    QWORD PTR [rsp+0x38],rsi
   1185f:	mov    WORD PTR [rsp+0x40],si
   11864:	mov    WORD PTR [rsp+0x42],r12w
   1186a:	mov    QWORD PTR [rsp+0x48],rax
   1186f:	call   0x152c0
   11874:	mov    rax,QWORD PTR [rbx]
   11877:	mov    rcx,QWORD PTR [rip+0x762a]        # 0x18ea8
   1187e:	lea    r9,[rsp+0x38]
   11883:	lea    r8,[rsp+0x70]
   11888:	xor    edx,edx
   1188a:	mov    QWORD PTR [rsp+0x90],rax
   11892:	mov    DWORD PTR [rsp+0x70],edi
   11896:	mov    DWORD PTR [rsp+0x88],0x1
   118a1:	mov    DWORD PTR [rsp+0x8c],0x1
   118ac:	call   QWORD PTR [rip+0x730e]        # 0x18bc0
   118b2:	mov    edi,eax
   118b4:	cmp    eax,esi
   118b6:	jne    0x11a50
   118bc:	mov    r8,QWORD PTR [rsp+0x38]
   118c1:	mov    rdx,QWORD PTR [rbx]
   118c4:	mov    rcx,QWORD PTR [rip+0x75dd]        # 0x18ea8
   118cb:	call   QWORD PTR [rip+0x6a8f]        # 0x18360
   118d1:	mov    edi,eax
   118d3:	cmp    eax,esi
   118d5:	jne    0x11a50
   118db:	mov    rdx,QWORD PTR [rsp+0x38]
   118e0:	mov    rcx,QWORD PTR [rip+0x75c1]        # 0x18ea8
   118e7:	lea    r8,[rbx+0x48]
   118eb:	call   QWORD PTR [rip+0x72d7]        # 0x18bc8
   118f1:	mov    rdx,QWORD PTR [rbx]
   118f4:	mov    rcx,QWORD PTR [rip+0x75ad]        # 0x18ea8
   118fb:	lea    rax,[rsp+0xb0]
   11903:	lea    r8d,[rsi+0x1]
   11907:	mov    r9d,0x1f0000
   1190d:	mov    QWORD PTR [rsp+0x58],rax
   11912:	lea    rax,[rsp+0x30]
   11917:	mov    WORD PTR [rsp+0x50],si
   1191c:	mov    QWORD PTR [rsp+0x28],rax
   11921:	mov    WORD PTR [rsp+0x52],r12w
   11927:	mov    QWORD PTR [rsp+0x30],rsi
   1192c:	mov    QWORD PTR [rsp+0x20],rsi
   11931:	call   QWORD PTR [rip+0x6a69]        # 0x183a0
   11937:	mov    edi,eax
   11939:	cmp    eax,esi
   1193b:	jne    0x11975
   1193d:	lea    rdx,[rip+0x495c]        # 0x162a0
   11944:	lea    rcx,[rsp+0x60]
   11949:	call   QWORD PTR [rip+0x5721]        # 0x17070
   1194f:	mov    rcx,QWORD PTR [rip+0x7552]        # 0x18ea8
   11956:	lea    rdx,[rsp+0x50]
   1195b:	mov    QWORD PTR [rsp+0x20],rdx
   11960:	mov    rdx,QWORD PTR [rsp+0x30]
   11965:	lea    r8,[rsp+0x60]
   1196a:	xor    r9d,r9d
   1196d:	call   QWORD PTR [rip+0x701d]        # 0x18990
   11973:	mov    edi,eax
   11975:	mov    rdx,QWORD PTR [rsp+0x30]
   1197a:	cmp    rdx,rsi
   1197d:	je     0x1198c
   1197f:	mov    rcx,QWORD PTR [rip+0x7522]        # 0x18ea8
   11986:	call   QWORD PTR [rip+0x6fcc]        # 0x18958
   1198c:	cmp    edi,esi
   1198e:	jne    0x11a50
   11994:	lea    r9,[rsp+0xb0]
   1199c:	lea    r8,[rip+0x491d]        # 0x162c0
   119a3:	lea    rdx,[rip+0x4936]        # 0x162e0
   119aa:	lea    rcx,[rsp+0x40]
   119af:	call   0x11184
   119b4:	mov    edi,eax
   119b6:	cmp    eax,esi
   119b8:	jne    0x11a50
   119be:	mov    rdx,QWORD PTR [rbx]
   119c1:	mov    rcx,QWORD PTR [rip+0x74e0]        # 0x18ea8
   119c8:	lea    r8,[rsp+0x40]
   119cd:	call   QWORD PTR [rip+0x6acd]        # 0x184a0
   119d3:	mov    edi,eax
   119d5:	cmp    eax,esi
   119d7:	jne    0x11a50
   119d9:	mov    r8,QWORD PTR [rbx+0x50]
   119dd:	xor    eax,eax
   119df:	or     rcx,0xffffffffffffffff
   119e3:	mov    r9d,0x1
   119e9:	lea    rdi,[rsp+0xb0]
   119f1:	lea    rdx,[rip+0x48f8]        # 0x162f0
   119f8:	repnz scas ax,WORD PTR es:[rdi]
   119fb:	mov    BYTE PTR [rbx+0xc9],0x1
   11a02:	not    rcx
   11a05:	lea    eax,[rcx+rcx*1]
   11a08:	lea    ecx,[r9+0x3]
   11a0c:	mov    DWORD PTR [rsp+0x28],eax
   11a10:	lea    rax,[rsp+0xb0]
   11a18:	mov    QWORD PTR [rsp+0x20],rax
   11a1d:	call   QWORD PTR [rip+0x560d]        # 0x17030
   11a23:	mov    edi,eax
   11a25:	cmp    eax,esi
   11a27:	jne    0x11a50
   11a29:	mov    rdx,QWORD PTR [rbx]
   11a2c:	mov    rcx,QWORD PTR [rip+0x7475]        # 0x18ea8
   11a33:	lea    r8,[rip+0x5766]        # 0x171a0
   11a3a:	xor    r9d,r9d
   11a3d:	mov    BYTE PTR [rbx+0xca],0x1
   11a44:	call   QWORD PTR [rip+0x6a3e]        # 0x18488
   11a4a:	mov    edi,eax
   11a4c:	cmp    eax,esi
   11a4e:	je     0x11a54
   11a50:	mov    QWORD PTR [rbx+0x50],rsi
   11a54:	mov    eax,edi
   11a56:	mov    rcx,QWORD PTR [rsp+0x2b0]
   11a5e:	xor    rcx,rsp
   11a61:	call   0x14ce0
   11a66:	lea    r11,[rsp+0x2c0]
   11a6e:	mov    rbx,QWORD PTR [r11+0x18]
   11a72:	mov    rsi,QWORD PTR [r11+0x20]
   11a76:	mov    rdi,QWORD PTR [r11+0x28]
   11a7a:	mov    rsp,r11
   11a7d:	pop    r12
   11a7f:	ret
   11a80:	int3
   11a81:	int3
   11a82:	int3
   11a83:	int3
   11a84:	int3
   11a85:	int3
   11a86:	int3
   11a87:	int3
   11a88:	rex push rbx
   11a8a:	sub    rsp,0x40
   11a8e:	cmp    BYTE PTR [rcx+0x68],0xff
   11a92:	mov    rbx,rcx
   11a95:	jne    0x11a9b
   11a97:	xor    eax,eax
   11a99:	jmp    0x11aeb
   11a9b:	xor    edx,edx
   11a9d:	lea    rcx,[rsp+0x20]
   11aa2:	lea    r8d,[rdx+0x14]
   11aa6:	call   0x152c0
   11aab:	mov    rdx,QWORD PTR [rbx+0x80]
   11ab2:	mov    rcx,QWORD PTR [rip+0x73ef]        # 0x18ea8
   11ab9:	lea    r8,[rsp+0x20]
   11abe:	mov    DWORD PTR [rsp+0x20],0x14
   11ac6:	call   QWORD PTR [rip+0x71fc]        # 0x18cc8
   11acc:	movzx  r8d,BYTE PTR [rsp+0x28]
   11ad2:	movzx  r9d,BYTE PTR [rbx+0x68]
   11ad7:	shl    r8w,0x8
   11adc:	mov    dl,0x22
   11ade:	mov    rcx,rbx
   11ae1:	or     r8w,0x1
   11ae6:	call   0x12fb4
   11aeb:	add    rsp,0x40
   11aef:	pop    rbx
   11af0:	ret
   11af1:	int3
   11af2:	int3
   11af3:	int3
   11af4:	int3
   11af5:	int3
   11af6:	int3
   11af7:	int3
   11af8:	xor    eax,eax
   11afa:	ret
   11afb:	int3
   11afc:	int3
   11afd:	int3
   11afe:	int3
   11aff:	int3
   11b00:	int3
   11b01:	int3
   11b02:	int3
   11b03:	int3
   11b04:	sub    rsp,0x28
   11b08:	cmp    BYTE PTR [rcx+0x68],0xff
   11b0c:	jne    0x11b12
   11b0e:	xor    eax,eax
   11b10:	jmp    0x11b24
   11b12:	movzx  r9d,BYTE PTR [rcx+0x68]
   11b17:	mov    r8d,0x1
   11b1d:	mov    dl,0x22
   11b1f:	call   0x12fb4
   11b24:	add    rsp,0x28
   11b28:	ret
   11b29:	int3
   11b2a:	int3
   11b2b:	int3
   11b2c:	int3
   11b2d:	int3
   11b2e:	int3
   11b2f:	int3
   11b30:	sub    rsp,0x28
   11b34:	cmp    BYTE PTR [rcx+0x68],0xff
   11b38:	jne    0x11b3e
   11b3a:	xor    eax,eax
   11b3c:	jmp    0x11b4d
   11b3e:	movzx  r9d,BYTE PTR [rcx+0x68]
   11b43:	xor    r8d,r8d
   11b46:	mov    dl,0x22
   11b48:	call   0x12fb4
   11b4d:	add    rsp,0x28
   11b51:	ret
   11b52:	int3
   11b53:	int3
   11b54:	int3
   11b55:	int3
   11b56:	int3
   11b57:	int3
   11b58:	mov    QWORD PTR [rsp+0x10],rbx
   11b5d:	mov    QWORD PTR [rsp+0x18],rbp
   11b62:	push   rsi
   11b63:	push   rdi
   11b64:	push   r12
   11b66:	sub    rsp,0x1c0
   11b6d:	mov    rax,QWORD PTR [rip+0x658c]        # 0x18100
   11b74:	xor    rax,rsp
   11b77:	mov    QWORD PTR [rsp+0x1b8],rax
   11b7f:	mov    rdx,QWORD PTR [rcx]
   11b82:	xor    r12d,r12d
   11b85:	mov    rbx,rcx
   11b88:	mov    DWORD PTR [rcx+0x1cc],0x5
   11b92:	mov    DWORD PTR [rcx+0x1d0],0x20000
   11b9c:	mov    BYTE PTR [rcx+0x1db],0x1
   11ba3:	mov    BYTE PTR [rcx+0x1da],r12b
   11baa:	mov    BYTE PTR [rcx+0x1d9],r12b
   11bb1:	mov    DWORD PTR [rcx+0x1d4],0x1000
   11bbb:	mov    BYTE PTR [rcx+0x1d8],0x1
   11bc2:	mov    rcx,QWORD PTR [rip+0x72df]        # 0x18ea8
   11bc9:	lea    rax,[rsp+0x38]
   11bce:	mov    QWORD PTR [rsp+0x28],rax
   11bd3:	lea    r8d,[r12+0x1]
   11bd8:	mov    r9d,0x1f0000
   11bde:	mov    QWORD PTR [rsp+0x38],r12
   11be3:	mov    QWORD PTR [rsp+0x20],r12
   11be8:	call   QWORD PTR [rip+0x67b2]        # 0x183a0
   11bee:	cmp    eax,r12d
   11bf1:	jne    0x11f36
   11bf7:	lea    edi,[r12+0x34]
   11bfc:	lea    rcx,[rsp+0x180]
   11c04:	lea    rdx,[rip+0x4705]        # 0x16310
   11c0b:	mov    r8,rdi
   11c0e:	call   0x15f60
   11c13:	lea    r11d,[r12+0x32]
   11c18:	lea    rax,[rsp+0x180]
   11c20:	lea    ebp,[rdi-0x10]
   11c23:	lea    rcx,[rsp+0x108]
   11c2b:	lea    rdx,[rip+0x471e]        # 0x16350
   11c32:	mov    r8,rbp
   11c35:	mov    WORD PTR [rsp+0x80],r11w
   11c3e:	mov    WORD PTR [rsp+0x82],di
   11c46:	mov    QWORD PTR [rsp+0x88],rax
   11c4e:	call   0x15f60
   11c53:	lea    esi,[rdi-0x12]
   11c56:	lea    rax,[rsp+0x108]
   11c5e:	lea    edi,[rbp+0x4]
   11c61:	lea    rcx,[rsp+0x158]
   11c69:	lea    rdx,[rip+0x4710]        # 0x16380
   11c70:	mov    r8,rdi
   11c73:	mov    WORD PTR [rsp+0x90],si
   11c7b:	mov    WORD PTR [rsp+0x92],bp
   11c83:	mov    QWORD PTR [rsp+0x98],rax
   11c8b:	call   0x15f60
   11c90:	lea    r11d,[r12+0x26]
   11c95:	lea    rax,[rsp+0x158]
   11c9d:	lea    rcx,[rsp+0x130]
   11ca5:	lea    rdx,[rip+0x4704]        # 0x163b0
   11cac:	mov    r8,rbp
   11caf:	mov    WORD PTR [rsp+0x72],di
   11cb4:	mov    WORD PTR [rsp+0x70],r11w
   11cba:	mov    QWORD PTR [rsp+0x78],rax
   11cbf:	call   0x15f60
   11cc4:	lea    r8,[rip+0xffffffffffffe335]        # 0x10000
   11ccb:	lea    rcx,[rsp+0xb0]
   11cd3:	lea    rax,[rsp+0x130]
   11cdb:	mov    QWORD PTR [rsp+0x58],rax
   11ce0:	mov    rax,QWORD PTR [r8+0x63e0]
   11ce7:	lea    edx,[rbp-0xa]
   11cea:	mov    QWORD PTR [rcx],rax
   11ced:	mov    rax,QWORD PTR [r8+0x63e8]
   11cf4:	mov    WORD PTR [rsp+0x50],si
   11cf9:	mov    QWORD PTR [rcx+0x8],rax
   11cfd:	mov    eax,DWORD PTR [r8+0x63f0]
   11d04:	mov    WORD PTR [rsp+0x52],bp
   11d09:	mov    DWORD PTR [rcx+0x10],eax
   11d0c:	movzx  eax,WORD PTR [r8+0x63f4]
   11d14:	mov    WORD PTR [rsp+0xa0],dx
   11d1c:	mov    WORD PTR [rcx+0x14],ax
   11d20:	lea    rcx,[rsp+0xe8]
   11d28:	lea    eax,[rbp-0x10]
   11d2b:	mov    WORD PTR [rsp+0x60],ax
   11d30:	lea    eax,[rbp-0xe]
   11d33:	mov    WORD PTR [rsp+0x42],dx
   11d38:	mov    WORD PTR [rsp+0x62],ax
   11d3d:	lea    rax,[rsp+0xb0]
   11d45:	mov    QWORD PTR [rsp+0x68],rax
   11d4a:	mov    rax,QWORD PTR [r8+0x6400]
   11d51:	mov    QWORD PTR [rcx],rax
   11d54:	mov    rax,QWORD PTR [r8+0x6408]
   11d5b:	mov    QWORD PTR [rcx+0x8],rax
   11d5f:	mov    rax,QWORD PTR [r8+0x6410]
   11d66:	mov    QWORD PTR [rcx+0x10],rax
   11d6a:	mov    eax,DWORD PTR [r8+0x6418]
   11d71:	mov    DWORD PTR [rcx+0x18],eax
   11d74:	lea    rcx,[rsp+0xc8]
   11d7c:	lea    eax,[rbp-0x8]
   11d7f:	mov    WORD PTR [rsp+0xa2],ax
   11d87:	lea    rax,[rsp+0xe8]
   11d8f:	mov    QWORD PTR [rsp+0xa8],rax
   11d97:	mov    rax,QWORD PTR [r8+0x6420]
   11d9e:	mov    QWORD PTR [rcx],rax
   11da1:	mov    rax,QWORD PTR [r8+0x6428]
   11da8:	mov    QWORD PTR [rcx+0x8],rax
   11dac:	mov    rax,QWORD PTR [r8+0x6430]
   11db3:	mov    QWORD PTR [rcx+0x10],rax
   11db7:	movzx  eax,WORD PTR [r8+0x6438]
   11dbf:	mov    WORD PTR [rcx+0x18],ax
   11dc3:	lea    eax,[rbp-0xc]
   11dc6:	mov    WORD PTR [rsp+0x40],ax
   11dcb:	mov    rdx,QWORD PTR [rsp+0x38]
   11dd0:	mov    rcx,QWORD PTR [rip+0x70d1]        # 0x18ea8
   11dd7:	lea    rax,[rsp+0xc8]
   11ddf:	lea    r9,[rsp+0x30]
   11de4:	lea    r8,[rsp+0x80]
   11dec:	mov    QWORD PTR [rsp+0x48],rax
   11df1:	call   QWORD PTR [rip+0x6ba9]        # 0x189a0
   11df7:	cmp    eax,r12d
   11dfa:	jne    0x11e06
   11dfc:	mov    eax,DWORD PTR [rsp+0x30]
   11e00:	mov    DWORD PTR [rbx+0x1cc],eax
   11e06:	mov    rdx,QWORD PTR [rsp+0x38]
   11e0b:	mov    rcx,QWORD PTR [rip+0x7096]        # 0x18ea8
   11e12:	lea    r9,[rsp+0x30]
   11e17:	lea    r8,[rsp+0x90]
   11e1f:	call   QWORD PTR [rip+0x6b7b]        # 0x189a0
   11e25:	cmp    eax,r12d
   11e28:	jne    0x11e38
   11e2a:	cmp    DWORD PTR [rsp+0x30],r12d
   11e2f:	setne  al
   11e32:	mov    BYTE PTR [rbx+0x1d8],al
   11e38:	mov    rdx,QWORD PTR [rsp+0x38]
   11e3d:	mov    rcx,QWORD PTR [rip+0x7064]        # 0x18ea8
   11e44:	lea    r9,[rsp+0x30]
   11e49:	lea    r8,[rsp+0x70]
   11e4e:	call   QWORD PTR [rip+0x6b4c]        # 0x189a0
   11e54:	cmp    eax,r12d
   11e57:	jne    0x11e67
   11e59:	cmp    DWORD PTR [rsp+0x30],r12d
   11e5e:	setne  al
   11e61:	mov    BYTE PTR [rbx+0x1d9],al
   11e67:	mov    rdx,QWORD PTR [rsp+0x38]
   11e6c:	mov    rcx,QWORD PTR [rip+0x7035]        # 0x18ea8
   11e73:	lea    r9,[rsp+0x30]
   11e78:	lea    r8,[rsp+0x50]
   11e7d:	call   QWORD PTR [rip+0x6b1d]        # 0x189a0
   11e83:	cmp    eax,r12d
   11e86:	jne    0x11e96
   11e88:	cmp    DWORD PTR [rsp+0x30],r12d
   11e8d:	setne  al
   11e90:	mov    BYTE PTR [rbx+0x1da],al
   11e96:	mov    rdx,QWORD PTR [rsp+0x38]
   11e9b:	mov    rcx,QWORD PTR [rip+0x7006]        # 0x18ea8
   11ea2:	lea    r9,[rsp+0x30]
   11ea7:	lea    r8,[rsp+0x60]
   11eac:	call   QWORD PTR [rip+0x6aee]        # 0x189a0
   11eb2:	cmp    eax,r12d
   11eb5:	jne    0x11ec4
   11eb7:	mov    eax,DWORD PTR [rsp+0x30]
   11ebb:	shl    eax,0xa
   11ebe:	mov    DWORD PTR [rbx+0x1d0],eax
   11ec4:	mov    rdx,QWORD PTR [rsp+0x38]
   11ec9:	mov    rcx,QWORD PTR [rip+0x6fd8]        # 0x18ea8
   11ed0:	lea    r9,[rsp+0x30]
   11ed5:	lea    r8,[rsp+0x40]
   11eda:	call   QWORD PTR [rip+0x6ac0]        # 0x189a0
   11ee0:	cmp    eax,r12d
   11ee3:	jne    0x11ef3
   11ee5:	cmp    DWORD PTR [rsp+0x30],r12d
   11eea:	setne  al
   11eed:	mov    BYTE PTR [rbx+0x1db],al
   11ef3:	mov    rdx,QWORD PTR [rsp+0x38]
   11ef8:	mov    rcx,QWORD PTR [rip+0x6fa9]        # 0x18ea8
   11eff:	lea    r9,[rsp+0x30]
   11f04:	lea    r8,[rsp+0xa0]
   11f0c:	call   QWORD PTR [rip+0x6a8e]        # 0x189a0
   11f12:	cmp    eax,r12d
   11f15:	jne    0x11f24
   11f17:	mov    eax,DWORD PTR [rsp+0x30]
   11f1b:	shl    eax,0xa
   11f1e:	mov    DWORD PTR [rbx+0x1d4],eax
   11f24:	mov    rdx,QWORD PTR [rsp+0x38]
   11f29:	mov    rcx,QWORD PTR [rip+0x6f78]        # 0x18ea8
   11f30:	call   QWORD PTR [rip+0x6a22]        # 0x18958
   11f36:	cmp    BYTE PTR [rbx+0x1d8],r12b
   11f3d:	je     0x11f64
   11f3f:	lea    rax,[rip+0xfffffffffffffbea]        # 0x11b30
   11f46:	mov    QWORD PTR [rbx+0x1e0],rax
   11f4d:	lea    rax,[rip+0xfffffffffffffb34]        # 0x11a88
   11f54:	mov    QWORD PTR [rbx+0x1e8],rax
   11f5b:	lea    rax,[rip+0xfffffffffffffb96]        # 0x11af8
   11f62:	jmp    0x11f90
   11f64:	cmp    BYTE PTR [rbx+0x1d9],r12b
   11f6b:	je     0x11f99
   11f6d:	lea    rax,[rip+0xfffffffffffffb84]        # 0x11af8
   11f74:	mov    QWORD PTR [rbx+0x1e0],rax
   11f7b:	lea    rax,[rip+0xfffffffffffffb82]        # 0x11b04
   11f82:	mov    QWORD PTR [rbx+0x1e8],rax
   11f89:	lea    rax,[rip+0xfffffffffffffba0]        # 0x11b30
   11f90:	mov    QWORD PTR [rbx+0x1f0],rax
   11f97:	jmp    0x11fae
   11f99:	mov    QWORD PTR [rbx+0x1e0],r12
   11fa0:	mov    QWORD PTR [rbx+0x1e8],r12
   11fa7:	mov    QWORD PTR [rbx+0x1f0],r12
   11fae:	mov    rcx,QWORD PTR [rsp+0x1b8]
   11fb6:	xor    rcx,rsp
   11fb9:	call   0x14ce0
   11fbe:	lea    r11,[rsp+0x1c0]
   11fc6:	mov    rbx,QWORD PTR [r11+0x28]
   11fca:	mov    rbp,QWORD PTR [r11+0x30]
   11fce:	mov    rsp,r11
   11fd1:	pop    r12
   11fd3:	pop    rdi
   11fd4:	pop    rsi
   11fd5:	ret
   11fd6:	int3
   11fd7:	int3
   11fd8:	int3
   11fd9:	int3
   11fda:	int3
   11fdb:	int3
   11fdc:	mov    QWORD PTR [rsp+0x8],rbx
   11fe1:	mov    QWORD PTR [rsp+0x18],rbp
   11fe6:	push   rsi
   11fe7:	push   rdi
   11fe8:	push   r12
   11fea:	sub    rsp,0x2c0
   11ff1:	mov    rax,QWORD PTR [rip+0x6108]        # 0x18100
   11ff8:	xor    rax,rsp
   11ffb:	mov    QWORD PTR [rsp+0x2b0],rax
   12003:	xor    ebp,ebp
   12005:	mov    eax,0x100
   1200a:	mov    QWORD PTR [rsp+0x30],rdx
   1200f:	mov    WORD PTR [rsp+0x42],ax
   12014:	lea    rax,[rsp+0x1b0]
   1201c:	lea    esi,[rbp+0x1]
   1201f:	mov    QWORD PTR [rsp+0x38],rbp
   12024:	mov    WORD PTR [rsp+0x40],bp
   12029:	mov    QWORD PTR [rsp+0x48],rax
   1202e:	mov    r9d,esi
   12031:	lock xadd DWORD PTR [rip+0x709e],r9d        # 0x190d8
   1203a:	lea    r8,[rip+0x43ff]        # 0x16440
   12041:	lea    rdx,[rip+0x4438]        # 0x16480
   12048:	lea    rcx,[rsp+0x40]
   1204d:	add    r9d,esi
   12050:	call   0x11184
   12055:	cmp    eax,ebp
   12057:	jne    0x123bc
   1205d:	mov    rdx,QWORD PTR [rsp+0x30]
   12062:	mov    rcx,QWORD PTR [rip+0x6e3f]        # 0x18ea8
   12069:	lea    r8,[rsp+0x40]
   1206e:	call   QWORD PTR [rip+0x63c4]        # 0x18438
   12074:	cmp    eax,ebp
   12076:	jne    0x123bc
   1207c:	mov    rdx,QWORD PTR [rsp+0x30]
   12081:	mov    rcx,QWORD PTR [rip+0x6e20]        # 0x18ea8
   12088:	lea    r8d,[rbp+0x1b]
   1208c:	call   QWORD PTR [rip+0x639e]        # 0x18430
   12092:	mov    ebx,0x88
   12097:	lea    rcx,[rsp+0x120]
   1209f:	mov    r8,rbx
   120a2:	xor    edx,edx
   120a4:	call   0x152c0
   120a9:	mov    rdx,QWORD PTR [rsp+0x30]
   120ae:	mov    rcx,QWORD PTR [rip+0x6df3]        # 0x18ea8
   120b5:	lea    rax,[rip+0x330]        # 0x123ec
   120bc:	lea    r8,[rsp+0x120]
   120c4:	mov    DWORD PTR [rsp+0x120],ebx
   120cb:	mov    QWORD PTR [rsp+0x128],rax
   120d3:	lea    rax,[rip+0x38e]        # 0x12468
   120da:	mov    QWORD PTR [rsp+0x138],rax
   120e2:	lea    rax,[rip+0x41b]        # 0x12504
   120e9:	mov    QWORD PTR [rsp+0x148],rax
   120f1:	lea    rax,[rip+0x8a0]        # 0x12998
   120f8:	mov    QWORD PTR [rsp+0x150],rax
   12100:	lea    rax,[rip+0x3dd]        # 0x124e4
   12107:	mov    QWORD PTR [rsp+0x160],rax
   1210f:	lea    rax,[rip+0x3ce]        # 0x124e4
   12116:	mov    QWORD PTR [rsp+0x180],rax
   1211e:	call   QWORD PTR [rip+0x62b4]        # 0x183d8
   12124:	lea    r12d,[rbp+0x38]
   12128:	lea    rcx,[rsp+0x50]
   1212d:	mov    r8,r12
   12130:	xor    edx,edx
   12132:	call   0x152c0
   12137:	mov    rax,QWORD PTR [rip+0x6042]        # 0x18180
   1213e:	mov    rdx,QWORD PTR [rsp+0x30]
   12143:	mov    rcx,QWORD PTR [rip+0x6d5e]        # 0x18ea8
   1214a:	lea    r8,[rsp+0x50]
   1214f:	mov    QWORD PTR [rsp+0x80],rax
   12157:	mov    DWORD PTR [rsp+0x50],r12d
   1215c:	mov    DWORD PTR [rsp+0x68],esi
   12160:	mov    DWORD PTR [rsp+0x6c],esi
   12164:	call   QWORD PTR [rip+0x62f6]        # 0x18460
   1216a:	lea    rax,[rip+0x9af]        # 0x12b20
   12171:	lea    ebx,[rbp+0x4]
   12174:	mov    QWORD PTR [rsp+0xc0],rax
   1217c:	lea    rax,[rip+0xb2d]        # 0x12cb0
   12183:	lea    edi,[rbp+0x2]
   12186:	mov    QWORD PTR [rsp+0xc8],rax
   1218e:	lea    rax,[rip+0xc47]        # 0x12ddc
   12195:	lea    rcx,[rsp+0x50]
   1219a:	mov    r8,r12
   1219d:	xor    edx,edx
   1219f:	mov    DWORD PTR [rsp+0xb8],0x28
   121aa:	mov    QWORD PTR [rsp+0xd0],rax
   121b2:	mov    DWORD PTR [rsp+0xdc],ebx
   121b9:	mov    DWORD PTR [rsp+0xd8],edi
   121c0:	call   0x152c0
   121c5:	mov    rdx,QWORD PTR [rsp+0x30]
   121ca:	mov    rcx,QWORD PTR [rip+0x6cd7]        # 0x18ea8
   121d1:	lea    r9,[rsp+0x50]
   121d6:	lea    r8,[rsp+0xb8]
   121de:	mov    DWORD PTR [rsp+0x50],r12d
   121e3:	mov    DWORD PTR [rsp+0x68],esi
   121e7:	mov    DWORD PTR [rsp+0x6c],ebx
   121eb:	call   QWORD PTR [rip+0x6267]        # 0x18458
   121f1:	mov    rdx,QWORD PTR [rsp+0x30]
   121f6:	mov    rcx,QWORD PTR [rip+0x6cab]        # 0x18ea8
   121fd:	lea    r8,[rip+0x2424]        # 0x14628
   12204:	mov    r9b,0x3
   12207:	mov    DWORD PTR [rsp+0x28],ebp
   1220b:	mov    QWORD PTR [rsp+0x20],rbp
   12210:	call   QWORD PTR [rip+0x6252]        # 0x18468
   12216:	mov    rdx,QWORD PTR [rsp+0x30]
   1221b:	mov    rcx,QWORD PTR [rip+0x6c86]        # 0x18ea8
   12222:	mov    r8b,sil
   12225:	call   QWORD PTR [rip+0x61e5]        # 0x18410
   1222b:	mov    rdx,QWORD PTR [rsp+0x30]
   12230:	mov    rcx,QWORD PTR [rip+0x6c71]        # 0x18ea8
   12237:	mov    r8d,edi
   1223a:	call   QWORD PTR [rip+0x61c8]        # 0x18408
   12240:	mov    r8,r12
   12243:	xor    edx,edx
   12245:	lea    rcx,[rsp+0xe0]
   1224d:	call   0x152c0
   12252:	mov    rax,QWORD PTR [rip+0x5f77]        # 0x181d0
   12259:	mov    rcx,QWORD PTR [rip+0x6c48]        # 0x18ea8
   12260:	mov    QWORD PTR [rsp+0x110],rax
   12268:	lea    rax,[rip+0xcd5]        # 0x12f44
   1226f:	lea    r9,[rsp+0x38]
   12274:	lea    r8,[rsp+0xe0]
   1227c:	lea    rdx,[rsp+0x30]
   12281:	mov    DWORD PTR [rsp+0xe0],r12d
   12289:	mov    QWORD PTR [rsp+0xe8],rax
   12291:	mov    DWORD PTR [rsp+0xf8],esi
   12298:	mov    DWORD PTR [rsp+0xfc],edi
   1229f:	call   QWORD PTR [rip+0x61d3]        # 0x18478
   122a5:	cmp    eax,ebp
   122a7:	jl     0x123bc
   122ad:	lea    ebx,[rbp+0x30]
   122b0:	lea    rcx,[rsp+0x88]
   122b8:	xor    edx,edx
   122ba:	mov    r8,rbx
   122bd:	call   0x152c0
   122c2:	mov    rdx,QWORD PTR [rsp+0x38]
   122c7:	mov    rcx,QWORD PTR [rip+0x6bda]        # 0x18ea8
   122ce:	or     eax,0xffffffff
   122d1:	lea    r8,[rsp+0x88]
   122d9:	mov    DWORD PTR [rsp+0x88],ebx
   122e0:	mov    DWORD PTR [rsp+0x8c],edi
   122e7:	mov    DWORD PTR [rsp+0x90],edi
   122ee:	mov    DWORD PTR [rsp+0x98],edi
   122f5:	mov    DWORD PTR [rsp+0x9c],edi
   122fc:	mov    DWORD PTR [rsp+0xa0],edi
   12303:	mov    DWORD PTR [rsp+0xa8],edi
   1230a:	mov    DWORD PTR [rsp+0xac],edi
   12311:	mov    DWORD PTR [rsp+0xb0],eax
   12318:	mov    DWORD PTR [rsp+0xb4],eax
   1231f:	mov    DWORD PTR [rsp+0x94],esi
   12326:	mov    DWORD PTR [rsp+0xa4],esi
   1232d:	call   QWORD PTR [rip+0x6185]        # 0x184b8
   12333:	mov    r8,QWORD PTR [rip+0x5e96]        # 0x181d0
   1233a:	mov    rdx,QWORD PTR [rsp+0x38]
   1233f:	mov    rcx,QWORD PTR [rip+0x6b62]        # 0x18ea8
   12346:	call   QWORD PTR [rip+0x6524]        # 0x18870
   1234c:	mov    rcx,rax
   1234f:	mov    rbx,rax
   12352:	call   0x11204
   12357:	cmp    eax,ebp
   12359:	jl     0x123bc
   1235b:	mov    rcx,rbx
   1235e:	call   0x117f4
   12363:	cmp    eax,ebp
   12365:	jne    0x123bc
   12367:	lea    rcx,[rsp+0x50]
   1236c:	mov    r8,r12
   1236f:	xor    edx,edx
   12371:	call   0x152c0
   12376:	mov    rcx,QWORD PTR [rip+0x6b2b]        # 0x18ea8
   1237d:	mov    DWORD PTR [rsp+0x50],r12d
   12382:	mov    DWORD PTR [rsp+0x68],esi
   12386:	mov    DWORD PTR [rsp+0x6c],esi
   1238a:	mov    rax,QWORD PTR [rbx]
   1238d:	lea    r8,[rbx+0x118]
   12394:	lea    rdx,[rsp+0x50]
   12399:	mov    QWORD PTR [rsp+0x70],rax
   1239e:	call   QWORD PTR [rip+0x6854]        # 0x18bf8
   123a4:	cmp    eax,ebp
   123a6:	mov    edi,eax
   123a8:	jl     0x123bc
   123aa:	call   QWORD PTR [rip+0x4cc8]        # 0x17078
   123b0:	add    DWORD PTR [rax+0x14],esi
   123b3:	mov    BYTE PTR [rbx+0xcb],sil
   123ba:	mov    eax,edi
   123bc:	mov    rcx,QWORD PTR [rsp+0x2b0]
   123c4:	xor    rcx,rsp
   123c7:	call   0x14ce0
   123cc:	lea    r11,[rsp+0x2c0]
   123d4:	mov    rbx,QWORD PTR [r11+0x20]
   123d8:	mov    rbp,QWORD PTR [r11+0x30]
   123dc:	mov    rsp,r11
   123df:	pop    r12
   123e1:	pop    rdi
   123e2:	pop    rsi
   123e3:	ret
   123e4:	int3
   123e5:	int3
   123e6:	int3
   123e7:	int3
   123e8:	int3
   123e9:	int3
   123ea:	int3
   123eb:	int3
   123ec:	mov    QWORD PTR [rsp+0x8],rbx
   123f1:	push   rdi
   123f2:	sub    rsp,0x20
   123f6:	mov    r8,QWORD PTR [rip+0x5dd3]        # 0x181d0
   123fd:	mov    rdx,rcx
   12400:	mov    rcx,QWORD PTR [rip+0x6aa1]        # 0x18ea8
   12407:	xor    edi,edi
   12409:	call   QWORD PTR [rip+0x6461]        # 0x18870
   1240f:	mov    rbx,rax
   12412:	cmp    DWORD PTR [rax+0xd8],edi
   12418:	je     0x12452
   1241a:	mov    rax,QWORD PTR [rax+0x1e8]
   12421:	test   rax,rax
   12424:	je     0x1242d
   12426:	mov    rcx,rbx
   12429:	call   rax
   1242b:	mov    edi,eax
   1242d:	mov    ecx,0x1
   12432:	xchg   DWORD PTR [rbx+0xdc],ecx
   12438:	test   ecx,ecx
   1243a:	jne    0x12452
   1243c:	mov    rdx,QWORD PTR [rbx+0x88]
   12443:	mov    rcx,QWORD PTR [rip+0x6a5e]        # 0x18ea8
   1244a:	call   QWORD PTR [rip+0x6328]        # 0x18778
   12450:	mov    edi,eax
   12452:	mov    eax,edi
   12454:	mov    rbx,QWORD PTR [rsp+0x30]
   12459:	add    rsp,0x20
   1245d:	pop    rdi
   1245e:	ret
   1245f:	int3
   12460:	int3
   12461:	int3
   12462:	int3
   12463:	int3
   12464:	int3
   12465:	int3
   12466:	int3
   12467:	int3
   12468:	mov    QWORD PTR [rsp+0x8],rbx
   1246d:	push   rdi
   1246e:	sub    rsp,0x20
   12472:	mov    r8,QWORD PTR [rip+0x5d57]        # 0x181d0
   12479:	mov    rdx,rcx
   1247c:	mov    rcx,QWORD PTR [rip+0x6a25]        # 0x18ea8
   12483:	xor    ebx,ebx
   12485:	call   QWORD PTR [rip+0x63e5]        # 0x18870
   1248b:	mov    rdi,rax
   1248e:	cmp    DWORD PTR [rax+0xd8],ebx
   12494:	je     0x124ce
   12496:	mov    eax,ebx
   12498:	lea    r8d,[rbx+0x1]
   1249c:	xchg   DWORD PTR [rdi+0xdc],eax
   124a2:	cmp    eax,r8d
   124a5:	jne    0x124bb
   124a7:	mov    rdx,QWORD PTR [rdi+0x88]
   124ae:	mov    rcx,QWORD PTR [rip+0x69f3]        # 0x18ea8
   124b5:	call   QWORD PTR [rip+0x62c5]        # 0x18780
   124bb:	mov    rax,QWORD PTR [rdi+0x1f0]
   124c2:	cmp    rax,rbx
   124c5:	je     0x124ce
   124c7:	mov    rcx,rdi
   124ca:	call   rax
   124cc:	mov    ebx,eax
   124ce:	mov    eax,ebx
   124d0:	mov    rbx,QWORD PTR [rsp+0x30]
   124d5:	add    rsp,0x20
   124d9:	pop    rdi
   124da:	ret
   124db:	int3
   124dc:	int3
   124dd:	int3
   124de:	int3
   124df:	int3
   124e0:	int3
   124e1:	int3
   124e2:	int3
   124e3:	int3
   124e4:	mov    r8,QWORD PTR [rip+0x5ce5]        # 0x181d0
   124eb:	mov    rdx,rcx
   124ee:	mov    rcx,QWORD PTR [rip+0x69b3]        # 0x18ea8
   124f5:	rex.W jmp QWORD PTR [rip+0x6374]        # 0x18870
   124fc:	int3
   124fd:	int3
   124fe:	int3
   124ff:	int3
   12500:	int3
   12501:	int3
   12502:	int3
   12503:	int3
   12504:	mov    QWORD PTR [rsp+0x8],rbx
   12509:	mov    QWORD PTR [rsp+0x10],rbp
   1250e:	push   rsi
   1250f:	push   rdi
   12510:	push   r12
   12512:	push   r13
   12514:	push   r15
   12516:	sub    rsp,0x130
   1251d:	mov    r8,QWORD PTR [rip+0x5cac]        # 0x181d0
   12524:	mov    rdx,rcx
   12527:	mov    rcx,QWORD PTR [rip+0x697a]        # 0x18ea8
   1252e:	call   QWORD PTR [rip+0x633c]        # 0x18870
   12534:	xor    r15d,r15d
   12537:	lea    rbx,[rax+0x58]
   1253b:	mov    WORD PTR [rsp+0x178],r15w
   12544:	mov    rdi,rax
   12547:	cmp    QWORD PTR [rbx],r15
   1254a:	jne    0x1256b
   1254c:	mov    rdx,QWORD PTR [rax]
   1254f:	mov    rcx,QWORD PTR [rip+0x6952]        # 0x18ea8
   12556:	mov    r9,rbx
   12559:	xor    r8d,r8d
   1255c:	call   QWORD PTR [rip+0x66ce]        # 0x18c30
   12562:	cmp    eax,r15d
   12565:	jne    0x12976
   1256b:	mov    rdx,QWORD PTR [rbx]
   1256e:	mov    rcx,QWORD PTR [rip+0x6933]        # 0x18ea8
   12575:	lea    r8,[rdi+0x90]
   1257c:	call   QWORD PTR [rip+0x66be]        # 0x18c40
   12582:	mov    rdx,QWORD PTR [rbx]
   12585:	mov    rcx,QWORD PTR [rip+0x691c]        # 0x18ea8
   1258c:	lea    r9,[rsp+0x178]
   12594:	xor    r8d,r8d
   12597:	call   QWORD PTR [rip+0x66ab]        # 0x18c48
   1259d:	cmp    eax,0xc0000023
   125a2:	jne    0x12976
   125a8:	movzx  esi,WORD PTR [rsp+0x178]
   125b0:	cmp    si,r15w
   125b4:	je     0x12976
   125ba:	mov    ebp,0x38
   125bf:	lea    rcx,[rsp+0xa8]
   125c7:	xor    edx,edx
   125c9:	mov    r8,rbp
   125cc:	call   0x152c0
   125d1:	mov    DWORD PTR [rsp+0xa8],ebp
   125d8:	mov    ebp,0x1
   125dd:	mov    DWORD PTR [rsp+0xc0],ebp
   125e4:	mov    DWORD PTR [rsp+0xc4],ebp
   125eb:	mov    rax,QWORD PTR [rdi]
   125ee:	mov    QWORD PTR [rsp+0xc8],rax
   125f6:	movzx  eax,si
   125f9:	lea    rcx,[rsp+0xa0]
   12601:	lea    rsi,[rdi+0x70]
   12605:	lea    rdx,[rsp+0xa8]
   1260d:	mov    r9d,0x6d6f6355
   12613:	mov    QWORD PTR [rsp+0x30],rsi
   12618:	mov    QWORD PTR [rsp+0x28],rcx
   1261d:	mov    rcx,QWORD PTR [rip+0x6884]        # 0x18ea8
   12624:	xor    r8d,r8d
   12627:	mov    QWORD PTR [rsp+0x20],rax
   1262c:	call   QWORD PTR [rip+0x61ee]        # 0x18820
   12632:	cmp    eax,r15d
   12635:	jne    0x12976
   1263b:	mov    r8,QWORD PTR [rsi]
   1263e:	mov    rdx,QWORD PTR [rbx]
   12641:	mov    rcx,QWORD PTR [rip+0x6860]        # 0x18ea8
   12648:	lea    r9,[rsp+0x178]
   12650:	call   QWORD PTR [rip+0x65f2]        # 0x18c48
   12656:	cmp    eax,r15d
   12659:	jne    0x12976
   1265f:	mov    rdx,QWORD PTR [rbx]
   12662:	mov    rcx,QWORD PTR [rip+0x683f]        # 0x18ea8
   12669:	call   QWORD PTR [rip+0x65f9]        # 0x18c68
   1266f:	lea    esi,[rbp+0x1f]
   12672:	xor    edx,edx
   12674:	mov    BYTE PTR [rdi+0x1c6],al
   1267a:	lea    rcx,[rsp+0x40]
   1267f:	mov    r8,rsi
   12682:	cmp    al,bpl
   12685:	jne    0x12779
   1268b:	call   0x152c0
   12690:	lea    rcx,[rsp+0x80]
   12698:	lea    rdx,[rsp+0x40]
   1269d:	mov    r8,rsi
   126a0:	mov    DWORD PTR [rsp+0x40],esi
   126a4:	mov    DWORD PTR [rsp+0x44],0x2
   126ac:	call   0x15f60
   126b1:	mov    rdx,QWORD PTR [rbx]
   126b4:	mov    rcx,QWORD PTR [rip+0x67ed]        # 0x18ea8
   126bb:	lea    r9,[rsp+0x80]
   126c3:	xor    r8d,r8d
   126c6:	call   QWORD PTR [rip+0x65a4]        # 0x18c70
   126cc:	cmp    eax,r15d
   126cf:	jne    0x12976
   126d5:	mov    rdx,QWORD PTR [rbx]
   126d8:	mov    rcx,QWORD PTR [rip+0x67c9]        # 0x18ea8
   126df:	call   QWORD PTR [rip+0x6583]        # 0x18c68
   126e5:	cmp    al,r15b
   126e8:	jbe    0x1289e
   126ee:	mov    rax,QWORD PTR [rsp+0x90]
   126f6:	mov    QWORD PTR [rdi+0x60],rax
   126fa:	mov    al,BYTE PTR [rsp+0x88]
   12701:	mov    BYTE PTR [rdi+0x78],al
   12704:	cmp    al,0x2
   12706:	jb     0x12971
   1270c:	mov    bl,r15b
   1270f:	cmp    al,r15b
   12712:	jbe    0x1289e
   12718:	xor    edx,edx
   1271a:	lea    rcx,[rsp+0x60]
   1271f:	lea    r8d,[rdx+0x14]
   12723:	call   0x152c0
   12728:	mov    rdx,QWORD PTR [rdi+0x60]
   1272c:	mov    rcx,QWORD PTR [rip+0x6775]        # 0x18ea8
   12733:	lea    r9,[rsp+0x60]
   12738:	mov    r8b,bl
   1273b:	mov    DWORD PTR [rsp+0x60],0x14
   12743:	call   QWORD PTR [rip+0x663f]        # 0x18d88
   12749:	cmp    rax,r15
   1274c:	je     0x1276c
   1274e:	cmp    DWORD PTR [rsp+0x6c],0x3
   12753:	jne    0x1276c
   12755:	test   BYTE PTR [rsp+0x68],0x80
   1275a:	je     0x12765
   1275c:	mov    QWORD PTR [rdi+0x88],rax
   12763:	jmp    0x1276c
   12765:	mov    QWORD PTR [rdi+0x80],rax
   1276c:	add    bl,bpl
   1276f:	cmp    bl,BYTE PTR [rdi+0x78]
   12772:	jb     0x12718
   12774:	jmp    0x1289e
   12779:	call   0x152c0
   1277e:	lea    rcx,[rsp+0x80]
   12786:	lea    rdx,[rsp+0x40]
   1278b:	mov    r8,rsi
   1278e:	mov    DWORD PTR [rsp+0x40],esi
   12792:	mov    DWORD PTR [rsp+0x44],0x3
   1279a:	call   0x15f60
   1279f:	mov    rdx,QWORD PTR [rbx]
   127a2:	mov    rcx,QWORD PTR [rip+0x66ff]        # 0x18ea8
   127a9:	lea    r9,[rsp+0x80]
   127b1:	xor    r8d,r8d
   127b4:	call   QWORD PTR [rip+0x64b6]        # 0x18c70
   127ba:	cmp    eax,r15d
   127bd:	jne    0x12976
   127c3:	mov    rdx,QWORD PTR [rbx]
   127c6:	mov    rcx,QWORD PTR [rip+0x66db]        # 0x18ea8
   127cd:	call   QWORD PTR [rip+0x6495]        # 0x18c68
   127d3:	cmp    al,r15b
   127d6:	jbe    0x1289e
   127dc:	mov    al,BYTE PTR [rsp+0x98]
   127e3:	mov    sil,r15b
   127e6:	mov    BYTE PTR [rdi+0x1c5],al
   127ec:	cmp    al,r15b
   127ef:	jbe    0x1289e
   127f5:	mov    rdx,QWORD PTR [rbx]
   127f8:	mov    rcx,QWORD PTR [rip+0x66a9]        # 0x18ea8
   127ff:	mov    r8b,sil
   12802:	call   QWORD PTR [rip+0x6568]        # 0x18d70
   12808:	mov    r12,rax
   1280b:	cmp    rax,r15
   1280e:	je     0x12971
   12814:	mov    rcx,QWORD PTR [rip+0x668d]        # 0x18ea8
   1281b:	mov    rdx,rax
   1281e:	call   QWORD PTR [rip+0x655c]        # 0x18d80
   12824:	mov    bpl,r15b
   12827:	mov    r13b,al
   1282a:	cmp    al,r15b
   1282d:	jbe    0x1288e
   1282f:	xor    edx,edx
   12831:	lea    rcx,[rsp+0x40]
   12836:	lea    r8d,[rdx+0x14]
   1283a:	call   0x152c0
   1283f:	mov    rcx,QWORD PTR [rip+0x6662]        # 0x18ea8
   12846:	lea    r9,[rsp+0x40]
   1284b:	mov    r8b,bpl
   1284e:	mov    rdx,r12
   12851:	mov    DWORD PTR [rsp+0x40],0x14
   12859:	call   QWORD PTR [rip+0x6529]        # 0x18d88
   1285f:	cmp    rax,r15
   12862:	je     0x12886
   12864:	cmp    DWORD PTR [rsp+0x4c],0x3
   12869:	jne    0x12886
   1286b:	test   BYTE PTR [rsp+0x48],0x80
   12870:	je     0x1287b
   12872:	mov    QWORD PTR [rdi+0x88],rax
   12879:	jmp    0x12882
   1287b:	mov    QWORD PTR [rdi+0x80],rax
   12882:	mov    QWORD PTR [rdi+0x60],r12
   12886:	inc    bpl
   12889:	cmp    bpl,r13b
   1288c:	jb     0x1282f
   1288e:	inc    sil
   12891:	cmp    sil,BYTE PTR [rdi+0x1c5]
   12898:	jb     0x127f5
   1289e:	mov    eax,r15d
   128a1:	cmp    eax,r15d
   128a4:	jne    0x12976
   128aa:	cmp    QWORD PTR [rdi+0x80],r15
   128b1:	je     0x12971
   128b7:	cmp    QWORD PTR [rdi+0x88],r15
   128be:	je     0x12971
   128c4:	mov    rdx,QWORD PTR [rdi+0x60]
   128c8:	cmp    rdx,r15
   128cb:	je     0x128dd
   128cd:	mov    rcx,QWORD PTR [rip+0x65d4]        # 0x18ea8
   128d4:	call   QWORD PTR [rip+0x646e]        # 0x18d48
   128da:	mov    BYTE PTR [rdi+0x68],al
   128dd:	mov    rax,QWORD PTR [rdi+0x1e0]
   128e4:	cmp    rax,r15
   128e7:	jne    0x128ee
   128e9:	mov    eax,r15d
   128ec:	jmp    0x128f8
   128ee:	mov    rcx,rdi
   128f1:	call   rax
   128f3:	cmp    eax,r15d
   128f6:	jne    0x12976
   128f8:	cmp    BYTE PTR [rdi+0x1da],r15b
   128ff:	je     0x12976
   12901:	mov    ebx,DWORD PTR [rdi+0x1d4]
   12907:	mov    esi,0x48
   1290c:	lea    rcx,[rsp+0xe0]
   12914:	mov    r8,rsi
   12917:	xor    edx,edx
   12919:	call   0x152c0
   1291e:	mov    rcx,QWORD PTR [rip+0x6583]        # 0x18ea8
   12925:	lea    rax,[rip+0x1830]        # 0x1415c
   1292c:	mov    QWORD PTR [rsp+0x110],rax
   12934:	lea    rax,[rip+0x1815]        # 0x14150
   1293b:	mov    DWORD PTR [rsp+0xe0],esi
   12942:	mov    QWORD PTR [rsp+0x118],rdi
   1294a:	mov    QWORD PTR [rsp+0xe8],rbx
   12952:	mov    QWORD PTR [rsp+0x120],rax
   1295a:	mov    rdx,QWORD PTR [rdi+0x88]
   12961:	lea    r8,[rsp+0xe0]
   12969:	call   QWORD PTR [rip+0x63a1]        # 0x18d10
   1296f:	jmp    0x12976
   12971:	mov    eax,0xc0000001
   12976:	lea    r11,[rsp+0x130]
   1297e:	mov    rbx,QWORD PTR [r11+0x30]
   12982:	mov    rbp,QWORD PTR [r11+0x38]
   12986:	mov    rsp,r11
   12989:	pop    r15
   1298b:	pop    r13
   1298d:	pop    r12
   1298f:	pop    rdi
   12990:	pop    rsi
   12991:	ret
   12992:	int3
   12993:	int3
   12994:	int3
   12995:	int3
   12996:	int3
   12997:	int3
   12998:	rex push rbx
   1299a:	sub    rsp,0x20
   1299e:	mov    r8,QWORD PTR [rip+0x582b]        # 0x181d0
   129a5:	mov    rdx,rcx
   129a8:	mov    rcx,QWORD PTR [rip+0x64f9]        # 0x18ea8
   129af:	call   QWORD PTR [rip+0x5ebb]        # 0x18870
   129b5:	mov    edx,0xf
   129ba:	mov    rcx,rax
   129bd:	mov    rbx,rax
   129c0:	call   0x14b98
   129c5:	xor    edx,edx
   129c7:	mov    rcx,rbx
   129ca:	call   0x14a8c
   129cf:	xor    eax,eax
   129d1:	add    rsp,0x20
   129d5:	pop    rbx
   129d6:	ret
   129d7:	int3
   129d8:	int3
   129d9:	int3
   129da:	int3
   129db:	int3
   129dc:	int3
   129dd:	int3
   129de:	int3
   129df:	int3
   129e0:	mov    QWORD PTR [rsp+0x8],rbx
   129e5:	mov    QWORD PTR [rsp+0x10],rsi
   129ea:	push   rdi
   129eb:	sub    rsp,0x50
   129ef:	cmp    BYTE PTR [rcx+0x1da],0x0
   129f6:	mov    rbx,rcx
   129f9:	je     0x12a16
   129fb:	mov    rdx,QWORD PTR [rcx+0x88]
   12a02:	mov    rcx,QWORD PTR [rip+0x649f]        # 0x18ea8
   12a09:	call   QWORD PTR [rip+0x5d69]        # 0x18778
   12a0f:	mov    edi,eax
   12a11:	jmp    0x12b07
   12a16:	mov    rdx,QWORD PTR [rcx+0xa8]
   12a1d:	mov    r8,QWORD PTR [rip+0x5784]        # 0x181a8
   12a24:	mov    rcx,QWORD PTR [rip+0x647d]        # 0x18ea8
   12a2b:	call   QWORD PTR [rip+0x5e3f]        # 0x18870
   12a31:	mov    rdx,QWORD PTR [rbx+0xa8]
   12a38:	mov    rcx,QWORD PTR [rip+0x6469]        # 0x18ea8
   12a3f:	mov    rsi,rax
   12a42:	xor    eax,eax
   12a44:	lea    r8,[rsp+0x30]
   12a49:	mov    QWORD PTR [rsp+0x30],rax
   12a4e:	and    DWORD PTR [rsp+0x34],eax
   12a52:	mov    QWORD PTR [rsp+0x38],rax
   12a57:	and    DWORD PTR [rsp+0x38],eax
   12a5b:	mov    DWORD PTR [rsp+0x30],0x18
   12a63:	mov    QWORD PTR [rsp+0x40],rax
   12a68:	call   QWORD PTR [rip+0x5f7a]        # 0x189e8
   12a6e:	mov    edi,eax
   12a70:	test   eax,eax
   12a72:	jne    0x12b07
   12a78:	mov    r9,QWORD PTR [rsi+0x8]
   12a7c:	mov    r8,QWORD PTR [rbx+0xa8]
   12a83:	mov    rdx,QWORD PTR [rbx+0x88]
   12a8a:	mov    rcx,QWORD PTR [rip+0x6417]        # 0x18ea8
   12a91:	and    QWORD PTR [rsp+0x20],0x0
   12a97:	call   QWORD PTR [rip+0x626b]        # 0x18d08
   12a9d:	mov    edi,eax
   12a9f:	test   eax,eax
   12aa1:	jne    0x12b07
   12aa3:	mov    rdx,QWORD PTR [rbx+0xa8]
   12aaa:	mov    rcx,QWORD PTR [rip+0x63f7]        # 0x18ea8
   12ab1:	lea    r8,[rip+0x19a0]        # 0x14458
   12ab8:	mov    r9,rsi
   12abb:	call   QWORD PTR [rip+0x5f7f]        # 0x18a40
   12ac1:	lea    rcx,[rbx+0xb0]
   12ac8:	call   QWORD PTR [rip+0x45ba]        # 0x17088
   12ace:	mov    r8,QWORD PTR [rbx+0x88]
   12ad5:	mov    rdx,QWORD PTR [rbx+0xa8]
   12adc:	mov    rcx,QWORD PTR [rip+0x63c5]        # 0x18ea8
   12ae3:	xor    r9d,r9d
   12ae6:	call   QWORD PTR [rip+0x5f1c]        # 0x18a08
   12aec:	test   al,al
   12aee:	jne    0x12b07
   12af0:	lea    rcx,[rbx+0xb0]
   12af7:	xor    r8d,r8d
   12afa:	xor    edx,edx
   12afc:	mov    edi,0xc0000001
   12b01:	call   QWORD PTR [rip+0x4561]        # 0x17068
   12b07:	mov    rbx,QWORD PTR [rsp+0x60]
   12b0c:	mov    rsi,QWORD PTR [rsp+0x68]
   12b11:	mov    eax,edi
   12b13:	add    rsp,0x50
   12b17:	pop    rdi
   12b18:	ret
   12b19:	int3
   12b1a:	int3
   12b1b:	int3
   12b1c:	int3
   12b1d:	int3
   12b1e:	int3
   12b1f:	int3
   12b20:	mov    rax,rsp
   12b23:	mov    QWORD PTR [rax+0x8],rbx
   12b27:	mov    QWORD PTR [rax+0x10],rbp
   12b2b:	mov    QWORD PTR [rax+0x18],rsi
   12b2f:	mov    QWORD PTR [rax+0x20],rdi
   12b33:	push   r12
   12b35:	sub    rsp,0x20
   12b39:	mov    r8,QWORD PTR [rip+0x5690]        # 0x181d0
   12b40:	mov    r12,rdx
   12b43:	mov    rdx,rcx
   12b46:	mov    rcx,QWORD PTR [rip+0x635b]        # 0x18ea8
   12b4d:	call   QWORD PTR [rip+0x5d1d]        # 0x18870
   12b53:	mov    ebp,0x1
   12b58:	xor    edi,edi
   12b5a:	mov    ecx,ebp
   12b5c:	mov    rbx,rax
   12b5f:	xchg   DWORD PTR [rax+0xd8],ecx
   12b65:	cmp    ecx,edi
   12b67:	je     0x12b74
   12b69:	mov    r8d,0x80000011
   12b6f:	jmp    0x12c7e
   12b74:	mov    esi,0x14
   12b79:	lea    rcx,[rax+0x168]
   12b80:	xor    edx,edx
   12b82:	mov    r8,rsi
   12b85:	mov    DWORD PTR [rax+0x158],edi
   12b8b:	mov    DWORD PTR [rax+0x1c0],edi
   12b91:	mov    DWORD PTR [rax+0x20],edi
   12b94:	mov    DWORD PTR [rax+0x190],0x30
   12b9e:	call   0x152c0
   12ba3:	xor    eax,eax
   12ba5:	lea    rcx,[rbx+0x17c]
   12bac:	lea    r8d,[rsi-0x4]
   12bb0:	mov    DWORD PTR [rbx+0x160],eax
   12bb6:	mov    WORD PTR [rbx+0x164],ax
   12bbd:	xor    edx,edx
   12bbf:	mov    DWORD PTR [rbx+0x15c],0x800
   12bc9:	call   0x152c0
   12bce:	xor    eax,eax
   12bd0:	mov    WORD PTR [rbx+0x18c],ax
   12bd7:	lea    rcx,[rbx+0x1ac]
   12bde:	mov    r8,rsi
   12be1:	xor    edx,edx
   12be3:	mov    BYTE PTR [rbx+0x18e],al
   12be9:	call   0x152c0
   12bee:	mov    BYTE PTR [rbx+0x1c7],dil
   12bf5:	mov    BYTE PTR [rbx+0x1c8],dil
   12bfc:	mov    rax,QWORD PTR [rbx+0x128]
   12c03:	mov    QWORD PTR [rbx+0x138],rax
   12c0a:	mov    QWORD PTR [rbx+0x130],rax
   12c11:	mov    rax,QWORD PTR [rbx+0x1e8]
   12c18:	cmp    rax,rdi
   12c1b:	jne    0x12c21
   12c1d:	mov    esi,edi
   12c1f:	jmp    0x12c2c
   12c21:	mov    rcx,rbx
   12c24:	call   rax
   12c26:	mov    esi,eax
   12c28:	cmp    eax,edi
   12c2a:	jne    0x12c75
   12c2c:	xchg   DWORD PTR [rbx+0xdc],ebp
   12c32:	cmp    ebp,edi
   12c34:	jne    0x12c44
   12c36:	mov    rcx,rbx
   12c39:	call   0x129e0
   12c3e:	mov    esi,eax
   12c40:	cmp    eax,edi
   12c42:	jne    0x12c75
   12c44:	mov    rdx,QWORD PTR [rbx+0x8]
   12c48:	mov    rcx,QWORD PTR [rip+0x6259]        # 0x18ea8
   12c4f:	mov    r8,0xfffffffffff0bdc0
   12c56:	call   QWORD PTR [rip+0x5fbc]        # 0x18c18
   12c5c:	cmp    esi,edi
   12c5e:	jne    0x12c75
   12c60:	mov    rdx,QWORD PTR [rbx]
   12c63:	mov    rcx,QWORD PTR [rip+0x623e]        # 0x18ea8
   12c6a:	xor    r8d,r8d
   12c6d:	call   QWORD PTR [rip+0x580d]        # 0x18480
   12c73:	jmp    0x12c7b
   12c75:	xchg   DWORD PTR [rbx+0xd8],edi
   12c7b:	mov    r8d,esi
   12c7e:	mov    rcx,QWORD PTR [rip+0x6223]        # 0x18ea8
   12c85:	mov    rdx,r12
   12c88:	mov    rbx,QWORD PTR [rsp+0x30]
   12c8d:	mov    rbp,QWORD PTR [rsp+0x38]
   12c92:	mov    rsi,QWORD PTR [rsp+0x40]
   12c97:	mov    rdi,QWORD PTR [rsp+0x48]
   12c9c:	add    rsp,0x20
   12ca0:	pop    r12
   12ca2:	rex.W jmp QWORD PTR [rip+0x5daf]        # 0x18a58
   12ca9:	int3
   12caa:	int3
   12cab:	int3
   12cac:	int3
   12cad:	int3
   12cae:	int3
   12caf:	int3
   12cb0:	mov    QWORD PTR [rsp+0x8],rbx
   12cb5:	push   rdi
   12cb6:	sub    rsp,0x30
   12cba:	mov    rdx,rcx
   12cbd:	mov    rcx,QWORD PTR [rip+0x61e4]        # 0x18ea8
   12cc4:	xor    edi,edi
   12cc6:	mov    DWORD PTR [rsp+0x48],edi
   12cca:	call   QWORD PTR [rip+0x59a8]        # 0x18678
   12cd0:	mov    r8,QWORD PTR [rip+0x54f9]        # 0x181d0
   12cd7:	mov    rcx,QWORD PTR [rip+0x61ca]        # 0x18ea8
   12cde:	mov    rdx,rax
   12ce1:	call   QWORD PTR [rip+0x5b89]        # 0x18870
   12ce7:	lea    rdx,[rsp+0x48]
   12cec:	mov    rcx,rax
   12cef:	mov    rbx,rax
   12cf2:	call   0x14918
   12cf7:	mov    ecx,edi
   12cf9:	xchg   DWORD PTR [rbx+0xdc],ecx
   12cff:	cmp    ecx,0x1
   12d02:	jne    0x12d4e
   12d04:	mov    rcx,QWORD PTR [rip+0x619d]        # 0x18ea8
   12d0b:	cmp    BYTE PTR [rbx+0x1da],dil
   12d12:	je     0x12d27
   12d14:	mov    rdx,QWORD PTR [rbx+0x88]
   12d1b:	lea    r8d,[rdi+0x1]
   12d1f:	call   QWORD PTR [rip+0x5a5b]        # 0x18780
   12d25:	jmp    0x12d4e
   12d27:	mov    rdx,QWORD PTR [rbx+0xa8]
   12d2e:	call   QWORD PTR [rip+0x5cfc]        # 0x18a30
   12d34:	lea    rcx,[rbx+0xb0]
   12d3b:	xor    r9d,r9d
   12d3e:	xor    r8d,r8d
   12d41:	xor    edx,edx
   12d43:	mov    QWORD PTR [rsp+0x20],rdi
   12d48:	call   QWORD PTR [rip+0x42da]        # 0x17028
   12d4e:	mov    rdx,QWORD PTR [rbx+0x8]
   12d52:	mov    rcx,QWORD PTR [rip+0x614f]        # 0x18ea8
   12d59:	mov    r8b,0x1
   12d5c:	call   QWORD PTR [rip+0x5ebe]        # 0x18c20
   12d62:	mov    rdx,QWORD PTR [rbx+0x40]
   12d66:	mov    rcx,QWORD PTR [rip+0x613b]        # 0x18ea8
   12d6d:	mov    r8b,0x1
   12d70:	call   QWORD PTR [rip+0x5832]        # 0x185a8
   12d76:	mov    rdx,QWORD PTR [rbx+0x30]
   12d7a:	mov    rcx,QWORD PTR [rip+0x6127]        # 0x18ea8
   12d81:	mov    r8b,0x1
   12d84:	call   QWORD PTR [rip+0x581e]        # 0x185a8
   12d8a:	mov    rdx,QWORD PTR [rbx+0x38]
   12d8e:	mov    rcx,QWORD PTR [rip+0x6113]        # 0x18ea8
   12d95:	mov    r8b,0x1
   12d98:	call   QWORD PTR [rip+0x580a]        # 0x185a8
   12d9e:	mov    r11,QWORD PTR [rbx+0x1f0]
   12da5:	cmp    r11,rdi
   12da8:	je     0x12db0
   12daa:	mov    rcx,rbx
   12dad:	call   r11
   12db0:	xchg   DWORD PTR [rbx+0xd8],edi
   12db6:	mov    rdx,QWORD PTR [rbx]
   12db9:	mov    rcx,QWORD PTR [rip+0x60e8]        # 0x18ea8
   12dc0:	mov    r8b,0x1
   12dc3:	mov    rbx,QWORD PTR [rsp+0x40]
   12dc8:	add    rsp,0x30
   12dcc:	pop    rdi
   12dcd:	rex.W jmp QWORD PTR [rip+0x56ac]        # 0x18480
   12dd4:	int3
   12dd5:	int3
   12dd6:	int3
   12dd7:	int3
   12dd8:	int3
   12dd9:	int3
   12dda:	int3
   12ddb:	int3
   12ddc:	sub    rsp,0x28
   12de0:	and    DWORD PTR [rsp+0x38],0x0
   12de5:	mov    rdx,rcx
   12de8:	mov    rcx,QWORD PTR [rip+0x60b9]        # 0x18ea8
   12def:	call   QWORD PTR [rip+0x5883]        # 0x18678
   12df5:	mov    r8,QWORD PTR [rip+0x53d4]        # 0x181d0
   12dfc:	mov    rcx,QWORD PTR [rip+0x60a5]        # 0x18ea8
   12e03:	mov    rdx,rax
   12e06:	call   QWORD PTR [rip+0x5a64]        # 0x18870
   12e0c:	lea    rdx,[rsp+0x38]
   12e11:	mov    rcx,rax
   12e14:	call   0x14918
   12e19:	add    rsp,0x28
   12e1d:	ret
   12e1e:	int3
   12e1f:	int3
   12e20:	int3
   12e21:	int3
   12e22:	int3
   12e23:	int3
   12e24:	mov    QWORD PTR [rsp+0x8],rbx
   12e29:	mov    QWORD PTR [rsp+0x10],rsi
   12e2e:	push   rdi
   12e2f:	sub    rsp,0x20
   12e33:	mov    rdx,rcx
   12e36:	mov    rcx,QWORD PTR [rip+0x606b]        # 0x18ea8
   12e3d:	call   QWORD PTR [rip+0x5de5]        # 0x18c28
   12e43:	mov    r8,QWORD PTR [rip+0x5386]        # 0x181d0
   12e4a:	mov    rcx,QWORD PTR [rip+0x6057]        # 0x18ea8
   12e51:	mov    rdx,rax
   12e54:	call   QWORD PTR [rip+0x5a16]        # 0x18870
   12e5a:	mov    rbx,rax
   12e5d:	cmp    BYTE PTR [rax+0x1c8],0x0
   12e64:	je     0x12e88
   12e66:	cmp    BYTE PTR [rax+0x1c7],0x0
   12e6d:	mov    BYTE PTR [rax+0x1c8],0x0
   12e74:	je     0x12e80
   12e76:	bts    DWORD PTR [rax+0x190],0x7
   12e7e:	jmp    0x12e88
   12e80:	btr    DWORD PTR [rax+0x190],0x7
   12e88:	cmp    QWORD PTR [rax+0xe8],0x0
   12e90:	je     0x12f2c
   12e96:	movabs rax,0xfffff78000000014
   12ea0:	mov    rax,QWORD PTR [rax]
   12ea3:	cmp    QWORD PTR [rbx+0x108],rax
   12eaa:	jl     0x12eb5
   12eac:	cmp    QWORD PTR [rbx+0x110],rax
   12eb3:	jge    0x12f2c
   12eb5:	mov    rdi,QWORD PTR [rbx+0xe8]
   12ebc:	mov    rsi,QWORD PTR [rbx+0x100]
   12ec3:	mov    rcx,QWORD PTR [rip+0x5fde]        # 0x18ea8
   12eca:	and    QWORD PTR [rbx+0xe8],0x0
   12ed2:	and    QWORD PTR [rbx+0xf0],0x0
   12eda:	and    QWORD PTR [rbx+0xf8],0x0
   12ee2:	and    QWORD PTR [rbx+0x100],0x0
   12eea:	mov    rdx,rdi
   12eed:	call   QWORD PTR [rip+0x5b2d]        # 0x18a20
   12ef3:	mov    rcx,QWORD PTR [rip+0x5fae]        # 0x18ea8
   12efa:	mov    rdx,rdi
   12efd:	test   eax,eax
   12eff:	je     0x12f0c
   12f01:	mov    r8d,eax
   12f04:	call   QWORD PTR [rip+0x5b4e]        # 0x18a58
   12f0a:	jmp    0x12f1b
   12f0c:	mov    r9,rsi
   12f0f:	mov    r8d,0x102
   12f15:	call   QWORD PTR [rip+0x5b4d]        # 0x18a68
   12f1b:	mov    rdx,QWORD PTR [rbx+0x30]
   12f1f:	mov    rcx,QWORD PTR [rip+0x5f82]        # 0x18ea8
   12f26:	call   QWORD PTR [rip+0x5674]        # 0x185a0
   12f2c:	mov    rbx,QWORD PTR [rsp+0x30]
   12f31:	mov    rsi,QWORD PTR [rsp+0x38]
   12f36:	add    rsp,0x20
   12f3a:	pop    rdi
   12f3b:	ret
   12f3c:	int3
   12f3d:	int3
   12f3e:	int3
   12f3f:	int3
   12f40:	int3
   12f41:	int3
   12f42:	int3
   12f43:	int3
   12f44:	mov    QWORD PTR [rsp+0x8],rbx
   12f49:	push   rdi
   12f4a:	sub    rsp,0x20
   12f4e:	mov    r8,QWORD PTR [rip+0x527b]        # 0x181d0
   12f55:	mov    rdx,rcx
   12f58:	mov    rcx,QWORD PTR [rip+0x5f49]        # 0x18ea8
   12f5f:	call   QWORD PTR [rip+0x590b]        # 0x18870
   12f65:	mov    rdi,rax
   12f68:	cmp    BYTE PTR [rax+0xcb],0x0
   12f6f:	mov    rbx,QWORD PTR [rax+0x50]
   12f73:	je     0x12f7e
   12f75:	call   QWORD PTR [rip+0x40fd]        # 0x17078
   12f7b:	dec    DWORD PTR [rax+0x14]
   12f7e:	test   rbx,rbx
   12f81:	je     0x12fa1
   12f83:	cmp    BYTE PTR [rdi+0xca],0x0
   12f8a:	je     0x12fa1
   12f8c:	lea    rdx,[rip+0x335d]        # 0x162f0
   12f93:	mov    r8,rbx
   12f96:	mov    ecx,0x4
   12f9b:	call   QWORD PTR [rip+0x4097]        # 0x17038
   12fa1:	mov    rbx,QWORD PTR [rsp+0x30]
   12fa6:	add    rsp,0x20
   12faa:	pop    rdi
   12fab:	ret
   12fac:	int3
   12fad:	int3
   12fae:	int3
   12faf:	int3
   12fb0:	int3
   12fb1:	int3
   12fb2:	int3
   12fb3:	int3
   12fb4:	sub    rsp,0x68
   12fb8:	mov    rax,QWORD PTR [rip+0x5141]        # 0x18100
   12fbf:	xor    rax,rsp
   12fc2:	mov    QWORD PTR [rsp+0x58],rax
   12fc7:	xor    eax,eax
   12fc9:	mov    QWORD PTR [rsp+0x50],rax
   12fce:	and    al,0x1c
   12fd0:	mov    BYTE PTR [rsp+0x51],0x22
   12fd5:	or     al,0x21
   12fd7:	mov    WORD PTR [rsp+0x52],r8w
   12fdd:	mov    WORD PTR [rsp+0x54],r9w
   12fe3:	mov    BYTE PTR [rsp+0x50],al
   12fe7:	mov    eax,DWORD PTR [rcx+0x1cc]
   12fed:	test   eax,eax
   12fef:	jne    0x12ff6
   12ff1:	xor    r9d,r9d
   12ff4:	jmp    0x13023
   12ff6:	xor    edx,edx
   12ff8:	imul   rax,rax,0xffffffffff676980
   12fff:	lea    r9,[rsp+0x40]
   13004:	mov    QWORD PTR [rsp+0x40],rdx
   13009:	mov    QWORD PTR [rsp+0x48],rdx
   1300e:	mov    QWORD PTR [rsp+0x48],rax
   13013:	mov    DWORD PTR [rsp+0x40],0x10
   1301b:	mov    DWORD PTR [rsp+0x44],0x1
   13023:	and    QWORD PTR [rsp+0x30],0x0
   13029:	mov    rdx,QWORD PTR [rcx+0x58]
   1302d:	and    QWORD PTR [rsp+0x28],0x0
   13033:	mov    rcx,QWORD PTR [rip+0x5e6e]        # 0x18ea8
   1303a:	lea    rax,[rsp+0x50]
   1303f:	xor    r8d,r8d
   13042:	mov    QWORD PTR [rsp+0x20],rax
   13047:	call   QWORD PTR [rip+0x5c3b]        # 0x18c88
   1304d:	mov    rcx,QWORD PTR [rsp+0x58]
   13052:	xor    rcx,rsp
   13055:	call   0x14ce0
   1305a:	add    rsp,0x68
   1305e:	ret
   1305f:	int3
   13060:	int3
   13061:	int3
   13062:	int3
   13063:	int3
   13064:	int3
   13065:	int3
   13066:	int3
   13067:	int3
   13068:	sub    rsp,0x28
   1306c:	mov    rdx,rcx
   1306f:	mov    rcx,QWORD PTR [rip+0x5e32]        # 0x18ea8
   13076:	call   QWORD PTR [rip+0x5534]        # 0x185b0
   1307c:	mov    r8,QWORD PTR [rip+0x514d]        # 0x181d0
   13083:	mov    rcx,QWORD PTR [rip+0x5e1e]        # 0x18ea8
   1308a:	mov    rdx,rax
   1308d:	call   QWORD PTR [rip+0x57dd]        # 0x18870
   13093:	mov    ecx,DWORD PTR [rax+0x1c0]
   13099:	mov    edx,DWORD PTR [rax+0x20]
   1309c:	and    edx,ecx
   1309e:	test   dl,0x10
   130a1:	je     0x130a8
   130a3:	or     edx,0x8
   130a6:	jmp    0x130ab
   130a8:	and    edx,0xfffffff7
   130ab:	test   edx,edx
   130ad:	jne    0x130b8
   130af:	test   ecx,ecx
   130b1:	jne    0x130c0
   130b3:	cmp    DWORD PTR [rax+0x20],ecx
   130b6:	je     0x130c0
   130b8:	mov    rcx,rax
   130bb:	call   0x14a8c
   130c0:	add    rsp,0x28
   130c4:	ret
   130c5:	int3
   130c6:	int3
   130c7:	int3
   130c8:	int3
   130c9:	int3
   130ca:	int3
   130cb:	int3
   130cc:	mov    rax,rsp
   130cf:	mov    QWORD PTR [rax+0x8],rbx
   130d3:	mov    QWORD PTR [rax+0x10],rbp
   130d7:	mov    QWORD PTR [rax+0x18],rsi
   130db:	mov    QWORD PTR [rax+0x20],rdi
   130df:	push   r12
   130e1:	sub    rsp,0x40
   130e5:	mov    rbp,rdx
   130e8:	mov    rdx,rcx
   130eb:	mov    rcx,QWORD PTR [rip+0x5db6]        # 0x18ea8
   130f2:	call   QWORD PTR [rip+0x5610]        # 0x18708
   130f8:	mov    r8,QWORD PTR [rip+0x50d1]        # 0x181d0
   130ff:	mov    rcx,QWORD PTR [rip+0x5da2]        # 0x18ea8
   13106:	mov    rdx,rax
   13109:	call   QWORD PTR [rip+0x5761]        # 0x18870
   1310f:	mov    ecx,DWORD PTR [rsp+0x70]
   13113:	xor    edi,edi
   13115:	mov    rsi,rax
   13118:	mov    eax,0x1b004c
   1311d:	mov    QWORD PTR [rsp+0x30],rdi
   13122:	mov    QWORD PTR [rsp+0x38],rdi
   13127:	cmp    ecx,eax
   13129:	ja     0x13475
   1312f:	je     0x13434
   13135:	mov    eax,0x1b0028
   1313a:	cmp    ecx,eax
   1313c:	ja     0x1334f
   13142:	je     0x13318
   13148:	sub    ecx,0x1b0004
   1314e:	je     0x132d7
   13154:	lea    ebx,[rdi+0x4]
   13157:	sub    ecx,ebx
   13159:	je     0x132a8
   1315f:	sub    ecx,ebx
   13161:	je     0x13261
   13167:	sub    ecx,0x10
   1316a:	je     0x131d7
   1316c:	sub    ecx,ebx
   1316e:	je     0x1318f
   13170:	cmp    ecx,ebx
   13172:	jne    0x13680
   13178:	cmp    BYTE PTR [rsi+0x1c7],dil
   1317f:	je     0x13188
   13181:	or     DWORD PTR [rsi+0x190],0x20
   13188:	mov    eax,edi
   1318a:	jmp    0x137e2
   1318f:	mov    rcx,QWORD PTR [rip+0x5d12]        # 0x18ea8
   13196:	lea    rax,[rsp+0x38]
   1319b:	mov    ebx,0x14
   131a0:	lea    r9,[rsp+0x30]
   131a5:	mov    r8,rbx
   131a8:	mov    rdx,rbp
   131ab:	mov    QWORD PTR [rsp+0x20],rax
   131b0:	call   QWORD PTR [rip+0x58da]        # 0x18a90
   131b6:	cmp    eax,edi
   131b8:	jne    0x137db
   131be:	lea    rdx,[rsi+0x1ac]
   131c5:	mov    rcx,QWORD PTR [rsp+0x30]
   131ca:	mov    r8,rbx
   131cd:	call   0x15f60
   131d2:	jmp    0x137d6
   131d7:	mov    rcx,QWORD PTR [rip+0x5cca]        # 0x18ea8
   131de:	lea    rax,[rsp+0x38]
   131e3:	mov    ebx,0x14
   131e8:	lea    r9,[rsp+0x30]
   131ed:	mov    r8,rbx
   131f0:	mov    rdx,rbp
   131f3:	mov    QWORD PTR [rsp+0x20],rax
   131f8:	call   QWORD PTR [rip+0x588a]        # 0x18a88
   131fe:	cmp    eax,edi
   13200:	jne    0x137db
   13206:	mov    rdx,QWORD PTR [rsp+0x30]
   1320b:	or     r12d,0xffffffff
   1320f:	cmp    DWORD PTR [rdx],r12d
   13212:	jne    0x1322a
   13214:	cmp    DWORD PTR [rdx+0x4],r12d
   13218:	jne    0x1322a
   1321a:	cmp    DWORD PTR [rdx+0x8],r12d
   1321e:	jne    0x1322a
   13220:	mov    eax,0xc000000d
   13225:	jmp    0x137e2
   1322a:	lea    rcx,[rsi+0x1ac]
   13231:	mov    r8,rbx
   13234:	call   0x15f60
   13239:	mov    rcx,QWORD PTR [rsp+0x30]
   1323e:	mov    eax,edi
   13240:	cmp    DWORD PTR [rcx],r12d
   13243:	jne    0x13254
   13245:	cmp    DWORD PTR [rcx+0x4],edi
   13248:	jne    0x13254
   1324a:	cmp    DWORD PTR [rcx+0x8],edi
   1324d:	mov    ecx,0x1
   13252:	je     0x13256
   13254:	mov    ecx,edi
   13256:	mov    BYTE PTR [rsi+0x1c4],cl
   1325c:	jmp    0x137db
   13261:	mov    rcx,QWORD PTR [rip+0x5c40]        # 0x18ea8
   13268:	lea    rax,[rsp+0x38]
   1326d:	lea    r9,[rsp+0x30]
   13272:	mov    r8d,0x3
   13278:	mov    rdx,rbp
   1327b:	mov    QWORD PTR [rsp+0x20],rax
   13280:	call   QWORD PTR [rip+0x5802]        # 0x18a88
   13286:	cmp    eax,edi
   13288:	jne    0x137db
   1328e:	mov    rcx,QWORD PTR [rsp+0x30]
   13293:	movzx  eax,WORD PTR [rcx]
   13296:	mov    WORD PTR [rsi+0x18c],ax
   1329d:	mov    al,BYTE PTR [rcx+0x2]
   132a0:	mov    BYTE PTR [rsi+0x18e],al
   132a6:	jmp    0x13311
   132a8:	mov    rcx,QWORD PTR [rip+0x5bf9]        # 0x18ea8
   132af:	lea    rax,[rsp+0x38]
   132b4:	lea    r9,[rsp+0x30]
   132b9:	mov    r8d,0x8
   132bf:	mov    rdx,rbp
   132c2:	mov    QWORD PTR [rsp+0x20],rax
   132c7:	call   QWORD PTR [rip+0x57bb]        # 0x18a88
   132cd:	cmp    eax,edi
   132cf:	jne    0x137db
   132d5:	jmp    0x13311
   132d7:	mov    rcx,QWORD PTR [rip+0x5bca]        # 0x18ea8
   132de:	lea    rax,[rsp+0x38]
   132e3:	lea    r9,[rsp+0x30]
   132e8:	mov    r8d,0x4
   132ee:	mov    rdx,rbp
   132f1:	mov    QWORD PTR [rsp+0x20],rax
   132f6:	call   QWORD PTR [rip+0x578c]        # 0x18a88
   132fc:	cmp    eax,edi
   132fe:	jne    0x137db
   13304:	mov    rax,QWORD PTR [rsp+0x30]
   13309:	mov    ecx,DWORD PTR [rax]
   1330b:	mov    DWORD PTR [rsi+0x15c],ecx
   13311:	mov    eax,edi
   13313:	jmp    0x137db
   13318:	and    DWORD PTR [rsi+0x190],0xffffff5f
   13322:	test   BYTE PTR [rsi+0x1c0],0x20
   13329:	mov    BYTE PTR [rsi+0x1c7],dil
   13330:	mov    BYTE PTR [rsi+0x1c8],dil
   13337:	je     0x13188
   1333d:	mov    edx,0x20
   13342:	mov    rcx,rsi
   13345:	call   0x14b50
   1334a:	jmp    0x13188
   1334f:	sub    ecx,0x1b0030
   13355:	je     0x13188
   1335b:	mov    ebx,0x4
   13360:	sub    ecx,ebx
   13362:	je     0x13188
   13368:	sub    ecx,0xc
   1336b:	je     0x133ff
   13371:	sub    ecx,ebx
   13373:	je     0x133b7
   13375:	cmp    ecx,ebx
   13377:	jne    0x13680
   1337d:	mov    rcx,QWORD PTR [rip+0x5b24]        # 0x18ea8
   13384:	lea    rax,[rsp+0x38]
   13389:	lea    r9,[rsp+0x30]
   1338e:	mov    r8,rbx
   13391:	mov    rdx,rbp
   13394:	mov    QWORD PTR [rsp+0x20],rax
   13399:	call   QWORD PTR [rip+0x56f1]        # 0x18a90
   1339f:	cmp    eax,edi
   133a1:	jne    0x137db
   133a7:	mov    rdx,rbp
   133aa:	mov    rcx,rsi
   133ad:	call   0x14978
   133b2:	jmp    0x137f8
   133b7:	mov    rcx,QWORD PTR [rip+0x5aea]        # 0x18ea8
   133be:	lea    rax,[rsp+0x38]
   133c3:	lea    r9,[rsp+0x30]
   133c8:	mov    r8,rbx
   133cb:	mov    rdx,rbp
   133ce:	mov    QWORD PTR [rsp+0x20],rax
   133d3:	call   QWORD PTR [rip+0x56af]        # 0x18a88
   133d9:	cmp    eax,edi
   133db:	jne    0x137db
   133e1:	mov    rdx,QWORD PTR [rsp+0x30]
   133e6:	test   DWORD PTR [rdx],0xfffff800
   133ec:	jne    0x13220
   133f2:	mov    rcx,rsi
   133f5:	call   0x14918
   133fa:	jmp    0x137db
   133ff:	mov    rcx,QWORD PTR [rip+0x5aa2]        # 0x18ea8
   13406:	lea    rax,[rsp+0x38]
   1340b:	lea    r9,[rsp+0x30]
   13410:	mov    r8,rbx
   13413:	mov    rdx,rbp
   13416:	mov    QWORD PTR [rsp+0x20],rax
   1341b:	call   QWORD PTR [rip+0x566f]        # 0x18a90
   13421:	cmp    eax,edi
   13423:	jne    0x137db
   13429:	mov    ecx,DWORD PTR [rsi+0x1c0]
   1342f:	jmp    0x137cf
   13434:	mov    rcx,QWORD PTR [rip+0x5a6d]        # 0x18ea8
   1343b:	lea    rax,[rsp+0x38]
   13440:	lea    r9,[rsp+0x30]
   13445:	mov    r8d,0x4
   1344b:	mov    rdx,rbp
   1344e:	mov    QWORD PTR [rsp+0x20],rax
   13453:	call   QWORD PTR [rip+0x562f]        # 0x18a88
   13459:	cmp    eax,edi
   1345b:	jne    0x137db
   13461:	mov    rax,QWORD PTR [rsp+0x30]
   13466:	mov    rcx,rsi
   13469:	mov    edx,DWORD PTR [rax]
   1346b:	call   0x14b98
   13470:	jmp    0x137db
   13475:	mov    eax,0x1b0064
   1347a:	cmp    ecx,eax
   1347c:	ja     0x13655
   13482:	je     0x13612
   13488:	sub    ecx,0x1b0050
   1348e:	mov    ebx,0x4
   13493:	je     0x135dd
   13499:	sub    ecx,ebx
   1349b:	je     0x13591
   134a1:	sub    ecx,ebx
   134a3:	je     0x13545
   134a9:	sub    ecx,ebx
   134ab:	je     0x134fb
   134ad:	cmp    ecx,ebx
   134af:	jne    0x13680
   134b5:	mov    rcx,QWORD PTR [rip+0x59ec]        # 0x18ea8
   134bc:	lea    rax,[rsp+0x38]
   134c1:	lea    r9,[rsp+0x30]
   134c6:	lea    r8d,[rbx+0xc]
   134ca:	mov    rdx,rbp
   134cd:	mov    QWORD PTR [rsp+0x20],rax
   134d2:	call   QWORD PTR [rip+0x55b8]        # 0x18a90
   134d8:	cmp    eax,edi
   134da:	jne    0x137db
   134e0:	mov    rax,QWORD PTR [rsp+0x30]
   134e5:	movdqu xmm0,XMMWORD PTR [rsi+0x17c]
   134ed:	movdqu XMMWORD PTR [rax],xmm0
   134f1:	mov    eax,edi
   134f3:	lea    edi,[rbx+0xc]
   134f6:	jmp    0x137db
   134fb:	mov    rcx,QWORD PTR [rip+0x59a6]        # 0x18ea8
   13502:	lea    rax,[rsp+0x38]
   13507:	lea    r9,[rsp+0x30]
   1350c:	mov    r8d,0x6
   13512:	mov    rdx,rbp
   13515:	mov    QWORD PTR [rsp+0x20],rax
   1351a:	call   QWORD PTR [rip+0x5568]        # 0x18a88
   13520:	cmp    eax,edi
   13522:	jne    0x137db
   13528:	mov    rcx,QWORD PTR [rsp+0x30]
   1352d:	mov    eax,DWORD PTR [rcx]
   1352f:	mov    DWORD PTR [rsi+0x160],eax
   13535:	movzx  eax,WORD PTR [rcx+0x4]
   13539:	mov    WORD PTR [rsi+0x164],ax
   13540:	jmp    0x13311
   13545:	mov    rcx,QWORD PTR [rip+0x595c]        # 0x18ea8
   1354c:	lea    rax,[rsp+0x38]
   13551:	mov    ebx,0x6
   13556:	lea    r9,[rsp+0x30]
   1355b:	mov    r8,rbx
   1355e:	mov    rdx,rbp
   13561:	mov    QWORD PTR [rsp+0x20],rax
   13566:	call   QWORD PTR [rip+0x5524]        # 0x18a90
   1356c:	cmp    eax,edi
   1356e:	jne    0x137db
   13574:	mov    eax,DWORD PTR [rsi+0x160]
   1357a:	mov    rcx,QWORD PTR [rsp+0x30]
   1357f:	mov    DWORD PTR [rcx],eax
   13581:	movzx  eax,WORD PTR [rsi+0x164]
   13588:	mov    WORD PTR [rcx+0x4],ax
   1358c:	jmp    0x137d6
   13591:	mov    rcx,QWORD PTR [rip+0x5910]        # 0x18ea8
   13598:	lea    rax,[rsp+0x38]
   1359d:	mov    ebx,0x3
   135a2:	lea    r9,[rsp+0x30]
   135a7:	mov    r8,rbx
   135aa:	mov    rdx,rbp
   135ad:	mov    QWORD PTR [rsp+0x20],rax
   135b2:	call   QWORD PTR [rip+0x54d8]        # 0x18a90
   135b8:	cmp    eax,edi
   135ba:	jne    0x137db
   135c0:	movzx  eax,WORD PTR [rsi+0x18c]
   135c7:	mov    rcx,QWORD PTR [rsp+0x30]
   135cc:	mov    WORD PTR [rcx],ax
   135cf:	mov    al,BYTE PTR [rsi+0x18e]
   135d5:	mov    BYTE PTR [rcx+0x2],al
   135d8:	jmp    0x137d6
   135dd:	mov    rcx,QWORD PTR [rip+0x58c4]        # 0x18ea8
   135e4:	lea    rax,[rsp+0x38]
   135e9:	lea    r9,[rsp+0x30]
   135ee:	mov    r8,rbx
   135f1:	mov    rdx,rbp
   135f4:	mov    QWORD PTR [rsp+0x20],rax
   135f9:	call   QWORD PTR [rip+0x5491]        # 0x18a90
   135ff:	cmp    eax,edi
   13601:	jne    0x137db
   13607:	mov    ecx,DWORD PTR [rsi+0x15c]
   1360d:	jmp    0x137cf
   13612:	mov    rcx,QWORD PTR [rip+0x588f]        # 0x18ea8
   13619:	lea    rax,[rsp+0x38]
   1361e:	lea    r9,[rsp+0x30]
   13623:	mov    r8d,0x10
   13629:	mov    rdx,rbp
   1362c:	mov    QWORD PTR [rsp+0x20],rax
   13631:	call   QWORD PTR [rip+0x5451]        # 0x18a88
   13637:	cmp    eax,edi
   13639:	jne    0x137db
   1363f:	mov    rax,QWORD PTR [rsp+0x30]
   13644:	movdqu xmm0,XMMWORD PTR [rax]
   13648:	movdqu XMMWORD PTR [rsi+0x17c],xmm0
   13650:	jmp    0x13311
   13655:	sub    ecx,0x1b0068
   1365b:	mov    ebx,0x4
   13660:	je     0x137a3
   13666:	sub    ecx,ebx
   13668:	je     0x1376c
   1366e:	sub    ecx,0x8
   13671:	je     0x136e3
   13673:	lea    r12d,[rbx+0x14]
   13677:	sub    ecx,r12d
   1367a:	je     0x136a0
   1367c:	cmp    ecx,ebx
   1367e:	je     0x1368a
   13680:	mov    eax,0xc00000bb
   13685:	jmp    0x137e2
   1368a:	lea    rcx,[rsi+0x194]
   13691:	mov    r8,r12
   13694:	xor    edx,edx
   13696:	call   0x152c0
   1369b:	jmp    0x13188
   136a0:	mov    rcx,QWORD PTR [rip+0x5801]        # 0x18ea8
   136a7:	lea    rax,[rsp+0x38]
   136ac:	lea    r9,[rsp+0x30]
   136b1:	mov    r8,r12
   136b4:	mov    rdx,rbp
   136b7:	mov    QWORD PTR [rsp+0x20],rax
   136bc:	call   QWORD PTR [rip+0x53ce]        # 0x18a90
   136c2:	cmp    eax,edi
   136c4:	jne    0x137db
   136ca:	mov    rcx,QWORD PTR [rsp+0x30]
   136cf:	lea    rdx,[rsi+0x194]
   136d6:	mov    r8,r12
   136d9:	call   0x15f60
   136de:	jmp    0x13765
   136e3:	mov    rcx,QWORD PTR [rip+0x57be]        # 0x18ea8
   136ea:	lea    rax,[rsp+0x38]
   136ef:	mov    r12d,0x40
   136f5:	lea    r9,[rsp+0x30]
   136fa:	mov    r8,r12
   136fd:	mov    rdx,rbp
   13700:	mov    QWORD PTR [rsp+0x20],rax
   13705:	call   QWORD PTR [rip+0x5385]        # 0x18a90
   1370b:	cmp    eax,edi
   1370d:	jne    0x137db
   13713:	mov    rbx,QWORD PTR [rsp+0x30]
   13718:	mov    r8,r12
   1371b:	xor    edx,edx
   1371d:	mov    rcx,rbx
   13720:	call   0x152c0
   13725:	lea    edx,[r12-0x3e]
   1372a:	mov    WORD PTR [rbx],r12w
   1372e:	lea    ecx,[rdx-0x1]
   13731:	mov    WORD PTR [rbx+0x2],dx
   13735:	mov    DWORD PTR [rbx+0xc],edi
   13738:	mov    DWORD PTR [rbx+0x4],ecx
   1373b:	mov    eax,DWORD PTR [rsi+0x148]
   13741:	mov    DWORD PTR [rbx+0x14],0x10000000
   13748:	mov    DWORD PTR [rbx+0x18],ecx
   1374b:	mov    DWORD PTR [rbx+0x1c],r12d
   1374f:	mov    DWORD PTR [rbx+0x20],edx
   13752:	mov    DWORD PTR [rbx+0x10],eax
   13755:	mov    DWORD PTR [rbx+0x24],0x1007fffb
   1375c:	mov    eax,DWORD PTR [rsi+0x148]
   13762:	mov    DWORD PTR [rbx+0x30],eax
   13765:	mov    eax,edi
   13767:	mov    rdi,r12
   1376a:	jmp    0x137db
   1376c:	mov    rcx,QWORD PTR [rip+0x5735]        # 0x18ea8
   13773:	lea    rax,[rsp+0x38]
   13778:	mov    ebx,0x14
   1377d:	lea    r9,[rsp+0x30]
   13782:	mov    r8,rbx
   13785:	mov    rdx,rbp
   13788:	mov    QWORD PTR [rsp+0x20],rax
   1378d:	call   QWORD PTR [rip+0x52fd]        # 0x18a90
   13793:	cmp    eax,edi
   13795:	jne    0x137db
   13797:	lea    rdx,[rsi+0x168]
   1379e:	jmp    0x131c5
   137a3:	mov    rcx,QWORD PTR [rip+0x56fe]        # 0x18ea8
   137aa:	lea    rax,[rsp+0x38]
   137af:	lea    r9,[rsp+0x30]
   137b4:	mov    r8,rbx
   137b7:	mov    rdx,rbp
   137ba:	mov    QWORD PTR [rsp+0x20],rax
   137bf:	call   QWORD PTR [rip+0x52cb]        # 0x18a90
   137c5:	cmp    eax,edi
   137c7:	jne    0x137db
   137c9:	mov    ecx,DWORD PTR [rsi+0x190]
   137cf:	mov    rax,QWORD PTR [rsp+0x30]
   137d4:	mov    DWORD PTR [rax],ecx
   137d6:	mov    eax,edi
   137d8:	mov    rdi,rbx
   137db:	cmp    eax,0x103
   137e0:	je     0x137f8
   137e2:	mov    rcx,QWORD PTR [rip+0x56bf]        # 0x18ea8
   137e9:	mov    r9,rdi
   137ec:	mov    r8d,eax
   137ef:	mov    rdx,rbp
   137f2:	call   QWORD PTR [rip+0x5270]        # 0x18a68
   137f8:	mov    rbx,QWORD PTR [rsp+0x50]
   137fd:	mov    rbp,QWORD PTR [rsp+0x58]
   13802:	mov    rsi,QWORD PTR [rsp+0x60]
   13807:	mov    rdi,QWORD PTR [rsp+0x68]
   1380c:	add    rsp,0x40
   13810:	pop    r12
   13812:	ret
   13813:	int3
   13814:	int3
   13815:	int3
   13816:	int3
   13817:	int3
   13818:	int3
   13819:	int3
   1381a:	int3
   1381b:	int3
   1381c:	sub    rsp,0x28
   13820:	mov    r8,QWORD PTR [rip+0x4959]        # 0x18180
   13827:	mov    rdx,rcx
   1382a:	mov    rcx,QWORD PTR [rip+0x5677]        # 0x18ea8
   13831:	call   QWORD PTR [rip+0x5039]        # 0x18870
   13837:	mov    r8,QWORD PTR [rip+0x4992]        # 0x181d0
   1383e:	mov    rcx,QWORD PTR [rip+0x5663]        # 0x18ea8
   13845:	mov    rdx,QWORD PTR [rax]
   13848:	call   QWORD PTR [rip+0x5022]        # 0x18870
   1384e:	mov    rdx,QWORD PTR [rax+0x28]
   13852:	test   rdx,rdx
   13855:	je     0x1386f
   13857:	mov    rcx,QWORD PTR [rip+0x564a]        # 0x18ea8
   1385e:	and    QWORD PTR [rax+0x28],0x0
   13863:	mov    r8d,0xc0000120
   13869:	call   QWORD PTR [rip+0x51e9]        # 0x18a58
   1386f:	add    rsp,0x28
   13873:	ret
   13874:	int3
   13875:	int3
   13876:	int3
   13877:	int3
   13878:	int3
   13879:	int3
   1387a:	int3
   1387b:	int3
   1387c:	mov    QWORD PTR [rsp+0x8],rbx
   13881:	push   rdi
   13882:	sub    rsp,0x20
   13886:	mov    rdi,rdx
   13889:	mov    rdx,rcx
   1388c:	mov    rcx,QWORD PTR [rip+0x5615]        # 0x18ea8
   13893:	call   QWORD PTR [rip+0x4e6f]        # 0x18708
   13899:	mov    r8,QWORD PTR [rip+0x4930]        # 0x181d0
   138a0:	mov    rcx,QWORD PTR [rip+0x5601]        # 0x18ea8
   138a7:	mov    rdx,rax
   138aa:	call   QWORD PTR [rip+0x4fc0]        # 0x18870
   138b0:	mov    rcx,QWORD PTR [rip+0x55f1]        # 0x18ea8
   138b7:	mov    rdx,rdi
   138ba:	mov    r8,QWORD PTR [rax+0x10]
   138be:	mov    rbx,rax
   138c1:	call   QWORD PTR [rip+0x5221]        # 0x18ae8
   138c7:	mov    rcx,QWORD PTR [rip+0x55da]        # 0x18ea8
   138ce:	test   eax,eax
   138d0:	je     0x138e0
   138d2:	mov    r8d,eax
   138d5:	mov    rdx,rdi
   138d8:	call   QWORD PTR [rip+0x517a]        # 0x18a58
   138de:	jmp    0x138ea
   138e0:	mov    rdx,QWORD PTR [rbx+0x30]
   138e4:	call   QWORD PTR [rip+0x4cb6]        # 0x185a0
   138ea:	mov    rbx,QWORD PTR [rsp+0x30]
   138ef:	add    rsp,0x20
   138f3:	pop    rdi
   138f4:	ret
   138f5:	int3
   138f6:	int3
   138f7:	int3
   138f8:	int3
   138f9:	int3
   138fa:	int3
   138fb:	int3
   138fc:	mov    QWORD PTR [rsp+0x8],rbx
   13901:	mov    QWORD PTR [rsp+0x10],rsi
   13906:	push   rdi
   13907:	sub    rsp,0x20
   1390b:	mov    rsi,rdx
   1390e:	mov    rdx,rcx
   13911:	mov    rcx,QWORD PTR [rip+0x5590]        # 0x18ea8
   13918:	mov    rdi,r8
   1391b:	call   QWORD PTR [rip+0x4de7]        # 0x18708
   13921:	mov    r8,QWORD PTR [rip+0x48a8]        # 0x181d0
   13928:	mov    rcx,QWORD PTR [rip+0x5579]        # 0x18ea8
   1392f:	mov    rdx,rax
   13932:	call   QWORD PTR [rip+0x4f38]        # 0x18870
   13938:	mov    rcx,QWORD PTR [rip+0x5569]        # 0x18ea8
   1393f:	mov    rdx,rsi
   13942:	mov    r8,QWORD PTR [rax+0x18]
   13946:	add    DWORD PTR [rax+0x174],edi
   1394c:	mov    rbx,rax
   1394f:	call   QWORD PTR [rip+0x5193]        # 0x18ae8
   13955:	mov    rcx,QWORD PTR [rip+0x554c]        # 0x18ea8
   1395c:	test   eax,eax
   1395e:	je     0x13974
   13960:	mov    r8d,eax
   13963:	mov    rdx,rsi
   13966:	call   QWORD PTR [rip+0x50ec]        # 0x18a58
   1396c:	sub    DWORD PTR [rbx+0x174],edi
   13972:	jmp    0x1397e
   13974:	mov    rdx,QWORD PTR [rbx+0x38]
   13978:	call   QWORD PTR [rip+0x4c22]        # 0x185a0
   1397e:	mov    rbx,QWORD PTR [rsp+0x30]
   13983:	mov    rsi,QWORD PTR [rsp+0x38]
   13988:	add    rsp,0x20
   1398c:	pop    rdi
   1398d:	ret
   1398e:	int3
   1398f:	int3
   13990:	int3
   13991:	int3
   13992:	int3
   13993:	int3
   13994:	mov    rcx,QWORD PTR [rip+0x550d]        # 0x18ea8
   1399b:	xor    r9d,r9d
   1399e:	mov    r8d,0xc0000120
   139a4:	rex.W jmp QWORD PTR [rip+0x50bd]        # 0x18a68
   139ab:	int3
   139ac:	int3
   139ad:	int3
   139ae:	int3
   139af:	int3
   139b0:	int3
   139b1:	int3
   139b2:	int3
   139b3:	int3
   139b4:	mov    QWORD PTR [rsp+0x8],rbx
   139b9:	mov    QWORD PTR [rsp+0x10],rbp
   139be:	mov    QWORD PTR [rsp+0x18],rsi
   139c3:	push   rdi
   139c4:	sub    rsp,0x20
   139c8:	mov    edi,r8d
   139cb:	mov    r8,QWORD PTR [rip+0x47ae]        # 0x18180
   139d2:	mov    rbx,rcx
   139d5:	mov    rcx,QWORD PTR [rip+0x54cc]        # 0x18ea8
   139dc:	mov    rsi,rdx
   139df:	call   QWORD PTR [rip+0x4e8b]        # 0x18870
   139e5:	mov    rcx,QWORD PTR [rip+0x54bc]        # 0x18ea8
   139ec:	mov    rdx,rbx
   139ef:	mov    rbp,rax
   139f2:	call   QWORD PTR [rip+0x4d10]        # 0x18708
   139f8:	mov    r8,QWORD PTR [rip+0x47d1]        # 0x181d0
   139ff:	mov    rcx,QWORD PTR [rip+0x54a2]        # 0x18ea8
   13a06:	mov    rdx,rax
   13a09:	call   QWORD PTR [rip+0x4e61]        # 0x18870
   13a0f:	bt     edi,0x1c
   13a13:	jae    0x13a28
   13a15:	cmp    QWORD PTR [rbp+0x8],0x0
   13a1a:	je     0x13a24
   13a1c:	mov    rcx,rsi
   13a1f:	call   0x11118
   13a24:	btr    edi,0x1c
   13a28:	test   dil,0x2
   13a2c:	je     0x13a40
   13a2e:	mov    rcx,QWORD PTR [rip+0x5473]        # 0x18ea8
   13a35:	mov    rdx,rsi
   13a38:	call   QWORD PTR [rip+0x4ff2]        # 0x18a30
   13a3e:	jmp    0x13a59
   13a40:	test   dil,0x1
   13a44:	je     0x13a59
   13a46:	mov    rcx,QWORD PTR [rip+0x545b]        # 0x18ea8
   13a4d:	xor    r8d,r8d
   13a50:	mov    rdx,rsi
   13a53:	call   QWORD PTR [rip+0x50a7]        # 0x18b00
   13a59:	mov    rbx,QWORD PTR [rsp+0x30]
   13a5e:	mov    rbp,QWORD PTR [rsp+0x38]
   13a63:	mov    rsi,QWORD PTR [rsp+0x40]
   13a68:	add    rsp,0x20
   13a6c:	pop    rdi
   13a6d:	ret
   13a6e:	int3
   13a6f:	int3
   13a70:	int3
   13a71:	int3
   13a72:	int3
   13a73:	int3
   13a74:	rex push rbx
   13a76:	sub    rsp,0x20
   13a7a:	mov    r8,QWORD PTR [rip+0x46ff]        # 0x18180
   13a81:	mov    rcx,QWORD PTR [rip+0x5420]        # 0x18ea8
   13a88:	mov    rbx,rdx
   13a8b:	call   QWORD PTR [rip+0x4ddf]        # 0x18870
   13a91:	mov    rdx,QWORD PTR [rax+0x8]
   13a95:	test   rdx,rdx
   13a98:	je     0x13aa2
   13a9a:	mov    rcx,rbx
   13a9d:	call   0x11098
   13aa2:	add    rsp,0x20
   13aa6:	pop    rbx
   13aa7:	ret
   13aa8:	int3
   13aa9:	int3
   13aaa:	int3
   13aab:	int3
   13aac:	int3
   13aad:	int3
   13aae:	int3
   13aaf:	int3
   13ab0:	mov    QWORD PTR [rsp+0x8],rbx
   13ab5:	push   rdi
   13ab6:	sub    rsp,0x60
   13aba:	mov    rdx,rcx
   13abd:	mov    rcx,QWORD PTR [rip+0x53e4]        # 0x18ea8
   13ac4:	call   QWORD PTR [rip+0x4ae6]        # 0x185b0
   13aca:	mov    r8,QWORD PTR [rip+0x46ff]        # 0x181d0
   13ad1:	mov    rcx,QWORD PTR [rip+0x53d0]        # 0x18ea8
   13ad8:	mov    rdx,rax
   13adb:	call   QWORD PTR [rip+0x4d8f]        # 0x18870
   13ae1:	mov    ebx,0x14
   13ae6:	lea    rcx,[rsp+0x40]
   13aeb:	mov    r8,rbx
   13aee:	xor    edx,edx
   13af0:	mov    rdi,rax
   13af3:	call   0x152c0
   13af8:	mov    rcx,QWORD PTR [rip+0x53a9]        # 0x18ea8
   13aff:	mov    DWORD PTR [rsp+0x40],ebx
   13b03:	mov    rdx,QWORD PTR [rdi+0x80]
   13b0a:	lea    r8,[rsp+0x40]
   13b0f:	call   QWORD PTR [rip+0x51b3]        # 0x18cc8
   13b15:	lea    ecx,[rbx-0x13]
   13b18:	xor    ebx,ebx
   13b1a:	xchg   DWORD PTR [rdi+0xe0],ecx
   13b20:	cmp    ecx,ebx
   13b22:	jne    0x13cf9
   13b28:	jmp    0x13cc8
   13b2d:	mov    rdx,QWORD PTR [rsp+0x78]
   13b32:	mov    rcx,QWORD PTR [rip+0x536f]        # 0x18ea8
   13b39:	lea    r8,[rsp+0x88]
   13b41:	call   QWORD PTR [rip+0x4f31]        # 0x18a78
   13b47:	mov    rcx,QWORD PTR [rip+0x535a]        # 0x18ea8
   13b4e:	cmp    eax,ebx
   13b50:	jne    0x13cba
   13b56:	mov    rdx,QWORD PTR [rsp+0x88]
   13b5e:	lea    r8,[rsp+0x80]
   13b66:	call   QWORD PTR [rip+0x4cc4]        # 0x18830
   13b6c:	mov    ecx,DWORD PTR [rsp+0x80]
   13b73:	sub    DWORD PTR [rdi+0x174],ecx
   13b79:	cmp    rax,rbx
   13b7c:	jne    0x13b90
   13b7e:	mov    r8d,0xc000000d
   13b84:	mov    rcx,QWORD PTR [rip+0x531d]        # 0x18ea8
   13b8b:	jmp    0x13cbd
   13b90:	mov    rax,QWORD PTR [rsp+0x80]
   13b98:	cmp    rax,rbx
   13b9b:	jne    0x13ba2
   13b9d:	xor    r8d,r8d
   13ba0:	jmp    0x13b84
   13ba2:	cmp    BYTE PTR [rdi+0x1db],bl
   13ba8:	je     0x13bcd
   13baa:	cmp    DWORD PTR [rsp+0x44],ebx
   13bae:	je     0x13bc7
   13bb0:	mov    ecx,DWORD PTR [rsp+0x44]
   13bb4:	xor    edx,edx
   13bb6:	div    rcx
   13bb9:	cmp    rdx,rbx
   13bbc:	jne    0x13bc7
   13bbe:	mov    BYTE PTR [rdi+0xcc],0x1
   13bc5:	jmp    0x13bcd
   13bc7:	mov    BYTE PTR [rdi+0xcc],bl
   13bcd:	mov    r9,QWORD PTR [rsp+0x88]
   13bd5:	mov    r8,QWORD PTR [rsp+0x78]
   13bda:	mov    rdx,QWORD PTR [rdi+0x80]
   13be1:	mov    rcx,QWORD PTR [rip+0x52c0]        # 0x18ea8
   13be8:	mov    QWORD PTR [rsp+0x20],rbx
   13bed:	call   QWORD PTR [rip+0x5105]        # 0x18cf8
   13bf3:	mov    rcx,QWORD PTR [rip+0x52ae]        # 0x18ea8
   13bfa:	cmp    eax,ebx
   13bfc:	je     0x13c09
   13bfe:	mov    BYTE PTR [rdi+0xcc],bl
   13c04:	jmp    0x13cba
   13c09:	mov    rax,QWORD PTR [rsp+0x78]
   13c0e:	lea    r8,[rip+0x707]        # 0x1431c
   13c15:	mov    r9,rdi
   13c18:	mov    QWORD PTR [rdi+0x120],rax
   13c1f:	mov    rdx,QWORD PTR [rsp+0x78]
   13c24:	call   QWORD PTR [rip+0x4e16]        # 0x18a40
   13c2a:	mov    r11d,DWORD PTR [rdi+0x1b8]
   13c31:	mov    eax,DWORD PTR [rdi+0x1bc]
   13c37:	imul   r11,QWORD PTR [rsp+0x80]
   13c40:	add    r11,rax
   13c43:	jne    0x13c4a
   13c45:	mov    r9,rbx
   13c48:	jmp    0x13c77
   13c4a:	xor    eax,eax
   13c4c:	imul   r11,r11,0xffffffffffffd8f0
   13c53:	lea    r9,[rsp+0x30]
   13c58:	mov    QWORD PTR [rsp+0x30],rax
   13c5d:	mov    QWORD PTR [rsp+0x38],rax
   13c62:	mov    QWORD PTR [rsp+0x38],r11
   13c67:	mov    DWORD PTR [rsp+0x30],0x10
   13c6f:	mov    DWORD PTR [rsp+0x34],0x1
   13c77:	mov    r8,QWORD PTR [rdi+0x80]
   13c7e:	mov    rdx,QWORD PTR [rsp+0x78]
   13c83:	mov    rcx,QWORD PTR [rip+0x521e]        # 0x18ea8
   13c8a:	call   QWORD PTR [rip+0x4d78]        # 0x18a08
   13c90:	cmp    al,bl
   13c92:	jne    0x13cf9
   13c94:	mov    rcx,QWORD PTR [rip+0x520d]        # 0x18ea8
   13c9b:	mov    BYTE PTR [rdi+0xcc],bl
   13ca1:	mov    QWORD PTR [rdi+0x120],rbx
   13ca8:	mov    rdx,QWORD PTR [rsp+0x78]
   13cad:	call   QWORD PTR [rip+0x4d5d]        # 0x18a10
   13cb3:	mov    rcx,QWORD PTR [rip+0x51ee]        # 0x18ea8
   13cba:	mov    r8d,eax
   13cbd:	mov    rdx,QWORD PTR [rsp+0x78]
   13cc2:	call   QWORD PTR [rip+0x4d90]        # 0x18a58
   13cc8:	mov    rdx,QWORD PTR [rdi+0x18]
   13ccc:	mov    rcx,QWORD PTR [rip+0x51d5]        # 0x18ea8
   13cd3:	lea    r8,[rsp+0x78]
   13cd8:	call   QWORD PTR [rip+0x4a32]        # 0x18710
   13cde:	cmp    eax,ebx
   13ce0:	je     0x13b2d
   13ce6:	xchg   DWORD PTR [rdi+0xe0],ebx
   13cec:	mov    edx,0x4
   13cf1:	mov    rcx,rdi
   13cf4:	call   0x14b50
   13cf9:	mov    rbx,QWORD PTR [rsp+0x70]
   13cfe:	add    rsp,0x60
   13d02:	pop    rdi
   13d03:	ret
   13d04:	int3
   13d05:	int3
   13d06:	int3
   13d07:	int3
   13d08:	int3
   13d09:	int3
   13d0a:	int3
   13d0b:	int3
   13d0c:	rex push rbx
   13d0e:	sub    rsp,0x40
   13d12:	mov    rbx,rcx
   13d15:	lea    rcx,[rsp+0x20]
   13d1a:	mov    r8d,0x14
   13d20:	lea    rdx,[rbx+0x1ac]
   13d27:	call   0x15f60
   13d2c:	mov    rcx,QWORD PTR [rsp+0x20]
   13d31:	mov    r8d,DWORD PTR [rsp+0x28]
   13d36:	mov    r11d,DWORD PTR [rbx+0x100]
   13d3d:	mov    rax,rcx
   13d40:	or     r9d,0xffffffff
   13d44:	shr    rax,0x20
   13d48:	mov    edx,r8d
   13d4b:	cmp    eax,r9d
   13d4e:	je     0x13d5c
   13d50:	mov    edx,DWORD PTR [rbx+0xf8]
   13d56:	imul   edx,eax
   13d59:	add    edx,r8d
   13d5c:	cmp    ecx,r9d
   13d5f:	jne    0x13d6e
   13d61:	test   r8d,r8d
   13d64:	jne    0x13d6e
   13d66:	test   eax,eax
   13d68:	jne    0x13d6e
   13d6a:	xor    ecx,ecx
   13d6c:	xor    edx,edx
   13d6e:	neg    r11d
   13d71:	movabs r9,0xfffff78000000014
   13d7b:	movabs r8,0x7fffffffffffffff
   13d85:	sbb    eax,eax
   13d87:	and    eax,ecx
   13d89:	jne    0x13d94
   13d8b:	mov    QWORD PTR [rbx+0x108],r8
   13d92:	jmp    0x13daa
   13d94:	mov    ecx,eax
   13d96:	mov    rax,QWORD PTR [r9]
   13d99:	imul   rcx,rcx,0x2710
   13da0:	add    rcx,rax
   13da3:	mov    QWORD PTR [rbx+0x108],rcx
   13daa:	test   edx,edx
   13dac:	jne    0x13db7
   13dae:	mov    QWORD PTR [rbx+0x110],r8
   13db5:	jmp    0x13dcd
   13db7:	mov    rax,QWORD PTR [r9]
   13dba:	mov    ecx,edx
   13dbc:	imul   rcx,rcx,0x2710
   13dc3:	add    rcx,rax
   13dc6:	mov    QWORD PTR [rbx+0x110],rcx
   13dcd:	add    rsp,0x40
   13dd1:	pop    rbx
   13dd2:	ret
   13dd3:	int3
   13dd4:	int3
   13dd5:	int3
   13dd6:	int3
   13dd7:	int3
   13dd8:	int3
   13dd9:	int3
   13dda:	int3
   13ddb:	int3
   13ddc:	mov    QWORD PTR [rsp+0x8],rbx
   13de1:	push   rdi
   13de2:	sub    rsp,0x20
   13de6:	mov    r8,QWORD PTR [rip+0x4393]        # 0x18180
   13ded:	mov    rdi,rcx
   13df0:	mov    rdx,rcx
   13df3:	mov    rcx,QWORD PTR [rip+0x50ae]        # 0x18ea8
   13dfa:	call   QWORD PTR [rip+0x4a70]        # 0x18870
   13e00:	mov    r8,QWORD PTR [rip+0x43c9]        # 0x181d0
   13e07:	mov    rcx,QWORD PTR [rip+0x509a]        # 0x18ea8
   13e0e:	mov    rdx,QWORD PTR [rax]
   13e11:	call   QWORD PTR [rip+0x4a59]        # 0x18870
   13e17:	mov    rcx,QWORD PTR [rip+0x508a]        # 0x18ea8
   13e1e:	mov    r8d,0xc0000120
   13e24:	mov    rbx,rax
   13e27:	xor    eax,eax
   13e29:	mov    rdx,rdi
   13e2c:	mov    QWORD PTR [rbx+0xe8],rax
   13e33:	mov    QWORD PTR [rbx+0xf0],rax
   13e3a:	mov    QWORD PTR [rbx+0x100],rax
   13e41:	mov    QWORD PTR [rbx+0xf8],rax
   13e48:	movabs rax,0x7fffffffffffffff
   13e52:	mov    QWORD PTR [rbx+0x108],rax
   13e59:	mov    QWORD PTR [rbx+0x110],rax
   13e60:	call   QWORD PTR [rip+0x4bf2]        # 0x18a58
   13e66:	mov    rdx,QWORD PTR [rbx+0x30]
   13e6a:	mov    rcx,QWORD PTR [rip+0x5037]        # 0x18ea8
   13e71:	mov    rbx,QWORD PTR [rsp+0x30]
   13e76:	add    rsp,0x20
   13e7a:	pop    rdi
   13e7b:	rex.W jmp QWORD PTR [rip+0x471e]        # 0x185a0
   13e82:	int3
   13e83:	int3
   13e84:	int3
   13e85:	int3
   13e86:	int3
   13e87:	int3
   13e88:	mov    QWORD PTR [rsp+0x8],rbx
   13e8d:	mov    QWORD PTR [rsp+0x18],rsi
   13e92:	push   rdi
   13e93:	sub    rsp,0x50
   13e97:	mov    rdx,rcx
   13e9a:	mov    rcx,QWORD PTR [rip+0x5007]        # 0x18ea8
   13ea1:	call   QWORD PTR [rip+0x4709]        # 0x185b0
   13ea7:	mov    r8,QWORD PTR [rip+0x4322]        # 0x181d0
   13eae:	mov    rcx,QWORD PTR [rip+0x4ff3]        # 0x18ea8
   13eb5:	mov    rdx,rax
   13eb8:	call   QWORD PTR [rip+0x49b2]        # 0x18870
   13ebe:	mov    sil,BYTE PTR [rsp+0x68]
   13ec3:	mov    rbx,rax
   13ec6:	cmp    QWORD PTR [rbx+0xe8],0x0
   13ece:	je     0x14079
   13ed4:	mov    rcx,QWORD PTR [rbx+0xf8]
   13edb:	sub    rcx,QWORD PTR [rbx+0x100]
   13ee2:	je     0x13f35
   13ee4:	mov    rax,QWORD PTR [rbx+0x138]
   13eeb:	cmp    QWORD PTR [rbx+0x130],rax
   13ef2:	je     0x13f35
   13ef4:	mov    sil,BYTE PTR [rax]
   13ef7:	inc    rax
   13efa:	cmp    rax,QWORD PTR [rbx+0x140]
   13f01:	jb     0x13f0a
   13f03:	mov    rax,QWORD PTR [rbx+0x128]
   13f0a:	mov    QWORD PTR [rbx+0x138],rax
   13f11:	mov    rax,QWORD PTR [rbx+0xf0]
   13f18:	mov    BYTE PTR [rax],sil
   13f1b:	inc    QWORD PTR [rbx+0xf0]
   13f22:	inc    QWORD PTR [rbx+0x100]
   13f29:	dec    DWORD PTR [rbx+0x170]
   13f2f:	sub    rcx,0x1
   13f33:	jne    0x13ee4
   13f35:	mov    rdx,QWORD PTR [rbx+0x138]
   13f3c:	mov    rax,QWORD PTR [rbx+0x130]
   13f43:	cmp    rdx,rax
   13f46:	ja     0x13f4d
   13f48:	sub    rax,rdx
   13f4b:	jmp    0x13f61
   13f4d:	mov    rcx,QWORD PTR [rbx+0x140]
   13f54:	sub    rcx,QWORD PTR [rbx+0x128]
   13f5b:	sub    rcx,rdx
   13f5e:	add    rax,rcx
   13f61:	mov    rcx,QWORD PTR [rbx+0x140]
   13f68:	imul   rax,rax,0x64
   13f6c:	xor    edx,edx
   13f6e:	sub    rcx,QWORD PTR [rbx+0x128]
   13f75:	div    rcx
   13f78:	cmp    rax,0x32
   13f7c:	jae    0x13f93
   13f7e:	xor    eax,eax
   13f80:	xchg   DWORD PTR [rbx+0x158],eax
   13f86:	cmp    eax,0x1
   13f89:	jne    0x13f93
   13f8b:	mov    rcx,rbx
   13f8e:	call   0x129e0
   13f93:	mov    rdi,QWORD PTR [rbx+0x100]
   13f9a:	cmp    rdi,QWORD PTR [rbx+0xf8]
   13fa1:	jae    0x13ff8
   13fa3:	lea    rcx,[rsp+0x30]
   13fa8:	lea    rdx,[rbx+0x1ac]
   13faf:	mov    r8d,0x14
   13fb5:	call   0x15f60
   13fba:	mov    r11,QWORD PTR [rsp+0x30]
   13fbf:	cmp    r11d,0xffffffff
   13fc3:	jne    0x14132
   13fc9:	mov    eax,DWORD PTR [rsp+0x38]
   13fcd:	shr    r11,0x20
   13fd1:	test   r11d,r11d
   13fd4:	jne    0x13fda
   13fd6:	test   eax,eax
   13fd8:	je     0x13ff8
   13fda:	cmp    r11d,0xffffffff
   13fde:	jne    0x14132
   13fe4:	dec    eax
   13fe6:	cmp    eax,0xfffffffd
   13fe9:	ja     0x14132
   13fef:	test   rdi,rdi
   13ff2:	je     0x14132
   13ff8:	mov    rax,QWORD PTR [rbx+0xe8]
   13fff:	mov    rcx,QWORD PTR [rip+0x4ea2]        # 0x18ea8
   14006:	mov    QWORD PTR [rsp+0x68],rax
   1400b:	and    QWORD PTR [rbx+0xe8],0x0
   14013:	mov    rdx,QWORD PTR [rsp+0x68]
   14018:	call   QWORD PTR [rip+0x4a02]        # 0x18a20
   1401e:	test   eax,eax
   14020:	js     0x14040
   14022:	mov    r9,QWORD PTR [rbx+0x100]
   14029:	mov    rdx,QWORD PTR [rsp+0x68]
   1402e:	mov    rcx,QWORD PTR [rip+0x4e73]        # 0x18ea8
   14035:	xor    r8d,r8d
   14038:	call   QWORD PTR [rip+0x4a2a]        # 0x18a68
   1403e:	jmp    0x1405c
   14040:	cmp    eax,0xc0000120
   14045:	je     0x1405c
   14047:	mov    rdx,QWORD PTR [rsp+0x68]
   1404c:	mov    rcx,QWORD PTR [rip+0x4e55]        # 0x18ea8
   14053:	mov    r8d,eax
   14056:	call   QWORD PTR [rip+0x49fc]        # 0x18a58
   1405c:	and    QWORD PTR [rbx+0xf8],0x0
   14064:	and    QWORD PTR [rbx+0x100],0x0
   1406c:	and    QWORD PTR [rbx+0xf0],0x0
   14074:	jmp    0x13ec6
   14079:	mov    rdx,QWORD PTR [rbx+0x10]
   1407d:	mov    rcx,QWORD PTR [rip+0x4e24]        # 0x18ea8
   14084:	lea    r8,[rsp+0x68]
   14089:	call   QWORD PTR [rip+0x4681]        # 0x18710
   1408f:	test   eax,eax
   14091:	jne    0x1413a
   14097:	mov    rdx,QWORD PTR [rsp+0x68]
   1409c:	mov    rcx,QWORD PTR [rip+0x4e05]        # 0x18ea8
   140a3:	lea    rax,[rbx+0xf8]
   140aa:	lea    r9,[rbx+0xf0]
   140b1:	mov    r8d,0x1
   140b7:	mov    QWORD PTR [rsp+0x20],rax
   140bc:	call   QWORD PTR [rip+0x49ce]        # 0x18a90
   140c2:	test   eax,eax
   140c4:	je     0x140e0
   140c6:	mov    rdx,QWORD PTR [rsp+0x68]
   140cb:	mov    rcx,QWORD PTR [rip+0x4dd6]        # 0x18ea8
   140d2:	mov    r8d,eax
   140d5:	call   QWORD PTR [rip+0x497d]        # 0x18a58
   140db:	jmp    0x13ec6
   140e0:	mov    r8,QWORD PTR [rip+0x4099]        # 0x18180
   140e7:	mov    rdx,QWORD PTR [rsp+0x68]
   140ec:	mov    rcx,QWORD PTR [rip+0x4db5]        # 0x18ea8
   140f3:	call   QWORD PTR [rip+0x4777]        # 0x18870
   140f9:	lea    rdx,[rip+0xfffffffffffffcdc]        # 0x13ddc
   14100:	and    QWORD PTR [rax],0x0
   14104:	and    QWORD PTR [rax+0x8],0x0
   14109:	and    DWORD PTR [rax+0x10],0x0
   1410d:	mov    rcx,QWORD PTR [rbx]
   14110:	mov    QWORD PTR [rax],rcx
   14113:	mov    rcx,QWORD PTR [rsp+0x68]
   14118:	call   0x11098
   1411d:	test   eax,eax
   1411f:	jne    0x140c6
   14121:	mov    rax,QWORD PTR [rsp+0x68]
   14126:	mov    QWORD PTR [rbx+0xe8],rax
   1412d:	jmp    0x13ec6
   14132:	mov    rcx,rbx
   14135:	call   0x13d0c
   1413a:	mov    rbx,QWORD PTR [rsp+0x60]
   1413f:	mov    rsi,QWORD PTR [rsp+0x70]
   14144:	add    rsp,0x50
   14148:	pop    rdi
   14149:	ret
   1414a:	int3
   1414b:	int3
   1414c:	int3
   1414d:	int3
   1414e:	int3
   1414f:	int3
   14150:	mov    al,0x1
   14152:	ret
   14153:	int3
   14154:	int3
   14155:	int3
   14156:	int3
   14157:	int3
   14158:	int3
   14159:	int3
   1415a:	int3
   1415b:	int3
   1415c:	mov    rax,rsp
   1415f:	mov    QWORD PTR [rax+0x8],rbx
   14163:	mov    QWORD PTR [rax+0x10],rbp
   14167:	mov    QWORD PTR [rax+0x18],rsi
   1416b:	mov    QWORD PTR [rax+0x20],rdi
   1416f:	push   r12
   14171:	sub    rsp,0x20
   14175:	mov    rcx,QWORD PTR [rip+0x4d2c]        # 0x18ea8
   1417c:	mov    rbx,rdx
   1417f:	mov    rdx,QWORD PTR [r9]
   14182:	mov    rdi,r9
   14185:	mov    rbp,r8
   14188:	xor    esi,esi
   1418a:	call   QWORD PTR [rip+0x4a40]        # 0x18bd0
   14190:	mov    rcx,QWORD PTR [rip+0x4d11]        # 0x18ea8
   14197:	xor    r8d,r8d
   1419a:	mov    rdx,rbx
   1419d:	call   QWORD PTR [rip+0x468d]        # 0x18830
   141a3:	xor    ebx,ebx
   141a5:	mov    r12,rax
   141a8:	test   rbp,rbp
   141ab:	je     0x14279
   141b1:	mov    rcx,QWORD PTR [rdi+0x130]
   141b8:	mov    dl,BYTE PTR [r12]
   141bc:	lea    rax,[rcx+0x1]
   141c0:	cmp    rax,QWORD PTR [rdi+0x140]
   141c7:	jb     0x141d0
   141c9:	mov    rax,QWORD PTR [rdi+0x128]
   141d0:	cmp    rax,QWORD PTR [rdi+0x138]
   141d7:	je     0x1426f
   141dd:	mov    BYTE PTR [rcx],dl
   141df:	mov    rax,QWORD PTR [rdi+0x130]
   141e6:	inc    rax
   141e9:	cmp    rax,QWORD PTR [rdi+0x140]
   141f0:	jb     0x141f9
   141f2:	mov    rax,QWORD PTR [rdi+0x128]
   141f9:	mov    QWORD PTR [rdi+0x130],rax
   14200:	mov    al,BYTE PTR [rdi+0x163]
   14206:	inc    DWORD PTR [rdi+0x194]
   1420c:	inc    DWORD PTR [rdi+0x170]
   14212:	cmp    dl,al
   14214:	jne    0x1421d
   14216:	test   al,al
   14218:	je     0x1421d
   1421a:	or     esi,0x2
   1421d:	movsx  ecx,BYTE PTR [rip+0x226c]        # 0x16490
   14224:	movzx  eax,dl
   14227:	cmp    eax,ecx
   14229:	jne    0x1425f
   1422b:	mov    rax,rbp
   1422e:	sub    rax,rbx
   14231:	cmp    rax,0x7
   14235:	jb     0x1425f
   14237:	lea    rdx,[rip+0x2252]        # 0x16490
   1423e:	mov    r8d,0x7
   14244:	mov    rcx,r12
   14247:	call   QWORD PTR [rip+0x2df3]        # 0x17040
   1424d:	test   eax,eax
   1424f:	jne    0x1425f
   14251:	mov    BYTE PTR [rdi+0x1c7],0x1
   14258:	mov    BYTE PTR [rdi+0x1c8],0x1
   1425f:	inc    rbx
   14262:	inc    r12
   14265:	cmp    rbx,rbp
   14268:	jae    0x14279
   1426a:	jmp    0x141b1
   1426f:	mov    eax,ebp
   14271:	sub    eax,ebx
   14273:	add    DWORD PTR [rdi+0x1a4],eax
   14279:	mov    rdx,QWORD PTR [rdi+0x138]
   14280:	mov    rax,QWORD PTR [rdi+0x130]
   14287:	cmp    rdx,rax
   1428a:	ja     0x14291
   1428c:	sub    rax,rdx
   1428f:	jmp    0x142a5
   14291:	mov    rcx,QWORD PTR [rdi+0x140]
   14298:	sub    rcx,rdx
   1429b:	sub    rcx,QWORD PTR [rdi+0x128]
   142a2:	add    rax,rcx
   142a5:	mov    rcx,QWORD PTR [rdi+0x140]
   142ac:	imul   rax,rax,0x64
   142b0:	xor    edx,edx
   142b2:	sub    rcx,QWORD PTR [rdi+0x128]
   142b9:	div    rcx
   142bc:	cmp    rax,0x50
   142c0:	jb     0x142c6
   142c2:	bts    esi,0xa
   142c6:	test   rbp,rbp
   142c9:	je     0x142ce
   142cb:	or     esi,0x1
   142ce:	mov    edx,esi
   142d0:	mov    rcx,rdi
   142d3:	call   0x14b50
   142d8:	mov    rdx,QWORD PTR [rdi]
   142db:	mov    rcx,QWORD PTR [rip+0x4bc6]        # 0x18ea8
   142e2:	call   QWORD PTR [rip+0x48f0]        # 0x18bd8
   142e8:	mov    rdx,QWORD PTR [rdi+0x30]
   142ec:	mov    rcx,QWORD PTR [rip+0x4bb5]        # 0x18ea8
   142f3:	mov    rbx,QWORD PTR [rsp+0x30]
   142f8:	mov    rbp,QWORD PTR [rsp+0x38]
   142fd:	mov    rsi,QWORD PTR [rsp+0x40]
   14302:	mov    rdi,QWORD PTR [rsp+0x48]
   14307:	add    rsp,0x20
   1430b:	pop    r12
   1430d:	rex.W jmp QWORD PTR [rip+0x428c]        # 0x185a0
   14314:	int3
   14315:	int3
   14316:	int3
   14317:	int3
   14318:	int3
   14319:	int3
   1431a:	int3
   1431b:	int3
   1431c:	mov    QWORD PTR [rsp+0x8],rbx
   14321:	mov    QWORD PTR [rsp+0x10],rbp
   14326:	mov    QWORD PTR [rsp+0x18],rsi
   1432b:	push   rdi
   1432c:	sub    rsp,0x20
   14330:	mov    rbp,QWORD PTR [r9+0x120]
   14337:	mov    eax,DWORD PTR [r8+0x10]
   1433b:	xor    edi,edi
   1433d:	mov    rbx,r9
   14340:	mov    rsi,r8
   14343:	cmp    DWORD PTR [r8+0x8],edi
   14347:	jne    0x14352
   14349:	add    DWORD PTR [r9+0x198],eax
   14350:	jmp    0x14359
   14352:	add    DWORD PTR [r9+0x1a0],eax
   14359:	mov    rdx,QWORD PTR [r9+0xd0]
   14360:	cmp    rcx,rdx
   14363:	jne    0x143c5
   14365:	mov    rcx,QWORD PTR [rip+0x4b3c]        # 0x18ea8
   1436c:	call   QWORD PTR [rip+0x452e]        # 0x188a0
   14372:	mov    QWORD PTR [rbx+0xd0],rdi
   14379:	cmp    rbp,rdi
   1437c:	je     0x143bc
   1437e:	mov    r8,QWORD PTR [rip+0x3dfb]        # 0x18180
   14385:	mov    rcx,QWORD PTR [rip+0x4b1c]        # 0x18ea8
   1438c:	mov    rdx,rbp
   1438f:	call   QWORD PTR [rip+0x44db]        # 0x18870
   14395:	mov    rcx,QWORD PTR [rip+0x4b0c]        # 0x18ea8
   1439c:	mov    rdx,rbp
   1439f:	cmp    rax,rdi
   143a2:	je     0x143ae
   143a4:	mov    r9,QWORD PTR [rax+0x18]
   143a8:	mov    r8d,DWORD PTR [rax+0x20]
   143ac:	jmp    0x143b6
   143ae:	mov    r9,QWORD PTR [rsi+0x10]
   143b2:	mov    r8d,DWORD PTR [rsi+0x8]
   143b6:	call   QWORD PTR [rip+0x46ac]        # 0x18a68
   143bc:	mov    QWORD PTR [rbx+0x120],rdi
   143c3:	jmp    0x14426
   143c5:	cmp    BYTE PTR [r9+0xcc],dil
   143cc:	je     0x14407
   143ce:	cmp    rbp,rdi
   143d1:	je     0x143fd
   143d3:	mov    r8,QWORD PTR [rip+0x3da6]        # 0x18180
   143da:	mov    rcx,QWORD PTR [rip+0x4ac7]        # 0x18ea8
   143e1:	mov    rdx,rbp
   143e4:	call   QWORD PTR [rip+0x4486]        # 0x18870
   143ea:	cmp    rax,rdi
   143ed:	je     0x143fd
   143ef:	mov    ecx,DWORD PTR [rsi+0x8]
   143f2:	mov    DWORD PTR [rax+0x20],ecx
   143f5:	mov    rcx,QWORD PTR [rsi+0x10]
   143f9:	mov    QWORD PTR [rax+0x18],rcx
   143fd:	mov    rcx,rbx
   14400:	call   0x14728
   14405:	jmp    0x1443d
   14407:	mov    QWORD PTR [r9+0x120],rdi
   1440e:	mov    r9,QWORD PTR [r8+0x10]
   14412:	mov    r8d,DWORD PTR [r8+0x8]
   14416:	mov    rdx,rcx
   14419:	mov    rcx,QWORD PTR [rip+0x4a88]        # 0x18ea8
   14420:	call   QWORD PTR [rip+0x4642]        # 0x18a68
   14426:	xchg   DWORD PTR [rbx+0xe0],edi
   1442c:	mov    rdx,QWORD PTR [rbx+0x38]
   14430:	mov    rcx,QWORD PTR [rip+0x4a71]        # 0x18ea8
   14437:	call   QWORD PTR [rip+0x4163]        # 0x185a0
   1443d:	mov    rbx,QWORD PTR [rsp+0x30]
   14442:	mov    rbp,QWORD PTR [rsp+0x38]
   14447:	mov    rsi,QWORD PTR [rsp+0x40]
   1444c:	add    rsp,0x20
   14450:	pop    rdi
   14451:	ret
   14452:	int3
   14453:	int3
   14454:	int3
   14455:	int3
   14456:	int3
   14457:	int3
   14458:	mov    QWORD PTR [rsp+0x8],rbx
   1445d:	mov    QWORD PTR [rsp+0x10],rbp
   14462:	mov    QWORD PTR [rsp+0x18],rsi
   14467:	push   rdi
   14468:	sub    rsp,0x50
   1446c:	mov    rsi,r8
   1446f:	mov    r8,QWORD PTR [rip+0x3d32]        # 0x181a8
   14476:	mov    rbp,rcx
   14479:	mov    rdx,rcx
   1447c:	mov    rcx,QWORD PTR [rip+0x4a25]        # 0x18ea8
   14483:	call   QWORD PTR [rip+0x43e7]        # 0x18870
   14489:	mov    r8,QWORD PTR [rip+0x3d40]        # 0x181d0
   14490:	mov    rcx,QWORD PTR [rip+0x4a11]        # 0x18ea8
   14497:	mov    rdx,QWORD PTR [rax]
   1449a:	mov    rdi,rax
   1449d:	call   QWORD PTR [rip+0x43cd]        # 0x18870
   144a3:	cmp    DWORD PTR [rsi+0x8],0x0
   144a7:	mov    rbx,rax
   144aa:	jne    0x145c0
   144b0:	mov    r8,QWORD PTR [rsi+0x10]
   144b4:	mov    rdx,QWORD PTR [rdi+0x8]
   144b8:	mov    rcx,QWORD PTR [rax+0x88]
   144bf:	mov    r9,rax
   144c2:	call   0x1415c
   144c7:	mov    rdx,QWORD PTR [rbx+0x138]
   144ce:	mov    rax,QWORD PTR [rbx+0x130]
   144d5:	cmp    rdx,rax
   144d8:	ja     0x144df
   144da:	sub    rax,rdx
   144dd:	jmp    0x144f3
   144df:	mov    rcx,QWORD PTR [rbx+0x140]
   144e6:	sub    rcx,rdx
   144e9:	sub    rcx,QWORD PTR [rbx+0x128]
   144f0:	add    rax,rcx
   144f3:	mov    rcx,QWORD PTR [rbx+0x140]
   144fa:	imul   rax,rax,0x64
   144fe:	xor    edx,edx
   14500:	sub    rcx,QWORD PTR [rbx+0x128]
   14507:	div    rcx
   1450a:	cmp    rax,0x32
   1450e:	jae    0x145c0
   14514:	mov    rcx,QWORD PTR [rip+0x498d]        # 0x18ea8
   1451b:	xor    eax,eax
   1451d:	lea    r8,[rsp+0x30]
   14522:	mov    QWORD PTR [rsp+0x30],rax
   14527:	and    DWORD PTR [rsp+0x34],eax
   1452b:	mov    QWORD PTR [rsp+0x38],rax
   14530:	and    DWORD PTR [rsp+0x38],eax
   14534:	mov    rdx,rbp
   14537:	mov    QWORD PTR [rsp+0x40],rax
   1453c:	mov    DWORD PTR [rsp+0x30],0x18
   14544:	call   QWORD PTR [rip+0x449e]        # 0x189e8
   1454a:	test   eax,eax
   1454c:	jne    0x145c0
   1454e:	mov    r9,QWORD PTR [rdi+0x8]
   14552:	mov    r8,QWORD PTR [rbx+0xa8]
   14559:	mov    rdx,QWORD PTR [rbx+0x88]
   14560:	mov    rcx,QWORD PTR [rip+0x4941]        # 0x18ea8
   14567:	and    QWORD PTR [rsp+0x20],0x0
   1456d:	call   QWORD PTR [rip+0x4795]        # 0x18d08
   14573:	test   eax,eax
   14575:	jne    0x145c0
   14577:	mov    rdx,QWORD PTR [rbx+0xa8]
   1457e:	mov    rcx,QWORD PTR [rip+0x4923]        # 0x18ea8
   14585:	lea    r8,[rip+0xfffffffffffffecc]        # 0x14458
   1458c:	mov    r9,rdi
   1458f:	call   QWORD PTR [rip+0x44ab]        # 0x18a40
   14595:	cmp    DWORD PTR [rbx+0xdc],0x0
   1459c:	jle    0x145c0
   1459e:	mov    r8,QWORD PTR [rbx+0x88]
   145a5:	mov    rdx,QWORD PTR [rbx+0xa8]
   145ac:	mov    rcx,QWORD PTR [rip+0x48f5]        # 0x18ea8
   145b3:	xor    r9d,r9d
   145b6:	call   QWORD PTR [rip+0x444c]        # 0x18a08
   145bc:	test   al,al
   145be:	jne    0x145dd
   145c0:	lea    rcx,[rbx+0xb0]
   145c7:	xor    r8d,r8d
   145ca:	xor    edx,edx
   145cc:	call   QWORD PTR [rip+0x2a96]        # 0x17068
   145d2:	mov    eax,0x1
   145d7:	xchg   DWORD PTR [rbx+0x158],eax
   145dd:	mov    rbx,QWORD PTR [rsp+0x60]
   145e2:	mov    rbp,QWORD PTR [rsp+0x68]
   145e7:	mov    rsi,QWORD PTR [rsp+0x70]
   145ec:	add    rsp,0x50
   145f0:	pop    rdi
   145f1:	ret
   145f2:	int3
   145f3:	int3
   145f4:	int3
   145f5:	int3
   145f6:	int3
   145f7:	int3
   145f8:	sub    rsp,0x28
   145fc:	cmp    BYTE PTR [rdx+0x41],0x0
   14600:	mov    rax,r8
   14603:	jne    0x1460a
   14605:	mov    eax,DWORD PTR [rdx+0x30]
   14608:	jmp    0x1461d
   1460a:	xor    r8d,r8d
   1460d:	xor    edx,edx
   1460f:	mov    rcx,rax
   14612:	call   QWORD PTR [rip+0x2a50]        # 0x17068
   14618:	mov    eax,0xc0000016
   1461d:	add    rsp,0x28
   14621:	ret
   14622:	int3
   14623:	int3
   14624:	int3
   14625:	int3
   14626:	int3
   14627:	int3
   14628:	mov    QWORD PTR [rsp+0x8],rbx
   1462d:	mov    QWORD PTR [rsp+0x10],rsi
   14632:	push   rdi
   14633:	sub    rsp,0x50
   14637:	mov    r8,QWORD PTR [rip+0x3b92]        # 0x181d0
   1463e:	mov    rdi,rdx
   14641:	mov    rsi,rcx
   14644:	mov    rdx,rcx
   14647:	mov    rcx,QWORD PTR [rip+0x485a]        # 0x18ea8
   1464e:	call   QWORD PTR [rip+0x421c]        # 0x18870
   14654:	cmp    BYTE PTR [rax+0x1c4],0x0
   1465b:	jne    0x14680
   1465d:	mov    rcx,QWORD PTR [rip+0x4844]        # 0x18ea8
   14664:	inc    BYTE PTR [rdi+0x43]
   14667:	add    QWORD PTR [rdi+0xb8],0x48
   1466f:	mov    r8,rdi
   14672:	mov    rdx,rsi
   14675:	call   QWORD PTR [rip+0x3cb5]        # 0x18330
   1467b:	jmp    0x14712
   14680:	mov    rdx,QWORD PTR [rdi+0xb8]
   14687:	mov    r8d,0x38
   1468d:	lea    rbx,[rdx-0x48]
   14691:	mov    rcx,rbx
   14694:	call   0x15f60
   14699:	xor    r8d,r8d
   1469c:	lea    rcx,[rsp+0x30]
   146a1:	lea    edx,[r8+0x1]
   146a5:	mov    BYTE PTR [rbx+0x3],0x0
   146a9:	call   QWORD PTR [rip+0x2999]        # 0x17048
   146af:	mov    r11,QWORD PTR [rdi+0xb8]
   146b6:	mov    rcx,QWORD PTR [rip+0x47eb]        # 0x18ea8
   146bd:	lea    rax,[rip+0xffffffffffffff34]        # 0x145f8
   146c4:	mov    r8,rdi
   146c7:	mov    rdx,rsi
   146ca:	mov    QWORD PTR [r11-0x10],rax
   146ce:	lea    rax,[rsp+0x30]
   146d3:	mov    BYTE PTR [r11-0x45],0xe0
   146d8:	mov    QWORD PTR [r11-0x8],rax
   146dc:	call   QWORD PTR [rip+0x3c4e]        # 0x18330
   146e2:	cmp    eax,0x103
   146e7:	jne    0x14712
   146e9:	and    QWORD PTR [rsp+0x20],0x0
   146ef:	lea    rcx,[rsp+0x30]
   146f4:	xor    r9d,r9d
   146f7:	xor    r8d,r8d
   146fa:	xor    edx,edx
   146fc:	call   QWORD PTR [rip+0x2926]        # 0x17028
   14702:	mov    ebx,DWORD PTR [rdi+0x30]
   14705:	xor    edx,edx
   14707:	mov    rcx,rdi
   1470a:	call   QWORD PTR [rip+0x2970]        # 0x17080
   14710:	mov    eax,ebx
   14712:	mov    rbx,QWORD PTR [rsp+0x60]
   14717:	mov    rsi,QWORD PTR [rsp+0x68]
   1471c:	add    rsp,0x50
   14720:	pop    rdi
   14721:	ret
   14722:	int3
   14723:	int3
   14724:	int3
   14725:	int3
   14726:	int3
   14727:	int3
   14728:	test   rcx,rcx
   1472b:	je     0x14910
   14731:	mov    rax,rsp
   14734:	mov    QWORD PTR [rax+0x18],rbx
   14738:	mov    QWORD PTR [rax+0x20],rbp
   1473c:	push   rsi
   1473d:	push   rdi
   1473e:	push   r13
   14740:	sub    rsp,0x80
   14747:	and    QWORD PTR [rax+0x10],0x0
   1474c:	mov    rdi,rcx
   1474f:	mov    BYTE PTR [rcx+0xcc],0x0
   14756:	mov    rcx,QWORD PTR [rip+0x474b]        # 0x18ea8
   1475d:	lea    r9,[rax+0x8]
   14761:	xor    r8d,r8d
   14764:	xor    edx,edx
   14766:	call   QWORD PTR [rip+0x426c]        # 0x189d8
   1476c:	test   eax,eax
   1476e:	js     0x148f9
   14774:	mov    rbx,QWORD PTR [rsp+0xa0]
   1477c:	mov    rbp,QWORD PTR [rdi+0x80]
   14783:	mov    esi,0x38
   14788:	lea    rcx,[rsp+0x40]
   1478d:	mov    r8,rsi
   14790:	xor    edx,edx
   14792:	mov    QWORD PTR [rdi+0xd0],rbx
   14799:	call   0x152c0
   1479e:	and    QWORD PTR [rsp+0x30],0x0
   147a4:	mov    rcx,QWORD PTR [rip+0x46fd]        # 0x18ea8
   147ab:	lea    eax,[rsi-0x37]
   147ae:	lea    r13d,[rsi+0x48]
   147b2:	mov    DWORD PTR [rsp+0x58],eax
   147b6:	mov    DWORD PTR [rsp+0x5c],eax
   147ba:	lea    rax,[rsp+0xa8]
   147c2:	mov    QWORD PTR [rsp+0x28],rax
   147c7:	lea    rdx,[rsp+0x40]
   147cc:	xor    r9d,r9d
   147cf:	xor    r8d,r8d
   147d2:	mov    QWORD PTR [rsp+0x20],r13
   147d7:	mov    DWORD PTR [rsp+0x40],esi
   147db:	mov    QWORD PTR [rsp+0x60],rbx
   147e0:	call   QWORD PTR [rip+0x403a]        # 0x18820
   147e6:	mov    ebx,eax
   147e8:	test   eax,eax
   147ea:	js     0x148dd
   147f0:	mov    rdx,QWORD PTR [rsp+0xa8]
   147f8:	mov    rcx,QWORD PTR [rip+0x46a9]        # 0x18ea8
   147ff:	xor    r8d,r8d
   14802:	call   QWORD PTR [rip+0x4028]        # 0x18830
   14808:	mov    rsi,rax
   1480b:	test   rax,rax
   1480e:	je     0x148d9
   14814:	mov    r8,r13
   14817:	xor    edx,edx
   14819:	mov    rcx,rax
   1481c:	call   0x152c0
   14821:	mov    rcx,QWORD PTR [rip+0x4680]        # 0x18ea8
   14828:	lea    eax,[r13-0x77]
   1482c:	mov    rdx,rbp
   1482f:	mov    WORD PTR [rsi+0x2],ax
   14833:	mov    WORD PTR [rsi],r13w
   14837:	call   QWORD PTR [rip+0x4553]        # 0x18d90
   1483d:	and    QWORD PTR [rsi+0x28],0x0
   14842:	and    QWORD PTR [rsi+0x30],0x0
   14847:	and    DWORD PTR [rsi+0x24],0x0
   1484b:	and    DWORD PTR [rsi+0x20],0x0
   1484f:	and    QWORD PTR [rsi+0x38],0x0
   14854:	mov    rcx,QWORD PTR [rip+0x464d]        # 0x18ea8
   1485b:	and    QWORD PTR [rsp+0x20],0x0
   14861:	mov    QWORD PTR [rsi+0x18],rax
   14865:	mov    r9,QWORD PTR [rsp+0xa8]
   1486d:	mov    r8,QWORD PTR [rsp+0xa0]
   14875:	mov    rdx,rbp
   14878:	call   QWORD PTR [rip+0x44c2]        # 0x18d40
   1487e:	mov    ebx,eax
   14880:	test   eax,eax
   14882:	js     0x148dd
   14884:	mov    rdx,QWORD PTR [rsp+0xa0]
   1488c:	mov    rcx,QWORD PTR [rip+0x4615]        # 0x18ea8
   14893:	lea    r8,[rip+0xfffffffffffffa82]        # 0x1431c
   1489a:	mov    r9,rdi
   1489d:	call   QWORD PTR [rip+0x419d]        # 0x18a40
   148a3:	mov    rdx,QWORD PTR [rsp+0xa0]
   148ab:	mov    rcx,QWORD PTR [rip+0x45f6]        # 0x18ea8
   148b2:	xor    r9d,r9d
   148b5:	mov    r8,rbp
   148b8:	call   QWORD PTR [rip+0x414a]        # 0x18a08
   148be:	test   al,al
   148c0:	jne    0x148d9
   148c2:	mov    rdx,QWORD PTR [rsp+0xa0]
   148ca:	mov    rcx,QWORD PTR [rip+0x45d7]        # 0x18ea8
   148d1:	call   QWORD PTR [rip+0x4139]        # 0x18a10
   148d7:	mov    ebx,eax
   148d9:	test   ebx,ebx
   148db:	jns    0x148f9
   148dd:	mov    rdx,QWORD PTR [rdi+0xd0]
   148e4:	mov    rcx,QWORD PTR [rip+0x45bd]        # 0x18ea8
   148eb:	call   QWORD PTR [rip+0x3faf]        # 0x188a0
   148f1:	and    QWORD PTR [rdi+0xd0],0x0
   148f9:	lea    r11,[rsp+0x80]
   14901:	mov    rbx,QWORD PTR [r11+0x30]
   14905:	mov    rbp,QWORD PTR [r11+0x38]
   14909:	mov    rsp,r11
   1490c:	pop    r13
   1490e:	pop    rdi
   1490f:	pop    rsi
   14910:	ret
   14911:	int3
   14912:	int3
   14913:	int3
   14914:	int3
   14915:	int3
   14916:	int3
   14917:	int3
   14918:	mov    QWORD PTR [rsp+0x8],rbx
   1491d:	push   rdi
   1491e:	sub    rsp,0x20
   14922:	mov    rbx,rdx
   14925:	mov    rdx,QWORD PTR [rcx+0x118]
   1492c:	mov    rdi,rcx
   1492f:	mov    rcx,QWORD PTR [rip+0x4572]        # 0x18ea8
   14936:	call   QWORD PTR [rip+0x42c4]        # 0x18c00
   1493c:	xor    edx,edx
   1493e:	mov    rcx,rdi
   14941:	call   0x14a8c
   14946:	mov    r11d,DWORD PTR [rbx]
   14949:	mov    rdx,QWORD PTR [rdi+0x118]
   14950:	mov    rcx,QWORD PTR [rip+0x4551]        # 0x18ea8
   14957:	mov    DWORD PTR [rdi+0x1c0],r11d
   1495e:	call   QWORD PTR [rip+0x42a4]        # 0x18c08
   14964:	mov    rbx,QWORD PTR [rsp+0x30]
   14969:	xor    eax,eax
   1496b:	add    rsp,0x20
   1496f:	pop    rdi
   14970:	ret
   14971:	int3
   14972:	int3
   14973:	int3
   14974:	int3
   14975:	int3
   14976:	int3
   14977:	int3
   14978:	mov    QWORD PTR [rsp+0x8],rbx
   1497d:	mov    QWORD PTR [rsp+0x10],rbp
   14982:	mov    QWORD PTR [rsp+0x18],rsi
   14987:	push   rdi
   14988:	sub    rsp,0x20
   1498c:	mov    rsi,rdx
   1498f:	xor    edx,edx
   14991:	mov    rbx,rcx
   14994:	xor    edi,edi
   14996:	call   0x14a8c
   1499b:	mov    rcx,QWORD PTR [rip+0x4506]        # 0x18ea8
   149a2:	mov    rdx,rsi
   149a5:	cmp    DWORD PTR [rbx+0x1c0],edi
   149ab:	jne    0x149c2
   149ad:	mov    ebx,0xc0000120
   149b2:	mov    r8d,ebx
   149b5:	call   QWORD PTR [rip+0x409d]        # 0x18a58
   149bb:	mov    eax,ebx
   149bd:	jmp    0x14a70
   149c2:	mov    r8,QWORD PTR [rip+0x37b7]        # 0x18180
   149c9:	call   QWORD PTR [rip+0x3ea1]        # 0x18870
   149cf:	lea    rdx,[rip+0xffffffffffffee46]        # 0x1381c
   149d6:	and    QWORD PTR [rax],rdi
   149d9:	and    QWORD PTR [rax+0x8],rdi
   149dd:	and    DWORD PTR [rax+0x10],edi
   149e0:	mov    rcx,QWORD PTR [rbx]
   149e3:	mov    QWORD PTR [rax],rcx
   149e6:	mov    rcx,rsi
   149e9:	mov    QWORD PTR [rbx+0x28],rsi
   149ed:	call   0x11098
   149f2:	mov    ebp,eax
   149f4:	test   eax,eax
   149f6:	je     0x14a13
   149f8:	mov    rcx,QWORD PTR [rip+0x44a9]        # 0x18ea8
   149ff:	mov    r8d,eax
   14a02:	mov    rdx,rsi
   14a05:	call   QWORD PTR [rip+0x404d]        # 0x18a58
   14a0b:	and    QWORD PTR [rbx+0x28],rdi
   14a0f:	mov    eax,ebp
   14a11:	jmp    0x14a70
   14a13:	mov    rax,QWORD PTR [rbx+0x138]
   14a1a:	cmp    QWORD PTR [rbx+0x130],rax
   14a21:	je     0x14a61
   14a23:	mov    rdx,QWORD PTR [rbx+0x130]
   14a2a:	mov    edi,0x1
   14a2f:	cmp    rax,rdx
   14a32:	je     0x14a61
   14a34:	mov    cl,BYTE PTR [rbx+0x163]
   14a3a:	cmp    BYTE PTR [rax],cl
   14a3c:	jne    0x14a42
   14a3e:	test   cl,cl
   14a40:	jne    0x14a5c
   14a42:	inc    rax
   14a45:	cmp    rax,QWORD PTR [rbx+0x140]
   14a4c:	jb     0x14a55
   14a4e:	mov    rax,QWORD PTR [rbx+0x128]
   14a55:	cmp    rax,rdx
   14a58:	je     0x14a61
   14a5a:	jmp    0x14a3a
   14a5c:	mov    edi,0x3
   14a61:	mov    edx,edi
   14a63:	mov    rcx,rbx
   14a66:	call   0x14b50
   14a6b:	mov    eax,0x103
   14a70:	mov    rbx,QWORD PTR [rsp+0x30]
   14a75:	mov    rbp,QWORD PTR [rsp+0x38]
   14a7a:	mov    rsi,QWORD PTR [rsp+0x40]
   14a7f:	add    rsp,0x20
   14a83:	pop    rdi
   14a84:	ret
   14a85:	int3
   14a86:	int3
   14a87:	int3
   14a88:	int3
   14a89:	int3
   14a8a:	int3
   14a8b:	int3
   14a8c:	mov    rax,rsp
   14a8f:	mov    QWORD PTR [rax+0x10],rbx
   14a93:	mov    QWORD PTR [rax+0x20],rsi
   14a97:	push   rdi
   14a98:	sub    rsp,0x30
   14a9c:	mov    rsi,QWORD PTR [rcx+0x28]
   14aa0:	and    QWORD PTR [rax+0x8],0x0
   14aa5:	and    QWORD PTR [rax+0x18],0x0
   14aaa:	mov    ebx,edx
   14aac:	mov    rdi,rcx
   14aaf:	test   rsi,rsi
   14ab2:	je     0x14b38
   14ab8:	and    QWORD PTR [rcx+0x28],0x0
   14abd:	mov    rcx,rsi
   14ac0:	call   0x11118
   14ac5:	cmp    eax,0xc0000120
   14aca:	je     0x14b38
   14acc:	mov    rcx,QWORD PTR [rip+0x43d5]        # 0x18ea8
   14ad3:	lea    rax,[rsp+0x50]
   14ad8:	lea    r9,[rsp+0x40]
   14add:	mov    r8d,0x4
   14ae3:	mov    rdx,rsi
   14ae6:	mov    QWORD PTR [rsp+0x20],rax
   14aeb:	call   QWORD PTR [rip+0x3f9f]        # 0x18a90
   14af1:	test   eax,eax
   14af3:	je     0x14b0a
   14af5:	mov    rcx,QWORD PTR [rip+0x43ac]        # 0x18ea8
   14afc:	mov    r8d,eax
   14aff:	mov    rdx,rsi
   14b02:	call   QWORD PTR [rip+0x3f50]        # 0x18a58
   14b08:	jmp    0x14b38
   14b0a:	mov    rax,QWORD PTR [rsp+0x40]
   14b0f:	mov    DWORD PTR [rax],ebx
   14b11:	test   ebx,ebx
   14b13:	jne    0x14b1a
   14b15:	and    DWORD PTR [rdi+0x20],ebx
   14b18:	jmp    0x14b1f
   14b1a:	not    ebx
   14b1c:	and    DWORD PTR [rdi+0x20],ebx
   14b1f:	mov    rcx,QWORD PTR [rip+0x4382]        # 0x18ea8
   14b26:	mov    r9d,0x4
   14b2c:	xor    r8d,r8d
   14b2f:	mov    rdx,rsi
   14b32:	call   QWORD PTR [rip+0x3f30]        # 0x18a68
   14b38:	mov    rbx,QWORD PTR [rsp+0x48]
   14b3d:	mov    rsi,QWORD PTR [rsp+0x58]
   14b42:	add    rsp,0x30
   14b46:	pop    rdi
   14b47:	ret
   14b48:	int3
   14b49:	int3
   14b4a:	int3
   14b4b:	int3
   14b4c:	int3
   14b4d:	int3
   14b4e:	int3
   14b4f:	int3
   14b50:	sub    rsp,0x28
   14b54:	or     DWORD PTR [rcx+0x20],edx
   14b57:	mov    edx,DWORD PTR [rcx+0x1c0]
   14b5d:	mov    eax,edx
   14b5f:	and    eax,DWORD PTR [rcx+0x20]
   14b62:	test   al,0x10
   14b64:	je     0x14b6b
   14b66:	or     eax,0x8
   14b69:	jmp    0x14b6e
   14b6b:	and    eax,0xfffffff7
   14b6e:	test   eax,eax
   14b70:	jne    0x14b7b
   14b72:	cmp    DWORD PTR [rcx+0x20],eax
   14b75:	je     0x14b8c
   14b77:	test   edx,edx
   14b79:	jne    0x14b8c
   14b7b:	mov    rdx,QWORD PTR [rcx+0x40]
   14b7f:	mov    rcx,QWORD PTR [rip+0x4322]        # 0x18ea8
   14b86:	call   QWORD PTR [rip+0x3a14]        # 0x185a0
   14b8c:	add    rsp,0x28
   14b90:	ret
   14b91:	int3
   14b92:	int3
   14b93:	int3
   14b94:	int3
   14b95:	int3
   14b96:	int3
   14b97:	int3
   14b98:	mov    QWORD PTR [rsp+0x8],rbx
   14b9d:	push   rdi
   14b9e:	sub    rsp,0x20
   14ba2:	mov    edi,edx
   14ba4:	mov    rbx,rcx
   14ba7:	test   edx,edx
   14ba9:	je     0x14cb8
   14baf:	test   edx,0xfffffff0
   14bb5:	jne    0x14cb8
   14bbb:	test   dl,0x2
   14bbe:	je     0x14c51
   14bc4:	mov    rdx,QWORD PTR [rcx+0x10]
   14bc8:	jmp    0x14be6
   14bca:	mov    rdx,QWORD PTR [rsp+0x40]
   14bcf:	mov    rcx,QWORD PTR [rip+0x42d2]        # 0x18ea8
   14bd6:	mov    r8d,0xc0000120
   14bdc:	call   QWORD PTR [rip+0x3e76]        # 0x18a58
   14be2:	mov    rdx,QWORD PTR [rbx+0x10]
   14be6:	mov    rcx,QWORD PTR [rip+0x42bb]        # 0x18ea8
   14bed:	lea    r8,[rsp+0x40]
   14bf2:	call   QWORD PTR [rip+0x3b18]        # 0x18710
   14bf8:	test   eax,eax
   14bfa:	je     0x14bca
   14bfc:	mov    rcx,QWORD PTR [rbx+0xe8]
   14c03:	and    QWORD PTR [rbx+0xe8],0x0
   14c0b:	mov    QWORD PTR [rsp+0x40],rcx
   14c10:	test   rcx,rcx
   14c13:	je     0x14c51
   14c15:	call   0x11118
   14c1a:	and    QWORD PTR [rbx+0xf0],0x0
   14c22:	and    QWORD PTR [rbx+0xf8],0x0
   14c2a:	and    QWORD PTR [rbx+0x100],0x0
   14c32:	cmp    eax,0xc0000120
   14c37:	je     0x14c51
   14c39:	mov    rdx,QWORD PTR [rsp+0x40]
   14c3e:	mov    rcx,QWORD PTR [rip+0x4263]        # 0x18ea8
   14c45:	mov    r8d,0xc0000120
   14c4b:	call   QWORD PTR [rip+0x3e07]        # 0x18a58
   14c51:	test   dil,0x8
   14c55:	je     0x14c73
   14c57:	mov    rax,QWORD PTR [rbx+0x128]
   14c5e:	mov    QWORD PTR [rbx+0x138],rax
   14c65:	mov    QWORD PTR [rbx+0x130],rax
   14c6c:	and    DWORD PTR [rbx+0x170],0x0
   14c73:	test   dil,0x1
   14c77:	je     0x14cb4
   14c79:	jmp    0x14c93
   14c7b:	mov    rdx,QWORD PTR [rsp+0x40]
   14c80:	mov    rcx,QWORD PTR [rip+0x4221]        # 0x18ea8
   14c87:	mov    r8d,0xc0000120
   14c8d:	call   QWORD PTR [rip+0x3dc5]        # 0x18a58
   14c93:	mov    rdx,QWORD PTR [rbx+0x18]
   14c97:	mov    rcx,QWORD PTR [rip+0x420a]        # 0x18ea8
   14c9e:	lea    r8,[rsp+0x40]
   14ca3:	call   QWORD PTR [rip+0x3a67]        # 0x18710
   14ca9:	test   eax,eax
   14cab:	je     0x14c7b
   14cad:	and    DWORD PTR [rbx+0x174],0x0
   14cb4:	xor    eax,eax
   14cb6:	jmp    0x14cbd
   14cb8:	mov    eax,0xc000000d
   14cbd:	mov    rbx,QWORD PTR [rsp+0x30]
   14cc2:	add    rsp,0x20
   14cc6:	pop    rdi
   14cc7:	ret
   14cc8:	int3
   14cc9:	int3
   14cca:	int3
   14ccb:	int3
   14ccc:	int3
   14ccd:	int3
   14cce:	int3
   14ccf:	int3
   14cd0:	int3
   14cd1:	int3
   14cd2:	int3
   14cd3:	int3
   14cd4:	int3
   14cd5:	int3
   14cd6:	data16 nop WORD PTR [rax+rax*1+0x0]
   14ce0:	cmp    rcx,QWORD PTR [rip+0x3419]        # 0x18100
   14ce7:	jne    0x14cfb
   14ce9:	rol    rcx,0x10
   14ced:	test   cx,0xffff
   14cf2:	jne    0x14cf7
   14cf4:	ret    0x0
   14cf7:	ror    rcx,0x10
   14cfb:	jmp    0x14d08
   14d00:	int3
   14d01:	int3
   14d02:	int3
   14d03:	int3
   14d04:	int3
   14d05:	int3
   14d06:	int3
   14d07:	int3
   14d08:	sub    rsp,0x38
   14d0c:	mov    r9,QWORD PTR [rip+0x33f5]        # 0x18108
   14d13:	mov    r8,QWORD PTR [rip+0x33e6]        # 0x18100
   14d1a:	and    QWORD PTR [rsp+0x20],0x0
   14d20:	mov    rdx,rcx
   14d23:	mov    ecx,0xf7
   14d28:	call   QWORD PTR [rip+0x2322]        # 0x17050
   14d2e:	int3
   14d2f:	int3
   14d30:	int3
   14d31:	int3
   14d32:	int3
   14d33:	int3
   14d34:	int3
   14d35:	int3
   14d36:	int3
   14d37:	int3
   14d38:	sub    rsp,0x28
   14d3c:	lea    rcx,[rip+0x33cd]        # 0x18110
   14d43:	call   0x14f00
   14d48:	mov    r8,QWORD PTR [rip+0x4159]        # 0x18ea8
   14d4f:	lea    rdx,[rip+0x33ba]        # 0x18110
   14d56:	lea    rcx,[rip+0x412b]        # 0x18e88
   14d5d:	add    rsp,0x28
   14d61:	jmp    0x15f1c
   14d66:	int3
   14d67:	int3
   14d68:	int3
   14d69:	int3
   14d6a:	int3
   14d6b:	int3
   14d6c:	jmp    0x14d38
   14d71:	int3
   14d72:	int3
   14d73:	int3
   14d74:	int3
   14d75:	int3
   14d76:	int3
   14d77:	int3
   14d78:	sub    rsp,0x28
   14d7c:	mov    rax,QWORD PTR [rip+0x4115]        # 0x18e98
   14d83:	test   rax,rax
   14d86:	je     0x14d96
   14d88:	lea    rdx,[rip+0xffffffffffffffe9]        # 0x14d78
   14d8f:	cmp    rax,rdx
   14d92:	je     0x14d96
   14d94:	call   rax
   14d96:	add    rsp,0x28
   14d9a:	jmp    0x14d38
   14d9f:	int3
   14da0:	int3
   14da1:	int3
   14da2:	int3
   14da3:	int3
   14da4:	int3
   14da5:	int3
   14da6:	int3
   14da7:	int3
   14da8:	mov    QWORD PTR [rsp+0x8],rbx
   14dad:	mov    QWORD PTR [rsp+0x10],rbp
   14db2:	mov    QWORD PTR [rsp+0x18],rsi
   14db7:	push   rdi
   14db8:	sub    rsp,0x20
   14dbc:	xor    ebp,ebp
   14dbe:	mov    rsi,rdx
   14dc1:	mov    rdi,rcx
   14dc4:	cmp    rcx,rbp
   14dc7:	jne    0x14dd5
   14dc9:	xor    ecx,ecx
   14dcb:	call   0x11008
   14dd0:	jmp    0x14eb5
   14dd5:	mov    eax,0x208
   14dda:	mov    QWORD PTR [rip+0x40cf],rcx        # 0x18eb0
   14de1:	lea    rcx,[rip+0x40a0]        # 0x18e88
   14de8:	mov    WORD PTR [rip+0x409b],ax        # 0x18e8a
   14def:	lea    rax,[rip+0x40ca]        # 0x18ec0
   14df6:	mov    WORD PTR [rip+0x408b],bp        # 0x18e88
   14dfd:	mov    QWORD PTR [rip+0x408c],rax        # 0x18e90
   14e04:	call   QWORD PTR [rip+0x224e]        # 0x17058
   14e0a:	lea    r9,[rip+0x4097]        # 0x18ea8
   14e11:	lea    r8,[rip+0x32f8]        # 0x18110
   14e18:	lea    rdx,[rip+0x4069]        # 0x18e88
   14e1f:	mov    rcx,rdi
   14e22:	call   0x15f28
   14e27:	cmp    eax,ebp
   14e29:	jl     0x14eb5
   14e2f:	lea    rcx,[rip+0x32da]        # 0x18110
   14e36:	call   0x14f80
   14e3b:	cmp    eax,ebp
   14e3d:	mov    ebx,eax
   14e3f:	jl     0x14eae
   14e41:	call   0x1500c
   14e46:	mov    rdx,rsi
   14e49:	mov    rcx,rdi
   14e4c:	call   0x11008
   14e51:	cmp    eax,ebp
   14e53:	mov    ebx,eax
   14e55:	jl     0x14eae
   14e57:	mov    rax,QWORD PTR [rip+0x404a]        # 0x18ea8
   14e5e:	cmp    BYTE PTR [rax+0x30],bpl
   14e62:	je     0x14e88
   14e64:	mov    rax,QWORD PTR [rip+0x402d]        # 0x18e98
   14e6b:	cmp    QWORD PTR [rdi+0x68],rbp
   14e6f:	cmovne rax,QWORD PTR [rdi+0x68]
   14e74:	mov    QWORD PTR [rip+0x401d],rax        # 0x18e98
   14e7b:	lea    rax,[rip+0xfffffffffffffef6]        # 0x14d78
   14e82:	mov    QWORD PTR [rdi+0x68],rax
   14e86:	jmp    0x14eaa
   14e88:	test   BYTE PTR [rax+0x8],0x2
   14e8c:	je     0x14eaa
   14e8e:	mov    rax,QWORD PTR [rip+0x39d3]        # 0x18868
   14e95:	mov    QWORD PTR [rip+0x4004],rax        # 0x18ea0
   14e9c:	lea    rax,[rip+0xfffffffffffffec9]        # 0x14d6c
   14ea3:	mov    QWORD PTR [rip+0x39be],rax        # 0x18868
   14eaa:	xor    eax,eax
   14eac:	jmp    0x14eb5
   14eae:	call   0x14d38
   14eb3:	mov    eax,ebx
   14eb5:	mov    rbx,QWORD PTR [rsp+0x30]
   14eba:	mov    rbp,QWORD PTR [rsp+0x38]
   14ebf:	mov    rsi,QWORD PTR [rsp+0x40]
   14ec4:	add    rsp,0x20
   14ec8:	pop    rdi
   14ec9:	ret
   14eca:	int3
   14ecb:	int3
   14ecc:	int3
   14ecd:	int3
   14ece:	int3
   14ecf:	int3
   14ed0:	mov    QWORD PTR [rsp+0x8],rbx
   14ed5:	push   rdi
   14ed6:	sub    rsp,0x20
   14eda:	mov    rbx,rdx
   14edd:	mov    rdi,rcx
   14ee0:	call   0x1b008
   14ee5:	mov    rdx,rbx
   14ee8:	mov    rcx,rdi
   14eeb:	mov    rbx,QWORD PTR [rsp+0x30]
   14ef0:	add    rsp,0x20
   14ef4:	pop    rdi
   14ef5:	jmp    0x14da8
   14efa:	int3
   14efb:	int3
   14efc:	int3
   14efd:	int3
   14efe:	int3
   14eff:	int3
   14f00:	mov    QWORD PTR [rsp+0x8],rbx
   14f05:	push   rdi
   14f06:	sub    rsp,0x20
   14f0a:	mov    rax,QWORD PTR [rip+0x32e7]        # 0x181f8
   14f11:	mov    rdi,rcx
   14f14:	lea    rcx,[rip+0x32c5]        # 0x181e0
   14f1b:	lea    rbx,[rip+0x32ce]        # 0x181f0
   14f22:	cmp    rax,rcx
   14f25:	je     0x14f6c
   14f27:	cmp    rbx,rax
   14f2a:	ja     0x14f6c
   14f2c:	mov    rax,QWORD PTR [rbx+0x40]
   14f30:	test   rax,rax
   14f33:	je     0x14f4d
   14f35:	mov    r8,QWORD PTR [rip+0x3f6c]        # 0x18ea8
   14f3c:	lea    rcx,[rip+0xffd]        # 0x15f40
   14f43:	mov    r9,rbx
   14f46:	mov    rdx,rdi
   14f49:	call   rax
   14f4b:	jmp    0x14f5f
   14f4d:	mov    rdx,QWORD PTR [rip+0x3f54]        # 0x18ea8
   14f54:	mov    r8,rbx
   14f57:	mov    rcx,rdi
   14f5a:	call   0x15f40
   14f5f:	add    rbx,0x50
   14f63:	cmp    rbx,QWORD PTR [rip+0x328e]        # 0x181f8
   14f6a:	jbe    0x14f2c
   14f6c:	mov    rbx,QWORD PTR [rsp+0x30]
   14f71:	add    rsp,0x20
   14f75:	pop    rdi
   14f76:	ret
   14f77:	int3
   14f78:	int3
   14f79:	int3
   14f7a:	int3
   14f7b:	int3
   14f7c:	int3
   14f7d:	int3
   14f7e:	int3
   14f7f:	int3
   14f80:	mov    QWORD PTR [rsp+0x8],rbx
   14f85:	mov    QWORD PTR [rsp+0x10],rsi
   14f8a:	push   rdi
   14f8b:	sub    rsp,0x20
   14f8f:	mov    rdi,rcx
   14f92:	xor    eax,eax
   14f94:	lea    rbx,[rip+0x3255]        # 0x181f0
   14f9b:	lea    rsi,[rip+0x324e]        # 0x181f0
   14fa2:	cmp    rbx,rsi
   14fa5:	jae    0x14ff5
   14fa7:	cmp    DWORD PTR [rbx],0x50
   14faa:	jne    0x14ff0
   14fac:	mov    rax,QWORD PTR [rbx+0x38]
   14fb0:	mov    QWORD PTR [rip+0x3241],rbx        # 0x181f8
   14fb7:	test   rax,rax
   14fba:	je     0x14fd4
   14fbc:	mov    r8,QWORD PTR [rip+0x3ee5]        # 0x18ea8
   14fc3:	lea    rcx,[rip+0xf6a]        # 0x15f34
   14fca:	mov    r9,rbx
   14fcd:	mov    rdx,rdi
   14fd0:	call   rax
   14fd2:	jmp    0x14fe6
   14fd4:	mov    rdx,QWORD PTR [rip+0x3ecd]        # 0x18ea8
   14fdb:	mov    r8,rbx
   14fde:	mov    rcx,rdi
   14fe1:	call   0x15f34
   14fe6:	test   eax,eax
   14fe8:	js     0x14ff5
   14fea:	add    rbx,0x50
   14fee:	jmp    0x14fa2
   14ff0:	mov    eax,0xc0000004
   14ff5:	mov    rbx,QWORD PTR [rsp+0x30]
   14ffa:	mov    rsi,QWORD PTR [rsp+0x38]
   14fff:	add    rsp,0x20
   15003:	pop    rdi
   15004:	ret
   15005:	int3
   15006:	int3
   15007:	int3
   15008:	int3
   15009:	int3
   1500a:	int3
   1500b:	int3
   1500c:	mov    QWORD PTR [rsp+0x8],rbx
   15011:	push   rdi
   15012:	sub    rsp,0x20
   15016:	lea    rax,[rip+0x31f3]        # 0x18210
   1501d:	lea    rcx,[rip+0x31ec]        # 0x18210
   15024:	cmp    rax,rcx
   15027:	jae    0x15065
   15029:	sub    rcx,rax
   1502c:	movabs rax,0xcccccccccccccccd
   15036:	lea    rbx,[rip+0x31f3]        # 0x18230
   1503d:	dec    rcx
   15040:	mul    rcx
   15043:	mov    rdi,rdx
   15046:	shr    rdi,0x5
   1504a:	inc    rdi
   1504d:	mov    rax,QWORD PTR [rbx]
   15050:	test   rax,rax
   15053:	je     0x1505b
   15055:	call   rax
   15057:	mov    QWORD PTR [rbx-0x8],rax
   1505b:	add    rbx,0x28
   1505f:	sub    rdi,0x1
   15063:	jne    0x1504d
   15065:	mov    rbx,QWORD PTR [rsp+0x30]
   1506a:	add    rsp,0x20
   1506e:	pop    rdi
   1506f:	ret
   15070:	int3
   15071:	int3
   15072:	int3
   15073:	int3
   15074:	int3
   15075:	int3
   15076:	int3
   15077:	int3
   15078:	mov    QWORD PTR [rsp+0x8],rbx
   1507d:	mov    QWORD PTR [rsp+0x10],rsi
   15082:	push   rdi
   15083:	sub    rsp,0x20
   15087:	mov    rax,r9
   1508a:	mov    r9,QWORD PTR [rsp+0x50]
   1508f:	mov    rdi,r8
   15092:	mov    r8,rax
   15095:	mov    rsi,rdx
   15098:	xor    ebx,ebx
   1509a:	call   0x15290
   1509f:	cmp    eax,ebx
   150a1:	jl     0x150af
   150a3:	cdqe
   150a5:	cmp    rax,rsi
   150a8:	ja     0x150af
   150aa:	mov    QWORD PTR [rdi],rax
   150ad:	jmp    0x150b7
   150af:	mov    QWORD PTR [rdi],rsi
   150b2:	mov    ebx,0x80000005
   150b7:	mov    rsi,QWORD PTR [rsp+0x38]
   150bc:	mov    eax,ebx
   150be:	mov    rbx,QWORD PTR [rsp+0x30]
   150c3:	add    rsp,0x20
   150c7:	pop    rdi
   150c8:	ret
   150c9:	int3
   150ca:	int3
   150cb:	int3
   150cc:	int3
   150cd:	int3
   150ce:	int3
   150cf:	int3
   150d0:	xor    r9d,r9d
   150d3:	mov    rax,rdx
   150d6:	mov    r10,rcx
   150d9:	cmp    rcx,r9
   150dc:	jne    0x150e5
   150de:	bt     r8d,0x8
   150e3:	jb     0x1511c
   150e5:	test   BYTE PTR [rcx],0x1
   150e8:	jne    0x15116
   150ea:	movzx  edx,WORD PTR [rcx+0x2]
   150ee:	test   dl,0x1
   150f1:	jne    0x15116
   150f3:	cmp    WORD PTR [rcx],dx
   150f6:	ja     0x15116
   150f8:	lea    rcx,[rax+rax*1]
   150fc:	movzx  eax,dx
   150ff:	cmp    rax,rcx
   15102:	ja     0x15116
   15104:	cmp    QWORD PTR [r10+0x8],r9
   15108:	jne    0x1511c
   1510a:	cmp    WORD PTR [r10],r9w
   1510e:	jne    0x15116
   15110:	cmp    dx,r9w
   15114:	je     0x1511c
   15116:	mov    r9d,0xc000000d
   1511c:	mov    eax,r9d
   1511f:	ret
   15120:	int3
   15121:	int3
   15122:	int3
   15123:	int3
   15124:	int3
   15125:	int3
   15126:	int3
   15127:	int3
   15128:	mov    QWORD PTR [rsp+0x8],rbx
   1512d:	mov    QWORD PTR [rsp+0x10],rsi
   15132:	push   rdi
   15133:	sub    rsp,0x20
   15137:	and    QWORD PTR [rdx],0x0
   1513b:	and    QWORD PTR [r8],0x0
   1513f:	mov    rbx,r9
   15142:	mov    rdi,r8
   15145:	mov    rsi,rdx
   15148:	mov    r11,rcx
   1514b:	test   r9,r9
   1514e:	je     0x15154
   15150:	and    QWORD PTR [r9],0x0
   15154:	mov    r8d,DWORD PTR [rsp+0x58]
   15159:	mov    rdx,QWORD PTR [rsp+0x50]
   1515e:	call   0x150d0
   15163:	mov    r8d,eax
   15166:	test   eax,eax
   15168:	js     0x15190
   1516a:	test   r11,r11
   1516d:	je     0x15190
   1516f:	mov    rcx,QWORD PTR [r11+0x8]
   15173:	mov    QWORD PTR [rsi],rcx
   15176:	movzx  ecx,WORD PTR [r11+0x2]
   1517b:	shr    rcx,1
   1517e:	mov    QWORD PTR [rdi],rcx
   15181:	test   rbx,rbx
   15184:	je     0x15190
   15186:	movzx  eax,WORD PTR [r11]
   1518a:	shr    rax,1
   1518d:	mov    QWORD PTR [rbx],rax
   15190:	mov    rbx,QWORD PTR [rsp+0x30]
   15195:	mov    rsi,QWORD PTR [rsp+0x38]
   1519a:	mov    eax,r8d
   1519d:	add    rsp,0x20
   151a1:	pop    rdi
   151a2:	ret
   151a3:	int3
   151a4:	int3
   151a5:	int3
   151a6:	int3
   151a7:	int3
   151a8:	int3
   151a9:	int3
   151aa:	int3
   151ab:	int3
   151ac:	mov    QWORD PTR [rsp+0x8],rbx
   151b1:	push   rdi
   151b2:	sub    rsp,0x60
   151b6:	mov    r11,r9
   151b9:	mov    r10,r8
   151bc:	mov    rbx,rcx
   151bf:	test   r8,r8
   151c2:	jne    0x151e1
   151c4:	and    QWORD PTR [rsp+0x20],0x0
   151ca:	xor    r9d,r9d
   151cd:	xor    r8d,r8d
   151d0:	xor    edx,edx
   151d2:	xor    ecx,ecx
   151d4:	call   0x153c0
   151d9:	or     eax,0xffffffff
   151dc:	jmp    0x1527f
   151e1:	test   rdx,rdx
   151e4:	je     0x151eb
   151e6:	test   rcx,rcx
   151e9:	je     0x151c4
   151eb:	mov    DWORD PTR [rsp+0x48],0x42
   151f3:	mov    QWORD PTR [rsp+0x40],rcx
   151f8:	mov    QWORD PTR [rsp+0x30],rcx
   151fd:	cmp    rdx,0x3fffffff
   15204:	jbe    0x15210
   15206:	mov    DWORD PTR [rsp+0x38],0x7fffffff
   1520e:	jmp    0x15217
   15210:	lea    eax,[rdx+rdx*1]
   15213:	mov    DWORD PTR [rsp+0x38],eax
   15217:	mov    r9,QWORD PTR [rsp+0x90]
   1521f:	lea    rcx,[rsp+0x30]
   15224:	mov    r8,r11
   15227:	mov    rdx,r10
   1522a:	call   0x154fc
   1522f:	mov    edi,eax
   15231:	test   rbx,rbx
   15234:	je     0x1527f
   15236:	sub    DWORD PTR [rsp+0x38],0x1
   1523b:	js     0x15254
   1523d:	mov    rax,QWORD PTR [rsp+0x30]
   15242:	mov    BYTE PTR [rax],0x0
   15245:	mov    rax,QWORD PTR [rsp+0x30]
   1524a:	inc    rax
   1524d:	mov    QWORD PTR [rsp+0x30],rax
   15252:	jmp    0x15265
   15254:	lea    rdx,[rsp+0x30]
   15259:	xor    ecx,ecx
   1525b:	call   0x153b0
   15260:	mov    rax,QWORD PTR [rsp+0x30]
   15265:	sub    DWORD PTR [rsp+0x38],0x1
   1526a:	js     0x15271
   1526c:	mov    BYTE PTR [rax],0x0
   1526f:	jmp    0x1527d
   15271:	lea    rdx,[rsp+0x30]
   15276:	xor    ecx,ecx
   15278:	call   0x153b0
   1527d:	mov    eax,edi
   1527f:	mov    rbx,QWORD PTR [rsp+0x70]
   15284:	add    rsp,0x60
   15288:	pop    rdi
   15289:	ret
   1528a:	int3
   1528b:	int3
   1528c:	int3
   1528d:	int3
   1528e:	int3
   1528f:	int3
   15290:	sub    rsp,0x38
   15294:	mov    QWORD PTR [rsp+0x20],r9
   15299:	xor    r9d,r9d
   1529c:	call   0x151ac
   152a1:	add    rsp,0x38
   152a5:	ret
   152a6:	int3
   152a7:	int3
   152a8:	int3
   152a9:	int3
   152aa:	int3
   152ab:	int3
   152ac:	int3
   152ad:	int3
   152ae:	int3
   152af:	int3
   152b0:	int3
   152b1:	int3
   152b2:	int3
   152b3:	int3
   152b4:	int3
   152b5:	int3
   152b6:	data16 nop WORD PTR [rax+rax*1+0x0]
   152c0:	mov    rax,rcx
   152c3:	cmp    r8,0x8
   152c7:	jb     0x1531c
   152c9:	movzx  edx,dl
   152cc:	movabs r9,0x101010101010101
   152d6:	imul   rdx,r9
   152da:	cmp    r8,0x40
   152de:	jb     0x152fe
   152e0:	neg    rcx
   152e3:	and    ecx,0x7
   152e6:	je     0x152ee
   152e8:	sub    r8,rcx
   152eb:	mov    QWORD PTR [rax],rdx
   152ee:	add    rcx,rax
   152f1:	mov    r9,r8
   152f4:	and    r8,0x3f
   152f8:	shr    r9,0x6
   152fc:	jne    0x15337
   152fe:	mov    r9,r8
   15301:	and    r8,0x7
   15305:	shr    r9,0x3
   15309:	je     0x1531c
   1530b:	data16 data16 xchg ax,ax
   1530f:	nop
   15310:	mov    QWORD PTR [rcx],rdx
   15313:	add    rcx,0x8
   15317:	dec    r9
   1531a:	jne    0x15310
   1531c:	test   r8,r8
   1531f:	je     0x1532b
   15321:	mov    BYTE PTR [rcx],dl
   15323:	inc    rcx
   15326:	dec    r8
   15329:	jne    0x15321
   1532b:	ret    0x0
   1532e:	xchg   ax,ax
   15330:	data16 data16 xchg ax,ax
   15334:	data16 xchg ax,ax
   15337:	cmp    r9,0x1c00
   1533e:	jae    0x15370
   15340:	mov    QWORD PTR [rcx],rdx
   15343:	mov    QWORD PTR [rcx+0x8],rdx
   15347:	mov    QWORD PTR [rcx+0x10],rdx
   1534b:	add    rcx,0x40
   1534f:	mov    QWORD PTR [rcx-0x28],rdx
   15353:	mov    QWORD PTR [rcx-0x20],rdx
   15357:	dec    r9
   1535a:	mov    QWORD PTR [rcx-0x18],rdx
   1535e:	mov    QWORD PTR [rcx-0x10],rdx
   15362:	mov    QWORD PTR [rcx-0x8],rdx
   15366:	jne    0x15340
   15368:	jmp    0x152fe
   1536a:	nop    WORD PTR [rax+rax*1+0x0]
   15370:	movnti QWORD PTR [rcx],rdx
   15374:	movnti QWORD PTR [rcx+0x8],rdx
   15379:	movnti QWORD PTR [rcx+0x10],rdx
   1537e:	add    rcx,0x40
   15382:	movnti QWORD PTR [rcx-0x28],rdx
   15387:	movnti QWORD PTR [rcx-0x20],rdx
   1538c:	dec    r9
   1538f:	movnti QWORD PTR [rcx-0x18],rdx
   15394:	movnti QWORD PTR [rcx-0x10],rdx
   15399:	movnti QWORD PTR [rcx-0x8],rdx
   1539e:	jne    0x15370
   153a0:	lock or BYTE PTR [rsp],0x0
   153a5:	jmp    0x152fe
   153aa:	int3
   153ab:	int3
   153ac:	int3
   153ad:	int3
   153ae:	int3
   153af:	int3
   153b0:	or     DWORD PTR [rdx+0x18],0x20
   153b4:	or     eax,0xffffffff
   153b7:	ret
   153b8:	int3
   153b9:	int3
   153ba:	int3
   153bb:	int3
   153bc:	int3
   153bd:	int3
   153be:	int3
   153bf:	int3
   153c0:	ret    0x0
   153c3:	int3
   153c4:	int3
   153c5:	int3
   153c6:	int3
   153c7:	int3
   153c8:	int3
   153c9:	int3
   153ca:	int3
   153cb:	int3
   153cc:	mov    QWORD PTR [rsp+0x8],rbx
   153d1:	push   rdi
   153d2:	sub    rsp,0x20
   153d6:	test   BYTE PTR [rdx+0x18],0x40
   153da:	mov    rbx,r8
   153dd:	mov    rdi,rdx
   153e0:	je     0x153ee
   153e2:	cmp    QWORD PTR [rdx+0x10],0x0
   153e7:	jne    0x153ee
   153e9:	inc    DWORD PTR [r8]
   153ec:	jmp    0x1540a
   153ee:	call   0x15e5c
   153f3:	mov    ecx,0xffff
   153f8:	cmp    ax,cx
   153fb:	jne    0x15408
   153fd:	test   BYTE PTR [rdi+0x18],0x20
   15401:	je     0x15408
   15403:	or     DWORD PTR [rbx],0xffffffff
   15406:	jmp    0x1540a
   15408:	inc    DWORD PTR [rbx]
   1540a:	mov    rbx,QWORD PTR [rsp+0x30]
   1540f:	add    rsp,0x20
   15413:	pop    rdi
   15414:	ret
   15415:	int3
   15416:	int3
   15417:	int3
   15418:	int3
   15419:	int3
   1541a:	int3
   1541b:	int3
   1541c:	test   edx,edx
   1541e:	jle    0x1546c
   15420:	mov    QWORD PTR [rsp+0x8],rbx
   15425:	mov    QWORD PTR [rsp+0x10],rbp
   1542a:	mov    QWORD PTR [rsp+0x18],rsi
   1542f:	push   rdi
   15430:	sub    rsp,0x20
   15434:	mov    rdi,r9
   15437:	mov    rsi,r8
   1543a:	mov    ebx,edx
   1543c:	movzx  ebp,cx
   1543f:	mov    r8,rdi
   15442:	mov    rdx,rsi
   15445:	movzx  ecx,bp
   15448:	dec    ebx
   1544a:	call   0x153cc
   1544f:	cmp    DWORD PTR [rdi],0xffffffff
   15452:	je     0x15458
   15454:	test   ebx,ebx
   15456:	jg     0x1543f
   15458:	mov    rbx,QWORD PTR [rsp+0x30]
   1545d:	mov    rbp,QWORD PTR [rsp+0x38]
   15462:	mov    rsi,QWORD PTR [rsp+0x40]
   15467:	add    rsp,0x20
   1546b:	pop    rdi
   1546c:	ret
   1546d:	int3
   1546e:	int3
   1546f:	int3
   15470:	int3
   15471:	int3
   15472:	int3
   15473:	int3
   15474:	mov    QWORD PTR [rsp+0x8],rbx
   15479:	mov    QWORD PTR [rsp+0x10],rbp
   1547e:	mov    QWORD PTR [rsp+0x18],rsi
   15483:	push   rdi
   15484:	sub    rsp,0x20
   15488:	test   BYTE PTR [r8+0x18],0x40
   1548d:	mov    rdi,r9
   15490:	mov    rsi,r8
   15493:	mov    ebx,edx
   15495:	mov    rbp,rcx
   15498:	je     0x154a6
   1549a:	cmp    QWORD PTR [r8+0x10],0x0
   1549f:	jne    0x154a6
   154a1:	add    DWORD PTR [r9],edx
   154a4:	jmp    0x154e1
   154a6:	test   edx,edx
   154a8:	jle    0x154e1
   154aa:	movzx  ecx,WORD PTR [rbp+0x0]
   154ae:	mov    r8,rdi
   154b1:	mov    rdx,rsi
   154b4:	dec    ebx
   154b6:	call   0x153cc
   154bb:	add    rbp,0x2
   154bf:	cmp    DWORD PTR [rdi],0xffffffff
   154c2:	jne    0x154dd
   154c4:	cmp    DWORD PTR [rip+0x3c11],0x2a        # 0x190dc
   154cb:	jne    0x154e1
   154cd:	mov    ecx,0x3f
   154d2:	mov    r8,rdi
   154d5:	mov    rdx,rsi
   154d8:	call   0x153cc
   154dd:	test   ebx,ebx
   154df:	jg     0x154aa
   154e1:	mov    rbx,QWORD PTR [rsp+0x30]
   154e6:	mov    rbp,QWORD PTR [rsp+0x38]
   154eb:	mov    rsi,QWORD PTR [rsp+0x40]
   154f0:	add    rsp,0x20
   154f4:	pop    rdi
   154f5:	ret
   154f6:	int3
   154f7:	int3
   154f8:	int3
   154f9:	int3
   154fa:	int3
   154fb:	int3
   154fc:	mov    QWORD PTR [rsp+0x18],rbx
   15501:	push   rbp
   15502:	push   rsi
   15503:	push   rdi
   15504:	push   r12
   15506:	push   r13
   15508:	push   r14
   1550a:	push   r15
   1550c:	sub    rsp,0x480
   15513:	mov    rax,QWORD PTR [rip+0x2be6]        # 0x18100
   1551a:	xor    rax,rsp
   1551d:	mov    QWORD PTR [rsp+0x470],rax
   15525:	xor    ebx,ebx
   15527:	mov    r15,r9
   1552a:	mov    r13,rdx
   1552d:	mov    r11,rcx
   15530:	mov    QWORD PTR [rsp+0x48],rcx
   15535:	mov    DWORD PTR [rsp+0x60],ebx
   15539:	mov    esi,ebx
   1553b:	mov    r8d,ebx
   1553e:	mov    DWORD PTR [rsp+0x40],ebx
   15542:	mov    r9d,ebx
   15545:	mov    DWORD PTR [rsp+0x3c],ebx
   15549:	mov    r10d,ebx
   1554c:	mov    DWORD PTR [rsp+0x34],ebx
   15550:	mov    DWORD PTR [rsp+0x5c],ebx
   15554:	mov    DWORD PTR [rsp+0x30],ebx
   15558:	cmp    rcx,rbx
   1555b:	jne    0x15573
   1555d:	xor    edx,edx
   1555f:	xor    ecx,ecx
   15561:	mov    QWORD PTR [rsp+0x20],rbx
   15566:	call   0x153c0
   1556b:	or     eax,0xffffffff
   1556e:	jmp    0x15c65
   15573:	cmp    rdx,rbx
   15576:	je     0x1555d
   15578:	movzx  edi,WORD PTR [r13+0x0]
   1557d:	mov    r12d,ebx
   15580:	mov    DWORD PTR [rsp+0x38],ebx
   15584:	mov    r14d,ebx
   15587:	mov    edx,ebx
   15589:	cmp    di,bx
   1558c:	je     0x15c62
   15592:	mov    rbx,QWORD PTR [rsp+0x68]
   15597:	or     rbp,0xffffffffffffffff
   1559b:	xor    ecx,ecx
   1559d:	add    r13,0x2
   155a1:	cmp    r12d,ecx
   155a4:	mov    QWORD PTR [rsp+0x68],r13
   155a9:	jl     0x15c62
   155af:	lea    eax,[rdi-0x20]
   155b2:	cmp    ax,0x58
   155b6:	ja     0x155cc
   155b8:	lea    rcx,[rip+0x1b31]        # 0x170f0
   155bf:	movzx  eax,di
   155c2:	movsx  ecx,BYTE PTR [rax+rcx*1-0x20]
   155c7:	and    ecx,0xf
   155ca:	jmp    0x155d0
   155cc:	xor    eax,eax
   155ce:	mov    ecx,eax
   155d0:	movsxd rax,edx
   155d3:	movsxd rcx,ecx
   155d6:	lea    rdx,[rax+rcx*8]
   155da:	lea    rax,[rip+0x1b0f]        # 0x170f0
   155e1:	movsx  edx,BYTE PTR [rdx+rax*1]
   155e5:	sar    edx,0x4
   155e8:	mov    DWORD PTR [rsp+0x50],edx
   155ec:	mov    ecx,edx
   155ee:	test   edx,edx
   155f0:	je     0x15c1d
   155f6:	sub    ecx,0x1
   155f9:	je     0x15d64
   155ff:	sub    ecx,0x1
   15602:	je     0x15d0b
   15608:	sub    ecx,0x1
   1560b:	je     0x15cd0
   15611:	sub    ecx,0x1
   15614:	je     0x15cc5
   1561a:	sub    ecx,0x1
   1561d:	je     0x15c90
   15623:	sub    ecx,0x1
   15626:	je     0x15b5c
   1562c:	cmp    ecx,0x1
   1562f:	jne    0x15c52
   15635:	movzx  ecx,di
   15638:	mov    eax,0x69
   1563d:	cmp    ecx,eax
   1563f:	jg     0x1580c
   15645:	je     0x157fe
   1564b:	sub    ecx,0x43
   1564e:	je     0x1578c
   15654:	sub    ecx,0x10
   15657:	je     0x1572b
   1565d:	sub    ecx,0x5
   15660:	je     0x1587f
   15666:	sub    ecx,0x2
   15669:	je     0x156b0
   1566b:	sub    ecx,0x9
   1566e:	je     0x1579b
   15674:	cmp    ecx,0x1
   15677:	je     0x157fe
   1567d:	xor    edx,edx
   1567f:	mov    edi,DWORD PTR [rsp+0x30]
   15683:	mov    eax,0x20
   15688:	cmp    DWORD PTR [rsp+0x5c],edx
   1568c:	jne    0x15c3f
   15692:	test   sil,0x40
   15696:	je     0x15a39
   1569c:	bt     esi,0x8
   156a0:	jae    0x15a0f
   156a6:	mov    ecx,0x2d
   156ab:	jmp    0x15a1a
   156b0:	mov    rcx,QWORD PTR [r15]
   156b3:	add    r15,0x8
   156b7:	xor    edx,edx
   156b9:	cmp    rcx,rdx
   156bc:	je     0x1570e
   156be:	mov    rbx,QWORD PTR [rcx+0x8]
   156c2:	cmp    rbx,rdx
   156c5:	je     0x1570e
   156c7:	movzx  eax,WORD PTR [rcx]
   156ca:	cmp    WORD PTR [rcx+0x2],ax
   156ce:	jb     0x15d8a
   156d4:	bt     esi,0xb
   156d8:	movzx  r14d,ax
   156dc:	jae    0x15703
   156de:	mov    eax,r14d
   156e1:	not    eax
   156e3:	test   al,0x1
   156e5:	je     0x15d8a
   156eb:	mov    eax,ebx
   156ed:	not    eax
   156ef:	test   al,0x1
   156f1:	je     0x15d8a
   156f7:	lea    edi,[rdx+0x1]
   156fa:	shr    r14d,1
   156fd:	mov    DWORD PTR [rsp+0x30],edi
   15701:	jmp    0x15683
   15703:	mov    edi,edx
   15705:	mov    DWORD PTR [rsp+0x30],edx
   15709:	jmp    0x15683
   1570e:	mov    rbx,QWORD PTR [rip+0x2a2b]        # 0x18140
   15715:	xor    eax,eax
   15717:	mov    rcx,rbp
   1571a:	mov    rdi,rbx
   1571d:	repnz scas al,BYTE PTR es:[rdi]
   1571f:	not    rcx
   15722:	lea    r14,[rcx-0x1]
   15726:	jmp    0x1567f
   1572b:	test   esi,0x830
   15731:	jne    0x15736
   15733:	or     esi,0x20
   15736:	mov    rbx,QWORD PTR [r15]
   15739:	mov    eax,0x7fffffff
   1573e:	cmp    r9d,ebp
   15741:	mov    ecx,r9d
   15744:	cmove  ecx,eax
   15747:	add    r15,0x8
   1574b:	mov    eax,0x20
   15750:	xor    edx,edx
   15752:	test   al,sil
   15755:	je     0x1583f
   1575b:	cmp    rbx,rdx
   1575e:	mov    r14d,edx
   15761:	cmove  rbx,QWORD PTR [rip+0x29d7]        # 0x18140
   15769:	cmp    ecx,edx
   1576b:	mov    rax,rbx
   1576e:	jle    0x1567f
   15774:	cmp    BYTE PTR [rax],dl
   15776:	je     0x1567f
   1577c:	inc    r14d
   1577f:	inc    rax
   15782:	cmp    r14d,ecx
   15785:	jl     0x15774
   15787:	jmp    0x1567f
   1578c:	test   esi,0x830
   15792:	jne    0x1579b
   15794:	mov    eax,0x20
   15799:	or     esi,eax
   1579b:	movzx  eax,WORD PTR [r15]
   1579f:	mov    edi,0x1
   157a4:	add    r15,0x8
   157a8:	lea    ecx,[rdi+0x1f]
   157ab:	mov    WORD PTR [rsp+0x58],ax
   157b0:	mov    DWORD PTR [rsp+0x30],edi
   157b4:	test   cl,sil
   157b7:	je     0x157ea
   157b9:	movsxd r8,DWORD PTR [rip+0x2998]        # 0x18158
   157c0:	mov    BYTE PTR [rsp+0x54],al
   157c4:	xor    eax,eax
   157c6:	lea    rdx,[rsp+0x54]
   157cb:	lea    rcx,[rsp+0x70]
   157d0:	mov    BYTE PTR [rsp+0x55],al
   157d4:	call   0x15ea8
   157d9:	mov    r10d,DWORD PTR [rsp+0x34]
   157de:	xor    edx,edx
   157e0:	cmp    eax,edx
   157e2:	jge    0x157f1
   157e4:	mov    DWORD PTR [rsp+0x5c],edi
   157e8:	jmp    0x157f1
   157ea:	mov    WORD PTR [rsp+0x70],ax
   157ef:	xor    edx,edx
   157f1:	lea    rbx,[rsp+0x70]
   157f6:	mov    r14d,edi
   157f9:	jmp    0x15683
   157fe:	or     esi,0x40
   15801:	mov    r8d,0xa
   15807:	jmp    0x158bb
   1580c:	sub    ecx,0x6e
   1580f:	je     0x159d2
   15815:	sub    ecx,0x1
   15818:	je     0x158ac
   1581e:	sub    ecx,0x1
   15821:	je     0x15875
   15823:	sub    ecx,0x3
   15826:	je     0x15736
   1582c:	sub    ecx,0x2
   1582f:	je     0x15801
   15831:	cmp    ecx,0x3
   15834:	jne    0x1567d
   1583a:	lea    eax,[rcx+0x24]
   1583d:	jmp    0x15884
   1583f:	cmp    rbx,rdx
   15842:	mov    edi,0x1
   15847:	cmove  rbx,QWORD PTR [rip+0x28f9]        # 0x18148
   1584f:	mov    DWORD PTR [rsp+0x30],edi
   15853:	mov    rax,rbx
   15856:	jmp    0x15863
   15858:	dec    ecx
   1585a:	cmp    WORD PTR [rax],dx
   1585d:	je     0x15867
   1585f:	add    rax,0x2
   15863:	cmp    ecx,edx
   15865:	jne    0x15858
   15867:	sub    rax,rbx
   1586a:	sar    rax,1
   1586d:	mov    r14d,eax
   15870:	jmp    0x15683
   15875:	mov    r9d,0x10
   1587b:	bts    esi,0xf
   1587f:	mov    eax,0x7
   15884:	mov    r8d,0x10
   1588a:	mov    DWORD PTR [rsp+0x60],eax
   1588e:	lea    r11d,[r8+0x20]
   15892:	test   sil,sil
   15895:	jns    0x158c1
   15897:	add    ax,0x51
   1589b:	mov    WORD PTR [rsp+0x44],r11w
   158a1:	lea    r10d,[r8-0xe]
   158a5:	mov    WORD PTR [rsp+0x46],ax
   158aa:	jmp    0x158c1
   158ac:	mov    r8d,0x8
   158b2:	test   sil,sil
   158b5:	jns    0x158bb
   158b7:	bts    esi,0x9
   158bb:	mov    r11d,0x30
   158c1:	bt     esi,0xf
   158c5:	jb     0x158cd
   158c7:	bt     esi,0xc
   158cb:	jae    0x158d6
   158cd:	mov    rdi,QWORD PTR [r15]
   158d0:	add    r15,0x8
   158d4:	jmp    0x15908
   158d6:	mov    eax,0x20
   158db:	add    r15,0x8
   158df:	test   al,sil
   158e2:	je     0x158f8
   158e4:	test   sil,0x40
   158e8:	je     0x158f1
   158ea:	movsx  rdi,WORD PTR [r15-0x8]
   158ef:	jmp    0x15908
   158f1:	movzx  edi,WORD PTR [r15-0x8]
   158f6:	jmp    0x15908
   158f8:	test   sil,0x40
   158fc:	je     0x15904
   158fe:	movsxd rdi,DWORD PTR [r15-0x8]
   15902:	jmp    0x15908
   15904:	mov    edi,DWORD PTR [r15-0x8]
   15908:	xor    edx,edx
   1590a:	test   sil,0x40
   1590e:	je     0x1591c
   15910:	cmp    rdi,rdx
   15913:	jge    0x1591c
   15915:	neg    rdi
   15918:	bts    esi,0x8
   1591c:	bt     esi,0xf
   15920:	jb     0x1592a
   15922:	bt     esi,0xc
   15926:	jb     0x1592a
   15928:	mov    edi,edi
   1592a:	cmp    r9d,edx
   1592d:	jge    0x15937
   1592f:	mov    r9d,0x1
   15935:	jmp    0x15946
   15937:	mov    eax,0x200
   1593c:	and    esi,0xfffffff7
   1593f:	cmp    r9d,eax
   15942:	cmovg  r9d,eax
   15946:	mov    rax,rdi
   15949:	lea    rbx,[rsp+0x26f]
   15951:	neg    rax
   15954:	sbb    ecx,ecx
   15956:	and    ecx,r10d
   15959:	mov    r10d,DWORD PTR [rsp+0x60]
   1595e:	mov    DWORD PTR [rsp+0x34],ecx
   15962:	mov    ecx,r9d
   15965:	dec    r9d
   15968:	cmp    ecx,edx
   1596a:	jg     0x15971
   1596c:	cmp    rdi,rdx
   1596f:	je     0x15993
   15971:	xor    edx,edx
   15973:	mov    rax,rdi
   15976:	movsxd rcx,r8d
   15979:	div    rcx
   1597c:	mov    rdi,rax
   1597f:	lea    eax,[rdx+0x30]
   15982:	cmp    eax,0x39
   15985:	jle    0x1598a
   15987:	add    eax,r10d
   1598a:	mov    BYTE PTR [rbx],al
   1598c:	dec    rbx
   1598f:	xor    edx,edx
   15991:	jmp    0x15962
   15993:	mov    r10d,DWORD PTR [rsp+0x34]
   15998:	lea    rax,[rsp+0x26f]
   159a0:	mov    DWORD PTR [rsp+0x3c],r9d
   159a5:	sub    eax,ebx
   159a7:	inc    rbx
   159aa:	bt     esi,0x9
   159ae:	mov    r14d,eax
   159b1:	jae    0x1567f
   159b7:	cmp    eax,edx
   159b9:	je     0x159c4
   159bb:	cmp    BYTE PTR [rbx],r11b
   159be:	je     0x1567f
   159c4:	dec    rbx
   159c7:	inc    r14d
   159ca:	mov    BYTE PTR [rbx],r11b
   159cd:	jmp    0x1567f
   159d2:	mov    rdi,QWORD PTR [r15]
   159d5:	add    r15,0x8
   159d9:	call   0x15e3c
   159de:	xor    edx,edx
   159e0:	cmp    eax,edx
   159e2:	je     0x15d8a
   159e8:	lea    eax,[rdx+0x20]
   159eb:	test   al,sil
   159ee:	je     0x159f6
   159f0:	mov    WORD PTR [rdi],r12w
   159f4:	jmp    0x159f9
   159f6:	mov    DWORD PTR [rdi],r12d
   159f9:	mov    edi,DWORD PTR [rsp+0x30]
   159fd:	mov    r10d,DWORD PTR [rsp+0x34]
   15a02:	mov    DWORD PTR [rsp+0x5c],0x1
   15a0a:	jmp    0x15688
   15a0f:	test   sil,0x1
   15a13:	je     0x15a2c
   15a15:	mov    ecx,0x2b
   15a1a:	mov    WORD PTR [rsp+0x44],cx
   15a1f:	mov    r12d,0x1
   15a25:	mov    DWORD PTR [rsp+0x34],r12d
   15a2a:	jmp    0x15a3e
   15a2c:	test   sil,0x2
   15a30:	je     0x15a39
   15a32:	mov    WORD PTR [rsp+0x44],ax
   15a37:	jmp    0x15a1f
   15a39:	mov    r12d,DWORD PTR [rsp+0x34]
   15a3e:	mov    r13d,DWORD PTR [rsp+0x40]
   15a43:	sub    r13d,r14d
   15a46:	sub    r13d,r12d
   15a49:	test   sil,0xc
   15a4d:	jne    0x15a63
   15a4f:	mov    r8,QWORD PTR [rsp+0x48]
   15a54:	lea    r9,[rsp+0x38]
   15a59:	mov    ecx,eax
   15a5b:	mov    edx,r13d
   15a5e:	call   0x1541c
   15a63:	mov    r8,QWORD PTR [rsp+0x48]
   15a68:	lea    r9,[rsp+0x38]
   15a6d:	lea    rcx,[rsp+0x44]
   15a72:	mov    edx,r12d
   15a75:	call   0x15474
   15a7a:	test   sil,0x8
   15a7e:	je     0x15a9d
   15a80:	test   sil,0x4
   15a84:	jne    0x15a9d
   15a86:	mov    r8,QWORD PTR [rsp+0x48]
   15a8b:	lea    r9,[rsp+0x38]
   15a90:	mov    ecx,0x30
   15a95:	mov    edx,r13d
   15a98:	call   0x1541c
   15a9d:	xor    eax,eax
   15a9f:	cmp    edi,eax
   15aa1:	jne    0x15b0e
   15aa3:	cmp    r14d,eax
   15aa6:	jle    0x15b0e
   15aa8:	mov    r12,rbx
   15aab:	mov    edi,r14d
   15aae:	movsxd r8,DWORD PTR [rip+0x26a3]        # 0x18158
   15ab5:	lea    rcx,[rsp+0x58]
   15aba:	mov    rdx,r12
   15abd:	dec    edi
   15abf:	call   0x15ea8
   15ac4:	movsxd rbp,eax
   15ac7:	cmp    ebp,0x2
   15aca:	jne    0x15ace
   15acc:	dec    edi
   15ace:	xor    edx,edx
   15ad0:	cmp    ebp,edx
   15ad2:	jle    0x15afc
   15ad4:	mov    rdx,QWORD PTR [rsp+0x48]
   15ad9:	movzx  ecx,WORD PTR [rsp+0x58]
   15ade:	lea    r8,[rsp+0x38]
   15ae3:	call   0x153cc
   15ae8:	add    r12,rbp
   15aeb:	xor    ebp,ebp
   15aed:	cmp    edi,ebp
   15aef:	jg     0x15aae
   15af1:	mov    rdi,QWORD PTR [rsp+0x48]
   15af6:	or     rbp,0xffffffffffffffff
   15afa:	jmp    0x15b26
   15afc:	mov    rdi,QWORD PTR [rsp+0x48]
   15b01:	or     rbp,0xffffffffffffffff
   15b05:	mov    r12d,ebp
   15b08:	mov    DWORD PTR [rsp+0x38],ebp
   15b0c:	jmp    0x15b2d
   15b0e:	mov    rdi,QWORD PTR [rsp+0x48]
   15b13:	lea    r9,[rsp+0x38]
   15b18:	mov    edx,r14d
   15b1b:	mov    r8,rdi
   15b1e:	mov    rcx,rbx
   15b21:	call   0x15474
   15b26:	mov    r12d,DWORD PTR [rsp+0x38]
   15b2b:	xor    edx,edx
   15b2d:	cmp    r12d,edx
   15b30:	jl     0x15b52
   15b32:	test   sil,0x4
   15b36:	je     0x15b52
   15b38:	lea    r9,[rsp+0x38]
   15b3d:	mov    ecx,0x20
   15b42:	mov    r8,rdi
   15b45:	mov    edx,r13d
   15b48:	call   0x1541c
   15b4d:	mov    r12d,DWORD PTR [rsp+0x38]
   15b52:	mov    r13,QWORD PTR [rsp+0x68]
   15b57:	jmp    0x15c3a
   15b5c:	movzx  eax,di
   15b5f:	cmp    eax,0x49
   15b62:	je     0x15ba8
   15b64:	cmp    eax,0x68
   15b67:	je     0x15ba0
   15b69:	mov    ecx,0x6c
   15b6e:	cmp    eax,ecx
   15b70:	je     0x15b84
   15b72:	cmp    eax,0x77
   15b75:	jne    0x15c52
   15b7b:	bts    esi,0xb
   15b7f:	jmp    0x15c52
   15b84:	cmp    WORD PTR [r13+0x0],cx
   15b89:	jne    0x15b98
   15b8b:	add    r13,0x2
   15b8f:	bts    esi,0xc
   15b93:	jmp    0x15c52
   15b98:	or     esi,0x10
   15b9b:	jmp    0x15c52
   15ba0:	or     esi,0x20
   15ba3:	jmp    0x15c52
   15ba8:	bts    esi,0xf
   15bac:	cmp    WORD PTR [r13+0x0],0x36
   15bb2:	jne    0x15bc9
   15bb4:	cmp    WORD PTR [r13+0x2],0x34
   15bba:	jne    0x15bc9
   15bbc:	add    r13,0x4
   15bc0:	bts    esi,0xf
   15bc4:	jmp    0x15c52
   15bc9:	cmp    WORD PTR [r13+0x0],0x33
   15bcf:	jne    0x15be3
   15bd1:	cmp    WORD PTR [r13+0x2],0x32
   15bd7:	jne    0x15be3
   15bd9:	add    r13,0x4
   15bdd:	btr    esi,0xf
   15be1:	jmp    0x15c52
   15be3:	cmp    WORD PTR [r13+0x0],0x64
   15be9:	je     0x15c52
   15beb:	mov    eax,0x69
   15bf0:	cmp    WORD PTR [r13+0x0],ax
   15bf5:	je     0x15c52
   15bf7:	cmp    WORD PTR [r13+0x0],0x6f
   15bfd:	je     0x15c52
   15bff:	cmp    WORD PTR [r13+0x0],0x75
   15c05:	je     0x15c52
   15c07:	cmp    WORD PTR [r13+0x0],0x78
   15c0d:	je     0x15c52
   15c0f:	cmp    WORD PTR [r13+0x0],0x58
   15c15:	je     0x15c52
   15c17:	xor    eax,eax
   15c19:	mov    DWORD PTR [rsp+0x50],eax
   15c1d:	lea    r8,[rsp+0x38]
   15c22:	mov    rdx,r11
   15c25:	movzx  ecx,di
   15c28:	mov    DWORD PTR [rsp+0x30],0x1
   15c30:	call   0x153cc
   15c35:	mov    r12d,DWORD PTR [rsp+0x38]
   15c3a:	mov    r10d,DWORD PTR [rsp+0x34]
   15c3f:	mov    edx,DWORD PTR [rsp+0x50]
   15c43:	mov    r11,QWORD PTR [rsp+0x48]
   15c48:	mov    r8d,DWORD PTR [rsp+0x40]
   15c4d:	mov    r9d,DWORD PTR [rsp+0x3c]
   15c52:	mov    di,WORD PTR [r13+0x0]
   15c57:	xor    ecx,ecx
   15c59:	cmp    di,cx
   15c5c:	jne    0x1559d
   15c62:	mov    eax,r12d
   15c65:	mov    rcx,QWORD PTR [rsp+0x470]
   15c6d:	xor    rcx,rsp
   15c70:	call   0x14ce0
   15c75:	mov    rbx,QWORD PTR [rsp+0x4d0]
   15c7d:	add    rsp,0x480
   15c84:	pop    r15
   15c86:	pop    r14
   15c88:	pop    r13
   15c8a:	pop    r12
   15c8c:	pop    rdi
   15c8d:	pop    rsi
   15c8e:	pop    rbp
   15c8f:	ret
   15c90:	cmp    di,0x2a
   15c94:	jne    0x15cb2
   15c96:	mov    r9d,DWORD PTR [r15]
   15c99:	add    r15,0x8
   15c9d:	xor    edi,edi
   15c9f:	cmp    r9d,edi
   15ca2:	mov    DWORD PTR [rsp+0x3c],r9d
   15ca7:	jge    0x15c52
   15ca9:	mov    r9d,ebp
   15cac:	mov    DWORD PTR [rsp+0x3c],ebp
   15cb0:	jmp    0x15c52
   15cb2:	lea    ecx,[r9+r9*4]
   15cb6:	movzx  eax,di
   15cb9:	lea    r9d,[rax+rcx*2-0x30]
   15cbe:	mov    DWORD PTR [rsp+0x3c],r9d
   15cc3:	jmp    0x15c52
   15cc5:	xor    edi,edi
   15cc7:	mov    r9d,edi
   15cca:	mov    DWORD PTR [rsp+0x3c],edi
   15cce:	jmp    0x15c52
   15cd0:	cmp    di,0x2a
   15cd4:	jne    0x15cf5
   15cd6:	mov    r8d,DWORD PTR [r15]
   15cd9:	add    r15,0x8
   15cdd:	xor    edi,edi
   15cdf:	cmp    r8d,edi
   15ce2:	mov    DWORD PTR [rsp+0x40],r8d
   15ce7:	jge    0x15c52
   15ced:	or     esi,0x4
   15cf0:	neg    r8d
   15cf3:	jmp    0x15d01
   15cf5:	lea    ecx,[r8+r8*4]
   15cf9:	movzx  eax,di
   15cfc:	lea    r8d,[rax+rcx*2-0x30]
   15d01:	mov    DWORD PTR [rsp+0x40],r8d
   15d06:	jmp    0x15c52
   15d0b:	movzx  eax,di
   15d0e:	mov    ecx,0x20
   15d13:	cmp    eax,ecx
   15d15:	je     0x15d5c
   15d17:	cmp    eax,0x23
   15d1a:	je     0x15d53
   15d1c:	mov    ecx,0x2b
   15d21:	cmp    eax,ecx
   15d23:	je     0x15d4b
   15d25:	mov    ecx,0x2d
   15d2a:	cmp    eax,ecx
   15d2c:	je     0x15d43
   15d2e:	mov    ecx,0x30
   15d33:	cmp    eax,ecx
   15d35:	jne    0x15c52
   15d3b:	or     esi,0x8
   15d3e:	jmp    0x15c52
   15d43:	or     esi,0x4
   15d46:	jmp    0x15c52
   15d4b:	or     esi,0x1
   15d4e:	jmp    0x15c52
   15d53:	bts    esi,0x7
   15d57:	jmp    0x15c52
   15d5c:	or     esi,0x2
   15d5f:	jmp    0x15c52
   15d64:	xor    edi,edi
   15d66:	mov    r9d,ebp
   15d69:	mov    DWORD PTR [rsp+0x3c],ebp
   15d6d:	mov    DWORD PTR [rsp+0x5c],edi
   15d71:	mov    r8d,edi
   15d74:	mov    DWORD PTR [rsp+0x40],edi
   15d78:	mov    r10d,edi
   15d7b:	mov    DWORD PTR [rsp+0x34],edi
   15d7f:	mov    esi,edi
   15d81:	mov    DWORD PTR [rsp+0x30],edi
   15d85:	jmp    0x15c52
   15d8a:	xor    r9d,r9d
   15d8d:	xor    r8d,r8d
   15d90:	xor    ecx,ecx
   15d92:	mov    QWORD PTR [rsp+0x20],rdx
   15d97:	call   0x153c0
   15d9c:	mov    eax,ebp
   15d9e:	jmp    0x15c65
   15da3:	int3
   15da4:	int3
   15da5:	int3
   15da6:	int3
   15da7:	int3
   15da8:	int3
   15da9:	int3
   15daa:	int3
   15dab:	int3
   15dac:	rex push rbx
   15dae:	sub    rsp,0x20
   15db2:	mov    r11d,DWORD PTR [r8]
   15db5:	mov    rbx,rdx
   15db8:	mov    r9,rcx
   15dbb:	and    r11d,0xfffffff8
   15dbf:	test   BYTE PTR [r8],0x4
   15dc3:	mov    r10,rcx
   15dc6:	je     0x15ddb
   15dc8:	mov    eax,DWORD PTR [r8+0x8]
   15dcc:	movsxd r10,DWORD PTR [r8+0x4]
   15dd0:	neg    eax
   15dd2:	add    r10,rcx
   15dd5:	movsxd rcx,eax
   15dd8:	and    r10,rcx
   15ddb:	movsxd rax,r11d
   15dde:	mov    rdx,QWORD PTR [rax+r10*1]
   15de2:	mov    rax,QWORD PTR [rbx+0x10]
   15de6:	mov    ecx,DWORD PTR [rax+0x8]
   15de9:	add    rcx,QWORD PTR [rbx+0x8]
   15ded:	test   BYTE PTR [rcx+0x3],0xf
   15df1:	je     0x15dff
   15df3:	movzx  eax,BYTE PTR [rcx+0x3]
   15df7:	and    eax,0xfffffff0
   15dfa:	cdqe
   15dfc:	add    r9,rax
   15dff:	xor    r9,rdx
   15e02:	mov    rcx,r9
   15e05:	add    rsp,0x20
   15e09:	pop    rbx
   15e0a:	jmp    0x14ce0
   15e0f:	int3
   15e10:	int3
   15e11:	int3
   15e12:	int3
   15e13:	int3
   15e14:	int3
   15e15:	int3
   15e16:	int3
   15e17:	int3
   15e18:	sub    rsp,0x28
   15e1c:	mov    r8,QWORD PTR [r9+0x38]
   15e20:	mov    rcx,rdx
   15e23:	mov    rdx,r9
   15e26:	call   0x15dac
   15e2b:	mov    eax,0x1
   15e30:	add    rsp,0x28
   15e34:	ret
   15e35:	int3
   15e36:	int3
   15e37:	int3
   15e38:	int3
   15e39:	int3
   15e3a:	int3
   15e3b:	int3
   15e3c:	mov    rcx,QWORD PTR [rip+0x22bd]        # 0x18100
   15e43:	xor    eax,eax
   15e45:	or     rcx,0x1
   15e49:	cmp    QWORD PTR [rip+0x3280],rcx        # 0x190d0
   15e50:	sete   al
   15e53:	ret
   15e54:	int3
   15e55:	int3
   15e56:	int3
   15e57:	int3
   15e58:	int3
   15e59:	int3
   15e5a:	int3
   15e5b:	int3
   15e5c:	sub    rsp,0x38
   15e60:	test   rdx,rdx
   15e63:	jne    0x15e7e
   15e65:	and    QWORD PTR [rsp+0x20],rdx
   15e6a:	xor    r9d,r9d
   15e6d:	xor    r8d,r8d
   15e70:	xor    ecx,ecx
   15e72:	call   0x153c0
   15e77:	mov    eax,0xffff
   15e7c:	jmp    0x15e9b
   15e7e:	add    DWORD PTR [rdx+0x8],0xfffffffe
   15e82:	js     0x15e93
   15e84:	mov    rax,QWORD PTR [rdx]
   15e87:	mov    WORD PTR [rax],cx
   15e8a:	add    QWORD PTR [rdx],0x2
   15e8e:	mov    ax,cx
   15e91:	jmp    0x15e9b
   15e93:	movzx  ecx,cx
   15e96:	call   0x15f00
   15e9b:	add    rsp,0x38
   15e9f:	ret
   15ea0:	int3
   15ea1:	int3
   15ea2:	int3
   15ea3:	int3
   15ea4:	int3
   15ea5:	int3
   15ea6:	int3
   15ea7:	int3
   15ea8:	mov    QWORD PTR [rsp+0x8],rbx
   15ead:	push   rdi
   15eae:	sub    rsp,0x20
   15eb2:	xor    eax,eax
   15eb4:	mov    rdi,rdx
   15eb7:	mov    rbx,rcx
   15eba:	cmp    rdx,rax
   15ebd:	je     0x15eec
   15ebf:	cmp    r8,rax
   15ec2:	je     0x15eec
   15ec4:	cmp    BYTE PTR [rdx],al
   15ec6:	jne    0x15ed2
   15ec8:	cmp    rcx,rax
   15ecb:	je     0x15eec
   15ecd:	mov    WORD PTR [rcx],ax
   15ed0:	jmp    0x15eec
   15ed2:	lea    rcx,[rsp+0x38]
   15ed7:	mov    QWORD PTR [rsp+0x38],rdx
   15edc:	call   0x15f10
   15ee1:	mov    WORD PTR [rbx],ax
   15ee4:	mov    rax,QWORD PTR [rsp+0x38]
   15ee9:	sub    rax,rdi
   15eec:	mov    rbx,QWORD PTR [rsp+0x30]
   15ef1:	add    rsp,0x20
   15ef5:	pop    rdi
   15ef6:	ret
   15ef7:	int3
   15ef8:	int3
   15ef9:	int3
   15efa:	int3
   15efb:	int3
   15efc:	int3
   15efd:	int3
   15efe:	int3
   15eff:	int3
   15f00:	or     DWORD PTR [rdx+0x18],0x20
   15f04:	mov    eax,0xffff
   15f09:	ret
   15f0a:	int3
   15f0b:	int3
   15f0c:	int3
   15f0d:	int3
   15f0e:	int3
   15f0f:	int3
   15f10:	jmp    QWORD PTR [rip+0x114a]        # 0x17060
   15f16:	int3
   15f17:	int3
   15f18:	int3
   15f19:	int3
   15f1a:	int3
   15f1b:	int3
   15f1c:	jmp    QWORD PTR [rip+0x10ee]        # 0x17010
   15f22:	int3
   15f23:	int3
   15f24:	int3
   15f25:	int3
   15f26:	int3
   15f27:	int3
   15f28:	jmp    QWORD PTR [rip+0x10da]        # 0x17008
   15f2e:	int3
   15f2f:	int3
   15f30:	int3
   15f31:	int3
   15f32:	int3
   15f33:	int3
   15f34:	jmp    QWORD PTR [rip+0x10c6]        # 0x17000
   15f3a:	int3
   15f3b:	int3
   15f3c:	int3
   15f3d:	int3
   15f3e:	int3
   15f3f:	int3
   15f40:	jmp    QWORD PTR [rip+0x10d2]        # 0x17018
   15f46:	int3
   15f47:	int3
   15f48:	int3
   15f49:	int3
   15f4a:	int3
   15f4b:	int3
   15f4c:	int3
   15f4d:	int3
   15f4e:	int3
   15f4f:	int3
   15f50:	int3
   15f51:	int3
   15f52:	int3
   15f53:	int3
   15f54:	int3
   15f55:	int3
   15f56:	data16 nop WORD PTR [rax+rax*1+0x0]
   15f60:	mov    r11,rcx
   15f63:	sub    rdx,rcx
   15f66:	jb     0x1610a
   15f6c:	cmp    r8,0x8
   15f70:	jb     0x15fd4
   15f72:	test   cl,0x7
   15f75:	je     0x15fae
   15f77:	test   cl,0x1
   15f7a:	je     0x15f88
   15f7c:	mov    al,BYTE PTR [rdx+rcx*1]
   15f7f:	dec    r8
   15f82:	mov    BYTE PTR [rcx],al
   15f84:	add    rcx,0x1
   15f88:	test   cl,0x2
   15f8b:	je     0x15f9c
   15f8d:	mov    ax,WORD PTR [rdx+rcx*1]
   15f91:	sub    r8,0x2
   15f95:	mov    WORD PTR [rcx],ax
   15f98:	add    rcx,0x2
   15f9c:	test   cl,0x4
   15f9f:	je     0x15fae
   15fa1:	mov    eax,DWORD PTR [rdx+rcx*1]
   15fa4:	sub    r8,0x4
   15fa8:	mov    DWORD PTR [rcx],eax
   15faa:	add    rcx,0x4
   15fae:	mov    r9,r8
   15fb1:	shr    r9,0x5
   15fb5:	jne    0x16007
   15fb7:	mov    r9,r8
   15fba:	shr    r9,0x3
   15fbe:	je     0x15fd4
   15fc0:	mov    rax,QWORD PTR [rdx+rcx*1]
   15fc4:	mov    QWORD PTR [rcx],rax
   15fc7:	add    rcx,0x8
   15fcb:	dec    r9
   15fce:	jne    0x15fc0
   15fd0:	and    r8,0x7
   15fd4:	test   r8,r8
   15fd7:	jne    0x15fe0
   15fd9:	mov    rax,r11
   15fdc:	ret
   15fdd:	nop    DWORD PTR [rax]
   15fe0:	mov    al,BYTE PTR [rdx+rcx*1]
   15fe3:	mov    BYTE PTR [rcx],al
   15fe5:	inc    rcx
   15fe8:	dec    r8
   15feb:	jne    0x15fe0
   15fed:	mov    rax,r11
   15ff0:	ret
   15ff1:	data16 data16 data16 data16 data16 data16 nop WORD PTR [rax+rax*1+0x0]
   16000:	data16 data16 xchg ax,ax
   16004:	data16 xchg ax,ax
   16007:	cmp    r9,0x2000
   1600e:	jae    0x16052
   16010:	mov    rax,QWORD PTR [rdx+rcx*1]
   16014:	mov    r10,QWORD PTR [rdx+rcx*1+0x8]
   16019:	add    rcx,0x20
   1601d:	mov    QWORD PTR [rcx-0x20],rax
   16021:	mov    QWORD PTR [rcx-0x18],r10
   16025:	mov    rax,QWORD PTR [rdx+rcx*1-0x10]
   1602a:	mov    r10,QWORD PTR [rdx+rcx*1-0x8]
   1602f:	dec    r9
   16032:	mov    QWORD PTR [rcx-0x10],rax
   16036:	mov    QWORD PTR [rcx-0x8],r10
   1603a:	jne    0x16010
   1603c:	and    r8,0x1f
   16040:	jmp    0x15fb7
   16045:	data16 data16 nop WORD PTR [rax+rax*1+0x0]
   16050:	xchg   ax,ax
   16052:	cmp    rdx,0x1000
   16059:	jb     0x16010
   1605b:	mov    eax,0x20
   16060:	prefetchnta BYTE PTR [rdx+rcx*1]
   16064:	prefetchnta BYTE PTR [rdx+rcx*1+0x40]
   16069:	add    rcx,0x80
   16070:	dec    eax
   16072:	jne    0x16060
   16074:	sub    rcx,0x1000
   1607b:	mov    eax,0x40
   16080:	mov    r9,QWORD PTR [rdx+rcx*1]
   16084:	mov    r10,QWORD PTR [rdx+rcx*1+0x8]
   16089:	movnti QWORD PTR [rcx],r9
   1608d:	movnti QWORD PTR [rcx+0x8],r10
   16092:	mov    r9,QWORD PTR [rdx+rcx*1+0x10]
   16097:	mov    r10,QWORD PTR [rdx+rcx*1+0x18]
   1609c:	movnti QWORD PTR [rcx+0x10],r9
   160a1:	movnti QWORD PTR [rcx+0x18],r10
   160a6:	mov    r9,QWORD PTR [rdx+rcx*1+0x20]
   160ab:	mov    r10,QWORD PTR [rdx+rcx*1+0x28]
   160b0:	add    rcx,0x40
   160b4:	movnti QWORD PTR [rcx-0x20],r9
   160b9:	movnti QWORD PTR [rcx-0x18],r10
   160be:	mov    r9,QWORD PTR [rdx+rcx*1-0x10]
   160c3:	mov    r10,QWORD PTR [rdx+rcx*1-0x8]
   160c8:	dec    eax
   160ca:	movnti QWORD PTR [rcx-0x10],r9
   160cf:	movnti QWORD PTR [rcx-0x8],r10
   160d4:	jne    0x16080
   160d6:	sub    r8,0x1000
   160dd:	cmp    r8,0x1000
   160e4:	jae    0x1605b
   160ea:	lock or BYTE PTR [rsp],0x0
   160ef:	jmp    0x15fae
   160f4:	data16 data16 data16 nop WORD PTR [rax+rax*1+0x0]
   16100:	data16 data16 xchg ax,ax
   16104:	data16 data16 xchg ax,ax
   16108:	xchg   ax,ax
   1610a:	add    rcx,r8
   1610d:	cmp    r8,0x8
   16111:	jb     0x16174
   16113:	test   cl,0x7
   16116:	je     0x1614e
   16118:	test   cl,0x1
   1611b:	je     0x16128
   1611d:	dec    rcx
   16120:	mov    al,BYTE PTR [rdx+rcx*1]
   16123:	dec    r8
   16126:	mov    BYTE PTR [rcx],al
   16128:	test   cl,0x2
   1612b:	je     0x1613c
   1612d:	sub    rcx,0x2
   16131:	mov    ax,WORD PTR [rdx+rcx*1]
   16135:	sub    r8,0x2
   16139:	mov    WORD PTR [rcx],ax
   1613c:	test   cl,0x4
   1613f:	je     0x1614e
   16141:	sub    rcx,0x4
   16145:	mov    eax,DWORD PTR [rdx+rcx*1]
   16148:	sub    r8,0x4
   1614c:	mov    DWORD PTR [rcx],eax
   1614e:	mov    r9,r8
   16151:	shr    r9,0x5
   16155:	jne    0x161a7
   16157:	mov    r9,r8
   1615a:	shr    r9,0x3
   1615e:	je     0x16174
   16160:	sub    rcx,0x8
   16164:	mov    rax,QWORD PTR [rdx+rcx*1]
   16168:	dec    r9
   1616b:	mov    QWORD PTR [rcx],rax
   1616e:	jne    0x16160
   16170:	and    r8,0x7
   16174:	test   r8,r8
   16177:	jne    0x16180
   16179:	mov    rax,r11
   1617c:	ret
   1617d:	nop    DWORD PTR [rax]
   16180:	dec    rcx
   16183:	mov    al,BYTE PTR [rdx+rcx*1]
   16186:	dec    r8
   16189:	mov    BYTE PTR [rcx],al
   1618b:	jne    0x16180
   1618d:	mov    rax,r11
   16190:	ret
   16191:	data16 data16 data16 data16 data16 data16 nop WORD PTR [rax+rax*1+0x0]
   161a0:	data16 data16 xchg ax,ax
   161a4:	data16 xchg ax,ax
   161a7:	cmp    r9,0x2000
   161ae:	jae    0x161f2
   161b0:	mov    rax,QWORD PTR [rdx+rcx*1-0x8]
   161b5:	mov    r10,QWORD PTR [rdx+rcx*1-0x10]
   161ba:	sub    rcx,0x20
   161be:	mov    QWORD PTR [rcx+0x18],rax
   161c2:	mov    QWORD PTR [rcx+0x10],r10
   161c6:	mov    rax,QWORD PTR [rdx+rcx*1+0x8]
   161cb:	mov    r10,QWORD PTR [rdx+rcx*1]
   161cf:	dec    r9
   161d2:	mov    QWORD PTR [rcx+0x8],rax
   161d6:	mov    QWORD PTR [rcx],r10
   161d9:	jne    0x161b0
   161db:	and    r8,0x1f
   161df:	jmp    0x16157
   161e4:	data16 data16 data16 nop WORD PTR [rax+rax*1+0x0]
   161f0:	xchg   ax,ax
   161f2:	cmp    rdx,0xfffffffffffff000
   161f9:	ja     0x161b0
   161fb:	mov    eax,0x20
   16200:	sub    rcx,0x80
   16207:	prefetchnta BYTE PTR [rdx+rcx*1]
   1620b:	prefetchnta BYTE PTR [rdx+rcx*1+0x40]
   16210:	dec    eax
   16212:	jne    0x16200
   16214:	add    rcx,0x1000
   1621b:	mov    eax,0x40
   16220:	mov    r9,QWORD PTR [rdx+rcx*1-0x8]
   16225:	mov    r10,QWORD PTR [rdx+rcx*1-0x10]
   1622a:	movnti QWORD PTR [rcx-0x8],r9
   1622f:	movnti QWORD PTR [rcx-0x10],r10
   16234:	mov    r9,QWORD PTR [rdx+rcx*1-0x18]
   16239:	mov    r10,QWORD PTR [rdx+rcx*1-0x20]
   1623e:	movnti QWORD PTR [rcx-0x18],r9
   16243:	movnti QWORD PTR [rcx-0x20],r10
   16248:	mov    r9,QWORD PTR [rdx+rcx*1-0x28]
   1624d:	mov    r10,QWORD PTR [rdx+rcx*1-0x30]
   16252:	sub    rcx,0x40
   16256:	movnti QWORD PTR [rcx+0x18],r9
   1625b:	movnti QWORD PTR [rcx+0x10],r10
   16260:	mov    r9,QWORD PTR [rdx+rcx*1+0x8]
   16265:	mov    r10,QWORD PTR [rdx+rcx*1]
   16269:	dec    eax
   1626b:	movnti QWORD PTR [rcx+0x8],r9
   16270:	movnti QWORD PTR [rcx],r10
   16274:	jne    0x16220
   16276:	sub    r8,0x1000
   1627d:	cmp    r8,0x1000
   16284:	jae    0x161fb
   1628a:	lock or BYTE PTR [rsp],0x0
   1628f:	jmp    0x1614e
   16294:	int3
   16295:	int3
   16296:	int3
   16297:	int3
   16298:	int3
   16299:	int3
   1629a:	int3
   1629b:	int3
   1629c:	int3
   1629d:	int3
   1629e:	int3
   1629f:	int3
   162a0:	push   rax
   162a1:	add    BYTE PTR [rdi+0x0],ch
   162a4:	jb     0x162a6
   162a6:	je     0x162a8
   162a8:	rex.WRX add BYTE PTR [rcx+0x0],r12b
   162ac:	ins    DWORD PTR es:[rdi],dx
   162ad:	add    BYTE PTR [rbp+0x0],ah
   162b0:	add    BYTE PTR [rax],al
   162b2:	int3
   162b3:	int3
   162b4:	int3
   162b5:	int3
   162b6:	int3
   162b7:	int3
   162b8:	int3
   162b9:	int3
   162ba:	int3
   162bb:	int3
   162bc:	int3
   162bd:	int3
   162be:	int3
   162bf:	int3
   162c0:	pop    rsp
   162c1:	add    BYTE PTR [rax+rax*1+0x6f],al
   162c5:	add    BYTE PTR [rbx+0x0],dh
   162c8:	add    BYTE PTR [rbp+0x0],r12b
   162cc:	jbe    0x162ce
   162ce:	imul   eax,DWORD PTR [rax],0x650063
   162d4:	jae    0x162d6
   162d6:	pop    rsp
   162d7:	add    BYTE PTR [rax],al
   162d9:	add    ah,cl
   162db:	int3
   162dc:	int3
   162dd:	int3
   162de:	int3
   162df:	int3
   162e0:	and    eax,0x73007700
   162e5:	add    BYTE PTR [rip+0x73007700],ah        # 0x7301d9eb
   162eb:	add    BYTE PTR [rax],al
   162ed:	add    ah,cl
   162ef:	int3
   162f0:	push   rbx
   162f1:	add    BYTE PTR [rbp+0x0],al
   162f4:	push   rdx
   162f5:	add    BYTE PTR [rcx+0x0],cl
   162f8:	add    BYTE PTR [r8+rax*1+0x43],cl
   162fd:	add    BYTE PTR [rdi+0x0],cl
   16300:	rex.WRB add BYTE PTR [r13+0x0],r9b
   16304:	add    BYTE PTR [rax],al
   16306:	int3
   16307:	int3
   16308:	int3
   16309:	int3
   1630a:	int3
   1630b:	int3
   1630c:	int3
   1630d:	int3
   1630e:	int3
   1630f:	int3
   16310:	push   rsi
   16311:	add    BYTE PTR [rbp+0x0],ah
   16314:	outs   dx,BYTE PTR ds:[rsi]
   16315:	add    BYTE PTR [rax+rax*1+0x6f],ah
   16319:	add    BYTE PTR [rdx+0x0],dh
   1631c:	push   rdx
   1631d:	add    BYTE PTR [rbp+0x0],ah
   16320:	jno    0x16322
   16322:	jne    0x16324
   16324:	add    BYTE PTR gs:[rbx+0x0],dh
   16328:	je     0x1632a
   1632a:	push   rsp
   1632b:	add    BYTE PTR [rcx+0x0],ch
   1632e:	ins    DWORD PTR es:[rdi],dx
   1632f:	add    BYTE PTR [rbp+0x0],ah
   16332:	outs   dx,DWORD PTR ds:[rsi]
   16333:	add    BYTE PTR [rbp+0x0],dh
   16336:	je     0x16338
   16338:	push   rsi
   16339:	add    BYTE PTR [rcx+0x0],ah
   1633c:	ins    BYTE PTR es:[rdi],dx
   1633d:	add    BYTE PTR [rbp+0x0],dh
   16340:	add    BYTE PTR gs:[rax],al
   16343:	add    ah,cl
   16345:	int3
   16346:	int3
   16347:	int3
   16348:	int3
   16349:	int3
   1634a:	int3
   1634b:	int3
   1634c:	int3
   1634d:	int3
   1634e:	int3
   1634f:	int3
   16350:	push   rbx
   16351:	add    BYTE PTR [rax+0x0],dh
   16354:	jb     0x16356
   16356:	add    BYTE PTR fs:[rsi+0x0],dl
   1635a:	add    BYTE PTR gs:[rsi+0x0],ch
   1635e:	add    BYTE PTR fs:[rdi+0x0],ch
   16362:	jb     0x16364
   16364:	push   rdx
   16365:	add    BYTE PTR [rbp+0x0],ah
   16368:	jno    0x1636a
   1636a:	jne    0x1636c
   1636c:	add    BYTE PTR gs:[rbx+0x0],dh
   16370:	je     0x16372
   16372:	add    BYTE PTR [rax],al
   16374:	int3
   16375:	int3
   16376:	int3
   16377:	int3
   16378:	int3
   16379:	int3
   1637a:	int3
   1637b:	int3
   1637c:	int3
   1637d:	int3
   1637e:	int3
   1637f:	int3
   16380:	add    BYTE PTR [r8+r8*1+0x63],spl
   16385:	add    BYTE PTR [rbx+0x0],al
   16388:	outs   dx,DWORD PTR ds:[rsi]
   16389:	add    BYTE PTR [rsi+0x0],ch
   1638c:	je     0x1638e
   1638e:	jb     0x16390
   16390:	outs   dx,DWORD PTR ds:[rsi]
   16391:	add    BYTE PTR [rax+rax*1+0x4c],ch
   16395:	add    BYTE PTR [rcx+0x0],ch
   16398:	outs   dx,BYTE PTR ds:[rsi]
   16399:	add    BYTE PTR [rbp+0x0],ah
   1639c:	push   rbx
   1639d:	add    BYTE PTR [rax+rax*1+0x61],dh
   163a1:	add    BYTE PTR [rax+rax*1+0x65],dh
   163a5:	add    BYTE PTR [rax],al
   163a7:	add    ah,cl
   163a9:	int3
   163aa:	int3
   163ab:	int3
   163ac:	int3
   163ad:	int3
   163ae:	int3
   163af:	int3
   163b0:	push   rbp
   163b1:	add    BYTE PTR [rbx+0x0],dh
   163b4:	add    BYTE PTR gs:[rbx+0x0],al
   163b8:	outs   dx,DWORD PTR ds:[rsi]
   163b9:	add    BYTE PTR [rsi+0x0],ch
   163bc:	je     0x163be
   163be:	imul   eax,DWORD PTR [rax],0x75006e
   163c4:	outs   dx,DWORD PTR ds:[rsi]
   163c5:	add    BYTE PTR [rbp+0x0],dh
   163c8:	jae    0x163ca
   163ca:	push   rdx
   163cb:	add    BYTE PTR [rbp+0x0],ah
   163ce:	(bad)
   163cf:	add    BYTE PTR [rax+rax*1+0x0],ah
   163d3:	add    ah,cl
   163d5:	int3
   163d6:	int3
   163d7:	int3
   163d8:	int3
   163d9:	int3
   163da:	int3
   163db:	int3
   163dc:	int3
   163dd:	int3
   163de:	int3
   163df:	int3
   163e0:	push   rdx
   163e1:	add    BYTE PTR [rax+0x0],bh
   163e4:	rex.RX add BYTE PTR [rcx+0x0],r13b
   163e8:	data16 add BYTE PTR [rdi+0x0],ch
   163ec:	push   rbx
   163ed:	add    BYTE PTR [rcx+0x0],ch
   163f0:	jp     0x163f2
   163f2:	add    BYTE PTR gs:[rax],al
   163f5:	add    ah,cl
   163f7:	int3
   163f8:	int3
   163f9:	int3
   163fa:	int3
   163fb:	int3
   163fc:	int3
   163fd:	int3
   163fe:	int3
   163ff:	int3
   16400:	rex.X add BYTE PTR [rbp+0x0],sil
   16404:	ins    BYTE PTR es:[rdi],dx
   16405:	add    BYTE PTR [rbx+0x0],ch
   16408:	rex.WB add BYTE PTR [r14+0x0],bpl
   1640c:	rex.X add BYTE PTR [rbp+0x0],sil
   16410:	data16 add BYTE PTR [rbx+0x0],dl
   16414:	imul   eax,DWORD PTR [rax],0x65007a
   1641a:	add    BYTE PTR [rax],al
   1641c:	int3
   1641d:	int3
   1641e:	int3
   1641f:	int3
   16420:	push   rbp
   16421:	add    BYTE PTR [rbx+0x0],dh
   16424:	(bad)
   16425:	add    BYTE PTR [rbp+0x0],al
   16428:	outs   dx,BYTE PTR ds:[rsi]
   16429:	add    BYTE PTR [rcx+0x0],ah
   1642c:	(bad)
   1642d:	add    BYTE PTR [rax+rax*1+0x65],ch
   16431:	add    BYTE PTR [rdx+0x0],bl
   16434:	rex.WR add BYTE PTR [rax+0x0],r10b
   16438:	add    BYTE PTR [rax],al
   1643a:	int3
   1643b:	int3
   1643c:	int3
   1643d:	int3
   1643e:	int3
   1643f:	int3
   16440:	pop    rsp
   16441:	add    BYTE PTR [rax+rax*1+0x65],al
   16445:	add    BYTE PTR [rsi+0x0],dh
   16448:	imul   eax,DWORD PTR [rax],0x650063
   1644e:	pop    rsp
   1644f:	add    BYTE PTR [rbx+0x0],dh
   16452:	jo     0x16454
   16454:	jb     0x16456
   16456:	add    BYTE PTR fs:[rdi+0x0],bl
   1645a:	jne    0x1645c
   1645c:	jae    0x1645e
   1645e:	(bad)
   1645f:	add    BYTE PTR [rbx+0x0],ah
   16462:	outs   dx,DWORD PTR ds:[rsi]
   16463:	add    BYTE PTR [rbp+0x0],ch
   16466:	ins    DWORD PTR es:[rdi],dx
   16467:	add    BYTE PTR [rdi+0x0],bl
   1646a:	jae    0x1646c
   1646c:	add    BYTE PTR gs:[rdx+0x0],dh
   16470:	imul   eax,DWORD PTR [rax],0x6c0061
   16476:	add    BYTE PTR [rax],al
   16478:	int3
   16479:	int3
   1647a:	int3
   1647b:	int3
   1647c:	int3
   1647d:	int3
   1647e:	int3
   1647f:	int3
   16480:	and    eax,0x73007700
   16485:	add    BYTE PTR [rip+0x6400],ah        # 0x1c88b
   1648b:	add    ah,cl
   1648d:	int3
   1648e:	int3
   1648f:	int3
   16490:	rex.XB
   16491:	rex.WRXB
   16492:	rex.WRX
   16493:	rex.WRX
   16494:	rex.RB
   16495:	rex.XB push r12
	...

Disassembly of section INIT:

000000000001b000 <INIT>:
	...
   1b008:	mov    rax,QWORD PTR [rip+0xffffffffffffd0f1]        # 0x18100
   1b00f:	movabs rdx,0x2b992ddfa232
   1b019:	test   rax,rax
   1b01c:	je     0x1b023
   1b01e:	cmp    rax,rdx
   1b021:	jne    0x1b052
   1b023:	lea    rcx,[rip+0xffffffffffffd0d6]        # 0x18100
   1b02a:	movabs rax,0xfffff78000000320
   1b034:	mov    rax,QWORD PTR [rax]
   1b037:	xor    rax,rcx
   1b03a:	movabs rcx,0xffffffffffff
   1b044:	and    rax,rcx
   1b047:	cmove  rax,rdx
   1b04b:	mov    QWORD PTR [rip+0xffffffffffffd0ae],rax        # 0x18100
   1b052:	not    rax
   1b055:	mov    QWORD PTR [rip+0xffffffffffffd0ac],rax        # 0x18108
   1b05c:	ret
   1b05d:	int3
   1b05e:	int3
   1b05f:	int3
   1b060:	enter  0xb0,0x0
	...
   1b06c:	sbb    al,0xb2
   1b06e:	add    BYTE PTR [rax],al
   1b070:	sub    BYTE PTR [rax+0x0],dh
   1b073:	add    BYTE PTR [rax+0xb0],ah
   1b079:	add    BYTE PTR [rax],al
   1b07b:	add    BYTE PTR [rax],al
   1b07d:	add    BYTE PTR [rax],al
   1b07f:	add    BYTE PTR [rdx+0xb2],dh
   1b085:	jo     0x1b087
	...
   1b09f:	add    BYTE PTR [rdx+rsi*4+0x0],al
   1b0a6:	add    BYTE PTR [rax],al
   1b0a8:	jb     0x1b05c
   1b0aa:	add    BYTE PTR [rax],al
   1b0ac:	add    BYTE PTR [rax],al
   1b0ae:	add    BYTE PTR [rax],al
   1b0b0:	pop    rsi
   1b0b1:	mov    dl,0x0
   1b0b3:	add    BYTE PTR [rax],al
   1b0b5:	add    BYTE PTR [rax],al
   1b0b7:	add    BYTE PTR [rdx+0xb2],bl
	...
   1b0c5:	add    BYTE PTR [rax],al
   1b0c7:	add    BYTE PTR [rdx+0xb1],ah
   1b0cd:	add    BYTE PTR [rax],al
   1b0cf:	add    BYTE PTR [rdx+0xb1],bh
   1b0d5:	add    BYTE PTR [rax],al
   1b0d7:	add    dl,dl
   1b0d9:	mov    cl,0x0
   1b0db:	add    BYTE PTR [rax],al
   1b0dd:	add    BYTE PTR [rax],al
   1b0df:	add    ah,ch
   1b0e1:	mov    cl,0x0
   1b0e3:	add    BYTE PTR [rax],al
   1b0e5:	add    BYTE PTR [rax],al
   1b0e7:	add    BYTE PTR [rsi+0xb1],cl
   1b0ed:	add    BYTE PTR [rax],al
   1b0ef:	add    BYTE PTR [rdx+rsi*4],cl
   1b0f2:	add    BYTE PTR [rax],al
   1b0f4:	add    BYTE PTR [rax],al
   1b0f6:	add    BYTE PTR [rax],al
   1b0f8:	sub    dh,BYTE PTR [rdx+0x0]
   1b0fe:	add    BYTE PTR [rax],al
   1b100:	rex.X mov dl,0x0
   1b103:	add    BYTE PTR [rax],al
   1b105:	add    BYTE PTR [rax],al
   1b107:	add    BYTE PTR [rax+0xb1],al
   1b10d:	add    BYTE PTR [rax],al
   1b10f:	add    BYTE PTR [rax-0x4f],ch
   1b112:	add    BYTE PTR [rax],al
   1b114:	add    BYTE PTR [rax],al
   1b116:	add    BYTE PTR [rax],al
   1b118:	rex.W mov cl,0x0
   1b11b:	add    BYTE PTR [rax],al
   1b11d:	add    BYTE PTR [rax],al
   1b11f:	add    dh,dh
   1b121:	mov    cl,0x0
   1b123:	add    BYTE PTR [rax],al
   1b125:	add    BYTE PTR [rax],al
   1b127:	add    BYTE PTR [rax],bh
   1b129:	mov    cl,0x0
	...
   1b137:	add    ch,cl
   1b139:	add    cl,BYTE PTR [rbx+0x65]
   1b13c:	rex.XB ins BYTE PTR es:[rdi],dx
   1b13e:	gs (bad)
   1b140:	jb     0x1b187
   1b142:	jbe    0x1b1a9
   1b144:	outs   dx,BYTE PTR ds:[rsi]
   1b145:	je     0x1b147
   1b147:	add    BYTE PTR [rdx],al
   1b149:	add    cl,BYTE PTR [rcx+0x6f]
   1b14c:	rex.RXB
   1b14d:	gs je  0x1b193
   1b150:	outs   dx,DWORD PTR ds:[rsi]
   1b151:	outs   dx,BYTE PTR ds:[rsi]
   1b152:	imul   sp,WORD PTR [rdi+0x75],0x6172
   1b158:	je     0x1b1c3
   1b15a:	outs   dx,DWORD PTR ds:[rsi]
   1b15b:	outs   dx,BYTE PTR ds:[rsi]
   1b15c:	rex.WB outs dx,BYTE PTR ds:[rsi]
   1b15e:	outs   dx,WORD PTR ds:[rsi]
   1b160:	jb     0x1b1cf
   1b162:	(bad)
   1b163:	je     0x1b1ce
   1b165:	outs   dx,DWORD PTR ds:[rsi]
   1b166:	outs   dx,BYTE PTR ds:[rsi]
   1b167:	add    BYTE PTR [rdx+0x6c745205],bh
   1b16d:	rex.WB outs dx,BYTE PTR ds:[rsi]
   1b16f:	imul   esi,DWORD PTR [rbp+rdx*2+0x6e],0x646f6369
   1b177:	gs push rbx
   1b179:	je     0x1b1ed
   1b17b:	imul   ebp,DWORD PTR [rsi+0x67],0x3650000
   1b182:	rex.WXB
   1b183:	gs push rbx
   1b185:	gs je  0x1b1cd
   1b188:	jbe    0x1b1ef
   1b18a:	outs   dx,BYTE PTR ds:[rsi]
   1b18b:	je     0x1b18d
   1b18d:	add    bh,dh
   1b18f:	add    cl,BYTE PTR [rbx+0x65]
   1b192:	rex.WB outs dx,BYTE PTR ds:[rsi]
   1b194:	imul   esi,DWORD PTR [rcx+rbp*2+0x61],0x657a696c
   1b19c:	rex.RB jbe 0x1b204
   1b19f:	outs   dx,BYTE PTR ds:[rsi]
   1b1a0:	je     0x1b1a2
   1b1a2:	xchg   DWORD PTR [rbx],eax
   1b1a4:	rex.WXB
   1b1a5:	gs push rdi
   1b1a7:	(bad)
   1b1a8:	imul   esi,DWORD PTR [rsi+rax*2+0x6f],0x6e695372
   1b1b0:	ins    BYTE PTR es:[edi],dx
   1b1b2:	gs rex.WRXB (bad)
   1b1b5:	push   0x65
   1b1b7:	movsxd esi,DWORD PTR [rax+rax*1+0x6b]
   1b1bb:	(bad)
   1b1bc:	push   rdx
   1b1bd:	je     0x1b22b
   1b1bf:	push   rdi
   1b1c0:	jb     0x1b22b
   1b1c2:	je     0x1b229
   1b1c4:	push   rdx
   1b1c5:	imul   esi,DWORD PTR gs:[ebx+0x74],0x61567972
   1b1ce:	ins    BYTE PTR es:[rdi],dx
   1b1cf:	jne    0x1b236
   1b1d1:	add    BYTE PTR [rdi+0x5],ah
   1b1d4:	push   rdx
   1b1d5:	je     0x1b243
   1b1d7:	rex.R
   1b1d8:	gs ins BYTE PTR es:[rdi],dx
   1b1da:	gs je  0x1b242
   1b1dd:	push   rdx
   1b1de:	imul   esi,DWORD PTR gs:[ebx+0x74],0x61567972
   1b1e7:	ins    BYTE PTR es:[rdi],dx
   1b1e8:	jne    0x1b24f
   1b1ea:	add    BYTE PTR [rax],al
   1b1ec:	(bad)
   1b1ed:	or     BYTE PTR [rbx+0x74],dh
   1b1f0:	jb     0x1b260
   1b1f2:	movsxd ebp,DWORD PTR [rbp+0x70]
   1b1f5:	add    BYTE PTR [rbx+0x666f4902],ah
   1b1fb:	rex.XB outs dx,DWORD PTR ds:[rsi]
   1b1fd:	ins    DWORD PTR es:[rdi],dx
   1b1fe:	jo     0x1b26c
   1b200:	gs je  0x1b268
   1b203:	push   rdx
   1b204:	gs jno 0x1b27c
   1b207:	gs jae 0x1b27e
   1b20a:	add    BYTE PTR [rax],al
   1b20c:	enter  0x4b02,0x65
   1b210:	rex.X jne 0x1b27a
   1b213:	rex.XB push 0x456b6365
   1b219:	js     0x1b21b
   1b21b:	add    BYTE PTR [rsi+0x74],ch
   1b21e:	outs   dx,DWORD PTR ds:[rsi]
   1b21f:	jae    0x1b28c
   1b221:	jb     0x1b291
   1b223:	ins    BYTE PTR es:[rdi],dx
   1b224:	cs gs js 0x1b28d
   1b228:	add    BYTE PTR [rax],al
   1b22a:	push   rcx
   1b22b:	add    eax,0x436c7452
   1b230:	outs   dx,DWORD PTR ds:[rsi]
   1b231:	jo     0x1b2ac
   1b233:	push   rbp
   1b234:	outs   dx,BYTE PTR ds:[rsi]
   1b235:	imul   esp,DWORD PTR [rbx+0x6f],0x74536564
   1b23c:	jb     0x1b2a7
   1b23e:	outs   dx,BYTE PTR ds:[rsi]
   1b23f:	add    BYTE PTR [eax],al
   1b242:	sub    DWORD PTR [rip+0x416c7452],eax        # 0x416e269a
   1b248:	outs   dx,BYTE PTR ds:[rsi]
   1b249:	jae    0x1b2b4
   1b24b:	rex.XB push 0x6f547261
   1b251:	push   rbp
   1b252:	outs   dx,BYTE PTR ds:[rsi]
   1b253:	imul   esp,DWORD PTR [rbx+0x6f],0x68436564
   1b25a:	(bad)
   1b25b:	jb     0x1b25d
   1b25d:	add    BYTE PTR [rax],cl
   1b25f:	add    BYTE PTR [rdi+0x64],dl
   1b262:	push   si
   1b264:	gs jb  0x1b2da
   1b267:	imul   ebp,DWORD PTR [rdi+0x6e],0x69626e55
   1b26e:	outs   dx,BYTE PTR ds:[rsi]
   1b26f:	add    BYTE PTR fs:[rax],al
   1b272:	(bad)
   1b273:	add    BYTE PTR [rdi+0x64],dl
   1b276:	push   si
   1b278:	gs jb  0x1b2ee
   1b27b:	imul   ebp,DWORD PTR [rdi+0x6e],0x646e6942
   1b282:	add    BYTE PTR [rax],al
   1b284:	(bad)
   1b285:	add    BYTE PTR [rdi+0x64],dl
   1b288:	push   si
   1b28a:	gs jb  0x1b300
   1b28d:	imul   ebp,DWORD PTR [rdi+0x6e],0x646e6942
   1b294:	rex.XB ins BYTE PTR es:[rdi],dx
   1b296:	(bad)
   1b297:	jae    0x1b30c
   1b299:	add    BYTE PTR [rcx],cl
   1b29b:	add    BYTE PTR [rdi+0x64],dl
   1b29e:	push   si
   1b2a0:	gs jb  0x1b316
   1b2a3:	imul   ebp,DWORD PTR [rdi+0x6e],0x69626e55
   1b2aa:	outs   dx,BYTE PTR ds:[rsi]
   1b2ab:	fs rex.XB ins BYTE PTR es:[rdi],dx
   1b2ae:	(bad)
   1b2af:	jae    0x1b324
   1b2b1:	add    BYTE PTR [rdi+0x44],dl
   1b2b4:	rex.RX
   1b2b5:	rex.WR
   1b2b6:	rex.R push rdx
   1b2b8:	cs push rbx
   1b2ba:	pop    rcx
   1b2bb:	push   rbx
	...
