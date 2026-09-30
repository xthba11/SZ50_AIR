; Static disassembly: Drivers/amd64/sprdvmdm.sys
; Addresses are as reported by objdump. No original symbols or C source are implied.

Drivers/amd64/sprdvmdm.sys:     file format pei-x86-64


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
   11023:	call   0x15160
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
   111b2:	call   0x14fc8
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
   111e2:	call   0x14f18
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
   11238:	call   0x15160
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
   11273:	lea    rax,[rip+0x2802]        # 0x13a7c
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
   112a8:	call   0x15160
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
   11301:	lea    rax,[rip+0x2b4c]        # 0x13e54
   11308:	xor    edx,edx
   1130a:	mov    DWORD PTR [rsp+0x40],ebx
   1130e:	mov    QWORD PTR [rsp+0x48],rax
   11313:	mov    BYTE PTR [rsp+0x50],bpl
   11318:	call   0x15160
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
   1136d:	lea    rax,[rip+0x1cc0]        # 0x13034
   11374:	xor    edx,edx
   11376:	mov    DWORD PTR [rsp+0x40],ebx
   1137a:	mov    QWORD PTR [rsp+0x48],rax
   1137f:	mov    BYTE PTR [rsp+0x50],bpl
   11384:	call   0x15160
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
   113d6:	call   0x15160
   113db:	and    DWORD PTR [rsp+0x108],0x0
   113e3:	lea    rax,[rip+0x1a06]        # 0x12df0
   113ea:	lea    rcx,[rsp+0x110]
   113f2:	mov    r8,r13
   113f5:	xor    edx,edx
   113f7:	mov    QWORD PTR [rsp+0xf8],rax
   113ff:	mov    DWORD PTR [rsp+0xf0],ebx
   11406:	mov    BYTE PTR [rsp+0x104],bpl
   1140e:	mov    DWORD PTR [rsp+0x100],0x64
   11419:	call   0x15160
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
   11475:	call   0x15160
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
   114f8:	call   0x15160
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
   11560:	call   0x15160
   11565:	mov    rcx,QWORD PTR [rip+0x793c]        # 0x18ea8
   1156c:	lea    rax,[rip+0x24cd]        # 0x13a40
   11573:	mov    QWORD PTR [rsp+0xd0],rax
   1157b:	lea    rax,[rip+0x23de]        # 0x13960
   11582:	lea    r15,[rip+0x23f7]        # 0x13980
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
   115eb:	call   0x15160
   115f0:	mov    rcx,QWORD PTR [rip+0x78b1]        # 0x18ea8
   115f7:	lea    rax,[rip+0x2442]        # 0x13a40
   115fe:	mov    QWORD PTR [rsp+0xd0],rax
   11606:	lea    rax,[rip+0x2353]        # 0x13960
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
   1166f:	call   0x15160
   11674:	mov    rcx,QWORD PTR [rip+0x782d]        # 0x18ea8
   1167b:	or     DWORD PTR [rsp+0xe0],0xffffffff
   11683:	lea    rax,[rip+0x21be]        # 0x13848
   1168a:	lea    r8,[rsp+0x90]
   11692:	xor    r9d,r9d
   11695:	mov    QWORD PTR [rsp+0xa8],rax
   1169d:	lea    rax,[rip+0x2224]        # 0x138c8
   116a4:	mov    rdx,rsi
   116a7:	mov    QWORD PTR [rsp+0xb0],rax
   116af:	lea    rax,[rip+0x238a]        # 0x13a40
   116b6:	mov    DWORD PTR [rsp+0x90],ebx
   116bd:	mov    QWORD PTR [rsp+0xd0],rax
   116c5:	lea    rax,[rip+0x19cc]        # 0x13098
   116cc:	mov    DWORD PTR [rsp+0x98],0x2
   116d7:	mov    QWORD PTR [rsp+0xb8],rax
   116df:	lea    rax,[rip+0x227a]        # 0x13960
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
   11734:	call   0x15160
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
   1183a:	call   0x15160
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
   1186f:	call   0x15160
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
   1193d:	lea    rdx,[rip+0x47fc]        # 0x16140
   11944:	lea    rcx,[rsp+0x60]
   11949:	call   QWORD PTR [rip+0x5719]        # 0x17068
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
   1199c:	lea    r8,[rip+0x47bd]        # 0x16160
   119a3:	lea    rdx,[rip+0x47d6]        # 0x16180
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
   119f1:	lea    rdx,[rip+0x4798]        # 0x16190
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
   11a33:	lea    r8,[rip+0x5756]        # 0x17190
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
   11a61:	call   0x14b80
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
   11aa6:	call   0x15160
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
   11ae6:	call   0x12f80
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
   11b1f:	call   0x12f80
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
   11b48:	call   0x12f80
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
   11c04:	lea    rdx,[rip+0x45a5]        # 0x161b0
   11c0b:	mov    r8,rdi
   11c0e:	call   0x15e00
   11c13:	lea    r11d,[r12+0x32]
   11c18:	lea    rax,[rsp+0x180]
   11c20:	lea    ebp,[rdi-0x10]
   11c23:	lea    rcx,[rsp+0x108]
   11c2b:	lea    rdx,[rip+0x45be]        # 0x161f0
   11c32:	mov    r8,rbp
   11c35:	mov    WORD PTR [rsp+0x80],r11w
   11c3e:	mov    WORD PTR [rsp+0x82],di
   11c46:	mov    QWORD PTR [rsp+0x88],rax
   11c4e:	call   0x15e00
   11c53:	lea    esi,[rdi-0x12]
   11c56:	lea    rax,[rsp+0x108]
   11c5e:	lea    edi,[rbp+0x4]
   11c61:	lea    rcx,[rsp+0x158]
   11c69:	lea    rdx,[rip+0x45b0]        # 0x16220
   11c70:	mov    r8,rdi
   11c73:	mov    WORD PTR [rsp+0x90],si
   11c7b:	mov    WORD PTR [rsp+0x92],bp
   11c83:	mov    QWORD PTR [rsp+0x98],rax
   11c8b:	call   0x15e00
   11c90:	lea    r11d,[r12+0x26]
   11c95:	lea    rax,[rsp+0x158]
   11c9d:	lea    rcx,[rsp+0x130]
   11ca5:	lea    rdx,[rip+0x45a4]        # 0x16250
   11cac:	mov    r8,rbp
   11caf:	mov    WORD PTR [rsp+0x72],di
   11cb4:	mov    WORD PTR [rsp+0x70],r11w
   11cba:	mov    QWORD PTR [rsp+0x78],rax
   11cbf:	call   0x15e00
   11cc4:	lea    r8,[rip+0xffffffffffffe335]        # 0x10000
   11ccb:	lea    rcx,[rsp+0xb0]
   11cd3:	lea    rax,[rsp+0x130]
   11cdb:	mov    QWORD PTR [rsp+0x58],rax
   11ce0:	mov    rax,QWORD PTR [r8+0x6280]
   11ce7:	lea    edx,[rbp-0xa]
   11cea:	mov    QWORD PTR [rcx],rax
   11ced:	mov    rax,QWORD PTR [r8+0x6288]
   11cf4:	mov    WORD PTR [rsp+0x50],si
   11cf9:	mov    QWORD PTR [rcx+0x8],rax
   11cfd:	mov    eax,DWORD PTR [r8+0x6290]
   11d04:	mov    WORD PTR [rsp+0x52],bp
   11d09:	mov    DWORD PTR [rcx+0x10],eax
   11d0c:	movzx  eax,WORD PTR [r8+0x6294]
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
   11d4a:	mov    rax,QWORD PTR [r8+0x62a0]
   11d51:	mov    QWORD PTR [rcx],rax
   11d54:	mov    rax,QWORD PTR [r8+0x62a8]
   11d5b:	mov    QWORD PTR [rcx+0x8],rax
   11d5f:	mov    rax,QWORD PTR [r8+0x62b0]
   11d66:	mov    QWORD PTR [rcx+0x10],rax
   11d6a:	mov    eax,DWORD PTR [r8+0x62b8]
   11d71:	mov    DWORD PTR [rcx+0x18],eax
   11d74:	lea    rcx,[rsp+0xc8]
   11d7c:	lea    eax,[rbp-0x8]
   11d7f:	mov    WORD PTR [rsp+0xa2],ax
   11d87:	lea    rax,[rsp+0xe8]
   11d8f:	mov    QWORD PTR [rsp+0xa8],rax
   11d97:	mov    rax,QWORD PTR [r8+0x62c0]
   11d9e:	mov    QWORD PTR [rcx],rax
   11da1:	mov    rax,QWORD PTR [r8+0x62c8]
   11da8:	mov    QWORD PTR [rcx+0x8],rax
   11dac:	mov    rax,QWORD PTR [r8+0x62d0]
   11db3:	mov    QWORD PTR [rcx+0x10],rax
   11db7:	movzx  eax,WORD PTR [r8+0x62d8]
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
   11fb9:	call   0x14b80
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
   11fea:	sub    rsp,0x2b0
   11ff1:	mov    rax,QWORD PTR [rip+0x6108]        # 0x18100
   11ff8:	xor    rax,rsp
   11ffb:	mov    QWORD PTR [rsp+0x2a0],rax
   12003:	xor    ebp,ebp
   12005:	mov    eax,0x100
   1200a:	mov    QWORD PTR [rsp+0x20],rdx
   1200f:	mov    WORD PTR [rsp+0x32],ax
   12014:	lea    rax,[rsp+0x1a0]
   1201c:	lea    esi,[rbp+0x1]
   1201f:	mov    QWORD PTR [rsp+0x28],rbp
   12024:	mov    WORD PTR [rsp+0x30],bp
   12029:	mov    QWORD PTR [rsp+0x38],rax
   1202e:	mov    r9d,esi
   12031:	lock xadd DWORD PTR [rip+0x709e],r9d        # 0x190d8
   1203a:	lea    r8,[rip+0x429f]        # 0x162e0
   12041:	lea    rdx,[rip+0x42d8]        # 0x16320
   12048:	lea    rcx,[rsp+0x30]
   1204d:	add    r9d,esi
   12050:	call   0x11184
   12055:	cmp    eax,ebp
   12057:	jne    0x12388
   1205d:	mov    rdx,QWORD PTR [rsp+0x20]
   12062:	mov    rcx,QWORD PTR [rip+0x6e3f]        # 0x18ea8
   12069:	lea    r8,[rsp+0x30]
   1206e:	call   QWORD PTR [rip+0x63c4]        # 0x18438
   12074:	cmp    eax,ebp
   12076:	jne    0x12388
   1207c:	mov    rdx,QWORD PTR [rsp+0x20]
   12081:	mov    rcx,QWORD PTR [rip+0x6e20]        # 0x18ea8
   12088:	lea    r8d,[rbp+0x2b]
   1208c:	call   QWORD PTR [rip+0x639e]        # 0x18430
   12092:	mov    ebx,0x88
   12097:	lea    rcx,[rsp+0x110]
   1209f:	mov    r8,rbx
   120a2:	xor    edx,edx
   120a4:	call   0x15160
   120a9:	mov    rdx,QWORD PTR [rsp+0x20]
   120ae:	mov    rcx,QWORD PTR [rip+0x6df3]        # 0x18ea8
   120b5:	lea    rax,[rip+0x2fc]        # 0x123b8
   120bc:	lea    r8,[rsp+0x110]
   120c4:	mov    DWORD PTR [rsp+0x110],ebx
   120cb:	mov    QWORD PTR [rsp+0x118],rax
   120d3:	lea    rax,[rip+0x35a]        # 0x12434
   120da:	mov    QWORD PTR [rsp+0x128],rax
   120e2:	lea    rax,[rip+0x3e7]        # 0x124d0
   120e9:	mov    QWORD PTR [rsp+0x138],rax
   120f1:	lea    rax,[rip+0x86c]        # 0x12964
   120f8:	mov    QWORD PTR [rsp+0x140],rax
   12100:	lea    rax,[rip+0x3a9]        # 0x124b0
   12107:	mov    QWORD PTR [rsp+0x150],rax
   1210f:	lea    rax,[rip+0x39a]        # 0x124b0
   12116:	mov    QWORD PTR [rsp+0x170],rax
   1211e:	call   QWORD PTR [rip+0x62b4]        # 0x183d8
   12124:	lea    r12d,[rbp+0x38]
   12128:	lea    rcx,[rsp+0x40]
   1212d:	mov    r8,r12
   12130:	xor    edx,edx
   12132:	call   0x15160
   12137:	mov    rax,QWORD PTR [rip+0x6042]        # 0x18180
   1213e:	mov    rdx,QWORD PTR [rsp+0x20]
   12143:	mov    rcx,QWORD PTR [rip+0x6d5e]        # 0x18ea8
   1214a:	lea    r8,[rsp+0x40]
   1214f:	mov    QWORD PTR [rsp+0x70],rax
   12154:	mov    DWORD PTR [rsp+0x40],r12d
   12159:	mov    DWORD PTR [rsp+0x58],esi
   1215d:	mov    DWORD PTR [rsp+0x5c],esi
   12161:	call   QWORD PTR [rip+0x62f9]        # 0x18460
   12167:	lea    rax,[rip+0x97e]        # 0x12aec
   1216e:	lea    ebx,[rbp+0x4]
   12171:	mov    QWORD PTR [rsp+0xb0],rax
   12179:	lea    rax,[rip+0xafc]        # 0x12c7c
   12180:	lea    edi,[rbp+0x2]
   12183:	mov    QWORD PTR [rsp+0xb8],rax
   1218b:	lea    rax,[rip+0xc16]        # 0x12da8
   12192:	lea    rcx,[rsp+0x40]
   12197:	mov    r8,r12
   1219a:	xor    edx,edx
   1219c:	mov    DWORD PTR [rsp+0xa8],0x28
   121a7:	mov    QWORD PTR [rsp+0xc0],rax
   121af:	mov    DWORD PTR [rsp+0xcc],ebx
   121b6:	mov    DWORD PTR [rsp+0xc8],edi
   121bd:	call   0x15160
   121c2:	mov    rdx,QWORD PTR [rsp+0x20]
   121c7:	mov    rcx,QWORD PTR [rip+0x6cda]        # 0x18ea8
   121ce:	lea    r9,[rsp+0x40]
   121d3:	lea    r8,[rsp+0xa8]
   121db:	mov    DWORD PTR [rsp+0x40],r12d
   121e0:	mov    DWORD PTR [rsp+0x58],esi
   121e4:	mov    DWORD PTR [rsp+0x5c],ebx
   121e8:	call   QWORD PTR [rip+0x626a]        # 0x18458
   121ee:	mov    rdx,QWORD PTR [rsp+0x20]
   121f3:	mov    rcx,QWORD PTR [rip+0x6cae]        # 0x18ea8
   121fa:	mov    r8b,sil
   121fd:	call   QWORD PTR [rip+0x620d]        # 0x18410
   12203:	mov    rdx,QWORD PTR [rsp+0x20]
   12208:	mov    rcx,QWORD PTR [rip+0x6c99]        # 0x18ea8
   1220f:	mov    r8d,edi
   12212:	call   QWORD PTR [rip+0x61f0]        # 0x18408
   12218:	lea    rcx,[rsp+0xd0]
   12220:	mov    r8,r12
   12223:	xor    edx,edx
   12225:	call   0x15160
   1222a:	mov    rax,QWORD PTR [rip+0x5f9f]        # 0x181d0
   12231:	mov    DWORD PTR [rsp+0xd0],r12d
   12239:	mov    QWORD PTR [rsp+0x100],rax
   12241:	lea    rax,[rip+0xcc8]        # 0x12f10
   12248:	mov    DWORD PTR [rsp+0xe8],esi
   1224f:	mov    QWORD PTR [rsp+0xd8],rax
   12257:	mov    rcx,QWORD PTR [rip+0x6c4a]        # 0x18ea8
   1225e:	lea    r9,[rsp+0x28]
   12263:	lea    r8,[rsp+0xd0]
   1226b:	lea    rdx,[rsp+0x20]
   12270:	mov    DWORD PTR [rsp+0xec],edi
   12277:	call   QWORD PTR [rip+0x61fb]        # 0x18478
   1227d:	cmp    eax,ebp
   1227f:	jl     0x12388
   12285:	lea    ebx,[rbp+0x30]
   12288:	lea    rcx,[rsp+0x78]
   1228d:	xor    edx,edx
   1228f:	mov    r8,rbx
   12292:	call   0x15160
   12297:	mov    rdx,QWORD PTR [rsp+0x28]
   1229c:	mov    rcx,QWORD PTR [rip+0x6c05]        # 0x18ea8
   122a3:	or     eax,0xffffffff
   122a6:	lea    r8,[rsp+0x78]
   122ab:	mov    DWORD PTR [rsp+0x78],ebx
   122af:	mov    DWORD PTR [rsp+0x7c],edi
   122b3:	mov    DWORD PTR [rsp+0x80],edi
   122ba:	mov    DWORD PTR [rsp+0x88],edi
   122c1:	mov    DWORD PTR [rsp+0x8c],edi
   122c8:	mov    DWORD PTR [rsp+0x90],edi
   122cf:	mov    DWORD PTR [rsp+0x98],edi
   122d6:	mov    DWORD PTR [rsp+0x9c],edi
   122dd:	mov    DWORD PTR [rsp+0xa0],eax
   122e4:	mov    DWORD PTR [rsp+0xa4],eax
   122eb:	mov    DWORD PTR [rsp+0x84],esi
   122f2:	mov    DWORD PTR [rsp+0x94],esi
   122f9:	call   QWORD PTR [rip+0x61b9]        # 0x184b8
   122ff:	mov    r8,QWORD PTR [rip+0x5eca]        # 0x181d0
   12306:	mov    rdx,QWORD PTR [rsp+0x28]
   1230b:	mov    rcx,QWORD PTR [rip+0x6b96]        # 0x18ea8
   12312:	call   QWORD PTR [rip+0x6558]        # 0x18870
   12318:	mov    rcx,rax
   1231b:	mov    rbx,rax
   1231e:	call   0x11204
   12323:	cmp    eax,ebp
   12325:	jl     0x12388
   12327:	mov    rcx,rbx
   1232a:	call   0x117f4
   1232f:	cmp    eax,ebp
   12331:	jne    0x12388
   12333:	lea    rcx,[rsp+0x40]
   12338:	mov    r8,r12
   1233b:	xor    edx,edx
   1233d:	call   0x15160
   12342:	mov    rcx,QWORD PTR [rip+0x6b5f]        # 0x18ea8
   12349:	mov    DWORD PTR [rsp+0x40],r12d
   1234e:	mov    DWORD PTR [rsp+0x58],esi
   12352:	mov    DWORD PTR [rsp+0x5c],esi
   12356:	mov    rax,QWORD PTR [rbx]
   12359:	lea    r8,[rbx+0x118]
   12360:	lea    rdx,[rsp+0x40]
   12365:	mov    QWORD PTR [rsp+0x60],rax
   1236a:	call   QWORD PTR [rip+0x6888]        # 0x18bf8
   12370:	cmp    eax,ebp
   12372:	mov    edi,eax
   12374:	jl     0x12388
   12376:	call   QWORD PTR [rip+0x4cf4]        # 0x17070
   1237c:	add    DWORD PTR [rax+0x14],esi
   1237f:	mov    BYTE PTR [rbx+0xcb],sil
   12386:	mov    eax,edi
   12388:	mov    rcx,QWORD PTR [rsp+0x2a0]
   12390:	xor    rcx,rsp
   12393:	call   0x14b80
   12398:	lea    r11,[rsp+0x2b0]
   123a0:	mov    rbx,QWORD PTR [r11+0x20]
   123a4:	mov    rbp,QWORD PTR [r11+0x30]
   123a8:	mov    rsp,r11
   123ab:	pop    r12
   123ad:	pop    rdi
   123ae:	pop    rsi
   123af:	ret
   123b0:	int3
   123b1:	int3
   123b2:	int3
   123b3:	int3
   123b4:	int3
   123b5:	int3
   123b6:	int3
   123b7:	int3
   123b8:	mov    QWORD PTR [rsp+0x8],rbx
   123bd:	push   rdi
   123be:	sub    rsp,0x20
   123c2:	mov    r8,QWORD PTR [rip+0x5e07]        # 0x181d0
   123c9:	mov    rdx,rcx
   123cc:	mov    rcx,QWORD PTR [rip+0x6ad5]        # 0x18ea8
   123d3:	xor    edi,edi
   123d5:	call   QWORD PTR [rip+0x6495]        # 0x18870
   123db:	mov    rbx,rax
   123de:	cmp    DWORD PTR [rax+0xd8],edi
   123e4:	je     0x1241e
   123e6:	mov    rax,QWORD PTR [rax+0x1e8]
   123ed:	test   rax,rax
   123f0:	je     0x123f9
   123f2:	mov    rcx,rbx
   123f5:	call   rax
   123f7:	mov    edi,eax
   123f9:	mov    ecx,0x1
   123fe:	xchg   DWORD PTR [rbx+0xdc],ecx
   12404:	test   ecx,ecx
   12406:	jne    0x1241e
   12408:	mov    rdx,QWORD PTR [rbx+0x88]
   1240f:	mov    rcx,QWORD PTR [rip+0x6a92]        # 0x18ea8
   12416:	call   QWORD PTR [rip+0x635c]        # 0x18778
   1241c:	mov    edi,eax
   1241e:	mov    eax,edi
   12420:	mov    rbx,QWORD PTR [rsp+0x30]
   12425:	add    rsp,0x20
   12429:	pop    rdi
   1242a:	ret
   1242b:	int3
   1242c:	int3
   1242d:	int3
   1242e:	int3
   1242f:	int3
   12430:	int3
   12431:	int3
   12432:	int3
   12433:	int3
   12434:	mov    QWORD PTR [rsp+0x8],rbx
   12439:	push   rdi
   1243a:	sub    rsp,0x20
   1243e:	mov    r8,QWORD PTR [rip+0x5d8b]        # 0x181d0
   12445:	mov    rdx,rcx
   12448:	mov    rcx,QWORD PTR [rip+0x6a59]        # 0x18ea8
   1244f:	xor    ebx,ebx
   12451:	call   QWORD PTR [rip+0x6419]        # 0x18870
   12457:	mov    rdi,rax
   1245a:	cmp    DWORD PTR [rax+0xd8],ebx
   12460:	je     0x1249a
   12462:	mov    eax,ebx
   12464:	lea    r8d,[rbx+0x1]
   12468:	xchg   DWORD PTR [rdi+0xdc],eax
   1246e:	cmp    eax,r8d
   12471:	jne    0x12487
   12473:	mov    rdx,QWORD PTR [rdi+0x88]
   1247a:	mov    rcx,QWORD PTR [rip+0x6a27]        # 0x18ea8
   12481:	call   QWORD PTR [rip+0x62f9]        # 0x18780
   12487:	mov    rax,QWORD PTR [rdi+0x1f0]
   1248e:	cmp    rax,rbx
   12491:	je     0x1249a
   12493:	mov    rcx,rdi
   12496:	call   rax
   12498:	mov    ebx,eax
   1249a:	mov    eax,ebx
   1249c:	mov    rbx,QWORD PTR [rsp+0x30]
   124a1:	add    rsp,0x20
   124a5:	pop    rdi
   124a6:	ret
   124a7:	int3
   124a8:	int3
   124a9:	int3
   124aa:	int3
   124ab:	int3
   124ac:	int3
   124ad:	int3
   124ae:	int3
   124af:	int3
   124b0:	mov    r8,QWORD PTR [rip+0x5d19]        # 0x181d0
   124b7:	mov    rdx,rcx
   124ba:	mov    rcx,QWORD PTR [rip+0x69e7]        # 0x18ea8
   124c1:	rex.W jmp QWORD PTR [rip+0x63a8]        # 0x18870
   124c8:	int3
   124c9:	int3
   124ca:	int3
   124cb:	int3
   124cc:	int3
   124cd:	int3
   124ce:	int3
   124cf:	int3
   124d0:	mov    QWORD PTR [rsp+0x8],rbx
   124d5:	mov    QWORD PTR [rsp+0x10],rbp
   124da:	push   rsi
   124db:	push   rdi
   124dc:	push   r12
   124de:	push   r13
   124e0:	push   r15
   124e2:	sub    rsp,0x130
   124e9:	mov    r8,QWORD PTR [rip+0x5ce0]        # 0x181d0
   124f0:	mov    rdx,rcx
   124f3:	mov    rcx,QWORD PTR [rip+0x69ae]        # 0x18ea8
   124fa:	call   QWORD PTR [rip+0x6370]        # 0x18870
   12500:	xor    r15d,r15d
   12503:	lea    rbx,[rax+0x58]
   12507:	mov    WORD PTR [rsp+0x178],r15w
   12510:	mov    rdi,rax
   12513:	cmp    QWORD PTR [rbx],r15
   12516:	jne    0x12537
   12518:	mov    rdx,QWORD PTR [rax]
   1251b:	mov    rcx,QWORD PTR [rip+0x6986]        # 0x18ea8
   12522:	mov    r9,rbx
   12525:	xor    r8d,r8d
   12528:	call   QWORD PTR [rip+0x6702]        # 0x18c30
   1252e:	cmp    eax,r15d
   12531:	jne    0x12942
   12537:	mov    rdx,QWORD PTR [rbx]
   1253a:	mov    rcx,QWORD PTR [rip+0x6967]        # 0x18ea8
   12541:	lea    r8,[rdi+0x90]
   12548:	call   QWORD PTR [rip+0x66f2]        # 0x18c40
   1254e:	mov    rdx,QWORD PTR [rbx]
   12551:	mov    rcx,QWORD PTR [rip+0x6950]        # 0x18ea8
   12558:	lea    r9,[rsp+0x178]
   12560:	xor    r8d,r8d
   12563:	call   QWORD PTR [rip+0x66df]        # 0x18c48
   12569:	cmp    eax,0xc0000023
   1256e:	jne    0x12942
   12574:	movzx  esi,WORD PTR [rsp+0x178]
   1257c:	cmp    si,r15w
   12580:	je     0x12942
   12586:	mov    ebp,0x38
   1258b:	lea    rcx,[rsp+0xa8]
   12593:	xor    edx,edx
   12595:	mov    r8,rbp
   12598:	call   0x15160
   1259d:	mov    DWORD PTR [rsp+0xa8],ebp
   125a4:	mov    ebp,0x1
   125a9:	mov    DWORD PTR [rsp+0xc0],ebp
   125b0:	mov    DWORD PTR [rsp+0xc4],ebp
   125b7:	mov    rax,QWORD PTR [rdi]
   125ba:	mov    QWORD PTR [rsp+0xc8],rax
   125c2:	movzx  eax,si
   125c5:	lea    rcx,[rsp+0xa0]
   125cd:	lea    rsi,[rdi+0x70]
   125d1:	lea    rdx,[rsp+0xa8]
   125d9:	mov    r9d,0x6d6f6355
   125df:	mov    QWORD PTR [rsp+0x30],rsi
   125e4:	mov    QWORD PTR [rsp+0x28],rcx
   125e9:	mov    rcx,QWORD PTR [rip+0x68b8]        # 0x18ea8
   125f0:	xor    r8d,r8d
   125f3:	mov    QWORD PTR [rsp+0x20],rax
   125f8:	call   QWORD PTR [rip+0x6222]        # 0x18820
   125fe:	cmp    eax,r15d
   12601:	jne    0x12942
   12607:	mov    r8,QWORD PTR [rsi]
   1260a:	mov    rdx,QWORD PTR [rbx]
   1260d:	mov    rcx,QWORD PTR [rip+0x6894]        # 0x18ea8
   12614:	lea    r9,[rsp+0x178]
   1261c:	call   QWORD PTR [rip+0x6626]        # 0x18c48
   12622:	cmp    eax,r15d
   12625:	jne    0x12942
   1262b:	mov    rdx,QWORD PTR [rbx]
   1262e:	mov    rcx,QWORD PTR [rip+0x6873]        # 0x18ea8
   12635:	call   QWORD PTR [rip+0x662d]        # 0x18c68
   1263b:	lea    esi,[rbp+0x1f]
   1263e:	xor    edx,edx
   12640:	mov    BYTE PTR [rdi+0x1c6],al
   12646:	lea    rcx,[rsp+0x40]
   1264b:	mov    r8,rsi
   1264e:	cmp    al,bpl
   12651:	jne    0x12745
   12657:	call   0x15160
   1265c:	lea    rcx,[rsp+0x80]
   12664:	lea    rdx,[rsp+0x40]
   12669:	mov    r8,rsi
   1266c:	mov    DWORD PTR [rsp+0x40],esi
   12670:	mov    DWORD PTR [rsp+0x44],0x2
   12678:	call   0x15e00
   1267d:	mov    rdx,QWORD PTR [rbx]
   12680:	mov    rcx,QWORD PTR [rip+0x6821]        # 0x18ea8
   12687:	lea    r9,[rsp+0x80]
   1268f:	xor    r8d,r8d
   12692:	call   QWORD PTR [rip+0x65d8]        # 0x18c70
   12698:	cmp    eax,r15d
   1269b:	jne    0x12942
   126a1:	mov    rdx,QWORD PTR [rbx]
   126a4:	mov    rcx,QWORD PTR [rip+0x67fd]        # 0x18ea8
   126ab:	call   QWORD PTR [rip+0x65b7]        # 0x18c68
   126b1:	cmp    al,r15b
   126b4:	jbe    0x1286a
   126ba:	mov    rax,QWORD PTR [rsp+0x90]
   126c2:	mov    QWORD PTR [rdi+0x60],rax
   126c6:	mov    al,BYTE PTR [rsp+0x88]
   126cd:	mov    BYTE PTR [rdi+0x78],al
   126d0:	cmp    al,0x2
   126d2:	jb     0x1293d
   126d8:	mov    bl,r15b
   126db:	cmp    al,r15b
   126de:	jbe    0x1286a
   126e4:	xor    edx,edx
   126e6:	lea    rcx,[rsp+0x60]
   126eb:	lea    r8d,[rdx+0x14]
   126ef:	call   0x15160
   126f4:	mov    rdx,QWORD PTR [rdi+0x60]
   126f8:	mov    rcx,QWORD PTR [rip+0x67a9]        # 0x18ea8
   126ff:	lea    r9,[rsp+0x60]
   12704:	mov    r8b,bl
   12707:	mov    DWORD PTR [rsp+0x60],0x14
   1270f:	call   QWORD PTR [rip+0x6673]        # 0x18d88
   12715:	cmp    rax,r15
   12718:	je     0x12738
   1271a:	cmp    DWORD PTR [rsp+0x6c],0x3
   1271f:	jne    0x12738
   12721:	test   BYTE PTR [rsp+0x68],0x80
   12726:	je     0x12731
   12728:	mov    QWORD PTR [rdi+0x88],rax
   1272f:	jmp    0x12738
   12731:	mov    QWORD PTR [rdi+0x80],rax
   12738:	add    bl,bpl
   1273b:	cmp    bl,BYTE PTR [rdi+0x78]
   1273e:	jb     0x126e4
   12740:	jmp    0x1286a
   12745:	call   0x15160
   1274a:	lea    rcx,[rsp+0x80]
   12752:	lea    rdx,[rsp+0x40]
   12757:	mov    r8,rsi
   1275a:	mov    DWORD PTR [rsp+0x40],esi
   1275e:	mov    DWORD PTR [rsp+0x44],0x3
   12766:	call   0x15e00
   1276b:	mov    rdx,QWORD PTR [rbx]
   1276e:	mov    rcx,QWORD PTR [rip+0x6733]        # 0x18ea8
   12775:	lea    r9,[rsp+0x80]
   1277d:	xor    r8d,r8d
   12780:	call   QWORD PTR [rip+0x64ea]        # 0x18c70
   12786:	cmp    eax,r15d
   12789:	jne    0x12942
   1278f:	mov    rdx,QWORD PTR [rbx]
   12792:	mov    rcx,QWORD PTR [rip+0x670f]        # 0x18ea8
   12799:	call   QWORD PTR [rip+0x64c9]        # 0x18c68
   1279f:	cmp    al,r15b
   127a2:	jbe    0x1286a
   127a8:	mov    al,BYTE PTR [rsp+0x98]
   127af:	mov    sil,r15b
   127b2:	mov    BYTE PTR [rdi+0x1c5],al
   127b8:	cmp    al,r15b
   127bb:	jbe    0x1286a
   127c1:	mov    rdx,QWORD PTR [rbx]
   127c4:	mov    rcx,QWORD PTR [rip+0x66dd]        # 0x18ea8
   127cb:	mov    r8b,sil
   127ce:	call   QWORD PTR [rip+0x659c]        # 0x18d70
   127d4:	mov    r12,rax
   127d7:	cmp    rax,r15
   127da:	je     0x1293d
   127e0:	mov    rcx,QWORD PTR [rip+0x66c1]        # 0x18ea8
   127e7:	mov    rdx,rax
   127ea:	call   QWORD PTR [rip+0x6590]        # 0x18d80
   127f0:	mov    bpl,r15b
   127f3:	mov    r13b,al
   127f6:	cmp    al,r15b
   127f9:	jbe    0x1285a
   127fb:	xor    edx,edx
   127fd:	lea    rcx,[rsp+0x40]
   12802:	lea    r8d,[rdx+0x14]
   12806:	call   0x15160
   1280b:	mov    rcx,QWORD PTR [rip+0x6696]        # 0x18ea8
   12812:	lea    r9,[rsp+0x40]
   12817:	mov    r8b,bpl
   1281a:	mov    rdx,r12
   1281d:	mov    DWORD PTR [rsp+0x40],0x14
   12825:	call   QWORD PTR [rip+0x655d]        # 0x18d88
   1282b:	cmp    rax,r15
   1282e:	je     0x12852
   12830:	cmp    DWORD PTR [rsp+0x4c],0x3
   12835:	jne    0x12852
   12837:	test   BYTE PTR [rsp+0x48],0x80
   1283c:	je     0x12847
   1283e:	mov    QWORD PTR [rdi+0x88],rax
   12845:	jmp    0x1284e
   12847:	mov    QWORD PTR [rdi+0x80],rax
   1284e:	mov    QWORD PTR [rdi+0x60],r12
   12852:	inc    bpl
   12855:	cmp    bpl,r13b
   12858:	jb     0x127fb
   1285a:	inc    sil
   1285d:	cmp    sil,BYTE PTR [rdi+0x1c5]
   12864:	jb     0x127c1
   1286a:	mov    eax,r15d
   1286d:	cmp    eax,r15d
   12870:	jne    0x12942
   12876:	cmp    QWORD PTR [rdi+0x80],r15
   1287d:	je     0x1293d
   12883:	cmp    QWORD PTR [rdi+0x88],r15
   1288a:	je     0x1293d
   12890:	mov    rdx,QWORD PTR [rdi+0x60]
   12894:	cmp    rdx,r15
   12897:	je     0x128a9
   12899:	mov    rcx,QWORD PTR [rip+0x6608]        # 0x18ea8
   128a0:	call   QWORD PTR [rip+0x64a2]        # 0x18d48
   128a6:	mov    BYTE PTR [rdi+0x68],al
   128a9:	mov    rax,QWORD PTR [rdi+0x1e0]
   128b0:	cmp    rax,r15
   128b3:	jne    0x128ba
   128b5:	mov    eax,r15d
   128b8:	jmp    0x128c4
   128ba:	mov    rcx,rdi
   128bd:	call   rax
   128bf:	cmp    eax,r15d
   128c2:	jne    0x12942
   128c4:	cmp    BYTE PTR [rdi+0x1da],r15b
   128cb:	je     0x12942
   128cd:	mov    ebx,DWORD PTR [rdi+0x1d4]
   128d3:	mov    esi,0x48
   128d8:	lea    rcx,[rsp+0xe0]
   128e0:	mov    r8,rsi
   128e3:	xor    edx,edx
   128e5:	call   0x15160
   128ea:	mov    rcx,QWORD PTR [rip+0x65b7]        # 0x18ea8
   128f1:	lea    rax,[rip+0x1830]        # 0x14128
   128f8:	mov    QWORD PTR [rsp+0x110],rax
   12900:	lea    rax,[rip+0x1815]        # 0x1411c
   12907:	mov    DWORD PTR [rsp+0xe0],esi
   1290e:	mov    QWORD PTR [rsp+0x118],rdi
   12916:	mov    QWORD PTR [rsp+0xe8],rbx
   1291e:	mov    QWORD PTR [rsp+0x120],rax
   12926:	mov    rdx,QWORD PTR [rdi+0x88]
   1292d:	lea    r8,[rsp+0xe0]
   12935:	call   QWORD PTR [rip+0x63d5]        # 0x18d10
   1293b:	jmp    0x12942
   1293d:	mov    eax,0xc0000001
   12942:	lea    r11,[rsp+0x130]
   1294a:	mov    rbx,QWORD PTR [r11+0x30]
   1294e:	mov    rbp,QWORD PTR [r11+0x38]
   12952:	mov    rsp,r11
   12955:	pop    r15
   12957:	pop    r13
   12959:	pop    r12
   1295b:	pop    rdi
   1295c:	pop    rsi
   1295d:	ret
   1295e:	int3
   1295f:	int3
   12960:	int3
   12961:	int3
   12962:	int3
   12963:	int3
   12964:	rex push rbx
   12966:	sub    rsp,0x20
   1296a:	mov    r8,QWORD PTR [rip+0x585f]        # 0x181d0
   12971:	mov    rdx,rcx
   12974:	mov    rcx,QWORD PTR [rip+0x652d]        # 0x18ea8
   1297b:	call   QWORD PTR [rip+0x5eef]        # 0x18870
   12981:	mov    edx,0xf
   12986:	mov    rcx,rax
   12989:	mov    rbx,rax
   1298c:	call   0x14a34
   12991:	xor    edx,edx
   12993:	mov    rcx,rbx
   12996:	call   0x14928
   1299b:	xor    eax,eax
   1299d:	add    rsp,0x20
   129a1:	pop    rbx
   129a2:	ret
   129a3:	int3
   129a4:	int3
   129a5:	int3
   129a6:	int3
   129a7:	int3
   129a8:	int3
   129a9:	int3
   129aa:	int3
   129ab:	int3
   129ac:	mov    QWORD PTR [rsp+0x8],rbx
   129b1:	mov    QWORD PTR [rsp+0x10],rsi
   129b6:	push   rdi
   129b7:	sub    rsp,0x50
   129bb:	cmp    BYTE PTR [rcx+0x1da],0x0
   129c2:	mov    rbx,rcx
   129c5:	je     0x129e2
   129c7:	mov    rdx,QWORD PTR [rcx+0x88]
   129ce:	mov    rcx,QWORD PTR [rip+0x64d3]        # 0x18ea8
   129d5:	call   QWORD PTR [rip+0x5d9d]        # 0x18778
   129db:	mov    edi,eax
   129dd:	jmp    0x12ad3
   129e2:	mov    rdx,QWORD PTR [rcx+0xa8]
   129e9:	mov    r8,QWORD PTR [rip+0x57b8]        # 0x181a8
   129f0:	mov    rcx,QWORD PTR [rip+0x64b1]        # 0x18ea8
   129f7:	call   QWORD PTR [rip+0x5e73]        # 0x18870
   129fd:	mov    rdx,QWORD PTR [rbx+0xa8]
   12a04:	mov    rcx,QWORD PTR [rip+0x649d]        # 0x18ea8
   12a0b:	mov    rsi,rax
   12a0e:	xor    eax,eax
   12a10:	lea    r8,[rsp+0x30]
   12a15:	mov    QWORD PTR [rsp+0x30],rax
   12a1a:	and    DWORD PTR [rsp+0x34],eax
   12a1e:	mov    QWORD PTR [rsp+0x38],rax
   12a23:	and    DWORD PTR [rsp+0x38],eax
   12a27:	mov    DWORD PTR [rsp+0x30],0x18
   12a2f:	mov    QWORD PTR [rsp+0x40],rax
   12a34:	call   QWORD PTR [rip+0x5fae]        # 0x189e8
   12a3a:	mov    edi,eax
   12a3c:	test   eax,eax
   12a3e:	jne    0x12ad3
   12a44:	mov    r9,QWORD PTR [rsi+0x8]
   12a48:	mov    r8,QWORD PTR [rbx+0xa8]
   12a4f:	mov    rdx,QWORD PTR [rbx+0x88]
   12a56:	mov    rcx,QWORD PTR [rip+0x644b]        # 0x18ea8
   12a5d:	and    QWORD PTR [rsp+0x20],0x0
   12a63:	call   QWORD PTR [rip+0x629f]        # 0x18d08
   12a69:	mov    edi,eax
   12a6b:	test   eax,eax
   12a6d:	jne    0x12ad3
   12a6f:	mov    rdx,QWORD PTR [rbx+0xa8]
   12a76:	mov    rcx,QWORD PTR [rip+0x642b]        # 0x18ea8
   12a7d:	lea    r8,[rip+0x19a0]        # 0x14424
   12a84:	mov    r9,rsi
   12a87:	call   QWORD PTR [rip+0x5fb3]        # 0x18a40
   12a8d:	lea    rcx,[rbx+0xb0]
   12a94:	call   QWORD PTR [rip+0x45e6]        # 0x17080
   12a9a:	mov    r8,QWORD PTR [rbx+0x88]
   12aa1:	mov    rdx,QWORD PTR [rbx+0xa8]
   12aa8:	mov    rcx,QWORD PTR [rip+0x63f9]        # 0x18ea8
   12aaf:	xor    r9d,r9d
   12ab2:	call   QWORD PTR [rip+0x5f50]        # 0x18a08
   12ab8:	test   al,al
   12aba:	jne    0x12ad3
   12abc:	lea    rcx,[rbx+0xb0]
   12ac3:	xor    r8d,r8d
   12ac6:	xor    edx,edx
   12ac8:	mov    edi,0xc0000001
   12acd:	call   QWORD PTR [rip+0x458d]        # 0x17060
   12ad3:	mov    rbx,QWORD PTR [rsp+0x60]
   12ad8:	mov    rsi,QWORD PTR [rsp+0x68]
   12add:	mov    eax,edi
   12adf:	add    rsp,0x50
   12ae3:	pop    rdi
   12ae4:	ret
   12ae5:	int3
   12ae6:	int3
   12ae7:	int3
   12ae8:	int3
   12ae9:	int3
   12aea:	int3
   12aeb:	int3
   12aec:	mov    rax,rsp
   12aef:	mov    QWORD PTR [rax+0x8],rbx
   12af3:	mov    QWORD PTR [rax+0x10],rbp
   12af7:	mov    QWORD PTR [rax+0x18],rsi
   12afb:	mov    QWORD PTR [rax+0x20],rdi
   12aff:	push   r12
   12b01:	sub    rsp,0x20
   12b05:	mov    r8,QWORD PTR [rip+0x56c4]        # 0x181d0
   12b0c:	mov    r12,rdx
   12b0f:	mov    rdx,rcx
   12b12:	mov    rcx,QWORD PTR [rip+0x638f]        # 0x18ea8
   12b19:	call   QWORD PTR [rip+0x5d51]        # 0x18870
   12b1f:	mov    ebp,0x1
   12b24:	xor    edi,edi
   12b26:	mov    ecx,ebp
   12b28:	mov    rbx,rax
   12b2b:	xchg   DWORD PTR [rax+0xd8],ecx
   12b31:	cmp    ecx,edi
   12b33:	je     0x12b40
   12b35:	mov    r8d,0x80000011
   12b3b:	jmp    0x12c4a
   12b40:	mov    esi,0x14
   12b45:	lea    rcx,[rax+0x168]
   12b4c:	xor    edx,edx
   12b4e:	mov    r8,rsi
   12b51:	mov    DWORD PTR [rax+0x158],edi
   12b57:	mov    DWORD PTR [rax+0x1c0],edi
   12b5d:	mov    DWORD PTR [rax+0x20],edi
   12b60:	mov    DWORD PTR [rax+0x190],0x30
   12b6a:	call   0x15160
   12b6f:	xor    eax,eax
   12b71:	lea    rcx,[rbx+0x17c]
   12b78:	lea    r8d,[rsi-0x4]
   12b7c:	mov    DWORD PTR [rbx+0x160],eax
   12b82:	mov    WORD PTR [rbx+0x164],ax
   12b89:	xor    edx,edx
   12b8b:	mov    DWORD PTR [rbx+0x15c],0x800
   12b95:	call   0x15160
   12b9a:	xor    eax,eax
   12b9c:	mov    WORD PTR [rbx+0x18c],ax
   12ba3:	lea    rcx,[rbx+0x1ac]
   12baa:	mov    r8,rsi
   12bad:	xor    edx,edx
   12baf:	mov    BYTE PTR [rbx+0x18e],al
   12bb5:	call   0x15160
   12bba:	mov    BYTE PTR [rbx+0x1c7],dil
   12bc1:	mov    BYTE PTR [rbx+0x1c8],dil
   12bc8:	mov    rax,QWORD PTR [rbx+0x128]
   12bcf:	mov    QWORD PTR [rbx+0x138],rax
   12bd6:	mov    QWORD PTR [rbx+0x130],rax
   12bdd:	mov    rax,QWORD PTR [rbx+0x1e8]
   12be4:	cmp    rax,rdi
   12be7:	jne    0x12bed
   12be9:	mov    esi,edi
   12beb:	jmp    0x12bf8
   12bed:	mov    rcx,rbx
   12bf0:	call   rax
   12bf2:	mov    esi,eax
   12bf4:	cmp    eax,edi
   12bf6:	jne    0x12c41
   12bf8:	xchg   DWORD PTR [rbx+0xdc],ebp
   12bfe:	cmp    ebp,edi
   12c00:	jne    0x12c10
   12c02:	mov    rcx,rbx
   12c05:	call   0x129ac
   12c0a:	mov    esi,eax
   12c0c:	cmp    eax,edi
   12c0e:	jne    0x12c41
   12c10:	mov    rdx,QWORD PTR [rbx+0x8]
   12c14:	mov    rcx,QWORD PTR [rip+0x628d]        # 0x18ea8
   12c1b:	mov    r8,0xfffffffffff0bdc0
   12c22:	call   QWORD PTR [rip+0x5ff0]        # 0x18c18
   12c28:	cmp    esi,edi
   12c2a:	jne    0x12c41
   12c2c:	mov    rdx,QWORD PTR [rbx]
   12c2f:	mov    rcx,QWORD PTR [rip+0x6272]        # 0x18ea8
   12c36:	xor    r8d,r8d
   12c39:	call   QWORD PTR [rip+0x5841]        # 0x18480
   12c3f:	jmp    0x12c47
   12c41:	xchg   DWORD PTR [rbx+0xd8],edi
   12c47:	mov    r8d,esi
   12c4a:	mov    rcx,QWORD PTR [rip+0x6257]        # 0x18ea8
   12c51:	mov    rdx,r12
   12c54:	mov    rbx,QWORD PTR [rsp+0x30]
   12c59:	mov    rbp,QWORD PTR [rsp+0x38]
   12c5e:	mov    rsi,QWORD PTR [rsp+0x40]
   12c63:	mov    rdi,QWORD PTR [rsp+0x48]
   12c68:	add    rsp,0x20
   12c6c:	pop    r12
   12c6e:	rex.W jmp QWORD PTR [rip+0x5de3]        # 0x18a58
   12c75:	int3
   12c76:	int3
   12c77:	int3
   12c78:	int3
   12c79:	int3
   12c7a:	int3
   12c7b:	int3
   12c7c:	mov    QWORD PTR [rsp+0x8],rbx
   12c81:	push   rdi
   12c82:	sub    rsp,0x30
   12c86:	mov    rdx,rcx
   12c89:	mov    rcx,QWORD PTR [rip+0x6218]        # 0x18ea8
   12c90:	xor    edi,edi
   12c92:	mov    DWORD PTR [rsp+0x48],edi
   12c96:	call   QWORD PTR [rip+0x59dc]        # 0x18678
   12c9c:	mov    r8,QWORD PTR [rip+0x552d]        # 0x181d0
   12ca3:	mov    rcx,QWORD PTR [rip+0x61fe]        # 0x18ea8
   12caa:	mov    rdx,rax
   12cad:	call   QWORD PTR [rip+0x5bbd]        # 0x18870
   12cb3:	lea    rdx,[rsp+0x48]
   12cb8:	mov    rcx,rax
   12cbb:	mov    rbx,rax
   12cbe:	call   0x147b4
   12cc3:	mov    ecx,edi
   12cc5:	xchg   DWORD PTR [rbx+0xdc],ecx
   12ccb:	cmp    ecx,0x1
   12cce:	jne    0x12d1a
   12cd0:	mov    rcx,QWORD PTR [rip+0x61d1]        # 0x18ea8
   12cd7:	cmp    BYTE PTR [rbx+0x1da],dil
   12cde:	je     0x12cf3
   12ce0:	mov    rdx,QWORD PTR [rbx+0x88]
   12ce7:	lea    r8d,[rdi+0x1]
   12ceb:	call   QWORD PTR [rip+0x5a8f]        # 0x18780
   12cf1:	jmp    0x12d1a
   12cf3:	mov    rdx,QWORD PTR [rbx+0xa8]
   12cfa:	call   QWORD PTR [rip+0x5d30]        # 0x18a30
   12d00:	lea    rcx,[rbx+0xb0]
   12d07:	xor    r9d,r9d
   12d0a:	xor    r8d,r8d
   12d0d:	xor    edx,edx
   12d0f:	mov    QWORD PTR [rsp+0x20],rdi
   12d14:	call   QWORD PTR [rip+0x430e]        # 0x17028
   12d1a:	mov    rdx,QWORD PTR [rbx+0x8]
   12d1e:	mov    rcx,QWORD PTR [rip+0x6183]        # 0x18ea8
   12d25:	mov    r8b,0x1
   12d28:	call   QWORD PTR [rip+0x5ef2]        # 0x18c20
   12d2e:	mov    rdx,QWORD PTR [rbx+0x40]
   12d32:	mov    rcx,QWORD PTR [rip+0x616f]        # 0x18ea8
   12d39:	mov    r8b,0x1
   12d3c:	call   QWORD PTR [rip+0x5866]        # 0x185a8
   12d42:	mov    rdx,QWORD PTR [rbx+0x30]
   12d46:	mov    rcx,QWORD PTR [rip+0x615b]        # 0x18ea8
   12d4d:	mov    r8b,0x1
   12d50:	call   QWORD PTR [rip+0x5852]        # 0x185a8
   12d56:	mov    rdx,QWORD PTR [rbx+0x38]
   12d5a:	mov    rcx,QWORD PTR [rip+0x6147]        # 0x18ea8
   12d61:	mov    r8b,0x1
   12d64:	call   QWORD PTR [rip+0x583e]        # 0x185a8
   12d6a:	mov    r11,QWORD PTR [rbx+0x1f0]
   12d71:	cmp    r11,rdi
   12d74:	je     0x12d7c
   12d76:	mov    rcx,rbx
   12d79:	call   r11
   12d7c:	xchg   DWORD PTR [rbx+0xd8],edi
   12d82:	mov    rdx,QWORD PTR [rbx]
   12d85:	mov    rcx,QWORD PTR [rip+0x611c]        # 0x18ea8
   12d8c:	mov    r8b,0x1
   12d8f:	mov    rbx,QWORD PTR [rsp+0x40]
   12d94:	add    rsp,0x30
   12d98:	pop    rdi
   12d99:	rex.W jmp QWORD PTR [rip+0x56e0]        # 0x18480
   12da0:	int3
   12da1:	int3
   12da2:	int3
   12da3:	int3
   12da4:	int3
   12da5:	int3
   12da6:	int3
   12da7:	int3
   12da8:	sub    rsp,0x28
   12dac:	and    DWORD PTR [rsp+0x38],0x0
   12db1:	mov    rdx,rcx
   12db4:	mov    rcx,QWORD PTR [rip+0x60ed]        # 0x18ea8
   12dbb:	call   QWORD PTR [rip+0x58b7]        # 0x18678
   12dc1:	mov    r8,QWORD PTR [rip+0x5408]        # 0x181d0
   12dc8:	mov    rcx,QWORD PTR [rip+0x60d9]        # 0x18ea8
   12dcf:	mov    rdx,rax
   12dd2:	call   QWORD PTR [rip+0x5a98]        # 0x18870
   12dd8:	lea    rdx,[rsp+0x38]
   12ddd:	mov    rcx,rax
   12de0:	call   0x147b4
   12de5:	add    rsp,0x28
   12de9:	ret
   12dea:	int3
   12deb:	int3
   12dec:	int3
   12ded:	int3
   12dee:	int3
   12def:	int3
   12df0:	mov    QWORD PTR [rsp+0x8],rbx
   12df5:	mov    QWORD PTR [rsp+0x10],rsi
   12dfa:	push   rdi
   12dfb:	sub    rsp,0x20
   12dff:	mov    rdx,rcx
   12e02:	mov    rcx,QWORD PTR [rip+0x609f]        # 0x18ea8
   12e09:	call   QWORD PTR [rip+0x5e19]        # 0x18c28
   12e0f:	mov    r8,QWORD PTR [rip+0x53ba]        # 0x181d0
   12e16:	mov    rcx,QWORD PTR [rip+0x608b]        # 0x18ea8
   12e1d:	mov    rdx,rax
   12e20:	call   QWORD PTR [rip+0x5a4a]        # 0x18870
   12e26:	mov    rbx,rax
   12e29:	cmp    BYTE PTR [rax+0x1c8],0x0
   12e30:	je     0x12e54
   12e32:	cmp    BYTE PTR [rax+0x1c7],0x0
   12e39:	mov    BYTE PTR [rax+0x1c8],0x0
   12e40:	je     0x12e4c
   12e42:	bts    DWORD PTR [rax+0x190],0x7
   12e4a:	jmp    0x12e54
   12e4c:	btr    DWORD PTR [rax+0x190],0x7
   12e54:	cmp    QWORD PTR [rax+0xe8],0x0
   12e5c:	je     0x12ef8
   12e62:	movabs rax,0xfffff78000000014
   12e6c:	mov    rax,QWORD PTR [rax]
   12e6f:	cmp    QWORD PTR [rbx+0x108],rax
   12e76:	jl     0x12e81
   12e78:	cmp    QWORD PTR [rbx+0x110],rax
   12e7f:	jge    0x12ef8
   12e81:	mov    rdi,QWORD PTR [rbx+0xe8]
   12e88:	mov    rsi,QWORD PTR [rbx+0x100]
   12e8f:	mov    rcx,QWORD PTR [rip+0x6012]        # 0x18ea8
   12e96:	and    QWORD PTR [rbx+0xe8],0x0
   12e9e:	and    QWORD PTR [rbx+0xf0],0x0
   12ea6:	and    QWORD PTR [rbx+0xf8],0x0
   12eae:	and    QWORD PTR [rbx+0x100],0x0
   12eb6:	mov    rdx,rdi
   12eb9:	call   QWORD PTR [rip+0x5b61]        # 0x18a20
   12ebf:	mov    rcx,QWORD PTR [rip+0x5fe2]        # 0x18ea8
   12ec6:	mov    rdx,rdi
   12ec9:	test   eax,eax
   12ecb:	je     0x12ed8
   12ecd:	mov    r8d,eax
   12ed0:	call   QWORD PTR [rip+0x5b82]        # 0x18a58
   12ed6:	jmp    0x12ee7
   12ed8:	mov    r9,rsi
   12edb:	mov    r8d,0x102
   12ee1:	call   QWORD PTR [rip+0x5b81]        # 0x18a68
   12ee7:	mov    rdx,QWORD PTR [rbx+0x30]
   12eeb:	mov    rcx,QWORD PTR [rip+0x5fb6]        # 0x18ea8
   12ef2:	call   QWORD PTR [rip+0x56a8]        # 0x185a0
   12ef8:	mov    rbx,QWORD PTR [rsp+0x30]
   12efd:	mov    rsi,QWORD PTR [rsp+0x38]
   12f02:	add    rsp,0x20
   12f06:	pop    rdi
   12f07:	ret
   12f08:	int3
   12f09:	int3
   12f0a:	int3
   12f0b:	int3
   12f0c:	int3
   12f0d:	int3
   12f0e:	int3
   12f0f:	int3
   12f10:	mov    QWORD PTR [rsp+0x8],rbx
   12f15:	push   rdi
   12f16:	sub    rsp,0x20
   12f1a:	mov    r8,QWORD PTR [rip+0x52af]        # 0x181d0
   12f21:	mov    rdx,rcx
   12f24:	mov    rcx,QWORD PTR [rip+0x5f7d]        # 0x18ea8
   12f2b:	call   QWORD PTR [rip+0x593f]        # 0x18870
   12f31:	mov    rdi,rax
   12f34:	cmp    BYTE PTR [rax+0xcb],0x0
   12f3b:	mov    rbx,QWORD PTR [rax+0x50]
   12f3f:	je     0x12f4a
   12f41:	call   QWORD PTR [rip+0x4129]        # 0x17070
   12f47:	dec    DWORD PTR [rax+0x14]
   12f4a:	test   rbx,rbx
   12f4d:	je     0x12f6d
   12f4f:	cmp    BYTE PTR [rdi+0xca],0x0
   12f56:	je     0x12f6d
   12f58:	lea    rdx,[rip+0x3231]        # 0x16190
   12f5f:	mov    r8,rbx
   12f62:	mov    ecx,0x4
   12f67:	call   QWORD PTR [rip+0x40cb]        # 0x17038
   12f6d:	mov    rbx,QWORD PTR [rsp+0x30]
   12f72:	add    rsp,0x20
   12f76:	pop    rdi
   12f77:	ret
   12f78:	int3
   12f79:	int3
   12f7a:	int3
   12f7b:	int3
   12f7c:	int3
   12f7d:	int3
   12f7e:	int3
   12f7f:	int3
   12f80:	sub    rsp,0x68
   12f84:	mov    rax,QWORD PTR [rip+0x5175]        # 0x18100
   12f8b:	xor    rax,rsp
   12f8e:	mov    QWORD PTR [rsp+0x58],rax
   12f93:	xor    eax,eax
   12f95:	mov    QWORD PTR [rsp+0x50],rax
   12f9a:	and    al,0x1c
   12f9c:	mov    BYTE PTR [rsp+0x51],0x22
   12fa1:	or     al,0x21
   12fa3:	mov    WORD PTR [rsp+0x52],r8w
   12fa9:	mov    WORD PTR [rsp+0x54],r9w
   12faf:	mov    BYTE PTR [rsp+0x50],al
   12fb3:	mov    eax,DWORD PTR [rcx+0x1cc]
   12fb9:	test   eax,eax
   12fbb:	jne    0x12fc2
   12fbd:	xor    r9d,r9d
   12fc0:	jmp    0x12fef
   12fc2:	xor    edx,edx
   12fc4:	imul   rax,rax,0xffffffffff676980
   12fcb:	lea    r9,[rsp+0x40]
   12fd0:	mov    QWORD PTR [rsp+0x40],rdx
   12fd5:	mov    QWORD PTR [rsp+0x48],rdx
   12fda:	mov    QWORD PTR [rsp+0x48],rax
   12fdf:	mov    DWORD PTR [rsp+0x40],0x10
   12fe7:	mov    DWORD PTR [rsp+0x44],0x1
   12fef:	and    QWORD PTR [rsp+0x30],0x0
   12ff5:	mov    rdx,QWORD PTR [rcx+0x58]
   12ff9:	and    QWORD PTR [rsp+0x28],0x0
   12fff:	mov    rcx,QWORD PTR [rip+0x5ea2]        # 0x18ea8
   13006:	lea    rax,[rsp+0x50]
   1300b:	xor    r8d,r8d
   1300e:	mov    QWORD PTR [rsp+0x20],rax
   13013:	call   QWORD PTR [rip+0x5c6f]        # 0x18c88
   13019:	mov    rcx,QWORD PTR [rsp+0x58]
   1301e:	xor    rcx,rsp
   13021:	call   0x14b80
   13026:	add    rsp,0x68
   1302a:	ret
   1302b:	int3
   1302c:	int3
   1302d:	int3
   1302e:	int3
   1302f:	int3
   13030:	int3
   13031:	int3
   13032:	int3
   13033:	int3
   13034:	sub    rsp,0x28
   13038:	mov    rdx,rcx
   1303b:	mov    rcx,QWORD PTR [rip+0x5e66]        # 0x18ea8
   13042:	call   QWORD PTR [rip+0x5568]        # 0x185b0
   13048:	mov    r8,QWORD PTR [rip+0x5181]        # 0x181d0
   1304f:	mov    rcx,QWORD PTR [rip+0x5e52]        # 0x18ea8
   13056:	mov    rdx,rax
   13059:	call   QWORD PTR [rip+0x5811]        # 0x18870
   1305f:	mov    ecx,DWORD PTR [rax+0x1c0]
   13065:	mov    edx,DWORD PTR [rax+0x20]
   13068:	and    edx,ecx
   1306a:	test   dl,0x10
   1306d:	je     0x13074
   1306f:	or     edx,0x8
   13072:	jmp    0x13077
   13074:	and    edx,0xfffffff7
   13077:	test   edx,edx
   13079:	jne    0x13084
   1307b:	test   ecx,ecx
   1307d:	jne    0x1308c
   1307f:	cmp    DWORD PTR [rax+0x20],ecx
   13082:	je     0x1308c
   13084:	mov    rcx,rax
   13087:	call   0x14928
   1308c:	add    rsp,0x28
   13090:	ret
   13091:	int3
   13092:	int3
   13093:	int3
   13094:	int3
   13095:	int3
   13096:	int3
   13097:	int3
   13098:	mov    rax,rsp
   1309b:	mov    QWORD PTR [rax+0x8],rbx
   1309f:	mov    QWORD PTR [rax+0x10],rbp
   130a3:	mov    QWORD PTR [rax+0x18],rsi
   130a7:	mov    QWORD PTR [rax+0x20],rdi
   130ab:	push   r12
   130ad:	sub    rsp,0x40
   130b1:	mov    rbp,rdx
   130b4:	mov    rdx,rcx
   130b7:	mov    rcx,QWORD PTR [rip+0x5dea]        # 0x18ea8
   130be:	call   QWORD PTR [rip+0x5644]        # 0x18708
   130c4:	mov    r8,QWORD PTR [rip+0x5105]        # 0x181d0
   130cb:	mov    rcx,QWORD PTR [rip+0x5dd6]        # 0x18ea8
   130d2:	mov    rdx,rax
   130d5:	call   QWORD PTR [rip+0x5795]        # 0x18870
   130db:	mov    ecx,DWORD PTR [rsp+0x70]
   130df:	xor    edi,edi
   130e1:	mov    rsi,rax
   130e4:	mov    eax,0x1b004c
   130e9:	mov    QWORD PTR [rsp+0x30],rdi
   130ee:	mov    QWORD PTR [rsp+0x38],rdi
   130f3:	cmp    ecx,eax
   130f5:	ja     0x13441
   130fb:	je     0x13400
   13101:	mov    eax,0x1b0028
   13106:	cmp    ecx,eax
   13108:	ja     0x1331b
   1310e:	je     0x132e4
   13114:	sub    ecx,0x1b0004
   1311a:	je     0x132a3
   13120:	lea    ebx,[rdi+0x4]
   13123:	sub    ecx,ebx
   13125:	je     0x13274
   1312b:	sub    ecx,ebx
   1312d:	je     0x1322d
   13133:	sub    ecx,0x10
   13136:	je     0x131a3
   13138:	sub    ecx,ebx
   1313a:	je     0x1315b
   1313c:	cmp    ecx,ebx
   1313e:	jne    0x1364c
   13144:	cmp    BYTE PTR [rsi+0x1c7],dil
   1314b:	je     0x13154
   1314d:	or     DWORD PTR [rsi+0x190],0x20
   13154:	mov    eax,edi
   13156:	jmp    0x137ae
   1315b:	mov    rcx,QWORD PTR [rip+0x5d46]        # 0x18ea8
   13162:	lea    rax,[rsp+0x38]
   13167:	mov    ebx,0x14
   1316c:	lea    r9,[rsp+0x30]
   13171:	mov    r8,rbx
   13174:	mov    rdx,rbp
   13177:	mov    QWORD PTR [rsp+0x20],rax
   1317c:	call   QWORD PTR [rip+0x590e]        # 0x18a90
   13182:	cmp    eax,edi
   13184:	jne    0x137a7
   1318a:	lea    rdx,[rsi+0x1ac]
   13191:	mov    rcx,QWORD PTR [rsp+0x30]
   13196:	mov    r8,rbx
   13199:	call   0x15e00
   1319e:	jmp    0x137a2
   131a3:	mov    rcx,QWORD PTR [rip+0x5cfe]        # 0x18ea8
   131aa:	lea    rax,[rsp+0x38]
   131af:	mov    ebx,0x14
   131b4:	lea    r9,[rsp+0x30]
   131b9:	mov    r8,rbx
   131bc:	mov    rdx,rbp
   131bf:	mov    QWORD PTR [rsp+0x20],rax
   131c4:	call   QWORD PTR [rip+0x58be]        # 0x18a88
   131ca:	cmp    eax,edi
   131cc:	jne    0x137a7
   131d2:	mov    rdx,QWORD PTR [rsp+0x30]
   131d7:	or     r12d,0xffffffff
   131db:	cmp    DWORD PTR [rdx],r12d
   131de:	jne    0x131f6
   131e0:	cmp    DWORD PTR [rdx+0x4],r12d
   131e4:	jne    0x131f6
   131e6:	cmp    DWORD PTR [rdx+0x8],r12d
   131ea:	jne    0x131f6
   131ec:	mov    eax,0xc000000d
   131f1:	jmp    0x137ae
   131f6:	lea    rcx,[rsi+0x1ac]
   131fd:	mov    r8,rbx
   13200:	call   0x15e00
   13205:	mov    rcx,QWORD PTR [rsp+0x30]
   1320a:	mov    eax,edi
   1320c:	cmp    DWORD PTR [rcx],r12d
   1320f:	jne    0x13220
   13211:	cmp    DWORD PTR [rcx+0x4],edi
   13214:	jne    0x13220
   13216:	cmp    DWORD PTR [rcx+0x8],edi
   13219:	mov    ecx,0x1
   1321e:	je     0x13222
   13220:	mov    ecx,edi
   13222:	mov    BYTE PTR [rsi+0x1c4],cl
   13228:	jmp    0x137a7
   1322d:	mov    rcx,QWORD PTR [rip+0x5c74]        # 0x18ea8
   13234:	lea    rax,[rsp+0x38]
   13239:	lea    r9,[rsp+0x30]
   1323e:	mov    r8d,0x3
   13244:	mov    rdx,rbp
   13247:	mov    QWORD PTR [rsp+0x20],rax
   1324c:	call   QWORD PTR [rip+0x5836]        # 0x18a88
   13252:	cmp    eax,edi
   13254:	jne    0x137a7
   1325a:	mov    rcx,QWORD PTR [rsp+0x30]
   1325f:	movzx  eax,WORD PTR [rcx]
   13262:	mov    WORD PTR [rsi+0x18c],ax
   13269:	mov    al,BYTE PTR [rcx+0x2]
   1326c:	mov    BYTE PTR [rsi+0x18e],al
   13272:	jmp    0x132dd
   13274:	mov    rcx,QWORD PTR [rip+0x5c2d]        # 0x18ea8
   1327b:	lea    rax,[rsp+0x38]
   13280:	lea    r9,[rsp+0x30]
   13285:	mov    r8d,0x8
   1328b:	mov    rdx,rbp
   1328e:	mov    QWORD PTR [rsp+0x20],rax
   13293:	call   QWORD PTR [rip+0x57ef]        # 0x18a88
   13299:	cmp    eax,edi
   1329b:	jne    0x137a7
   132a1:	jmp    0x132dd
   132a3:	mov    rcx,QWORD PTR [rip+0x5bfe]        # 0x18ea8
   132aa:	lea    rax,[rsp+0x38]
   132af:	lea    r9,[rsp+0x30]
   132b4:	mov    r8d,0x4
   132ba:	mov    rdx,rbp
   132bd:	mov    QWORD PTR [rsp+0x20],rax
   132c2:	call   QWORD PTR [rip+0x57c0]        # 0x18a88
   132c8:	cmp    eax,edi
   132ca:	jne    0x137a7
   132d0:	mov    rax,QWORD PTR [rsp+0x30]
   132d5:	mov    ecx,DWORD PTR [rax]
   132d7:	mov    DWORD PTR [rsi+0x15c],ecx
   132dd:	mov    eax,edi
   132df:	jmp    0x137a7
   132e4:	and    DWORD PTR [rsi+0x190],0xffffff5f
   132ee:	test   BYTE PTR [rsi+0x1c0],0x20
   132f5:	mov    BYTE PTR [rsi+0x1c7],dil
   132fc:	mov    BYTE PTR [rsi+0x1c8],dil
   13303:	je     0x13154
   13309:	mov    edx,0x20
   1330e:	mov    rcx,rsi
   13311:	call   0x149ec
   13316:	jmp    0x13154
   1331b:	sub    ecx,0x1b0030
   13321:	je     0x13154
   13327:	mov    ebx,0x4
   1332c:	sub    ecx,ebx
   1332e:	je     0x13154
   13334:	sub    ecx,0xc
   13337:	je     0x133cb
   1333d:	sub    ecx,ebx
   1333f:	je     0x13383
   13341:	cmp    ecx,ebx
   13343:	jne    0x1364c
   13349:	mov    rcx,QWORD PTR [rip+0x5b58]        # 0x18ea8
   13350:	lea    rax,[rsp+0x38]
   13355:	lea    r9,[rsp+0x30]
   1335a:	mov    r8,rbx
   1335d:	mov    rdx,rbp
   13360:	mov    QWORD PTR [rsp+0x20],rax
   13365:	call   QWORD PTR [rip+0x5725]        # 0x18a90
   1336b:	cmp    eax,edi
   1336d:	jne    0x137a7
   13373:	mov    rdx,rbp
   13376:	mov    rcx,rsi
   13379:	call   0x14814
   1337e:	jmp    0x137c4
   13383:	mov    rcx,QWORD PTR [rip+0x5b1e]        # 0x18ea8
   1338a:	lea    rax,[rsp+0x38]
   1338f:	lea    r9,[rsp+0x30]
   13394:	mov    r8,rbx
   13397:	mov    rdx,rbp
   1339a:	mov    QWORD PTR [rsp+0x20],rax
   1339f:	call   QWORD PTR [rip+0x56e3]        # 0x18a88
   133a5:	cmp    eax,edi
   133a7:	jne    0x137a7
   133ad:	mov    rdx,QWORD PTR [rsp+0x30]
   133b2:	test   DWORD PTR [rdx],0xfffff800
   133b8:	jne    0x131ec
   133be:	mov    rcx,rsi
   133c1:	call   0x147b4
   133c6:	jmp    0x137a7
   133cb:	mov    rcx,QWORD PTR [rip+0x5ad6]        # 0x18ea8
   133d2:	lea    rax,[rsp+0x38]
   133d7:	lea    r9,[rsp+0x30]
   133dc:	mov    r8,rbx
   133df:	mov    rdx,rbp
   133e2:	mov    QWORD PTR [rsp+0x20],rax
   133e7:	call   QWORD PTR [rip+0x56a3]        # 0x18a90
   133ed:	cmp    eax,edi
   133ef:	jne    0x137a7
   133f5:	mov    ecx,DWORD PTR [rsi+0x1c0]
   133fb:	jmp    0x1379b
   13400:	mov    rcx,QWORD PTR [rip+0x5aa1]        # 0x18ea8
   13407:	lea    rax,[rsp+0x38]
   1340c:	lea    r9,[rsp+0x30]
   13411:	mov    r8d,0x4
   13417:	mov    rdx,rbp
   1341a:	mov    QWORD PTR [rsp+0x20],rax
   1341f:	call   QWORD PTR [rip+0x5663]        # 0x18a88
   13425:	cmp    eax,edi
   13427:	jne    0x137a7
   1342d:	mov    rax,QWORD PTR [rsp+0x30]
   13432:	mov    rcx,rsi
   13435:	mov    edx,DWORD PTR [rax]
   13437:	call   0x14a34
   1343c:	jmp    0x137a7
   13441:	mov    eax,0x1b0064
   13446:	cmp    ecx,eax
   13448:	ja     0x13621
   1344e:	je     0x135de
   13454:	sub    ecx,0x1b0050
   1345a:	mov    ebx,0x4
   1345f:	je     0x135a9
   13465:	sub    ecx,ebx
   13467:	je     0x1355d
   1346d:	sub    ecx,ebx
   1346f:	je     0x13511
   13475:	sub    ecx,ebx
   13477:	je     0x134c7
   13479:	cmp    ecx,ebx
   1347b:	jne    0x1364c
   13481:	mov    rcx,QWORD PTR [rip+0x5a20]        # 0x18ea8
   13488:	lea    rax,[rsp+0x38]
   1348d:	lea    r9,[rsp+0x30]
   13492:	lea    r8d,[rbx+0xc]
   13496:	mov    rdx,rbp
   13499:	mov    QWORD PTR [rsp+0x20],rax
   1349e:	call   QWORD PTR [rip+0x55ec]        # 0x18a90
   134a4:	cmp    eax,edi
   134a6:	jne    0x137a7
   134ac:	mov    rax,QWORD PTR [rsp+0x30]
   134b1:	movdqu xmm0,XMMWORD PTR [rsi+0x17c]
   134b9:	movdqu XMMWORD PTR [rax],xmm0
   134bd:	mov    eax,edi
   134bf:	lea    edi,[rbx+0xc]
   134c2:	jmp    0x137a7
   134c7:	mov    rcx,QWORD PTR [rip+0x59da]        # 0x18ea8
   134ce:	lea    rax,[rsp+0x38]
   134d3:	lea    r9,[rsp+0x30]
   134d8:	mov    r8d,0x6
   134de:	mov    rdx,rbp
   134e1:	mov    QWORD PTR [rsp+0x20],rax
   134e6:	call   QWORD PTR [rip+0x559c]        # 0x18a88
   134ec:	cmp    eax,edi
   134ee:	jne    0x137a7
   134f4:	mov    rcx,QWORD PTR [rsp+0x30]
   134f9:	mov    eax,DWORD PTR [rcx]
   134fb:	mov    DWORD PTR [rsi+0x160],eax
   13501:	movzx  eax,WORD PTR [rcx+0x4]
   13505:	mov    WORD PTR [rsi+0x164],ax
   1350c:	jmp    0x132dd
   13511:	mov    rcx,QWORD PTR [rip+0x5990]        # 0x18ea8
   13518:	lea    rax,[rsp+0x38]
   1351d:	mov    ebx,0x6
   13522:	lea    r9,[rsp+0x30]
   13527:	mov    r8,rbx
   1352a:	mov    rdx,rbp
   1352d:	mov    QWORD PTR [rsp+0x20],rax
   13532:	call   QWORD PTR [rip+0x5558]        # 0x18a90
   13538:	cmp    eax,edi
   1353a:	jne    0x137a7
   13540:	mov    eax,DWORD PTR [rsi+0x160]
   13546:	mov    rcx,QWORD PTR [rsp+0x30]
   1354b:	mov    DWORD PTR [rcx],eax
   1354d:	movzx  eax,WORD PTR [rsi+0x164]
   13554:	mov    WORD PTR [rcx+0x4],ax
   13558:	jmp    0x137a2
   1355d:	mov    rcx,QWORD PTR [rip+0x5944]        # 0x18ea8
   13564:	lea    rax,[rsp+0x38]
   13569:	mov    ebx,0x3
   1356e:	lea    r9,[rsp+0x30]
   13573:	mov    r8,rbx
   13576:	mov    rdx,rbp
   13579:	mov    QWORD PTR [rsp+0x20],rax
   1357e:	call   QWORD PTR [rip+0x550c]        # 0x18a90
   13584:	cmp    eax,edi
   13586:	jne    0x137a7
   1358c:	movzx  eax,WORD PTR [rsi+0x18c]
   13593:	mov    rcx,QWORD PTR [rsp+0x30]
   13598:	mov    WORD PTR [rcx],ax
   1359b:	mov    al,BYTE PTR [rsi+0x18e]
   135a1:	mov    BYTE PTR [rcx+0x2],al
   135a4:	jmp    0x137a2
   135a9:	mov    rcx,QWORD PTR [rip+0x58f8]        # 0x18ea8
   135b0:	lea    rax,[rsp+0x38]
   135b5:	lea    r9,[rsp+0x30]
   135ba:	mov    r8,rbx
   135bd:	mov    rdx,rbp
   135c0:	mov    QWORD PTR [rsp+0x20],rax
   135c5:	call   QWORD PTR [rip+0x54c5]        # 0x18a90
   135cb:	cmp    eax,edi
   135cd:	jne    0x137a7
   135d3:	mov    ecx,DWORD PTR [rsi+0x15c]
   135d9:	jmp    0x1379b
   135de:	mov    rcx,QWORD PTR [rip+0x58c3]        # 0x18ea8
   135e5:	lea    rax,[rsp+0x38]
   135ea:	lea    r9,[rsp+0x30]
   135ef:	mov    r8d,0x10
   135f5:	mov    rdx,rbp
   135f8:	mov    QWORD PTR [rsp+0x20],rax
   135fd:	call   QWORD PTR [rip+0x5485]        # 0x18a88
   13603:	cmp    eax,edi
   13605:	jne    0x137a7
   1360b:	mov    rax,QWORD PTR [rsp+0x30]
   13610:	movdqu xmm0,XMMWORD PTR [rax]
   13614:	movdqu XMMWORD PTR [rsi+0x17c],xmm0
   1361c:	jmp    0x132dd
   13621:	sub    ecx,0x1b0068
   13627:	mov    ebx,0x4
   1362c:	je     0x1376f
   13632:	sub    ecx,ebx
   13634:	je     0x13738
   1363a:	sub    ecx,0x8
   1363d:	je     0x136af
   1363f:	lea    r12d,[rbx+0x14]
   13643:	sub    ecx,r12d
   13646:	je     0x1366c
   13648:	cmp    ecx,ebx
   1364a:	je     0x13656
   1364c:	mov    eax,0xc00000bb
   13651:	jmp    0x137ae
   13656:	lea    rcx,[rsi+0x194]
   1365d:	mov    r8,r12
   13660:	xor    edx,edx
   13662:	call   0x15160
   13667:	jmp    0x13154
   1366c:	mov    rcx,QWORD PTR [rip+0x5835]        # 0x18ea8
   13673:	lea    rax,[rsp+0x38]
   13678:	lea    r9,[rsp+0x30]
   1367d:	mov    r8,r12
   13680:	mov    rdx,rbp
   13683:	mov    QWORD PTR [rsp+0x20],rax
   13688:	call   QWORD PTR [rip+0x5402]        # 0x18a90
   1368e:	cmp    eax,edi
   13690:	jne    0x137a7
   13696:	mov    rcx,QWORD PTR [rsp+0x30]
   1369b:	lea    rdx,[rsi+0x194]
   136a2:	mov    r8,r12
   136a5:	call   0x15e00
   136aa:	jmp    0x13731
   136af:	mov    rcx,QWORD PTR [rip+0x57f2]        # 0x18ea8
   136b6:	lea    rax,[rsp+0x38]
   136bb:	mov    r12d,0x40
   136c1:	lea    r9,[rsp+0x30]
   136c6:	mov    r8,r12
   136c9:	mov    rdx,rbp
   136cc:	mov    QWORD PTR [rsp+0x20],rax
   136d1:	call   QWORD PTR [rip+0x53b9]        # 0x18a90
   136d7:	cmp    eax,edi
   136d9:	jne    0x137a7
   136df:	mov    rbx,QWORD PTR [rsp+0x30]
   136e4:	mov    r8,r12
   136e7:	xor    edx,edx
   136e9:	mov    rcx,rbx
   136ec:	call   0x15160
   136f1:	lea    edx,[r12-0x3e]
   136f6:	mov    WORD PTR [rbx],r12w
   136fa:	lea    ecx,[rdx-0x1]
   136fd:	mov    WORD PTR [rbx+0x2],dx
   13701:	mov    DWORD PTR [rbx+0xc],edi
   13704:	mov    DWORD PTR [rbx+0x4],ecx
   13707:	mov    eax,DWORD PTR [rsi+0x148]
   1370d:	mov    DWORD PTR [rbx+0x14],0x10000000
   13714:	mov    DWORD PTR [rbx+0x18],ecx
   13717:	mov    DWORD PTR [rbx+0x1c],r12d
   1371b:	mov    DWORD PTR [rbx+0x20],edx
   1371e:	mov    DWORD PTR [rbx+0x10],eax
   13721:	mov    DWORD PTR [rbx+0x24],0x1007fffb
   13728:	mov    eax,DWORD PTR [rsi+0x148]
   1372e:	mov    DWORD PTR [rbx+0x30],eax
   13731:	mov    eax,edi
   13733:	mov    rdi,r12
   13736:	jmp    0x137a7
   13738:	mov    rcx,QWORD PTR [rip+0x5769]        # 0x18ea8
   1373f:	lea    rax,[rsp+0x38]
   13744:	mov    ebx,0x14
   13749:	lea    r9,[rsp+0x30]
   1374e:	mov    r8,rbx
   13751:	mov    rdx,rbp
   13754:	mov    QWORD PTR [rsp+0x20],rax
   13759:	call   QWORD PTR [rip+0x5331]        # 0x18a90
   1375f:	cmp    eax,edi
   13761:	jne    0x137a7
   13763:	lea    rdx,[rsi+0x168]
   1376a:	jmp    0x13191
   1376f:	mov    rcx,QWORD PTR [rip+0x5732]        # 0x18ea8
   13776:	lea    rax,[rsp+0x38]
   1377b:	lea    r9,[rsp+0x30]
   13780:	mov    r8,rbx
   13783:	mov    rdx,rbp
   13786:	mov    QWORD PTR [rsp+0x20],rax
   1378b:	call   QWORD PTR [rip+0x52ff]        # 0x18a90
   13791:	cmp    eax,edi
   13793:	jne    0x137a7
   13795:	mov    ecx,DWORD PTR [rsi+0x190]
   1379b:	mov    rax,QWORD PTR [rsp+0x30]
   137a0:	mov    DWORD PTR [rax],ecx
   137a2:	mov    eax,edi
   137a4:	mov    rdi,rbx
   137a7:	cmp    eax,0x103
   137ac:	je     0x137c4
   137ae:	mov    rcx,QWORD PTR [rip+0x56f3]        # 0x18ea8
   137b5:	mov    r9,rdi
   137b8:	mov    r8d,eax
   137bb:	mov    rdx,rbp
   137be:	call   QWORD PTR [rip+0x52a4]        # 0x18a68
   137c4:	mov    rbx,QWORD PTR [rsp+0x50]
   137c9:	mov    rbp,QWORD PTR [rsp+0x58]
   137ce:	mov    rsi,QWORD PTR [rsp+0x60]
   137d3:	mov    rdi,QWORD PTR [rsp+0x68]
   137d8:	add    rsp,0x40
   137dc:	pop    r12
   137de:	ret
   137df:	int3
   137e0:	int3
   137e1:	int3
   137e2:	int3
   137e3:	int3
   137e4:	int3
   137e5:	int3
   137e6:	int3
   137e7:	int3
   137e8:	sub    rsp,0x28
   137ec:	mov    r8,QWORD PTR [rip+0x498d]        # 0x18180
   137f3:	mov    rdx,rcx
   137f6:	mov    rcx,QWORD PTR [rip+0x56ab]        # 0x18ea8
   137fd:	call   QWORD PTR [rip+0x506d]        # 0x18870
   13803:	mov    r8,QWORD PTR [rip+0x49c6]        # 0x181d0
   1380a:	mov    rcx,QWORD PTR [rip+0x5697]        # 0x18ea8
   13811:	mov    rdx,QWORD PTR [rax]
   13814:	call   QWORD PTR [rip+0x5056]        # 0x18870
   1381a:	mov    rdx,QWORD PTR [rax+0x28]
   1381e:	test   rdx,rdx
   13821:	je     0x1383b
   13823:	mov    rcx,QWORD PTR [rip+0x567e]        # 0x18ea8
   1382a:	and    QWORD PTR [rax+0x28],0x0
   1382f:	mov    r8d,0xc0000120
   13835:	call   QWORD PTR [rip+0x521d]        # 0x18a58
   1383b:	add    rsp,0x28
   1383f:	ret
   13840:	int3
   13841:	int3
   13842:	int3
   13843:	int3
   13844:	int3
   13845:	int3
   13846:	int3
   13847:	int3
   13848:	mov    QWORD PTR [rsp+0x8],rbx
   1384d:	push   rdi
   1384e:	sub    rsp,0x20
   13852:	mov    rdi,rdx
   13855:	mov    rdx,rcx
   13858:	mov    rcx,QWORD PTR [rip+0x5649]        # 0x18ea8
   1385f:	call   QWORD PTR [rip+0x4ea3]        # 0x18708
   13865:	mov    r8,QWORD PTR [rip+0x4964]        # 0x181d0
   1386c:	mov    rcx,QWORD PTR [rip+0x5635]        # 0x18ea8
   13873:	mov    rdx,rax
   13876:	call   QWORD PTR [rip+0x4ff4]        # 0x18870
   1387c:	mov    rcx,QWORD PTR [rip+0x5625]        # 0x18ea8
   13883:	mov    rdx,rdi
   13886:	mov    r8,QWORD PTR [rax+0x10]
   1388a:	mov    rbx,rax
   1388d:	call   QWORD PTR [rip+0x5255]        # 0x18ae8
   13893:	mov    rcx,QWORD PTR [rip+0x560e]        # 0x18ea8
   1389a:	test   eax,eax
   1389c:	je     0x138ac
   1389e:	mov    r8d,eax
   138a1:	mov    rdx,rdi
   138a4:	call   QWORD PTR [rip+0x51ae]        # 0x18a58
   138aa:	jmp    0x138b6
   138ac:	mov    rdx,QWORD PTR [rbx+0x30]
   138b0:	call   QWORD PTR [rip+0x4cea]        # 0x185a0
   138b6:	mov    rbx,QWORD PTR [rsp+0x30]
   138bb:	add    rsp,0x20
   138bf:	pop    rdi
   138c0:	ret
   138c1:	int3
   138c2:	int3
   138c3:	int3
   138c4:	int3
   138c5:	int3
   138c6:	int3
   138c7:	int3
   138c8:	mov    QWORD PTR [rsp+0x8],rbx
   138cd:	mov    QWORD PTR [rsp+0x10],rsi
   138d2:	push   rdi
   138d3:	sub    rsp,0x20
   138d7:	mov    rsi,rdx
   138da:	mov    rdx,rcx
   138dd:	mov    rcx,QWORD PTR [rip+0x55c4]        # 0x18ea8
   138e4:	mov    rdi,r8
   138e7:	call   QWORD PTR [rip+0x4e1b]        # 0x18708
   138ed:	mov    r8,QWORD PTR [rip+0x48dc]        # 0x181d0
   138f4:	mov    rcx,QWORD PTR [rip+0x55ad]        # 0x18ea8
   138fb:	mov    rdx,rax
   138fe:	call   QWORD PTR [rip+0x4f6c]        # 0x18870
   13904:	mov    rcx,QWORD PTR [rip+0x559d]        # 0x18ea8
   1390b:	mov    rdx,rsi
   1390e:	mov    r8,QWORD PTR [rax+0x18]
   13912:	add    DWORD PTR [rax+0x174],edi
   13918:	mov    rbx,rax
   1391b:	call   QWORD PTR [rip+0x51c7]        # 0x18ae8
   13921:	mov    rcx,QWORD PTR [rip+0x5580]        # 0x18ea8
   13928:	test   eax,eax
   1392a:	je     0x13940
   1392c:	mov    r8d,eax
   1392f:	mov    rdx,rsi
   13932:	call   QWORD PTR [rip+0x5120]        # 0x18a58
   13938:	sub    DWORD PTR [rbx+0x174],edi
   1393e:	jmp    0x1394a
   13940:	mov    rdx,QWORD PTR [rbx+0x38]
   13944:	call   QWORD PTR [rip+0x4c56]        # 0x185a0
   1394a:	mov    rbx,QWORD PTR [rsp+0x30]
   1394f:	mov    rsi,QWORD PTR [rsp+0x38]
   13954:	add    rsp,0x20
   13958:	pop    rdi
   13959:	ret
   1395a:	int3
   1395b:	int3
   1395c:	int3
   1395d:	int3
   1395e:	int3
   1395f:	int3
   13960:	mov    rcx,QWORD PTR [rip+0x5541]        # 0x18ea8
   13967:	xor    r9d,r9d
   1396a:	mov    r8d,0xc0000120
   13970:	rex.W jmp QWORD PTR [rip+0x50f1]        # 0x18a68
   13977:	int3
   13978:	int3
   13979:	int3
   1397a:	int3
   1397b:	int3
   1397c:	int3
   1397d:	int3
   1397e:	int3
   1397f:	int3
   13980:	mov    QWORD PTR [rsp+0x8],rbx
   13985:	mov    QWORD PTR [rsp+0x10],rbp
   1398a:	mov    QWORD PTR [rsp+0x18],rsi
   1398f:	push   rdi
   13990:	sub    rsp,0x20
   13994:	mov    edi,r8d
   13997:	mov    r8,QWORD PTR [rip+0x47e2]        # 0x18180
   1399e:	mov    rbx,rcx
   139a1:	mov    rcx,QWORD PTR [rip+0x5500]        # 0x18ea8
   139a8:	mov    rsi,rdx
   139ab:	call   QWORD PTR [rip+0x4ebf]        # 0x18870
   139b1:	mov    rcx,QWORD PTR [rip+0x54f0]        # 0x18ea8
   139b8:	mov    rdx,rbx
   139bb:	mov    rbp,rax
   139be:	call   QWORD PTR [rip+0x4d44]        # 0x18708
   139c4:	mov    r8,QWORD PTR [rip+0x4805]        # 0x181d0
   139cb:	mov    rcx,QWORD PTR [rip+0x54d6]        # 0x18ea8
   139d2:	mov    rdx,rax
   139d5:	call   QWORD PTR [rip+0x4e95]        # 0x18870
   139db:	bt     edi,0x1c
   139df:	jae    0x139f4
   139e1:	cmp    QWORD PTR [rbp+0x8],0x0
   139e6:	je     0x139f0
   139e8:	mov    rcx,rsi
   139eb:	call   0x11118
   139f0:	btr    edi,0x1c
   139f4:	test   dil,0x2
   139f8:	je     0x13a0c
   139fa:	mov    rcx,QWORD PTR [rip+0x54a7]        # 0x18ea8
   13a01:	mov    rdx,rsi
   13a04:	call   QWORD PTR [rip+0x5026]        # 0x18a30
   13a0a:	jmp    0x13a25
   13a0c:	test   dil,0x1
   13a10:	je     0x13a25
   13a12:	mov    rcx,QWORD PTR [rip+0x548f]        # 0x18ea8
   13a19:	xor    r8d,r8d
   13a1c:	mov    rdx,rsi
   13a1f:	call   QWORD PTR [rip+0x50db]        # 0x18b00
   13a25:	mov    rbx,QWORD PTR [rsp+0x30]
   13a2a:	mov    rbp,QWORD PTR [rsp+0x38]
   13a2f:	mov    rsi,QWORD PTR [rsp+0x40]
   13a34:	add    rsp,0x20
   13a38:	pop    rdi
   13a39:	ret
   13a3a:	int3
   13a3b:	int3
   13a3c:	int3
   13a3d:	int3
   13a3e:	int3
   13a3f:	int3
   13a40:	rex push rbx
   13a42:	sub    rsp,0x20
   13a46:	mov    r8,QWORD PTR [rip+0x4733]        # 0x18180
   13a4d:	mov    rcx,QWORD PTR [rip+0x5454]        # 0x18ea8
   13a54:	mov    rbx,rdx
   13a57:	call   QWORD PTR [rip+0x4e13]        # 0x18870
   13a5d:	mov    rdx,QWORD PTR [rax+0x8]
   13a61:	test   rdx,rdx
   13a64:	je     0x13a6e
   13a66:	mov    rcx,rbx
   13a69:	call   0x11098
   13a6e:	add    rsp,0x20
   13a72:	pop    rbx
   13a73:	ret
   13a74:	int3
   13a75:	int3
   13a76:	int3
   13a77:	int3
   13a78:	int3
   13a79:	int3
   13a7a:	int3
   13a7b:	int3
   13a7c:	mov    QWORD PTR [rsp+0x8],rbx
   13a81:	push   rdi
   13a82:	sub    rsp,0x60
   13a86:	mov    rdx,rcx
   13a89:	mov    rcx,QWORD PTR [rip+0x5418]        # 0x18ea8
   13a90:	call   QWORD PTR [rip+0x4b1a]        # 0x185b0
   13a96:	mov    r8,QWORD PTR [rip+0x4733]        # 0x181d0
   13a9d:	mov    rcx,QWORD PTR [rip+0x5404]        # 0x18ea8
   13aa4:	mov    rdx,rax
   13aa7:	call   QWORD PTR [rip+0x4dc3]        # 0x18870
   13aad:	mov    ebx,0x14
   13ab2:	lea    rcx,[rsp+0x40]
   13ab7:	mov    r8,rbx
   13aba:	xor    edx,edx
   13abc:	mov    rdi,rax
   13abf:	call   0x15160
   13ac4:	mov    rcx,QWORD PTR [rip+0x53dd]        # 0x18ea8
   13acb:	mov    DWORD PTR [rsp+0x40],ebx
   13acf:	mov    rdx,QWORD PTR [rdi+0x80]
   13ad6:	lea    r8,[rsp+0x40]
   13adb:	call   QWORD PTR [rip+0x51e7]        # 0x18cc8
   13ae1:	lea    ecx,[rbx-0x13]
   13ae4:	xor    ebx,ebx
   13ae6:	xchg   DWORD PTR [rdi+0xe0],ecx
   13aec:	cmp    ecx,ebx
   13aee:	jne    0x13cc5
   13af4:	jmp    0x13c94
   13af9:	mov    rdx,QWORD PTR [rsp+0x78]
   13afe:	mov    rcx,QWORD PTR [rip+0x53a3]        # 0x18ea8
   13b05:	lea    r8,[rsp+0x88]
   13b0d:	call   QWORD PTR [rip+0x4f65]        # 0x18a78
   13b13:	mov    rcx,QWORD PTR [rip+0x538e]        # 0x18ea8
   13b1a:	cmp    eax,ebx
   13b1c:	jne    0x13c86
   13b22:	mov    rdx,QWORD PTR [rsp+0x88]
   13b2a:	lea    r8,[rsp+0x80]
   13b32:	call   QWORD PTR [rip+0x4cf8]        # 0x18830
   13b38:	mov    ecx,DWORD PTR [rsp+0x80]
   13b3f:	sub    DWORD PTR [rdi+0x174],ecx
   13b45:	cmp    rax,rbx
   13b48:	jne    0x13b5c
   13b4a:	mov    r8d,0xc000000d
   13b50:	mov    rcx,QWORD PTR [rip+0x5351]        # 0x18ea8
   13b57:	jmp    0x13c89
   13b5c:	mov    rax,QWORD PTR [rsp+0x80]
   13b64:	cmp    rax,rbx
   13b67:	jne    0x13b6e
   13b69:	xor    r8d,r8d
   13b6c:	jmp    0x13b50
   13b6e:	cmp    BYTE PTR [rdi+0x1db],bl
   13b74:	je     0x13b99
   13b76:	cmp    DWORD PTR [rsp+0x44],ebx
   13b7a:	je     0x13b93
   13b7c:	mov    ecx,DWORD PTR [rsp+0x44]
   13b80:	xor    edx,edx
   13b82:	div    rcx
   13b85:	cmp    rdx,rbx
   13b88:	jne    0x13b93
   13b8a:	mov    BYTE PTR [rdi+0xcc],0x1
   13b91:	jmp    0x13b99
   13b93:	mov    BYTE PTR [rdi+0xcc],bl
   13b99:	mov    r9,QWORD PTR [rsp+0x88]
   13ba1:	mov    r8,QWORD PTR [rsp+0x78]
   13ba6:	mov    rdx,QWORD PTR [rdi+0x80]
   13bad:	mov    rcx,QWORD PTR [rip+0x52f4]        # 0x18ea8
   13bb4:	mov    QWORD PTR [rsp+0x20],rbx
   13bb9:	call   QWORD PTR [rip+0x5139]        # 0x18cf8
   13bbf:	mov    rcx,QWORD PTR [rip+0x52e2]        # 0x18ea8
   13bc6:	cmp    eax,ebx
   13bc8:	je     0x13bd5
   13bca:	mov    BYTE PTR [rdi+0xcc],bl
   13bd0:	jmp    0x13c86
   13bd5:	mov    rax,QWORD PTR [rsp+0x78]
   13bda:	lea    r8,[rip+0x707]        # 0x142e8
   13be1:	mov    r9,rdi
   13be4:	mov    QWORD PTR [rdi+0x120],rax
   13beb:	mov    rdx,QWORD PTR [rsp+0x78]
   13bf0:	call   QWORD PTR [rip+0x4e4a]        # 0x18a40
   13bf6:	mov    r11d,DWORD PTR [rdi+0x1b8]
   13bfd:	mov    eax,DWORD PTR [rdi+0x1bc]
   13c03:	imul   r11,QWORD PTR [rsp+0x80]
   13c0c:	add    r11,rax
   13c0f:	jne    0x13c16
   13c11:	mov    r9,rbx
   13c14:	jmp    0x13c43
   13c16:	xor    eax,eax
   13c18:	imul   r11,r11,0xffffffffffffd8f0
   13c1f:	lea    r9,[rsp+0x30]
   13c24:	mov    QWORD PTR [rsp+0x30],rax
   13c29:	mov    QWORD PTR [rsp+0x38],rax
   13c2e:	mov    QWORD PTR [rsp+0x38],r11
   13c33:	mov    DWORD PTR [rsp+0x30],0x10
   13c3b:	mov    DWORD PTR [rsp+0x34],0x1
   13c43:	mov    r8,QWORD PTR [rdi+0x80]
   13c4a:	mov    rdx,QWORD PTR [rsp+0x78]
   13c4f:	mov    rcx,QWORD PTR [rip+0x5252]        # 0x18ea8
   13c56:	call   QWORD PTR [rip+0x4dac]        # 0x18a08
   13c5c:	cmp    al,bl
   13c5e:	jne    0x13cc5
   13c60:	mov    rcx,QWORD PTR [rip+0x5241]        # 0x18ea8
   13c67:	mov    BYTE PTR [rdi+0xcc],bl
   13c6d:	mov    QWORD PTR [rdi+0x120],rbx
   13c74:	mov    rdx,QWORD PTR [rsp+0x78]
   13c79:	call   QWORD PTR [rip+0x4d91]        # 0x18a10
   13c7f:	mov    rcx,QWORD PTR [rip+0x5222]        # 0x18ea8
   13c86:	mov    r8d,eax
   13c89:	mov    rdx,QWORD PTR [rsp+0x78]
   13c8e:	call   QWORD PTR [rip+0x4dc4]        # 0x18a58
   13c94:	mov    rdx,QWORD PTR [rdi+0x18]
   13c98:	mov    rcx,QWORD PTR [rip+0x5209]        # 0x18ea8
   13c9f:	lea    r8,[rsp+0x78]
   13ca4:	call   QWORD PTR [rip+0x4a66]        # 0x18710
   13caa:	cmp    eax,ebx
   13cac:	je     0x13af9
   13cb2:	xchg   DWORD PTR [rdi+0xe0],ebx
   13cb8:	mov    edx,0x4
   13cbd:	mov    rcx,rdi
   13cc0:	call   0x149ec
   13cc5:	mov    rbx,QWORD PTR [rsp+0x70]
   13cca:	add    rsp,0x60
   13cce:	pop    rdi
   13ccf:	ret
   13cd0:	int3
   13cd1:	int3
   13cd2:	int3
   13cd3:	int3
   13cd4:	int3
   13cd5:	int3
   13cd6:	int3
   13cd7:	int3
   13cd8:	rex push rbx
   13cda:	sub    rsp,0x40
   13cde:	mov    rbx,rcx
   13ce1:	lea    rcx,[rsp+0x20]
   13ce6:	mov    r8d,0x14
   13cec:	lea    rdx,[rbx+0x1ac]
   13cf3:	call   0x15e00
   13cf8:	mov    rcx,QWORD PTR [rsp+0x20]
   13cfd:	mov    r8d,DWORD PTR [rsp+0x28]
   13d02:	mov    r11d,DWORD PTR [rbx+0x100]
   13d09:	mov    rax,rcx
   13d0c:	or     r9d,0xffffffff
   13d10:	shr    rax,0x20
   13d14:	mov    edx,r8d
   13d17:	cmp    eax,r9d
   13d1a:	je     0x13d28
   13d1c:	mov    edx,DWORD PTR [rbx+0xf8]
   13d22:	imul   edx,eax
   13d25:	add    edx,r8d
   13d28:	cmp    ecx,r9d
   13d2b:	jne    0x13d3a
   13d2d:	test   r8d,r8d
   13d30:	jne    0x13d3a
   13d32:	test   eax,eax
   13d34:	jne    0x13d3a
   13d36:	xor    ecx,ecx
   13d38:	xor    edx,edx
   13d3a:	neg    r11d
   13d3d:	movabs r9,0xfffff78000000014
   13d47:	movabs r8,0x7fffffffffffffff
   13d51:	sbb    eax,eax
   13d53:	and    eax,ecx
   13d55:	jne    0x13d60
   13d57:	mov    QWORD PTR [rbx+0x108],r8
   13d5e:	jmp    0x13d76
   13d60:	mov    ecx,eax
   13d62:	mov    rax,QWORD PTR [r9]
   13d65:	imul   rcx,rcx,0x2710
   13d6c:	add    rcx,rax
   13d6f:	mov    QWORD PTR [rbx+0x108],rcx
   13d76:	test   edx,edx
   13d78:	jne    0x13d83
   13d7a:	mov    QWORD PTR [rbx+0x110],r8
   13d81:	jmp    0x13d99
   13d83:	mov    rax,QWORD PTR [r9]
   13d86:	mov    ecx,edx
   13d88:	imul   rcx,rcx,0x2710
   13d8f:	add    rcx,rax
   13d92:	mov    QWORD PTR [rbx+0x110],rcx
   13d99:	add    rsp,0x40
   13d9d:	pop    rbx
   13d9e:	ret
   13d9f:	int3
   13da0:	int3
   13da1:	int3
   13da2:	int3
   13da3:	int3
   13da4:	int3
   13da5:	int3
   13da6:	int3
   13da7:	int3
   13da8:	mov    QWORD PTR [rsp+0x8],rbx
   13dad:	push   rdi
   13dae:	sub    rsp,0x20
   13db2:	mov    r8,QWORD PTR [rip+0x43c7]        # 0x18180
   13db9:	mov    rdi,rcx
   13dbc:	mov    rdx,rcx
   13dbf:	mov    rcx,QWORD PTR [rip+0x50e2]        # 0x18ea8
   13dc6:	call   QWORD PTR [rip+0x4aa4]        # 0x18870
   13dcc:	mov    r8,QWORD PTR [rip+0x43fd]        # 0x181d0
   13dd3:	mov    rcx,QWORD PTR [rip+0x50ce]        # 0x18ea8
   13dda:	mov    rdx,QWORD PTR [rax]
   13ddd:	call   QWORD PTR [rip+0x4a8d]        # 0x18870
   13de3:	mov    rcx,QWORD PTR [rip+0x50be]        # 0x18ea8
   13dea:	mov    r8d,0xc0000120
   13df0:	mov    rbx,rax
   13df3:	xor    eax,eax
   13df5:	mov    rdx,rdi
   13df8:	mov    QWORD PTR [rbx+0xe8],rax
   13dff:	mov    QWORD PTR [rbx+0xf0],rax
   13e06:	mov    QWORD PTR [rbx+0x100],rax
   13e0d:	mov    QWORD PTR [rbx+0xf8],rax
   13e14:	movabs rax,0x7fffffffffffffff
   13e1e:	mov    QWORD PTR [rbx+0x108],rax
   13e25:	mov    QWORD PTR [rbx+0x110],rax
   13e2c:	call   QWORD PTR [rip+0x4c26]        # 0x18a58
   13e32:	mov    rdx,QWORD PTR [rbx+0x30]
   13e36:	mov    rcx,QWORD PTR [rip+0x506b]        # 0x18ea8
   13e3d:	mov    rbx,QWORD PTR [rsp+0x30]
   13e42:	add    rsp,0x20
   13e46:	pop    rdi
   13e47:	rex.W jmp QWORD PTR [rip+0x4752]        # 0x185a0
   13e4e:	int3
   13e4f:	int3
   13e50:	int3
   13e51:	int3
   13e52:	int3
   13e53:	int3
   13e54:	mov    QWORD PTR [rsp+0x8],rbx
   13e59:	mov    QWORD PTR [rsp+0x18],rsi
   13e5e:	push   rdi
   13e5f:	sub    rsp,0x50
   13e63:	mov    rdx,rcx
   13e66:	mov    rcx,QWORD PTR [rip+0x503b]        # 0x18ea8
   13e6d:	call   QWORD PTR [rip+0x473d]        # 0x185b0
   13e73:	mov    r8,QWORD PTR [rip+0x4356]        # 0x181d0
   13e7a:	mov    rcx,QWORD PTR [rip+0x5027]        # 0x18ea8
   13e81:	mov    rdx,rax
   13e84:	call   QWORD PTR [rip+0x49e6]        # 0x18870
   13e8a:	mov    sil,BYTE PTR [rsp+0x68]
   13e8f:	mov    rbx,rax
   13e92:	cmp    QWORD PTR [rbx+0xe8],0x0
   13e9a:	je     0x14045
   13ea0:	mov    rcx,QWORD PTR [rbx+0xf8]
   13ea7:	sub    rcx,QWORD PTR [rbx+0x100]
   13eae:	je     0x13f01
   13eb0:	mov    rax,QWORD PTR [rbx+0x138]
   13eb7:	cmp    QWORD PTR [rbx+0x130],rax
   13ebe:	je     0x13f01
   13ec0:	mov    sil,BYTE PTR [rax]
   13ec3:	inc    rax
   13ec6:	cmp    rax,QWORD PTR [rbx+0x140]
   13ecd:	jb     0x13ed6
   13ecf:	mov    rax,QWORD PTR [rbx+0x128]
   13ed6:	mov    QWORD PTR [rbx+0x138],rax
   13edd:	mov    rax,QWORD PTR [rbx+0xf0]
   13ee4:	mov    BYTE PTR [rax],sil
   13ee7:	inc    QWORD PTR [rbx+0xf0]
   13eee:	inc    QWORD PTR [rbx+0x100]
   13ef5:	dec    DWORD PTR [rbx+0x170]
   13efb:	sub    rcx,0x1
   13eff:	jne    0x13eb0
   13f01:	mov    rdx,QWORD PTR [rbx+0x138]
   13f08:	mov    rax,QWORD PTR [rbx+0x130]
   13f0f:	cmp    rdx,rax
   13f12:	ja     0x13f19
   13f14:	sub    rax,rdx
   13f17:	jmp    0x13f2d
   13f19:	mov    rcx,QWORD PTR [rbx+0x140]
   13f20:	sub    rcx,QWORD PTR [rbx+0x128]
   13f27:	sub    rcx,rdx
   13f2a:	add    rax,rcx
   13f2d:	mov    rcx,QWORD PTR [rbx+0x140]
   13f34:	imul   rax,rax,0x64
   13f38:	xor    edx,edx
   13f3a:	sub    rcx,QWORD PTR [rbx+0x128]
   13f41:	div    rcx
   13f44:	cmp    rax,0x32
   13f48:	jae    0x13f5f
   13f4a:	xor    eax,eax
   13f4c:	xchg   DWORD PTR [rbx+0x158],eax
   13f52:	cmp    eax,0x1
   13f55:	jne    0x13f5f
   13f57:	mov    rcx,rbx
   13f5a:	call   0x129ac
   13f5f:	mov    rdi,QWORD PTR [rbx+0x100]
   13f66:	cmp    rdi,QWORD PTR [rbx+0xf8]
   13f6d:	jae    0x13fc4
   13f6f:	lea    rcx,[rsp+0x30]
   13f74:	lea    rdx,[rbx+0x1ac]
   13f7b:	mov    r8d,0x14
   13f81:	call   0x15e00
   13f86:	mov    r11,QWORD PTR [rsp+0x30]
   13f8b:	cmp    r11d,0xffffffff
   13f8f:	jne    0x140fe
   13f95:	mov    eax,DWORD PTR [rsp+0x38]
   13f99:	shr    r11,0x20
   13f9d:	test   r11d,r11d
   13fa0:	jne    0x13fa6
   13fa2:	test   eax,eax
   13fa4:	je     0x13fc4
   13fa6:	cmp    r11d,0xffffffff
   13faa:	jne    0x140fe
   13fb0:	dec    eax
   13fb2:	cmp    eax,0xfffffffd
   13fb5:	ja     0x140fe
   13fbb:	test   rdi,rdi
   13fbe:	je     0x140fe
   13fc4:	mov    rax,QWORD PTR [rbx+0xe8]
   13fcb:	mov    rcx,QWORD PTR [rip+0x4ed6]        # 0x18ea8
   13fd2:	mov    QWORD PTR [rsp+0x68],rax
   13fd7:	and    QWORD PTR [rbx+0xe8],0x0
   13fdf:	mov    rdx,QWORD PTR [rsp+0x68]
   13fe4:	call   QWORD PTR [rip+0x4a36]        # 0x18a20
   13fea:	test   eax,eax
   13fec:	js     0x1400c
   13fee:	mov    r9,QWORD PTR [rbx+0x100]
   13ff5:	mov    rdx,QWORD PTR [rsp+0x68]
   13ffa:	mov    rcx,QWORD PTR [rip+0x4ea7]        # 0x18ea8
   14001:	xor    r8d,r8d
   14004:	call   QWORD PTR [rip+0x4a5e]        # 0x18a68
   1400a:	jmp    0x14028
   1400c:	cmp    eax,0xc0000120
   14011:	je     0x14028
   14013:	mov    rdx,QWORD PTR [rsp+0x68]
   14018:	mov    rcx,QWORD PTR [rip+0x4e89]        # 0x18ea8
   1401f:	mov    r8d,eax
   14022:	call   QWORD PTR [rip+0x4a30]        # 0x18a58
   14028:	and    QWORD PTR [rbx+0xf8],0x0
   14030:	and    QWORD PTR [rbx+0x100],0x0
   14038:	and    QWORD PTR [rbx+0xf0],0x0
   14040:	jmp    0x13e92
   14045:	mov    rdx,QWORD PTR [rbx+0x10]
   14049:	mov    rcx,QWORD PTR [rip+0x4e58]        # 0x18ea8
   14050:	lea    r8,[rsp+0x68]
   14055:	call   QWORD PTR [rip+0x46b5]        # 0x18710
   1405b:	test   eax,eax
   1405d:	jne    0x14106
   14063:	mov    rdx,QWORD PTR [rsp+0x68]
   14068:	mov    rcx,QWORD PTR [rip+0x4e39]        # 0x18ea8
   1406f:	lea    rax,[rbx+0xf8]
   14076:	lea    r9,[rbx+0xf0]
   1407d:	mov    r8d,0x1
   14083:	mov    QWORD PTR [rsp+0x20],rax
   14088:	call   QWORD PTR [rip+0x4a02]        # 0x18a90
   1408e:	test   eax,eax
   14090:	je     0x140ac
   14092:	mov    rdx,QWORD PTR [rsp+0x68]
   14097:	mov    rcx,QWORD PTR [rip+0x4e0a]        # 0x18ea8
   1409e:	mov    r8d,eax
   140a1:	call   QWORD PTR [rip+0x49b1]        # 0x18a58
   140a7:	jmp    0x13e92
   140ac:	mov    r8,QWORD PTR [rip+0x40cd]        # 0x18180
   140b3:	mov    rdx,QWORD PTR [rsp+0x68]
   140b8:	mov    rcx,QWORD PTR [rip+0x4de9]        # 0x18ea8
   140bf:	call   QWORD PTR [rip+0x47ab]        # 0x18870
   140c5:	lea    rdx,[rip+0xfffffffffffffcdc]        # 0x13da8
   140cc:	and    QWORD PTR [rax],0x0
   140d0:	and    QWORD PTR [rax+0x8],0x0
   140d5:	and    DWORD PTR [rax+0x10],0x0
   140d9:	mov    rcx,QWORD PTR [rbx]
   140dc:	mov    QWORD PTR [rax],rcx
   140df:	mov    rcx,QWORD PTR [rsp+0x68]
   140e4:	call   0x11098
   140e9:	test   eax,eax
   140eb:	jne    0x14092
   140ed:	mov    rax,QWORD PTR [rsp+0x68]
   140f2:	mov    QWORD PTR [rbx+0xe8],rax
   140f9:	jmp    0x13e92
   140fe:	mov    rcx,rbx
   14101:	call   0x13cd8
   14106:	mov    rbx,QWORD PTR [rsp+0x60]
   1410b:	mov    rsi,QWORD PTR [rsp+0x70]
   14110:	add    rsp,0x50
   14114:	pop    rdi
   14115:	ret
   14116:	int3
   14117:	int3
   14118:	int3
   14119:	int3
   1411a:	int3
   1411b:	int3
   1411c:	mov    al,0x1
   1411e:	ret
   1411f:	int3
   14120:	int3
   14121:	int3
   14122:	int3
   14123:	int3
   14124:	int3
   14125:	int3
   14126:	int3
   14127:	int3
   14128:	mov    rax,rsp
   1412b:	mov    QWORD PTR [rax+0x8],rbx
   1412f:	mov    QWORD PTR [rax+0x10],rbp
   14133:	mov    QWORD PTR [rax+0x18],rsi
   14137:	mov    QWORD PTR [rax+0x20],rdi
   1413b:	push   r12
   1413d:	sub    rsp,0x20
   14141:	mov    rcx,QWORD PTR [rip+0x4d60]        # 0x18ea8
   14148:	mov    rbx,rdx
   1414b:	mov    rdx,QWORD PTR [r9]
   1414e:	mov    rdi,r9
   14151:	mov    rbp,r8
   14154:	xor    esi,esi
   14156:	call   QWORD PTR [rip+0x4a74]        # 0x18bd0
   1415c:	mov    rcx,QWORD PTR [rip+0x4d45]        # 0x18ea8
   14163:	xor    r8d,r8d
   14166:	mov    rdx,rbx
   14169:	call   QWORD PTR [rip+0x46c1]        # 0x18830
   1416f:	xor    ebx,ebx
   14171:	mov    r12,rax
   14174:	test   rbp,rbp
   14177:	je     0x14245
   1417d:	mov    rcx,QWORD PTR [rdi+0x130]
   14184:	mov    dl,BYTE PTR [r12]
   14188:	lea    rax,[rcx+0x1]
   1418c:	cmp    rax,QWORD PTR [rdi+0x140]
   14193:	jb     0x1419c
   14195:	mov    rax,QWORD PTR [rdi+0x128]
   1419c:	cmp    rax,QWORD PTR [rdi+0x138]
   141a3:	je     0x1423b
   141a9:	mov    BYTE PTR [rcx],dl
   141ab:	mov    rax,QWORD PTR [rdi+0x130]
   141b2:	inc    rax
   141b5:	cmp    rax,QWORD PTR [rdi+0x140]
   141bc:	jb     0x141c5
   141be:	mov    rax,QWORD PTR [rdi+0x128]
   141c5:	mov    QWORD PTR [rdi+0x130],rax
   141cc:	mov    al,BYTE PTR [rdi+0x163]
   141d2:	inc    DWORD PTR [rdi+0x194]
   141d8:	inc    DWORD PTR [rdi+0x170]
   141de:	cmp    dl,al
   141e0:	jne    0x141e9
   141e2:	test   al,al
   141e4:	je     0x141e9
   141e6:	or     esi,0x2
   141e9:	movsx  ecx,BYTE PTR [rip+0x2140]        # 0x16330
   141f0:	movzx  eax,dl
   141f3:	cmp    eax,ecx
   141f5:	jne    0x1422b
   141f7:	mov    rax,rbp
   141fa:	sub    rax,rbx
   141fd:	cmp    rax,0x7
   14201:	jb     0x1422b
   14203:	lea    rdx,[rip+0x2126]        # 0x16330
   1420a:	mov    r8d,0x7
   14210:	mov    rcx,r12
   14213:	call   QWORD PTR [rip+0x2e27]        # 0x17040
   14219:	test   eax,eax
   1421b:	jne    0x1422b
   1421d:	mov    BYTE PTR [rdi+0x1c7],0x1
   14224:	mov    BYTE PTR [rdi+0x1c8],0x1
   1422b:	inc    rbx
   1422e:	inc    r12
   14231:	cmp    rbx,rbp
   14234:	jae    0x14245
   14236:	jmp    0x1417d
   1423b:	mov    eax,ebp
   1423d:	sub    eax,ebx
   1423f:	add    DWORD PTR [rdi+0x1a4],eax
   14245:	mov    rdx,QWORD PTR [rdi+0x138]
   1424c:	mov    rax,QWORD PTR [rdi+0x130]
   14253:	cmp    rdx,rax
   14256:	ja     0x1425d
   14258:	sub    rax,rdx
   1425b:	jmp    0x14271
   1425d:	mov    rcx,QWORD PTR [rdi+0x140]
   14264:	sub    rcx,rdx
   14267:	sub    rcx,QWORD PTR [rdi+0x128]
   1426e:	add    rax,rcx
   14271:	mov    rcx,QWORD PTR [rdi+0x140]
   14278:	imul   rax,rax,0x64
   1427c:	xor    edx,edx
   1427e:	sub    rcx,QWORD PTR [rdi+0x128]
   14285:	div    rcx
   14288:	cmp    rax,0x50
   1428c:	jb     0x14292
   1428e:	bts    esi,0xa
   14292:	test   rbp,rbp
   14295:	je     0x1429a
   14297:	or     esi,0x1
   1429a:	mov    edx,esi
   1429c:	mov    rcx,rdi
   1429f:	call   0x149ec
   142a4:	mov    rdx,QWORD PTR [rdi]
   142a7:	mov    rcx,QWORD PTR [rip+0x4bfa]        # 0x18ea8
   142ae:	call   QWORD PTR [rip+0x4924]        # 0x18bd8
   142b4:	mov    rdx,QWORD PTR [rdi+0x30]
   142b8:	mov    rcx,QWORD PTR [rip+0x4be9]        # 0x18ea8
   142bf:	mov    rbx,QWORD PTR [rsp+0x30]
   142c4:	mov    rbp,QWORD PTR [rsp+0x38]
   142c9:	mov    rsi,QWORD PTR [rsp+0x40]
   142ce:	mov    rdi,QWORD PTR [rsp+0x48]
   142d3:	add    rsp,0x20
   142d7:	pop    r12
   142d9:	rex.W jmp QWORD PTR [rip+0x42c0]        # 0x185a0
   142e0:	int3
   142e1:	int3
   142e2:	int3
   142e3:	int3
   142e4:	int3
   142e5:	int3
   142e6:	int3
   142e7:	int3
   142e8:	mov    QWORD PTR [rsp+0x8],rbx
   142ed:	mov    QWORD PTR [rsp+0x10],rbp
   142f2:	mov    QWORD PTR [rsp+0x18],rsi
   142f7:	push   rdi
   142f8:	sub    rsp,0x20
   142fc:	mov    rbp,QWORD PTR [r9+0x120]
   14303:	mov    eax,DWORD PTR [r8+0x10]
   14307:	xor    edi,edi
   14309:	mov    rbx,r9
   1430c:	mov    rsi,r8
   1430f:	cmp    DWORD PTR [r8+0x8],edi
   14313:	jne    0x1431e
   14315:	add    DWORD PTR [r9+0x198],eax
   1431c:	jmp    0x14325
   1431e:	add    DWORD PTR [r9+0x1a0],eax
   14325:	mov    rdx,QWORD PTR [r9+0xd0]
   1432c:	cmp    rcx,rdx
   1432f:	jne    0x14391
   14331:	mov    rcx,QWORD PTR [rip+0x4b70]        # 0x18ea8
   14338:	call   QWORD PTR [rip+0x4562]        # 0x188a0
   1433e:	mov    QWORD PTR [rbx+0xd0],rdi
   14345:	cmp    rbp,rdi
   14348:	je     0x14388
   1434a:	mov    r8,QWORD PTR [rip+0x3e2f]        # 0x18180
   14351:	mov    rcx,QWORD PTR [rip+0x4b50]        # 0x18ea8
   14358:	mov    rdx,rbp
   1435b:	call   QWORD PTR [rip+0x450f]        # 0x18870
   14361:	mov    rcx,QWORD PTR [rip+0x4b40]        # 0x18ea8
   14368:	mov    rdx,rbp
   1436b:	cmp    rax,rdi
   1436e:	je     0x1437a
   14370:	mov    r9,QWORD PTR [rax+0x18]
   14374:	mov    r8d,DWORD PTR [rax+0x20]
   14378:	jmp    0x14382
   1437a:	mov    r9,QWORD PTR [rsi+0x10]
   1437e:	mov    r8d,DWORD PTR [rsi+0x8]
   14382:	call   QWORD PTR [rip+0x46e0]        # 0x18a68
   14388:	mov    QWORD PTR [rbx+0x120],rdi
   1438f:	jmp    0x143f2
   14391:	cmp    BYTE PTR [r9+0xcc],dil
   14398:	je     0x143d3
   1439a:	cmp    rbp,rdi
   1439d:	je     0x143c9
   1439f:	mov    r8,QWORD PTR [rip+0x3dda]        # 0x18180
   143a6:	mov    rcx,QWORD PTR [rip+0x4afb]        # 0x18ea8
   143ad:	mov    rdx,rbp
   143b0:	call   QWORD PTR [rip+0x44ba]        # 0x18870
   143b6:	cmp    rax,rdi
   143b9:	je     0x143c9
   143bb:	mov    ecx,DWORD PTR [rsi+0x8]
   143be:	mov    DWORD PTR [rax+0x20],ecx
   143c1:	mov    rcx,QWORD PTR [rsi+0x10]
   143c5:	mov    QWORD PTR [rax+0x18],rcx
   143c9:	mov    rcx,rbx
   143cc:	call   0x145c4
   143d1:	jmp    0x14409
   143d3:	mov    QWORD PTR [r9+0x120],rdi
   143da:	mov    r9,QWORD PTR [r8+0x10]
   143de:	mov    r8d,DWORD PTR [r8+0x8]
   143e2:	mov    rdx,rcx
   143e5:	mov    rcx,QWORD PTR [rip+0x4abc]        # 0x18ea8
   143ec:	call   QWORD PTR [rip+0x4676]        # 0x18a68
   143f2:	xchg   DWORD PTR [rbx+0xe0],edi
   143f8:	mov    rdx,QWORD PTR [rbx+0x38]
   143fc:	mov    rcx,QWORD PTR [rip+0x4aa5]        # 0x18ea8
   14403:	call   QWORD PTR [rip+0x4197]        # 0x185a0
   14409:	mov    rbx,QWORD PTR [rsp+0x30]
   1440e:	mov    rbp,QWORD PTR [rsp+0x38]
   14413:	mov    rsi,QWORD PTR [rsp+0x40]
   14418:	add    rsp,0x20
   1441c:	pop    rdi
   1441d:	ret
   1441e:	int3
   1441f:	int3
   14420:	int3
   14421:	int3
   14422:	int3
   14423:	int3
   14424:	mov    QWORD PTR [rsp+0x8],rbx
   14429:	mov    QWORD PTR [rsp+0x10],rbp
   1442e:	mov    QWORD PTR [rsp+0x18],rsi
   14433:	push   rdi
   14434:	sub    rsp,0x50
   14438:	mov    rsi,r8
   1443b:	mov    r8,QWORD PTR [rip+0x3d66]        # 0x181a8
   14442:	mov    rbp,rcx
   14445:	mov    rdx,rcx
   14448:	mov    rcx,QWORD PTR [rip+0x4a59]        # 0x18ea8
   1444f:	call   QWORD PTR [rip+0x441b]        # 0x18870
   14455:	mov    r8,QWORD PTR [rip+0x3d74]        # 0x181d0
   1445c:	mov    rcx,QWORD PTR [rip+0x4a45]        # 0x18ea8
   14463:	mov    rdx,QWORD PTR [rax]
   14466:	mov    rdi,rax
   14469:	call   QWORD PTR [rip+0x4401]        # 0x18870
   1446f:	cmp    DWORD PTR [rsi+0x8],0x0
   14473:	mov    rbx,rax
   14476:	jne    0x1458c
   1447c:	mov    r8,QWORD PTR [rsi+0x10]
   14480:	mov    rdx,QWORD PTR [rdi+0x8]
   14484:	mov    rcx,QWORD PTR [rax+0x88]
   1448b:	mov    r9,rax
   1448e:	call   0x14128
   14493:	mov    rdx,QWORD PTR [rbx+0x138]
   1449a:	mov    rax,QWORD PTR [rbx+0x130]
   144a1:	cmp    rdx,rax
   144a4:	ja     0x144ab
   144a6:	sub    rax,rdx
   144a9:	jmp    0x144bf
   144ab:	mov    rcx,QWORD PTR [rbx+0x140]
   144b2:	sub    rcx,rdx
   144b5:	sub    rcx,QWORD PTR [rbx+0x128]
   144bc:	add    rax,rcx
   144bf:	mov    rcx,QWORD PTR [rbx+0x140]
   144c6:	imul   rax,rax,0x64
   144ca:	xor    edx,edx
   144cc:	sub    rcx,QWORD PTR [rbx+0x128]
   144d3:	div    rcx
   144d6:	cmp    rax,0x32
   144da:	jae    0x1458c
   144e0:	mov    rcx,QWORD PTR [rip+0x49c1]        # 0x18ea8
   144e7:	xor    eax,eax
   144e9:	lea    r8,[rsp+0x30]
   144ee:	mov    QWORD PTR [rsp+0x30],rax
   144f3:	and    DWORD PTR [rsp+0x34],eax
   144f7:	mov    QWORD PTR [rsp+0x38],rax
   144fc:	and    DWORD PTR [rsp+0x38],eax
   14500:	mov    rdx,rbp
   14503:	mov    QWORD PTR [rsp+0x40],rax
   14508:	mov    DWORD PTR [rsp+0x30],0x18
   14510:	call   QWORD PTR [rip+0x44d2]        # 0x189e8
   14516:	test   eax,eax
   14518:	jne    0x1458c
   1451a:	mov    r9,QWORD PTR [rdi+0x8]
   1451e:	mov    r8,QWORD PTR [rbx+0xa8]
   14525:	mov    rdx,QWORD PTR [rbx+0x88]
   1452c:	mov    rcx,QWORD PTR [rip+0x4975]        # 0x18ea8
   14533:	and    QWORD PTR [rsp+0x20],0x0
   14539:	call   QWORD PTR [rip+0x47c9]        # 0x18d08
   1453f:	test   eax,eax
   14541:	jne    0x1458c
   14543:	mov    rdx,QWORD PTR [rbx+0xa8]
   1454a:	mov    rcx,QWORD PTR [rip+0x4957]        # 0x18ea8
   14551:	lea    r8,[rip+0xfffffffffffffecc]        # 0x14424
   14558:	mov    r9,rdi
   1455b:	call   QWORD PTR [rip+0x44df]        # 0x18a40
   14561:	cmp    DWORD PTR [rbx+0xdc],0x0
   14568:	jle    0x1458c
   1456a:	mov    r8,QWORD PTR [rbx+0x88]
   14571:	mov    rdx,QWORD PTR [rbx+0xa8]
   14578:	mov    rcx,QWORD PTR [rip+0x4929]        # 0x18ea8
   1457f:	xor    r9d,r9d
   14582:	call   QWORD PTR [rip+0x4480]        # 0x18a08
   14588:	test   al,al
   1458a:	jne    0x145a9
   1458c:	lea    rcx,[rbx+0xb0]
   14593:	xor    r8d,r8d
   14596:	xor    edx,edx
   14598:	call   QWORD PTR [rip+0x2ac2]        # 0x17060
   1459e:	mov    eax,0x1
   145a3:	xchg   DWORD PTR [rbx+0x158],eax
   145a9:	mov    rbx,QWORD PTR [rsp+0x60]
   145ae:	mov    rbp,QWORD PTR [rsp+0x68]
   145b3:	mov    rsi,QWORD PTR [rsp+0x70]
   145b8:	add    rsp,0x50
   145bc:	pop    rdi
   145bd:	ret
   145be:	int3
   145bf:	int3
   145c0:	int3
   145c1:	int3
   145c2:	int3
   145c3:	int3
   145c4:	test   rcx,rcx
   145c7:	je     0x147ac
   145cd:	mov    rax,rsp
   145d0:	mov    QWORD PTR [rax+0x18],rbx
   145d4:	mov    QWORD PTR [rax+0x20],rbp
   145d8:	push   rsi
   145d9:	push   rdi
   145da:	push   r13
   145dc:	sub    rsp,0x80
   145e3:	and    QWORD PTR [rax+0x10],0x0
   145e8:	mov    rdi,rcx
   145eb:	mov    BYTE PTR [rcx+0xcc],0x0
   145f2:	mov    rcx,QWORD PTR [rip+0x48af]        # 0x18ea8
   145f9:	lea    r9,[rax+0x8]
   145fd:	xor    r8d,r8d
   14600:	xor    edx,edx
   14602:	call   QWORD PTR [rip+0x43d0]        # 0x189d8
   14608:	test   eax,eax
   1460a:	js     0x14795
   14610:	mov    rbx,QWORD PTR [rsp+0xa0]
   14618:	mov    rbp,QWORD PTR [rdi+0x80]
   1461f:	mov    esi,0x38
   14624:	lea    rcx,[rsp+0x40]
   14629:	mov    r8,rsi
   1462c:	xor    edx,edx
   1462e:	mov    QWORD PTR [rdi+0xd0],rbx
   14635:	call   0x15160
   1463a:	and    QWORD PTR [rsp+0x30],0x0
   14640:	mov    rcx,QWORD PTR [rip+0x4861]        # 0x18ea8
   14647:	lea    eax,[rsi-0x37]
   1464a:	lea    r13d,[rsi+0x48]
   1464e:	mov    DWORD PTR [rsp+0x58],eax
   14652:	mov    DWORD PTR [rsp+0x5c],eax
   14656:	lea    rax,[rsp+0xa8]
   1465e:	mov    QWORD PTR [rsp+0x28],rax
   14663:	lea    rdx,[rsp+0x40]
   14668:	xor    r9d,r9d
   1466b:	xor    r8d,r8d
   1466e:	mov    QWORD PTR [rsp+0x20],r13
   14673:	mov    DWORD PTR [rsp+0x40],esi
   14677:	mov    QWORD PTR [rsp+0x60],rbx
   1467c:	call   QWORD PTR [rip+0x419e]        # 0x18820
   14682:	mov    ebx,eax
   14684:	test   eax,eax
   14686:	js     0x14779
   1468c:	mov    rdx,QWORD PTR [rsp+0xa8]
   14694:	mov    rcx,QWORD PTR [rip+0x480d]        # 0x18ea8
   1469b:	xor    r8d,r8d
   1469e:	call   QWORD PTR [rip+0x418c]        # 0x18830
   146a4:	mov    rsi,rax
   146a7:	test   rax,rax
   146aa:	je     0x14775
   146b0:	mov    r8,r13
   146b3:	xor    edx,edx
   146b5:	mov    rcx,rax
   146b8:	call   0x15160
   146bd:	mov    rcx,QWORD PTR [rip+0x47e4]        # 0x18ea8
   146c4:	lea    eax,[r13-0x77]
   146c8:	mov    rdx,rbp
   146cb:	mov    WORD PTR [rsi+0x2],ax
   146cf:	mov    WORD PTR [rsi],r13w
   146d3:	call   QWORD PTR [rip+0x46b7]        # 0x18d90
   146d9:	and    QWORD PTR [rsi+0x28],0x0
   146de:	and    QWORD PTR [rsi+0x30],0x0
   146e3:	and    DWORD PTR [rsi+0x24],0x0
   146e7:	and    DWORD PTR [rsi+0x20],0x0
   146eb:	and    QWORD PTR [rsi+0x38],0x0
   146f0:	mov    rcx,QWORD PTR [rip+0x47b1]        # 0x18ea8
   146f7:	and    QWORD PTR [rsp+0x20],0x0
   146fd:	mov    QWORD PTR [rsi+0x18],rax
   14701:	mov    r9,QWORD PTR [rsp+0xa8]
   14709:	mov    r8,QWORD PTR [rsp+0xa0]
   14711:	mov    rdx,rbp
   14714:	call   QWORD PTR [rip+0x4626]        # 0x18d40
   1471a:	mov    ebx,eax
   1471c:	test   eax,eax
   1471e:	js     0x14779
   14720:	mov    rdx,QWORD PTR [rsp+0xa0]
   14728:	mov    rcx,QWORD PTR [rip+0x4779]        # 0x18ea8
   1472f:	lea    r8,[rip+0xfffffffffffffbb2]        # 0x142e8
   14736:	mov    r9,rdi
   14739:	call   QWORD PTR [rip+0x4301]        # 0x18a40
   1473f:	mov    rdx,QWORD PTR [rsp+0xa0]
   14747:	mov    rcx,QWORD PTR [rip+0x475a]        # 0x18ea8
   1474e:	xor    r9d,r9d
   14751:	mov    r8,rbp
   14754:	call   QWORD PTR [rip+0x42ae]        # 0x18a08
   1475a:	test   al,al
   1475c:	jne    0x14775
   1475e:	mov    rdx,QWORD PTR [rsp+0xa0]
   14766:	mov    rcx,QWORD PTR [rip+0x473b]        # 0x18ea8
   1476d:	call   QWORD PTR [rip+0x429d]        # 0x18a10
   14773:	mov    ebx,eax
   14775:	test   ebx,ebx
   14777:	jns    0x14795
   14779:	mov    rdx,QWORD PTR [rdi+0xd0]
   14780:	mov    rcx,QWORD PTR [rip+0x4721]        # 0x18ea8
   14787:	call   QWORD PTR [rip+0x4113]        # 0x188a0
   1478d:	and    QWORD PTR [rdi+0xd0],0x0
   14795:	lea    r11,[rsp+0x80]
   1479d:	mov    rbx,QWORD PTR [r11+0x30]
   147a1:	mov    rbp,QWORD PTR [r11+0x38]
   147a5:	mov    rsp,r11
   147a8:	pop    r13
   147aa:	pop    rdi
   147ab:	pop    rsi
   147ac:	ret
   147ad:	int3
   147ae:	int3
   147af:	int3
   147b0:	int3
   147b1:	int3
   147b2:	int3
   147b3:	int3
   147b4:	mov    QWORD PTR [rsp+0x8],rbx
   147b9:	push   rdi
   147ba:	sub    rsp,0x20
   147be:	mov    rbx,rdx
   147c1:	mov    rdx,QWORD PTR [rcx+0x118]
   147c8:	mov    rdi,rcx
   147cb:	mov    rcx,QWORD PTR [rip+0x46d6]        # 0x18ea8
   147d2:	call   QWORD PTR [rip+0x4428]        # 0x18c00
   147d8:	xor    edx,edx
   147da:	mov    rcx,rdi
   147dd:	call   0x14928
   147e2:	mov    r11d,DWORD PTR [rbx]
   147e5:	mov    rdx,QWORD PTR [rdi+0x118]
   147ec:	mov    rcx,QWORD PTR [rip+0x46b5]        # 0x18ea8
   147f3:	mov    DWORD PTR [rdi+0x1c0],r11d
   147fa:	call   QWORD PTR [rip+0x4408]        # 0x18c08
   14800:	mov    rbx,QWORD PTR [rsp+0x30]
   14805:	xor    eax,eax
   14807:	add    rsp,0x20
   1480b:	pop    rdi
   1480c:	ret
   1480d:	int3
   1480e:	int3
   1480f:	int3
   14810:	int3
   14811:	int3
   14812:	int3
   14813:	int3
   14814:	mov    QWORD PTR [rsp+0x8],rbx
   14819:	mov    QWORD PTR [rsp+0x10],rbp
   1481e:	mov    QWORD PTR [rsp+0x18],rsi
   14823:	push   rdi
   14824:	sub    rsp,0x20
   14828:	mov    rsi,rdx
   1482b:	xor    edx,edx
   1482d:	mov    rbx,rcx
   14830:	xor    edi,edi
   14832:	call   0x14928
   14837:	mov    rcx,QWORD PTR [rip+0x466a]        # 0x18ea8
   1483e:	mov    rdx,rsi
   14841:	cmp    DWORD PTR [rbx+0x1c0],edi
   14847:	jne    0x1485e
   14849:	mov    ebx,0xc0000120
   1484e:	mov    r8d,ebx
   14851:	call   QWORD PTR [rip+0x4201]        # 0x18a58
   14857:	mov    eax,ebx
   14859:	jmp    0x1490c
   1485e:	mov    r8,QWORD PTR [rip+0x391b]        # 0x18180
   14865:	call   QWORD PTR [rip+0x4005]        # 0x18870
   1486b:	lea    rdx,[rip+0xffffffffffffef76]        # 0x137e8
   14872:	and    QWORD PTR [rax],rdi
   14875:	and    QWORD PTR [rax+0x8],rdi
   14879:	and    DWORD PTR [rax+0x10],edi
   1487c:	mov    rcx,QWORD PTR [rbx]
   1487f:	mov    QWORD PTR [rax],rcx
   14882:	mov    rcx,rsi
   14885:	mov    QWORD PTR [rbx+0x28],rsi
   14889:	call   0x11098
   1488e:	mov    ebp,eax
   14890:	test   eax,eax
   14892:	je     0x148af
   14894:	mov    rcx,QWORD PTR [rip+0x460d]        # 0x18ea8
   1489b:	mov    r8d,eax
   1489e:	mov    rdx,rsi
   148a1:	call   QWORD PTR [rip+0x41b1]        # 0x18a58
   148a7:	and    QWORD PTR [rbx+0x28],rdi
   148ab:	mov    eax,ebp
   148ad:	jmp    0x1490c
   148af:	mov    rax,QWORD PTR [rbx+0x138]
   148b6:	cmp    QWORD PTR [rbx+0x130],rax
   148bd:	je     0x148fd
   148bf:	mov    rdx,QWORD PTR [rbx+0x130]
   148c6:	mov    edi,0x1
   148cb:	cmp    rax,rdx
   148ce:	je     0x148fd
   148d0:	mov    cl,BYTE PTR [rbx+0x163]
   148d6:	cmp    BYTE PTR [rax],cl
   148d8:	jne    0x148de
   148da:	test   cl,cl
   148dc:	jne    0x148f8
   148de:	inc    rax
   148e1:	cmp    rax,QWORD PTR [rbx+0x140]
   148e8:	jb     0x148f1
   148ea:	mov    rax,QWORD PTR [rbx+0x128]
   148f1:	cmp    rax,rdx
   148f4:	je     0x148fd
   148f6:	jmp    0x148d6
   148f8:	mov    edi,0x3
   148fd:	mov    edx,edi
   148ff:	mov    rcx,rbx
   14902:	call   0x149ec
   14907:	mov    eax,0x103
   1490c:	mov    rbx,QWORD PTR [rsp+0x30]
   14911:	mov    rbp,QWORD PTR [rsp+0x38]
   14916:	mov    rsi,QWORD PTR [rsp+0x40]
   1491b:	add    rsp,0x20
   1491f:	pop    rdi
   14920:	ret
   14921:	int3
   14922:	int3
   14923:	int3
   14924:	int3
   14925:	int3
   14926:	int3
   14927:	int3
   14928:	mov    rax,rsp
   1492b:	mov    QWORD PTR [rax+0x10],rbx
   1492f:	mov    QWORD PTR [rax+0x20],rsi
   14933:	push   rdi
   14934:	sub    rsp,0x30
   14938:	mov    rsi,QWORD PTR [rcx+0x28]
   1493c:	and    QWORD PTR [rax+0x8],0x0
   14941:	and    QWORD PTR [rax+0x18],0x0
   14946:	mov    ebx,edx
   14948:	mov    rdi,rcx
   1494b:	test   rsi,rsi
   1494e:	je     0x149d4
   14954:	and    QWORD PTR [rcx+0x28],0x0
   14959:	mov    rcx,rsi
   1495c:	call   0x11118
   14961:	cmp    eax,0xc0000120
   14966:	je     0x149d4
   14968:	mov    rcx,QWORD PTR [rip+0x4539]        # 0x18ea8
   1496f:	lea    rax,[rsp+0x50]
   14974:	lea    r9,[rsp+0x40]
   14979:	mov    r8d,0x4
   1497f:	mov    rdx,rsi
   14982:	mov    QWORD PTR [rsp+0x20],rax
   14987:	call   QWORD PTR [rip+0x4103]        # 0x18a90
   1498d:	test   eax,eax
   1498f:	je     0x149a6
   14991:	mov    rcx,QWORD PTR [rip+0x4510]        # 0x18ea8
   14998:	mov    r8d,eax
   1499b:	mov    rdx,rsi
   1499e:	call   QWORD PTR [rip+0x40b4]        # 0x18a58
   149a4:	jmp    0x149d4
   149a6:	mov    rax,QWORD PTR [rsp+0x40]
   149ab:	mov    DWORD PTR [rax],ebx
   149ad:	test   ebx,ebx
   149af:	jne    0x149b6
   149b1:	and    DWORD PTR [rdi+0x20],ebx
   149b4:	jmp    0x149bb
   149b6:	not    ebx
   149b8:	and    DWORD PTR [rdi+0x20],ebx
   149bb:	mov    rcx,QWORD PTR [rip+0x44e6]        # 0x18ea8
   149c2:	mov    r9d,0x4
   149c8:	xor    r8d,r8d
   149cb:	mov    rdx,rsi
   149ce:	call   QWORD PTR [rip+0x4094]        # 0x18a68
   149d4:	mov    rbx,QWORD PTR [rsp+0x48]
   149d9:	mov    rsi,QWORD PTR [rsp+0x58]
   149de:	add    rsp,0x30
   149e2:	pop    rdi
   149e3:	ret
   149e4:	int3
   149e5:	int3
   149e6:	int3
   149e7:	int3
   149e8:	int3
   149e9:	int3
   149ea:	int3
   149eb:	int3
   149ec:	sub    rsp,0x28
   149f0:	or     DWORD PTR [rcx+0x20],edx
   149f3:	mov    edx,DWORD PTR [rcx+0x1c0]
   149f9:	mov    eax,edx
   149fb:	and    eax,DWORD PTR [rcx+0x20]
   149fe:	test   al,0x10
   14a00:	je     0x14a07
   14a02:	or     eax,0x8
   14a05:	jmp    0x14a0a
   14a07:	and    eax,0xfffffff7
   14a0a:	test   eax,eax
   14a0c:	jne    0x14a17
   14a0e:	cmp    DWORD PTR [rcx+0x20],eax
   14a11:	je     0x14a28
   14a13:	test   edx,edx
   14a15:	jne    0x14a28
   14a17:	mov    rdx,QWORD PTR [rcx+0x40]
   14a1b:	mov    rcx,QWORD PTR [rip+0x4486]        # 0x18ea8
   14a22:	call   QWORD PTR [rip+0x3b78]        # 0x185a0
   14a28:	add    rsp,0x28
   14a2c:	ret
   14a2d:	int3
   14a2e:	int3
   14a2f:	int3
   14a30:	int3
   14a31:	int3
   14a32:	int3
   14a33:	int3
   14a34:	mov    QWORD PTR [rsp+0x8],rbx
   14a39:	push   rdi
   14a3a:	sub    rsp,0x20
   14a3e:	mov    edi,edx
   14a40:	mov    rbx,rcx
   14a43:	test   edx,edx
   14a45:	je     0x14b54
   14a4b:	test   edx,0xfffffff0
   14a51:	jne    0x14b54
   14a57:	test   dl,0x2
   14a5a:	je     0x14aed
   14a60:	mov    rdx,QWORD PTR [rcx+0x10]
   14a64:	jmp    0x14a82
   14a66:	mov    rdx,QWORD PTR [rsp+0x40]
   14a6b:	mov    rcx,QWORD PTR [rip+0x4436]        # 0x18ea8
   14a72:	mov    r8d,0xc0000120
   14a78:	call   QWORD PTR [rip+0x3fda]        # 0x18a58
   14a7e:	mov    rdx,QWORD PTR [rbx+0x10]
   14a82:	mov    rcx,QWORD PTR [rip+0x441f]        # 0x18ea8
   14a89:	lea    r8,[rsp+0x40]
   14a8e:	call   QWORD PTR [rip+0x3c7c]        # 0x18710
   14a94:	test   eax,eax
   14a96:	je     0x14a66
   14a98:	mov    rcx,QWORD PTR [rbx+0xe8]
   14a9f:	and    QWORD PTR [rbx+0xe8],0x0
   14aa7:	mov    QWORD PTR [rsp+0x40],rcx
   14aac:	test   rcx,rcx
   14aaf:	je     0x14aed
   14ab1:	call   0x11118
   14ab6:	and    QWORD PTR [rbx+0xf0],0x0
   14abe:	and    QWORD PTR [rbx+0xf8],0x0
   14ac6:	and    QWORD PTR [rbx+0x100],0x0
   14ace:	cmp    eax,0xc0000120
   14ad3:	je     0x14aed
   14ad5:	mov    rdx,QWORD PTR [rsp+0x40]
   14ada:	mov    rcx,QWORD PTR [rip+0x43c7]        # 0x18ea8
   14ae1:	mov    r8d,0xc0000120
   14ae7:	call   QWORD PTR [rip+0x3f6b]        # 0x18a58
   14aed:	test   dil,0x8
   14af1:	je     0x14b0f
   14af3:	mov    rax,QWORD PTR [rbx+0x128]
   14afa:	mov    QWORD PTR [rbx+0x138],rax
   14b01:	mov    QWORD PTR [rbx+0x130],rax
   14b08:	and    DWORD PTR [rbx+0x170],0x0
   14b0f:	test   dil,0x1
   14b13:	je     0x14b50
   14b15:	jmp    0x14b2f
   14b17:	mov    rdx,QWORD PTR [rsp+0x40]
   14b1c:	mov    rcx,QWORD PTR [rip+0x4385]        # 0x18ea8
   14b23:	mov    r8d,0xc0000120
   14b29:	call   QWORD PTR [rip+0x3f29]        # 0x18a58
   14b2f:	mov    rdx,QWORD PTR [rbx+0x18]
   14b33:	mov    rcx,QWORD PTR [rip+0x436e]        # 0x18ea8
   14b3a:	lea    r8,[rsp+0x40]
   14b3f:	call   QWORD PTR [rip+0x3bcb]        # 0x18710
   14b45:	test   eax,eax
   14b47:	je     0x14b17
   14b49:	and    DWORD PTR [rbx+0x174],0x0
   14b50:	xor    eax,eax
   14b52:	jmp    0x14b59
   14b54:	mov    eax,0xc000000d
   14b59:	mov    rbx,QWORD PTR [rsp+0x30]
   14b5e:	add    rsp,0x20
   14b62:	pop    rdi
   14b63:	ret
   14b64:	int3
   14b65:	int3
   14b66:	int3
   14b67:	int3
   14b68:	int3
   14b69:	int3
   14b6a:	int3
   14b6b:	int3
   14b6c:	int3
   14b6d:	int3
   14b6e:	int3
   14b6f:	int3
   14b70:	int3
   14b71:	int3
   14b72:	int3
   14b73:	int3
   14b74:	int3
   14b75:	int3
   14b76:	data16 nop WORD PTR [rax+rax*1+0x0]
   14b80:	cmp    rcx,QWORD PTR [rip+0x3579]        # 0x18100
   14b87:	jne    0x14b9b
   14b89:	rol    rcx,0x10
   14b8d:	test   cx,0xffff
   14b92:	jne    0x14b97
   14b94:	ret    0x0
   14b97:	ror    rcx,0x10
   14b9b:	jmp    0x14ba8
   14ba0:	int3
   14ba1:	int3
   14ba2:	int3
   14ba3:	int3
   14ba4:	int3
   14ba5:	int3
   14ba6:	int3
   14ba7:	int3
   14ba8:	sub    rsp,0x38
   14bac:	mov    r9,QWORD PTR [rip+0x3555]        # 0x18108
   14bb3:	mov    r8,QWORD PTR [rip+0x3546]        # 0x18100
   14bba:	and    QWORD PTR [rsp+0x20],0x0
   14bc0:	mov    rdx,rcx
   14bc3:	mov    ecx,0xf7
   14bc8:	call   QWORD PTR [rip+0x24aa]        # 0x17078
   14bce:	int3
   14bcf:	int3
   14bd0:	int3
   14bd1:	int3
   14bd2:	int3
   14bd3:	int3
   14bd4:	int3
   14bd5:	int3
   14bd6:	int3
   14bd7:	int3
   14bd8:	sub    rsp,0x28
   14bdc:	lea    rcx,[rip+0x352d]        # 0x18110
   14be3:	call   0x14da0
   14be8:	mov    r8,QWORD PTR [rip+0x42b9]        # 0x18ea8
   14bef:	lea    rdx,[rip+0x351a]        # 0x18110
   14bf6:	lea    rcx,[rip+0x428b]        # 0x18e88
   14bfd:	add    rsp,0x28
   14c01:	jmp    0x15dbc
   14c06:	int3
   14c07:	int3
   14c08:	int3
   14c09:	int3
   14c0a:	int3
   14c0b:	int3
   14c0c:	jmp    0x14bd8
   14c11:	int3
   14c12:	int3
   14c13:	int3
   14c14:	int3
   14c15:	int3
   14c16:	int3
   14c17:	int3
   14c18:	sub    rsp,0x28
   14c1c:	mov    rax,QWORD PTR [rip+0x4275]        # 0x18e98
   14c23:	test   rax,rax
   14c26:	je     0x14c36
   14c28:	lea    rdx,[rip+0xffffffffffffffe9]        # 0x14c18
   14c2f:	cmp    rax,rdx
   14c32:	je     0x14c36
   14c34:	call   rax
   14c36:	add    rsp,0x28
   14c3a:	jmp    0x14bd8
   14c3f:	int3
   14c40:	int3
   14c41:	int3
   14c42:	int3
   14c43:	int3
   14c44:	int3
   14c45:	int3
   14c46:	int3
   14c47:	int3
   14c48:	mov    QWORD PTR [rsp+0x8],rbx
   14c4d:	mov    QWORD PTR [rsp+0x10],rbp
   14c52:	mov    QWORD PTR [rsp+0x18],rsi
   14c57:	push   rdi
   14c58:	sub    rsp,0x20
   14c5c:	xor    ebp,ebp
   14c5e:	mov    rsi,rdx
   14c61:	mov    rdi,rcx
   14c64:	cmp    rcx,rbp
   14c67:	jne    0x14c75
   14c69:	xor    ecx,ecx
   14c6b:	call   0x11008
   14c70:	jmp    0x14d55
   14c75:	mov    eax,0x208
   14c7a:	mov    QWORD PTR [rip+0x422f],rcx        # 0x18eb0
   14c81:	lea    rcx,[rip+0x4200]        # 0x18e88
   14c88:	mov    WORD PTR [rip+0x41fb],ax        # 0x18e8a
   14c8f:	lea    rax,[rip+0x422a]        # 0x18ec0
   14c96:	mov    WORD PTR [rip+0x41eb],bp        # 0x18e88
   14c9d:	mov    QWORD PTR [rip+0x41ec],rax        # 0x18e90
   14ca4:	call   QWORD PTR [rip+0x23a6]        # 0x17050
   14caa:	lea    r9,[rip+0x41f7]        # 0x18ea8
   14cb1:	lea    r8,[rip+0x3458]        # 0x18110
   14cb8:	lea    rdx,[rip+0x41c9]        # 0x18e88
   14cbf:	mov    rcx,rdi
   14cc2:	call   0x15dc8
   14cc7:	cmp    eax,ebp
   14cc9:	jl     0x14d55
   14ccf:	lea    rcx,[rip+0x343a]        # 0x18110
   14cd6:	call   0x14e20
   14cdb:	cmp    eax,ebp
   14cdd:	mov    ebx,eax
   14cdf:	jl     0x14d4e
   14ce1:	call   0x14eac
   14ce6:	mov    rdx,rsi
   14ce9:	mov    rcx,rdi
   14cec:	call   0x11008
   14cf1:	cmp    eax,ebp
   14cf3:	mov    ebx,eax
   14cf5:	jl     0x14d4e
   14cf7:	mov    rax,QWORD PTR [rip+0x41aa]        # 0x18ea8
   14cfe:	cmp    BYTE PTR [rax+0x30],bpl
   14d02:	je     0x14d28
   14d04:	mov    rax,QWORD PTR [rip+0x418d]        # 0x18e98
   14d0b:	cmp    QWORD PTR [rdi+0x68],rbp
   14d0f:	cmovne rax,QWORD PTR [rdi+0x68]
   14d14:	mov    QWORD PTR [rip+0x417d],rax        # 0x18e98
   14d1b:	lea    rax,[rip+0xfffffffffffffef6]        # 0x14c18
   14d22:	mov    QWORD PTR [rdi+0x68],rax
   14d26:	jmp    0x14d4a
   14d28:	test   BYTE PTR [rax+0x8],0x2
   14d2c:	je     0x14d4a
   14d2e:	mov    rax,QWORD PTR [rip+0x3b33]        # 0x18868
   14d35:	mov    QWORD PTR [rip+0x4164],rax        # 0x18ea0
   14d3c:	lea    rax,[rip+0xfffffffffffffec9]        # 0x14c0c
   14d43:	mov    QWORD PTR [rip+0x3b1e],rax        # 0x18868
   14d4a:	xor    eax,eax
   14d4c:	jmp    0x14d55
   14d4e:	call   0x14bd8
   14d53:	mov    eax,ebx
   14d55:	mov    rbx,QWORD PTR [rsp+0x30]
   14d5a:	mov    rbp,QWORD PTR [rsp+0x38]
   14d5f:	mov    rsi,QWORD PTR [rsp+0x40]
   14d64:	add    rsp,0x20
   14d68:	pop    rdi
   14d69:	ret
   14d6a:	int3
   14d6b:	int3
   14d6c:	int3
   14d6d:	int3
   14d6e:	int3
   14d6f:	int3
   14d70:	mov    QWORD PTR [rsp+0x8],rbx
   14d75:	push   rdi
   14d76:	sub    rsp,0x20
   14d7a:	mov    rbx,rdx
   14d7d:	mov    rdi,rcx
   14d80:	call   0x1b008
   14d85:	mov    rdx,rbx
   14d88:	mov    rcx,rdi
   14d8b:	mov    rbx,QWORD PTR [rsp+0x30]
   14d90:	add    rsp,0x20
   14d94:	pop    rdi
   14d95:	jmp    0x14c48
   14d9a:	int3
   14d9b:	int3
   14d9c:	int3
   14d9d:	int3
   14d9e:	int3
   14d9f:	int3
   14da0:	mov    QWORD PTR [rsp+0x8],rbx
   14da5:	push   rdi
   14da6:	sub    rsp,0x20
   14daa:	mov    rax,QWORD PTR [rip+0x3447]        # 0x181f8
   14db1:	mov    rdi,rcx
   14db4:	lea    rcx,[rip+0x3425]        # 0x181e0
   14dbb:	lea    rbx,[rip+0x342e]        # 0x181f0
   14dc2:	cmp    rax,rcx
   14dc5:	je     0x14e0c
   14dc7:	cmp    rbx,rax
   14dca:	ja     0x14e0c
   14dcc:	mov    rax,QWORD PTR [rbx+0x40]
   14dd0:	test   rax,rax
   14dd3:	je     0x14ded
   14dd5:	mov    r8,QWORD PTR [rip+0x40cc]        # 0x18ea8
   14ddc:	lea    rcx,[rip+0xffd]        # 0x15de0
   14de3:	mov    r9,rbx
   14de6:	mov    rdx,rdi
   14de9:	call   rax
   14deb:	jmp    0x14dff
   14ded:	mov    rdx,QWORD PTR [rip+0x40b4]        # 0x18ea8
   14df4:	mov    r8,rbx
   14df7:	mov    rcx,rdi
   14dfa:	call   0x15de0
   14dff:	add    rbx,0x50
   14e03:	cmp    rbx,QWORD PTR [rip+0x33ee]        # 0x181f8
   14e0a:	jbe    0x14dcc
   14e0c:	mov    rbx,QWORD PTR [rsp+0x30]
   14e11:	add    rsp,0x20
   14e15:	pop    rdi
   14e16:	ret
   14e17:	int3
   14e18:	int3
   14e19:	int3
   14e1a:	int3
   14e1b:	int3
   14e1c:	int3
   14e1d:	int3
   14e1e:	int3
   14e1f:	int3
   14e20:	mov    QWORD PTR [rsp+0x8],rbx
   14e25:	mov    QWORD PTR [rsp+0x10],rsi
   14e2a:	push   rdi
   14e2b:	sub    rsp,0x20
   14e2f:	mov    rdi,rcx
   14e32:	xor    eax,eax
   14e34:	lea    rbx,[rip+0x33b5]        # 0x181f0
   14e3b:	lea    rsi,[rip+0x33ae]        # 0x181f0
   14e42:	cmp    rbx,rsi
   14e45:	jae    0x14e95
   14e47:	cmp    DWORD PTR [rbx],0x50
   14e4a:	jne    0x14e90
   14e4c:	mov    rax,QWORD PTR [rbx+0x38]
   14e50:	mov    QWORD PTR [rip+0x33a1],rbx        # 0x181f8
   14e57:	test   rax,rax
   14e5a:	je     0x14e74
   14e5c:	mov    r8,QWORD PTR [rip+0x4045]        # 0x18ea8
   14e63:	lea    rcx,[rip+0xf6a]        # 0x15dd4
   14e6a:	mov    r9,rbx
   14e6d:	mov    rdx,rdi
   14e70:	call   rax
   14e72:	jmp    0x14e86
   14e74:	mov    rdx,QWORD PTR [rip+0x402d]        # 0x18ea8
   14e7b:	mov    r8,rbx
   14e7e:	mov    rcx,rdi
   14e81:	call   0x15dd4
   14e86:	test   eax,eax
   14e88:	js     0x14e95
   14e8a:	add    rbx,0x50
   14e8e:	jmp    0x14e42
   14e90:	mov    eax,0xc0000004
   14e95:	mov    rbx,QWORD PTR [rsp+0x30]
   14e9a:	mov    rsi,QWORD PTR [rsp+0x38]
   14e9f:	add    rsp,0x20
   14ea3:	pop    rdi
   14ea4:	ret
   14ea5:	int3
   14ea6:	int3
   14ea7:	int3
   14ea8:	int3
   14ea9:	int3
   14eaa:	int3
   14eab:	int3
   14eac:	mov    QWORD PTR [rsp+0x8],rbx
   14eb1:	push   rdi
   14eb2:	sub    rsp,0x20
   14eb6:	lea    rax,[rip+0x3353]        # 0x18210
   14ebd:	lea    rcx,[rip+0x334c]        # 0x18210
   14ec4:	cmp    rax,rcx
   14ec7:	jae    0x14f05
   14ec9:	sub    rcx,rax
   14ecc:	movabs rax,0xcccccccccccccccd
   14ed6:	lea    rbx,[rip+0x3353]        # 0x18230
   14edd:	dec    rcx
   14ee0:	mul    rcx
   14ee3:	mov    rdi,rdx
   14ee6:	shr    rdi,0x5
   14eea:	inc    rdi
   14eed:	mov    rax,QWORD PTR [rbx]
   14ef0:	test   rax,rax
   14ef3:	je     0x14efb
   14ef5:	call   rax
   14ef7:	mov    QWORD PTR [rbx-0x8],rax
   14efb:	add    rbx,0x28
   14eff:	sub    rdi,0x1
   14f03:	jne    0x14eed
   14f05:	mov    rbx,QWORD PTR [rsp+0x30]
   14f0a:	add    rsp,0x20
   14f0e:	pop    rdi
   14f0f:	ret
   14f10:	int3
   14f11:	int3
   14f12:	int3
   14f13:	int3
   14f14:	int3
   14f15:	int3
   14f16:	int3
   14f17:	int3
   14f18:	mov    QWORD PTR [rsp+0x8],rbx
   14f1d:	mov    QWORD PTR [rsp+0x10],rsi
   14f22:	push   rdi
   14f23:	sub    rsp,0x20
   14f27:	mov    rax,r9
   14f2a:	mov    r9,QWORD PTR [rsp+0x50]
   14f2f:	mov    rdi,r8
   14f32:	mov    r8,rax
   14f35:	mov    rsi,rdx
   14f38:	xor    ebx,ebx
   14f3a:	call   0x15130
   14f3f:	cmp    eax,ebx
   14f41:	jl     0x14f4f
   14f43:	cdqe
   14f45:	cmp    rax,rsi
   14f48:	ja     0x14f4f
   14f4a:	mov    QWORD PTR [rdi],rax
   14f4d:	jmp    0x14f57
   14f4f:	mov    QWORD PTR [rdi],rsi
   14f52:	mov    ebx,0x80000005
   14f57:	mov    rsi,QWORD PTR [rsp+0x38]
   14f5c:	mov    eax,ebx
   14f5e:	mov    rbx,QWORD PTR [rsp+0x30]
   14f63:	add    rsp,0x20
   14f67:	pop    rdi
   14f68:	ret
   14f69:	int3
   14f6a:	int3
   14f6b:	int3
   14f6c:	int3
   14f6d:	int3
   14f6e:	int3
   14f6f:	int3
   14f70:	xor    r9d,r9d
   14f73:	mov    rax,rdx
   14f76:	mov    r10,rcx
   14f79:	cmp    rcx,r9
   14f7c:	jne    0x14f85
   14f7e:	bt     r8d,0x8
   14f83:	jb     0x14fbc
   14f85:	test   BYTE PTR [rcx],0x1
   14f88:	jne    0x14fb6
   14f8a:	movzx  edx,WORD PTR [rcx+0x2]
   14f8e:	test   dl,0x1
   14f91:	jne    0x14fb6
   14f93:	cmp    WORD PTR [rcx],dx
   14f96:	ja     0x14fb6
   14f98:	lea    rcx,[rax+rax*1]
   14f9c:	movzx  eax,dx
   14f9f:	cmp    rax,rcx
   14fa2:	ja     0x14fb6
   14fa4:	cmp    QWORD PTR [r10+0x8],r9
   14fa8:	jne    0x14fbc
   14faa:	cmp    WORD PTR [r10],r9w
   14fae:	jne    0x14fb6
   14fb0:	cmp    dx,r9w
   14fb4:	je     0x14fbc
   14fb6:	mov    r9d,0xc000000d
   14fbc:	mov    eax,r9d
   14fbf:	ret
   14fc0:	int3
   14fc1:	int3
   14fc2:	int3
   14fc3:	int3
   14fc4:	int3
   14fc5:	int3
   14fc6:	int3
   14fc7:	int3
   14fc8:	mov    QWORD PTR [rsp+0x8],rbx
   14fcd:	mov    QWORD PTR [rsp+0x10],rsi
   14fd2:	push   rdi
   14fd3:	sub    rsp,0x20
   14fd7:	and    QWORD PTR [rdx],0x0
   14fdb:	and    QWORD PTR [r8],0x0
   14fdf:	mov    rbx,r9
   14fe2:	mov    rdi,r8
   14fe5:	mov    rsi,rdx
   14fe8:	mov    r11,rcx
   14feb:	test   r9,r9
   14fee:	je     0x14ff4
   14ff0:	and    QWORD PTR [r9],0x0
   14ff4:	mov    r8d,DWORD PTR [rsp+0x58]
   14ff9:	mov    rdx,QWORD PTR [rsp+0x50]
   14ffe:	call   0x14f70
   15003:	mov    r8d,eax
   15006:	test   eax,eax
   15008:	js     0x15030
   1500a:	test   r11,r11
   1500d:	je     0x15030
   1500f:	mov    rcx,QWORD PTR [r11+0x8]
   15013:	mov    QWORD PTR [rsi],rcx
   15016:	movzx  ecx,WORD PTR [r11+0x2]
   1501b:	shr    rcx,1
   1501e:	mov    QWORD PTR [rdi],rcx
   15021:	test   rbx,rbx
   15024:	je     0x15030
   15026:	movzx  eax,WORD PTR [r11]
   1502a:	shr    rax,1
   1502d:	mov    QWORD PTR [rbx],rax
   15030:	mov    rbx,QWORD PTR [rsp+0x30]
   15035:	mov    rsi,QWORD PTR [rsp+0x38]
   1503a:	mov    eax,r8d
   1503d:	add    rsp,0x20
   15041:	pop    rdi
   15042:	ret
   15043:	int3
   15044:	int3
   15045:	int3
   15046:	int3
   15047:	int3
   15048:	int3
   15049:	int3
   1504a:	int3
   1504b:	int3
   1504c:	mov    QWORD PTR [rsp+0x8],rbx
   15051:	push   rdi
   15052:	sub    rsp,0x60
   15056:	mov    r11,r9
   15059:	mov    r10,r8
   1505c:	mov    rbx,rcx
   1505f:	test   r8,r8
   15062:	jne    0x15081
   15064:	and    QWORD PTR [rsp+0x20],0x0
   1506a:	xor    r9d,r9d
   1506d:	xor    r8d,r8d
   15070:	xor    edx,edx
   15072:	xor    ecx,ecx
   15074:	call   0x15260
   15079:	or     eax,0xffffffff
   1507c:	jmp    0x1511f
   15081:	test   rdx,rdx
   15084:	je     0x1508b
   15086:	test   rcx,rcx
   15089:	je     0x15064
   1508b:	mov    DWORD PTR [rsp+0x48],0x42
   15093:	mov    QWORD PTR [rsp+0x40],rcx
   15098:	mov    QWORD PTR [rsp+0x30],rcx
   1509d:	cmp    rdx,0x3fffffff
   150a4:	jbe    0x150b0
   150a6:	mov    DWORD PTR [rsp+0x38],0x7fffffff
   150ae:	jmp    0x150b7
   150b0:	lea    eax,[rdx+rdx*1]
   150b3:	mov    DWORD PTR [rsp+0x38],eax
   150b7:	mov    r9,QWORD PTR [rsp+0x90]
   150bf:	lea    rcx,[rsp+0x30]
   150c4:	mov    r8,r11
   150c7:	mov    rdx,r10
   150ca:	call   0x1539c
   150cf:	mov    edi,eax
   150d1:	test   rbx,rbx
   150d4:	je     0x1511f
   150d6:	sub    DWORD PTR [rsp+0x38],0x1
   150db:	js     0x150f4
   150dd:	mov    rax,QWORD PTR [rsp+0x30]
   150e2:	mov    BYTE PTR [rax],0x0
   150e5:	mov    rax,QWORD PTR [rsp+0x30]
   150ea:	inc    rax
   150ed:	mov    QWORD PTR [rsp+0x30],rax
   150f2:	jmp    0x15105
   150f4:	lea    rdx,[rsp+0x30]
   150f9:	xor    ecx,ecx
   150fb:	call   0x15250
   15100:	mov    rax,QWORD PTR [rsp+0x30]
   15105:	sub    DWORD PTR [rsp+0x38],0x1
   1510a:	js     0x15111
   1510c:	mov    BYTE PTR [rax],0x0
   1510f:	jmp    0x1511d
   15111:	lea    rdx,[rsp+0x30]
   15116:	xor    ecx,ecx
   15118:	call   0x15250
   1511d:	mov    eax,edi
   1511f:	mov    rbx,QWORD PTR [rsp+0x70]
   15124:	add    rsp,0x60
   15128:	pop    rdi
   15129:	ret
   1512a:	int3
   1512b:	int3
   1512c:	int3
   1512d:	int3
   1512e:	int3
   1512f:	int3
   15130:	sub    rsp,0x38
   15134:	mov    QWORD PTR [rsp+0x20],r9
   15139:	xor    r9d,r9d
   1513c:	call   0x1504c
   15141:	add    rsp,0x38
   15145:	ret
   15146:	int3
   15147:	int3
   15148:	int3
   15149:	int3
   1514a:	int3
   1514b:	int3
   1514c:	int3
   1514d:	int3
   1514e:	int3
   1514f:	int3
   15150:	int3
   15151:	int3
   15152:	int3
   15153:	int3
   15154:	int3
   15155:	int3
   15156:	data16 nop WORD PTR [rax+rax*1+0x0]
   15160:	mov    rax,rcx
   15163:	cmp    r8,0x8
   15167:	jb     0x151bc
   15169:	movzx  edx,dl
   1516c:	movabs r9,0x101010101010101
   15176:	imul   rdx,r9
   1517a:	cmp    r8,0x40
   1517e:	jb     0x1519e
   15180:	neg    rcx
   15183:	and    ecx,0x7
   15186:	je     0x1518e
   15188:	sub    r8,rcx
   1518b:	mov    QWORD PTR [rax],rdx
   1518e:	add    rcx,rax
   15191:	mov    r9,r8
   15194:	and    r8,0x3f
   15198:	shr    r9,0x6
   1519c:	jne    0x151d7
   1519e:	mov    r9,r8
   151a1:	and    r8,0x7
   151a5:	shr    r9,0x3
   151a9:	je     0x151bc
   151ab:	data16 data16 xchg ax,ax
   151af:	nop
   151b0:	mov    QWORD PTR [rcx],rdx
   151b3:	add    rcx,0x8
   151b7:	dec    r9
   151ba:	jne    0x151b0
   151bc:	test   r8,r8
   151bf:	je     0x151cb
   151c1:	mov    BYTE PTR [rcx],dl
   151c3:	inc    rcx
   151c6:	dec    r8
   151c9:	jne    0x151c1
   151cb:	ret    0x0
   151ce:	xchg   ax,ax
   151d0:	data16 data16 xchg ax,ax
   151d4:	data16 xchg ax,ax
   151d7:	cmp    r9,0x1c00
   151de:	jae    0x15210
   151e0:	mov    QWORD PTR [rcx],rdx
   151e3:	mov    QWORD PTR [rcx+0x8],rdx
   151e7:	mov    QWORD PTR [rcx+0x10],rdx
   151eb:	add    rcx,0x40
   151ef:	mov    QWORD PTR [rcx-0x28],rdx
   151f3:	mov    QWORD PTR [rcx-0x20],rdx
   151f7:	dec    r9
   151fa:	mov    QWORD PTR [rcx-0x18],rdx
   151fe:	mov    QWORD PTR [rcx-0x10],rdx
   15202:	mov    QWORD PTR [rcx-0x8],rdx
   15206:	jne    0x151e0
   15208:	jmp    0x1519e
   1520a:	nop    WORD PTR [rax+rax*1+0x0]
   15210:	movnti QWORD PTR [rcx],rdx
   15214:	movnti QWORD PTR [rcx+0x8],rdx
   15219:	movnti QWORD PTR [rcx+0x10],rdx
   1521e:	add    rcx,0x40
   15222:	movnti QWORD PTR [rcx-0x28],rdx
   15227:	movnti QWORD PTR [rcx-0x20],rdx
   1522c:	dec    r9
   1522f:	movnti QWORD PTR [rcx-0x18],rdx
   15234:	movnti QWORD PTR [rcx-0x10],rdx
   15239:	movnti QWORD PTR [rcx-0x8],rdx
   1523e:	jne    0x15210
   15240:	lock or BYTE PTR [rsp],0x0
   15245:	jmp    0x1519e
   1524a:	int3
   1524b:	int3
   1524c:	int3
   1524d:	int3
   1524e:	int3
   1524f:	int3
   15250:	or     DWORD PTR [rdx+0x18],0x20
   15254:	or     eax,0xffffffff
   15257:	ret
   15258:	int3
   15259:	int3
   1525a:	int3
   1525b:	int3
   1525c:	int3
   1525d:	int3
   1525e:	int3
   1525f:	int3
   15260:	ret    0x0
   15263:	int3
   15264:	int3
   15265:	int3
   15266:	int3
   15267:	int3
   15268:	int3
   15269:	int3
   1526a:	int3
   1526b:	int3
   1526c:	mov    QWORD PTR [rsp+0x8],rbx
   15271:	push   rdi
   15272:	sub    rsp,0x20
   15276:	test   BYTE PTR [rdx+0x18],0x40
   1527a:	mov    rbx,r8
   1527d:	mov    rdi,rdx
   15280:	je     0x1528e
   15282:	cmp    QWORD PTR [rdx+0x10],0x0
   15287:	jne    0x1528e
   15289:	inc    DWORD PTR [r8]
   1528c:	jmp    0x152aa
   1528e:	call   0x15cfc
   15293:	mov    ecx,0xffff
   15298:	cmp    ax,cx
   1529b:	jne    0x152a8
   1529d:	test   BYTE PTR [rdi+0x18],0x20
   152a1:	je     0x152a8
   152a3:	or     DWORD PTR [rbx],0xffffffff
   152a6:	jmp    0x152aa
   152a8:	inc    DWORD PTR [rbx]
   152aa:	mov    rbx,QWORD PTR [rsp+0x30]
   152af:	add    rsp,0x20
   152b3:	pop    rdi
   152b4:	ret
   152b5:	int3
   152b6:	int3
   152b7:	int3
   152b8:	int3
   152b9:	int3
   152ba:	int3
   152bb:	int3
   152bc:	test   edx,edx
   152be:	jle    0x1530c
   152c0:	mov    QWORD PTR [rsp+0x8],rbx
   152c5:	mov    QWORD PTR [rsp+0x10],rbp
   152ca:	mov    QWORD PTR [rsp+0x18],rsi
   152cf:	push   rdi
   152d0:	sub    rsp,0x20
   152d4:	mov    rdi,r9
   152d7:	mov    rsi,r8
   152da:	mov    ebx,edx
   152dc:	movzx  ebp,cx
   152df:	mov    r8,rdi
   152e2:	mov    rdx,rsi
   152e5:	movzx  ecx,bp
   152e8:	dec    ebx
   152ea:	call   0x1526c
   152ef:	cmp    DWORD PTR [rdi],0xffffffff
   152f2:	je     0x152f8
   152f4:	test   ebx,ebx
   152f6:	jg     0x152df
   152f8:	mov    rbx,QWORD PTR [rsp+0x30]
   152fd:	mov    rbp,QWORD PTR [rsp+0x38]
   15302:	mov    rsi,QWORD PTR [rsp+0x40]
   15307:	add    rsp,0x20
   1530b:	pop    rdi
   1530c:	ret
   1530d:	int3
   1530e:	int3
   1530f:	int3
   15310:	int3
   15311:	int3
   15312:	int3
   15313:	int3
   15314:	mov    QWORD PTR [rsp+0x8],rbx
   15319:	mov    QWORD PTR [rsp+0x10],rbp
   1531e:	mov    QWORD PTR [rsp+0x18],rsi
   15323:	push   rdi
   15324:	sub    rsp,0x20
   15328:	test   BYTE PTR [r8+0x18],0x40
   1532d:	mov    rdi,r9
   15330:	mov    rsi,r8
   15333:	mov    ebx,edx
   15335:	mov    rbp,rcx
   15338:	je     0x15346
   1533a:	cmp    QWORD PTR [r8+0x10],0x0
   1533f:	jne    0x15346
   15341:	add    DWORD PTR [r9],edx
   15344:	jmp    0x15381
   15346:	test   edx,edx
   15348:	jle    0x15381
   1534a:	movzx  ecx,WORD PTR [rbp+0x0]
   1534e:	mov    r8,rdi
   15351:	mov    rdx,rsi
   15354:	dec    ebx
   15356:	call   0x1526c
   1535b:	add    rbp,0x2
   1535f:	cmp    DWORD PTR [rdi],0xffffffff
   15362:	jne    0x1537d
   15364:	cmp    DWORD PTR [rip+0x3d71],0x2a        # 0x190dc
   1536b:	jne    0x15381
   1536d:	mov    ecx,0x3f
   15372:	mov    r8,rdi
   15375:	mov    rdx,rsi
   15378:	call   0x1526c
   1537d:	test   ebx,ebx
   1537f:	jg     0x1534a
   15381:	mov    rbx,QWORD PTR [rsp+0x30]
   15386:	mov    rbp,QWORD PTR [rsp+0x38]
   1538b:	mov    rsi,QWORD PTR [rsp+0x40]
   15390:	add    rsp,0x20
   15394:	pop    rdi
   15395:	ret
   15396:	int3
   15397:	int3
   15398:	int3
   15399:	int3
   1539a:	int3
   1539b:	int3
   1539c:	mov    QWORD PTR [rsp+0x18],rbx
   153a1:	push   rbp
   153a2:	push   rsi
   153a3:	push   rdi
   153a4:	push   r12
   153a6:	push   r13
   153a8:	push   r14
   153aa:	push   r15
   153ac:	sub    rsp,0x480
   153b3:	mov    rax,QWORD PTR [rip+0x2d46]        # 0x18100
   153ba:	xor    rax,rsp
   153bd:	mov    QWORD PTR [rsp+0x470],rax
   153c5:	xor    ebx,ebx
   153c7:	mov    r15,r9
   153ca:	mov    r13,rdx
   153cd:	mov    r11,rcx
   153d0:	mov    QWORD PTR [rsp+0x48],rcx
   153d5:	mov    DWORD PTR [rsp+0x60],ebx
   153d9:	mov    esi,ebx
   153db:	mov    r8d,ebx
   153de:	mov    DWORD PTR [rsp+0x40],ebx
   153e2:	mov    r9d,ebx
   153e5:	mov    DWORD PTR [rsp+0x3c],ebx
   153e9:	mov    r10d,ebx
   153ec:	mov    DWORD PTR [rsp+0x34],ebx
   153f0:	mov    DWORD PTR [rsp+0x5c],ebx
   153f4:	mov    DWORD PTR [rsp+0x30],ebx
   153f8:	cmp    rcx,rbx
   153fb:	jne    0x15413
   153fd:	xor    edx,edx
   153ff:	xor    ecx,ecx
   15401:	mov    QWORD PTR [rsp+0x20],rbx
   15406:	call   0x15260
   1540b:	or     eax,0xffffffff
   1540e:	jmp    0x15b05
   15413:	cmp    rdx,rbx
   15416:	je     0x153fd
   15418:	movzx  edi,WORD PTR [r13+0x0]
   1541d:	mov    r12d,ebx
   15420:	mov    DWORD PTR [rsp+0x38],ebx
   15424:	mov    r14d,ebx
   15427:	mov    edx,ebx
   15429:	cmp    di,bx
   1542c:	je     0x15b02
   15432:	mov    rbx,QWORD PTR [rsp+0x68]
   15437:	or     rbp,0xffffffffffffffff
   1543b:	xor    ecx,ecx
   1543d:	add    r13,0x2
   15441:	cmp    r12d,ecx
   15444:	mov    QWORD PTR [rsp+0x68],r13
   15449:	jl     0x15b02
   1544f:	lea    eax,[rdi-0x20]
   15452:	cmp    ax,0x58
   15456:	ja     0x1546c
   15458:	lea    rcx,[rip+0x1c81]        # 0x170e0
   1545f:	movzx  eax,di
   15462:	movsx  ecx,BYTE PTR [rax+rcx*1-0x20]
   15467:	and    ecx,0xf
   1546a:	jmp    0x15470
   1546c:	xor    eax,eax
   1546e:	mov    ecx,eax
   15470:	movsxd rax,edx
   15473:	movsxd rcx,ecx
   15476:	lea    rdx,[rax+rcx*8]
   1547a:	lea    rax,[rip+0x1c5f]        # 0x170e0
   15481:	movsx  edx,BYTE PTR [rdx+rax*1]
   15485:	sar    edx,0x4
   15488:	mov    DWORD PTR [rsp+0x50],edx
   1548c:	mov    ecx,edx
   1548e:	test   edx,edx
   15490:	je     0x15abd
   15496:	sub    ecx,0x1
   15499:	je     0x15c04
   1549f:	sub    ecx,0x1
   154a2:	je     0x15bab
   154a8:	sub    ecx,0x1
   154ab:	je     0x15b70
   154b1:	sub    ecx,0x1
   154b4:	je     0x15b65
   154ba:	sub    ecx,0x1
   154bd:	je     0x15b30
   154c3:	sub    ecx,0x1
   154c6:	je     0x159fc
   154cc:	cmp    ecx,0x1
   154cf:	jne    0x15af2
   154d5:	movzx  ecx,di
   154d8:	mov    eax,0x69
   154dd:	cmp    ecx,eax
   154df:	jg     0x156ac
   154e5:	je     0x1569e
   154eb:	sub    ecx,0x43
   154ee:	je     0x1562c
   154f4:	sub    ecx,0x10
   154f7:	je     0x155cb
   154fd:	sub    ecx,0x5
   15500:	je     0x1571f
   15506:	sub    ecx,0x2
   15509:	je     0x15550
   1550b:	sub    ecx,0x9
   1550e:	je     0x1563b
   15514:	cmp    ecx,0x1
   15517:	je     0x1569e
   1551d:	xor    edx,edx
   1551f:	mov    edi,DWORD PTR [rsp+0x30]
   15523:	mov    eax,0x20
   15528:	cmp    DWORD PTR [rsp+0x5c],edx
   1552c:	jne    0x15adf
   15532:	test   sil,0x40
   15536:	je     0x158d9
   1553c:	bt     esi,0x8
   15540:	jae    0x158af
   15546:	mov    ecx,0x2d
   1554b:	jmp    0x158ba
   15550:	mov    rcx,QWORD PTR [r15]
   15553:	add    r15,0x8
   15557:	xor    edx,edx
   15559:	cmp    rcx,rdx
   1555c:	je     0x155ae
   1555e:	mov    rbx,QWORD PTR [rcx+0x8]
   15562:	cmp    rbx,rdx
   15565:	je     0x155ae
   15567:	movzx  eax,WORD PTR [rcx]
   1556a:	cmp    WORD PTR [rcx+0x2],ax
   1556e:	jb     0x15c2a
   15574:	bt     esi,0xb
   15578:	movzx  r14d,ax
   1557c:	jae    0x155a3
   1557e:	mov    eax,r14d
   15581:	not    eax
   15583:	test   al,0x1
   15585:	je     0x15c2a
   1558b:	mov    eax,ebx
   1558d:	not    eax
   1558f:	test   al,0x1
   15591:	je     0x15c2a
   15597:	lea    edi,[rdx+0x1]
   1559a:	shr    r14d,1
   1559d:	mov    DWORD PTR [rsp+0x30],edi
   155a1:	jmp    0x15523
   155a3:	mov    edi,edx
   155a5:	mov    DWORD PTR [rsp+0x30],edx
   155a9:	jmp    0x15523
   155ae:	mov    rbx,QWORD PTR [rip+0x2b8b]        # 0x18140
   155b5:	xor    eax,eax
   155b7:	mov    rcx,rbp
   155ba:	mov    rdi,rbx
   155bd:	repnz scas al,BYTE PTR es:[rdi]
   155bf:	not    rcx
   155c2:	lea    r14,[rcx-0x1]
   155c6:	jmp    0x1551f
   155cb:	test   esi,0x830
   155d1:	jne    0x155d6
   155d3:	or     esi,0x20
   155d6:	mov    rbx,QWORD PTR [r15]
   155d9:	mov    eax,0x7fffffff
   155de:	cmp    r9d,ebp
   155e1:	mov    ecx,r9d
   155e4:	cmove  ecx,eax
   155e7:	add    r15,0x8
   155eb:	mov    eax,0x20
   155f0:	xor    edx,edx
   155f2:	test   al,sil
   155f5:	je     0x156df
   155fb:	cmp    rbx,rdx
   155fe:	mov    r14d,edx
   15601:	cmove  rbx,QWORD PTR [rip+0x2b37]        # 0x18140
   15609:	cmp    ecx,edx
   1560b:	mov    rax,rbx
   1560e:	jle    0x1551f
   15614:	cmp    BYTE PTR [rax],dl
   15616:	je     0x1551f
   1561c:	inc    r14d
   1561f:	inc    rax
   15622:	cmp    r14d,ecx
   15625:	jl     0x15614
   15627:	jmp    0x1551f
   1562c:	test   esi,0x830
   15632:	jne    0x1563b
   15634:	mov    eax,0x20
   15639:	or     esi,eax
   1563b:	movzx  eax,WORD PTR [r15]
   1563f:	mov    edi,0x1
   15644:	add    r15,0x8
   15648:	lea    ecx,[rdi+0x1f]
   1564b:	mov    WORD PTR [rsp+0x58],ax
   15650:	mov    DWORD PTR [rsp+0x30],edi
   15654:	test   cl,sil
   15657:	je     0x1568a
   15659:	movsxd r8,DWORD PTR [rip+0x2af8]        # 0x18158
   15660:	mov    BYTE PTR [rsp+0x54],al
   15664:	xor    eax,eax
   15666:	lea    rdx,[rsp+0x54]
   1566b:	lea    rcx,[rsp+0x70]
   15670:	mov    BYTE PTR [rsp+0x55],al
   15674:	call   0x15d48
   15679:	mov    r10d,DWORD PTR [rsp+0x34]
   1567e:	xor    edx,edx
   15680:	cmp    eax,edx
   15682:	jge    0x15691
   15684:	mov    DWORD PTR [rsp+0x5c],edi
   15688:	jmp    0x15691
   1568a:	mov    WORD PTR [rsp+0x70],ax
   1568f:	xor    edx,edx
   15691:	lea    rbx,[rsp+0x70]
   15696:	mov    r14d,edi
   15699:	jmp    0x15523
   1569e:	or     esi,0x40
   156a1:	mov    r8d,0xa
   156a7:	jmp    0x1575b
   156ac:	sub    ecx,0x6e
   156af:	je     0x15872
   156b5:	sub    ecx,0x1
   156b8:	je     0x1574c
   156be:	sub    ecx,0x1
   156c1:	je     0x15715
   156c3:	sub    ecx,0x3
   156c6:	je     0x155d6
   156cc:	sub    ecx,0x2
   156cf:	je     0x156a1
   156d1:	cmp    ecx,0x3
   156d4:	jne    0x1551d
   156da:	lea    eax,[rcx+0x24]
   156dd:	jmp    0x15724
   156df:	cmp    rbx,rdx
   156e2:	mov    edi,0x1
   156e7:	cmove  rbx,QWORD PTR [rip+0x2a59]        # 0x18148
   156ef:	mov    DWORD PTR [rsp+0x30],edi
   156f3:	mov    rax,rbx
   156f6:	jmp    0x15703
   156f8:	dec    ecx
   156fa:	cmp    WORD PTR [rax],dx
   156fd:	je     0x15707
   156ff:	add    rax,0x2
   15703:	cmp    ecx,edx
   15705:	jne    0x156f8
   15707:	sub    rax,rbx
   1570a:	sar    rax,1
   1570d:	mov    r14d,eax
   15710:	jmp    0x15523
   15715:	mov    r9d,0x10
   1571b:	bts    esi,0xf
   1571f:	mov    eax,0x7
   15724:	mov    r8d,0x10
   1572a:	mov    DWORD PTR [rsp+0x60],eax
   1572e:	lea    r11d,[r8+0x20]
   15732:	test   sil,sil
   15735:	jns    0x15761
   15737:	add    ax,0x51
   1573b:	mov    WORD PTR [rsp+0x44],r11w
   15741:	lea    r10d,[r8-0xe]
   15745:	mov    WORD PTR [rsp+0x46],ax
   1574a:	jmp    0x15761
   1574c:	mov    r8d,0x8
   15752:	test   sil,sil
   15755:	jns    0x1575b
   15757:	bts    esi,0x9
   1575b:	mov    r11d,0x30
   15761:	bt     esi,0xf
   15765:	jb     0x1576d
   15767:	bt     esi,0xc
   1576b:	jae    0x15776
   1576d:	mov    rdi,QWORD PTR [r15]
   15770:	add    r15,0x8
   15774:	jmp    0x157a8
   15776:	mov    eax,0x20
   1577b:	add    r15,0x8
   1577f:	test   al,sil
   15782:	je     0x15798
   15784:	test   sil,0x40
   15788:	je     0x15791
   1578a:	movsx  rdi,WORD PTR [r15-0x8]
   1578f:	jmp    0x157a8
   15791:	movzx  edi,WORD PTR [r15-0x8]
   15796:	jmp    0x157a8
   15798:	test   sil,0x40
   1579c:	je     0x157a4
   1579e:	movsxd rdi,DWORD PTR [r15-0x8]
   157a2:	jmp    0x157a8
   157a4:	mov    edi,DWORD PTR [r15-0x8]
   157a8:	xor    edx,edx
   157aa:	test   sil,0x40
   157ae:	je     0x157bc
   157b0:	cmp    rdi,rdx
   157b3:	jge    0x157bc
   157b5:	neg    rdi
   157b8:	bts    esi,0x8
   157bc:	bt     esi,0xf
   157c0:	jb     0x157ca
   157c2:	bt     esi,0xc
   157c6:	jb     0x157ca
   157c8:	mov    edi,edi
   157ca:	cmp    r9d,edx
   157cd:	jge    0x157d7
   157cf:	mov    r9d,0x1
   157d5:	jmp    0x157e6
   157d7:	mov    eax,0x200
   157dc:	and    esi,0xfffffff7
   157df:	cmp    r9d,eax
   157e2:	cmovg  r9d,eax
   157e6:	mov    rax,rdi
   157e9:	lea    rbx,[rsp+0x26f]
   157f1:	neg    rax
   157f4:	sbb    ecx,ecx
   157f6:	and    ecx,r10d
   157f9:	mov    r10d,DWORD PTR [rsp+0x60]
   157fe:	mov    DWORD PTR [rsp+0x34],ecx
   15802:	mov    ecx,r9d
   15805:	dec    r9d
   15808:	cmp    ecx,edx
   1580a:	jg     0x15811
   1580c:	cmp    rdi,rdx
   1580f:	je     0x15833
   15811:	xor    edx,edx
   15813:	mov    rax,rdi
   15816:	movsxd rcx,r8d
   15819:	div    rcx
   1581c:	mov    rdi,rax
   1581f:	lea    eax,[rdx+0x30]
   15822:	cmp    eax,0x39
   15825:	jle    0x1582a
   15827:	add    eax,r10d
   1582a:	mov    BYTE PTR [rbx],al
   1582c:	dec    rbx
   1582f:	xor    edx,edx
   15831:	jmp    0x15802
   15833:	mov    r10d,DWORD PTR [rsp+0x34]
   15838:	lea    rax,[rsp+0x26f]
   15840:	mov    DWORD PTR [rsp+0x3c],r9d
   15845:	sub    eax,ebx
   15847:	inc    rbx
   1584a:	bt     esi,0x9
   1584e:	mov    r14d,eax
   15851:	jae    0x1551f
   15857:	cmp    eax,edx
   15859:	je     0x15864
   1585b:	cmp    BYTE PTR [rbx],r11b
   1585e:	je     0x1551f
   15864:	dec    rbx
   15867:	inc    r14d
   1586a:	mov    BYTE PTR [rbx],r11b
   1586d:	jmp    0x1551f
   15872:	mov    rdi,QWORD PTR [r15]
   15875:	add    r15,0x8
   15879:	call   0x15cdc
   1587e:	xor    edx,edx
   15880:	cmp    eax,edx
   15882:	je     0x15c2a
   15888:	lea    eax,[rdx+0x20]
   1588b:	test   al,sil
   1588e:	je     0x15896
   15890:	mov    WORD PTR [rdi],r12w
   15894:	jmp    0x15899
   15896:	mov    DWORD PTR [rdi],r12d
   15899:	mov    edi,DWORD PTR [rsp+0x30]
   1589d:	mov    r10d,DWORD PTR [rsp+0x34]
   158a2:	mov    DWORD PTR [rsp+0x5c],0x1
   158aa:	jmp    0x15528
   158af:	test   sil,0x1
   158b3:	je     0x158cc
   158b5:	mov    ecx,0x2b
   158ba:	mov    WORD PTR [rsp+0x44],cx
   158bf:	mov    r12d,0x1
   158c5:	mov    DWORD PTR [rsp+0x34],r12d
   158ca:	jmp    0x158de
   158cc:	test   sil,0x2
   158d0:	je     0x158d9
   158d2:	mov    WORD PTR [rsp+0x44],ax
   158d7:	jmp    0x158bf
   158d9:	mov    r12d,DWORD PTR [rsp+0x34]
   158de:	mov    r13d,DWORD PTR [rsp+0x40]
   158e3:	sub    r13d,r14d
   158e6:	sub    r13d,r12d
   158e9:	test   sil,0xc
   158ed:	jne    0x15903
   158ef:	mov    r8,QWORD PTR [rsp+0x48]
   158f4:	lea    r9,[rsp+0x38]
   158f9:	mov    ecx,eax
   158fb:	mov    edx,r13d
   158fe:	call   0x152bc
   15903:	mov    r8,QWORD PTR [rsp+0x48]
   15908:	lea    r9,[rsp+0x38]
   1590d:	lea    rcx,[rsp+0x44]
   15912:	mov    edx,r12d
   15915:	call   0x15314
   1591a:	test   sil,0x8
   1591e:	je     0x1593d
   15920:	test   sil,0x4
   15924:	jne    0x1593d
   15926:	mov    r8,QWORD PTR [rsp+0x48]
   1592b:	lea    r9,[rsp+0x38]
   15930:	mov    ecx,0x30
   15935:	mov    edx,r13d
   15938:	call   0x152bc
   1593d:	xor    eax,eax
   1593f:	cmp    edi,eax
   15941:	jne    0x159ae
   15943:	cmp    r14d,eax
   15946:	jle    0x159ae
   15948:	mov    r12,rbx
   1594b:	mov    edi,r14d
   1594e:	movsxd r8,DWORD PTR [rip+0x2803]        # 0x18158
   15955:	lea    rcx,[rsp+0x58]
   1595a:	mov    rdx,r12
   1595d:	dec    edi
   1595f:	call   0x15d48
   15964:	movsxd rbp,eax
   15967:	cmp    ebp,0x2
   1596a:	jne    0x1596e
   1596c:	dec    edi
   1596e:	xor    edx,edx
   15970:	cmp    ebp,edx
   15972:	jle    0x1599c
   15974:	mov    rdx,QWORD PTR [rsp+0x48]
   15979:	movzx  ecx,WORD PTR [rsp+0x58]
   1597e:	lea    r8,[rsp+0x38]
   15983:	call   0x1526c
   15988:	add    r12,rbp
   1598b:	xor    ebp,ebp
   1598d:	cmp    edi,ebp
   1598f:	jg     0x1594e
   15991:	mov    rdi,QWORD PTR [rsp+0x48]
   15996:	or     rbp,0xffffffffffffffff
   1599a:	jmp    0x159c6
   1599c:	mov    rdi,QWORD PTR [rsp+0x48]
   159a1:	or     rbp,0xffffffffffffffff
   159a5:	mov    r12d,ebp
   159a8:	mov    DWORD PTR [rsp+0x38],ebp
   159ac:	jmp    0x159cd
   159ae:	mov    rdi,QWORD PTR [rsp+0x48]
   159b3:	lea    r9,[rsp+0x38]
   159b8:	mov    edx,r14d
   159bb:	mov    r8,rdi
   159be:	mov    rcx,rbx
   159c1:	call   0x15314
   159c6:	mov    r12d,DWORD PTR [rsp+0x38]
   159cb:	xor    edx,edx
   159cd:	cmp    r12d,edx
   159d0:	jl     0x159f2
   159d2:	test   sil,0x4
   159d6:	je     0x159f2
   159d8:	lea    r9,[rsp+0x38]
   159dd:	mov    ecx,0x20
   159e2:	mov    r8,rdi
   159e5:	mov    edx,r13d
   159e8:	call   0x152bc
   159ed:	mov    r12d,DWORD PTR [rsp+0x38]
   159f2:	mov    r13,QWORD PTR [rsp+0x68]
   159f7:	jmp    0x15ada
   159fc:	movzx  eax,di
   159ff:	cmp    eax,0x49
   15a02:	je     0x15a48
   15a04:	cmp    eax,0x68
   15a07:	je     0x15a40
   15a09:	mov    ecx,0x6c
   15a0e:	cmp    eax,ecx
   15a10:	je     0x15a24
   15a12:	cmp    eax,0x77
   15a15:	jne    0x15af2
   15a1b:	bts    esi,0xb
   15a1f:	jmp    0x15af2
   15a24:	cmp    WORD PTR [r13+0x0],cx
   15a29:	jne    0x15a38
   15a2b:	add    r13,0x2
   15a2f:	bts    esi,0xc
   15a33:	jmp    0x15af2
   15a38:	or     esi,0x10
   15a3b:	jmp    0x15af2
   15a40:	or     esi,0x20
   15a43:	jmp    0x15af2
   15a48:	bts    esi,0xf
   15a4c:	cmp    WORD PTR [r13+0x0],0x36
   15a52:	jne    0x15a69
   15a54:	cmp    WORD PTR [r13+0x2],0x34
   15a5a:	jne    0x15a69
   15a5c:	add    r13,0x4
   15a60:	bts    esi,0xf
   15a64:	jmp    0x15af2
   15a69:	cmp    WORD PTR [r13+0x0],0x33
   15a6f:	jne    0x15a83
   15a71:	cmp    WORD PTR [r13+0x2],0x32
   15a77:	jne    0x15a83
   15a79:	add    r13,0x4
   15a7d:	btr    esi,0xf
   15a81:	jmp    0x15af2
   15a83:	cmp    WORD PTR [r13+0x0],0x64
   15a89:	je     0x15af2
   15a8b:	mov    eax,0x69
   15a90:	cmp    WORD PTR [r13+0x0],ax
   15a95:	je     0x15af2
   15a97:	cmp    WORD PTR [r13+0x0],0x6f
   15a9d:	je     0x15af2
   15a9f:	cmp    WORD PTR [r13+0x0],0x75
   15aa5:	je     0x15af2
   15aa7:	cmp    WORD PTR [r13+0x0],0x78
   15aad:	je     0x15af2
   15aaf:	cmp    WORD PTR [r13+0x0],0x58
   15ab5:	je     0x15af2
   15ab7:	xor    eax,eax
   15ab9:	mov    DWORD PTR [rsp+0x50],eax
   15abd:	lea    r8,[rsp+0x38]
   15ac2:	mov    rdx,r11
   15ac5:	movzx  ecx,di
   15ac8:	mov    DWORD PTR [rsp+0x30],0x1
   15ad0:	call   0x1526c
   15ad5:	mov    r12d,DWORD PTR [rsp+0x38]
   15ada:	mov    r10d,DWORD PTR [rsp+0x34]
   15adf:	mov    edx,DWORD PTR [rsp+0x50]
   15ae3:	mov    r11,QWORD PTR [rsp+0x48]
   15ae8:	mov    r8d,DWORD PTR [rsp+0x40]
   15aed:	mov    r9d,DWORD PTR [rsp+0x3c]
   15af2:	mov    di,WORD PTR [r13+0x0]
   15af7:	xor    ecx,ecx
   15af9:	cmp    di,cx
   15afc:	jne    0x1543d
   15b02:	mov    eax,r12d
   15b05:	mov    rcx,QWORD PTR [rsp+0x470]
   15b0d:	xor    rcx,rsp
   15b10:	call   0x14b80
   15b15:	mov    rbx,QWORD PTR [rsp+0x4d0]
   15b1d:	add    rsp,0x480
   15b24:	pop    r15
   15b26:	pop    r14
   15b28:	pop    r13
   15b2a:	pop    r12
   15b2c:	pop    rdi
   15b2d:	pop    rsi
   15b2e:	pop    rbp
   15b2f:	ret
   15b30:	cmp    di,0x2a
   15b34:	jne    0x15b52
   15b36:	mov    r9d,DWORD PTR [r15]
   15b39:	add    r15,0x8
   15b3d:	xor    edi,edi
   15b3f:	cmp    r9d,edi
   15b42:	mov    DWORD PTR [rsp+0x3c],r9d
   15b47:	jge    0x15af2
   15b49:	mov    r9d,ebp
   15b4c:	mov    DWORD PTR [rsp+0x3c],ebp
   15b50:	jmp    0x15af2
   15b52:	lea    ecx,[r9+r9*4]
   15b56:	movzx  eax,di
   15b59:	lea    r9d,[rax+rcx*2-0x30]
   15b5e:	mov    DWORD PTR [rsp+0x3c],r9d
   15b63:	jmp    0x15af2
   15b65:	xor    edi,edi
   15b67:	mov    r9d,edi
   15b6a:	mov    DWORD PTR [rsp+0x3c],edi
   15b6e:	jmp    0x15af2
   15b70:	cmp    di,0x2a
   15b74:	jne    0x15b95
   15b76:	mov    r8d,DWORD PTR [r15]
   15b79:	add    r15,0x8
   15b7d:	xor    edi,edi
   15b7f:	cmp    r8d,edi
   15b82:	mov    DWORD PTR [rsp+0x40],r8d
   15b87:	jge    0x15af2
   15b8d:	or     esi,0x4
   15b90:	neg    r8d
   15b93:	jmp    0x15ba1
   15b95:	lea    ecx,[r8+r8*4]
   15b99:	movzx  eax,di
   15b9c:	lea    r8d,[rax+rcx*2-0x30]
   15ba1:	mov    DWORD PTR [rsp+0x40],r8d
   15ba6:	jmp    0x15af2
   15bab:	movzx  eax,di
   15bae:	mov    ecx,0x20
   15bb3:	cmp    eax,ecx
   15bb5:	je     0x15bfc
   15bb7:	cmp    eax,0x23
   15bba:	je     0x15bf3
   15bbc:	mov    ecx,0x2b
   15bc1:	cmp    eax,ecx
   15bc3:	je     0x15beb
   15bc5:	mov    ecx,0x2d
   15bca:	cmp    eax,ecx
   15bcc:	je     0x15be3
   15bce:	mov    ecx,0x30
   15bd3:	cmp    eax,ecx
   15bd5:	jne    0x15af2
   15bdb:	or     esi,0x8
   15bde:	jmp    0x15af2
   15be3:	or     esi,0x4
   15be6:	jmp    0x15af2
   15beb:	or     esi,0x1
   15bee:	jmp    0x15af2
   15bf3:	bts    esi,0x7
   15bf7:	jmp    0x15af2
   15bfc:	or     esi,0x2
   15bff:	jmp    0x15af2
   15c04:	xor    edi,edi
   15c06:	mov    r9d,ebp
   15c09:	mov    DWORD PTR [rsp+0x3c],ebp
   15c0d:	mov    DWORD PTR [rsp+0x5c],edi
   15c11:	mov    r8d,edi
   15c14:	mov    DWORD PTR [rsp+0x40],edi
   15c18:	mov    r10d,edi
   15c1b:	mov    DWORD PTR [rsp+0x34],edi
   15c1f:	mov    esi,edi
   15c21:	mov    DWORD PTR [rsp+0x30],edi
   15c25:	jmp    0x15af2
   15c2a:	xor    r9d,r9d
   15c2d:	xor    r8d,r8d
   15c30:	xor    ecx,ecx
   15c32:	mov    QWORD PTR [rsp+0x20],rdx
   15c37:	call   0x15260
   15c3c:	mov    eax,ebp
   15c3e:	jmp    0x15b05
   15c43:	int3
   15c44:	int3
   15c45:	int3
   15c46:	int3
   15c47:	int3
   15c48:	int3
   15c49:	int3
   15c4a:	int3
   15c4b:	int3
   15c4c:	rex push rbx
   15c4e:	sub    rsp,0x20
   15c52:	mov    r11d,DWORD PTR [r8]
   15c55:	mov    rbx,rdx
   15c58:	mov    r9,rcx
   15c5b:	and    r11d,0xfffffff8
   15c5f:	test   BYTE PTR [r8],0x4
   15c63:	mov    r10,rcx
   15c66:	je     0x15c7b
   15c68:	mov    eax,DWORD PTR [r8+0x8]
   15c6c:	movsxd r10,DWORD PTR [r8+0x4]
   15c70:	neg    eax
   15c72:	add    r10,rcx
   15c75:	movsxd rcx,eax
   15c78:	and    r10,rcx
   15c7b:	movsxd rax,r11d
   15c7e:	mov    rdx,QWORD PTR [rax+r10*1]
   15c82:	mov    rax,QWORD PTR [rbx+0x10]
   15c86:	mov    ecx,DWORD PTR [rax+0x8]
   15c89:	add    rcx,QWORD PTR [rbx+0x8]
   15c8d:	test   BYTE PTR [rcx+0x3],0xf
   15c91:	je     0x15c9f
   15c93:	movzx  eax,BYTE PTR [rcx+0x3]
   15c97:	and    eax,0xfffffff0
   15c9a:	cdqe
   15c9c:	add    r9,rax
   15c9f:	xor    r9,rdx
   15ca2:	mov    rcx,r9
   15ca5:	add    rsp,0x20
   15ca9:	pop    rbx
   15caa:	jmp    0x14b80
   15caf:	int3
   15cb0:	int3
   15cb1:	int3
   15cb2:	int3
   15cb3:	int3
   15cb4:	int3
   15cb5:	int3
   15cb6:	int3
   15cb7:	int3
   15cb8:	sub    rsp,0x28
   15cbc:	mov    r8,QWORD PTR [r9+0x38]
   15cc0:	mov    rcx,rdx
   15cc3:	mov    rdx,r9
   15cc6:	call   0x15c4c
   15ccb:	mov    eax,0x1
   15cd0:	add    rsp,0x28
   15cd4:	ret
   15cd5:	int3
   15cd6:	int3
   15cd7:	int3
   15cd8:	int3
   15cd9:	int3
   15cda:	int3
   15cdb:	int3
   15cdc:	mov    rcx,QWORD PTR [rip+0x241d]        # 0x18100
   15ce3:	xor    eax,eax
   15ce5:	or     rcx,0x1
   15ce9:	cmp    QWORD PTR [rip+0x33e0],rcx        # 0x190d0
   15cf0:	sete   al
   15cf3:	ret
   15cf4:	int3
   15cf5:	int3
   15cf6:	int3
   15cf7:	int3
   15cf8:	int3
   15cf9:	int3
   15cfa:	int3
   15cfb:	int3
   15cfc:	sub    rsp,0x38
   15d00:	test   rdx,rdx
   15d03:	jne    0x15d1e
   15d05:	and    QWORD PTR [rsp+0x20],rdx
   15d0a:	xor    r9d,r9d
   15d0d:	xor    r8d,r8d
   15d10:	xor    ecx,ecx
   15d12:	call   0x15260
   15d17:	mov    eax,0xffff
   15d1c:	jmp    0x15d3b
   15d1e:	add    DWORD PTR [rdx+0x8],0xfffffffe
   15d22:	js     0x15d33
   15d24:	mov    rax,QWORD PTR [rdx]
   15d27:	mov    WORD PTR [rax],cx
   15d2a:	add    QWORD PTR [rdx],0x2
   15d2e:	mov    ax,cx
   15d31:	jmp    0x15d3b
   15d33:	movzx  ecx,cx
   15d36:	call   0x15da0
   15d3b:	add    rsp,0x38
   15d3f:	ret
   15d40:	int3
   15d41:	int3
   15d42:	int3
   15d43:	int3
   15d44:	int3
   15d45:	int3
   15d46:	int3
   15d47:	int3
   15d48:	mov    QWORD PTR [rsp+0x8],rbx
   15d4d:	push   rdi
   15d4e:	sub    rsp,0x20
   15d52:	xor    eax,eax
   15d54:	mov    rdi,rdx
   15d57:	mov    rbx,rcx
   15d5a:	cmp    rdx,rax
   15d5d:	je     0x15d8c
   15d5f:	cmp    r8,rax
   15d62:	je     0x15d8c
   15d64:	cmp    BYTE PTR [rdx],al
   15d66:	jne    0x15d72
   15d68:	cmp    rcx,rax
   15d6b:	je     0x15d8c
   15d6d:	mov    WORD PTR [rcx],ax
   15d70:	jmp    0x15d8c
   15d72:	lea    rcx,[rsp+0x38]
   15d77:	mov    QWORD PTR [rsp+0x38],rdx
   15d7c:	call   0x15db0
   15d81:	mov    WORD PTR [rbx],ax
   15d84:	mov    rax,QWORD PTR [rsp+0x38]
   15d89:	sub    rax,rdi
   15d8c:	mov    rbx,QWORD PTR [rsp+0x30]
   15d91:	add    rsp,0x20
   15d95:	pop    rdi
   15d96:	ret
   15d97:	int3
   15d98:	int3
   15d99:	int3
   15d9a:	int3
   15d9b:	int3
   15d9c:	int3
   15d9d:	int3
   15d9e:	int3
   15d9f:	int3
   15da0:	or     DWORD PTR [rdx+0x18],0x20
   15da4:	mov    eax,0xffff
   15da9:	ret
   15daa:	int3
   15dab:	int3
   15dac:	int3
   15dad:	int3
   15dae:	int3
   15daf:	int3
   15db0:	jmp    QWORD PTR [rip+0x12a2]        # 0x17058
   15db6:	int3
   15db7:	int3
   15db8:	int3
   15db9:	int3
   15dba:	int3
   15dbb:	int3
   15dbc:	jmp    QWORD PTR [rip+0x124e]        # 0x17010
   15dc2:	int3
   15dc3:	int3
   15dc4:	int3
   15dc5:	int3
   15dc6:	int3
   15dc7:	int3
   15dc8:	jmp    QWORD PTR [rip+0x123a]        # 0x17008
   15dce:	int3
   15dcf:	int3
   15dd0:	int3
   15dd1:	int3
   15dd2:	int3
   15dd3:	int3
   15dd4:	jmp    QWORD PTR [rip+0x1226]        # 0x17000
   15dda:	int3
   15ddb:	int3
   15ddc:	int3
   15ddd:	int3
   15dde:	int3
   15ddf:	int3
   15de0:	jmp    QWORD PTR [rip+0x1232]        # 0x17018
   15de6:	int3
   15de7:	int3
   15de8:	int3
   15de9:	int3
   15dea:	int3
   15deb:	int3
   15dec:	int3
   15ded:	int3
   15dee:	int3
   15def:	int3
   15df0:	int3
   15df1:	int3
   15df2:	int3
   15df3:	int3
   15df4:	int3
   15df5:	int3
   15df6:	data16 nop WORD PTR [rax+rax*1+0x0]
   15e00:	mov    r11,rcx
   15e03:	sub    rdx,rcx
   15e06:	jb     0x15faa
   15e0c:	cmp    r8,0x8
   15e10:	jb     0x15e74
   15e12:	test   cl,0x7
   15e15:	je     0x15e4e
   15e17:	test   cl,0x1
   15e1a:	je     0x15e28
   15e1c:	mov    al,BYTE PTR [rdx+rcx*1]
   15e1f:	dec    r8
   15e22:	mov    BYTE PTR [rcx],al
   15e24:	add    rcx,0x1
   15e28:	test   cl,0x2
   15e2b:	je     0x15e3c
   15e2d:	mov    ax,WORD PTR [rdx+rcx*1]
   15e31:	sub    r8,0x2
   15e35:	mov    WORD PTR [rcx],ax
   15e38:	add    rcx,0x2
   15e3c:	test   cl,0x4
   15e3f:	je     0x15e4e
   15e41:	mov    eax,DWORD PTR [rdx+rcx*1]
   15e44:	sub    r8,0x4
   15e48:	mov    DWORD PTR [rcx],eax
   15e4a:	add    rcx,0x4
   15e4e:	mov    r9,r8
   15e51:	shr    r9,0x5
   15e55:	jne    0x15ea7
   15e57:	mov    r9,r8
   15e5a:	shr    r9,0x3
   15e5e:	je     0x15e74
   15e60:	mov    rax,QWORD PTR [rdx+rcx*1]
   15e64:	mov    QWORD PTR [rcx],rax
   15e67:	add    rcx,0x8
   15e6b:	dec    r9
   15e6e:	jne    0x15e60
   15e70:	and    r8,0x7
   15e74:	test   r8,r8
   15e77:	jne    0x15e80
   15e79:	mov    rax,r11
   15e7c:	ret
   15e7d:	nop    DWORD PTR [rax]
   15e80:	mov    al,BYTE PTR [rdx+rcx*1]
   15e83:	mov    BYTE PTR [rcx],al
   15e85:	inc    rcx
   15e88:	dec    r8
   15e8b:	jne    0x15e80
   15e8d:	mov    rax,r11
   15e90:	ret
   15e91:	data16 data16 data16 data16 data16 data16 nop WORD PTR [rax+rax*1+0x0]
   15ea0:	data16 data16 xchg ax,ax
   15ea4:	data16 xchg ax,ax
   15ea7:	cmp    r9,0x2000
   15eae:	jae    0x15ef2
   15eb0:	mov    rax,QWORD PTR [rdx+rcx*1]
   15eb4:	mov    r10,QWORD PTR [rdx+rcx*1+0x8]
   15eb9:	add    rcx,0x20
   15ebd:	mov    QWORD PTR [rcx-0x20],rax
   15ec1:	mov    QWORD PTR [rcx-0x18],r10
   15ec5:	mov    rax,QWORD PTR [rdx+rcx*1-0x10]
   15eca:	mov    r10,QWORD PTR [rdx+rcx*1-0x8]
   15ecf:	dec    r9
   15ed2:	mov    QWORD PTR [rcx-0x10],rax
   15ed6:	mov    QWORD PTR [rcx-0x8],r10
   15eda:	jne    0x15eb0
   15edc:	and    r8,0x1f
   15ee0:	jmp    0x15e57
   15ee5:	data16 data16 nop WORD PTR [rax+rax*1+0x0]
   15ef0:	xchg   ax,ax
   15ef2:	cmp    rdx,0x1000
   15ef9:	jb     0x15eb0
   15efb:	mov    eax,0x20
   15f00:	prefetchnta BYTE PTR [rdx+rcx*1]
   15f04:	prefetchnta BYTE PTR [rdx+rcx*1+0x40]
   15f09:	add    rcx,0x80
   15f10:	dec    eax
   15f12:	jne    0x15f00
   15f14:	sub    rcx,0x1000
   15f1b:	mov    eax,0x40
   15f20:	mov    r9,QWORD PTR [rdx+rcx*1]
   15f24:	mov    r10,QWORD PTR [rdx+rcx*1+0x8]
   15f29:	movnti QWORD PTR [rcx],r9
   15f2d:	movnti QWORD PTR [rcx+0x8],r10
   15f32:	mov    r9,QWORD PTR [rdx+rcx*1+0x10]
   15f37:	mov    r10,QWORD PTR [rdx+rcx*1+0x18]
   15f3c:	movnti QWORD PTR [rcx+0x10],r9
   15f41:	movnti QWORD PTR [rcx+0x18],r10
   15f46:	mov    r9,QWORD PTR [rdx+rcx*1+0x20]
   15f4b:	mov    r10,QWORD PTR [rdx+rcx*1+0x28]
   15f50:	add    rcx,0x40
   15f54:	movnti QWORD PTR [rcx-0x20],r9
   15f59:	movnti QWORD PTR [rcx-0x18],r10
   15f5e:	mov    r9,QWORD PTR [rdx+rcx*1-0x10]
   15f63:	mov    r10,QWORD PTR [rdx+rcx*1-0x8]
   15f68:	dec    eax
   15f6a:	movnti QWORD PTR [rcx-0x10],r9
   15f6f:	movnti QWORD PTR [rcx-0x8],r10
   15f74:	jne    0x15f20
   15f76:	sub    r8,0x1000
   15f7d:	cmp    r8,0x1000
   15f84:	jae    0x15efb
   15f8a:	lock or BYTE PTR [rsp],0x0
   15f8f:	jmp    0x15e4e
   15f94:	data16 data16 data16 nop WORD PTR [rax+rax*1+0x0]
   15fa0:	data16 data16 xchg ax,ax
   15fa4:	data16 data16 xchg ax,ax
   15fa8:	xchg   ax,ax
   15faa:	add    rcx,r8
   15fad:	cmp    r8,0x8
   15fb1:	jb     0x16014
   15fb3:	test   cl,0x7
   15fb6:	je     0x15fee
   15fb8:	test   cl,0x1
   15fbb:	je     0x15fc8
   15fbd:	dec    rcx
   15fc0:	mov    al,BYTE PTR [rdx+rcx*1]
   15fc3:	dec    r8
   15fc6:	mov    BYTE PTR [rcx],al
   15fc8:	test   cl,0x2
   15fcb:	je     0x15fdc
   15fcd:	sub    rcx,0x2
   15fd1:	mov    ax,WORD PTR [rdx+rcx*1]
   15fd5:	sub    r8,0x2
   15fd9:	mov    WORD PTR [rcx],ax
   15fdc:	test   cl,0x4
   15fdf:	je     0x15fee
   15fe1:	sub    rcx,0x4
   15fe5:	mov    eax,DWORD PTR [rdx+rcx*1]
   15fe8:	sub    r8,0x4
   15fec:	mov    DWORD PTR [rcx],eax
   15fee:	mov    r9,r8
   15ff1:	shr    r9,0x5
   15ff5:	jne    0x16047
   15ff7:	mov    r9,r8
   15ffa:	shr    r9,0x3
   15ffe:	je     0x16014
   16000:	sub    rcx,0x8
   16004:	mov    rax,QWORD PTR [rdx+rcx*1]
   16008:	dec    r9
   1600b:	mov    QWORD PTR [rcx],rax
   1600e:	jne    0x16000
   16010:	and    r8,0x7
   16014:	test   r8,r8
   16017:	jne    0x16020
   16019:	mov    rax,r11
   1601c:	ret
   1601d:	nop    DWORD PTR [rax]
   16020:	dec    rcx
   16023:	mov    al,BYTE PTR [rdx+rcx*1]
   16026:	dec    r8
   16029:	mov    BYTE PTR [rcx],al
   1602b:	jne    0x16020
   1602d:	mov    rax,r11
   16030:	ret
   16031:	data16 data16 data16 data16 data16 data16 nop WORD PTR [rax+rax*1+0x0]
   16040:	data16 data16 xchg ax,ax
   16044:	data16 xchg ax,ax
   16047:	cmp    r9,0x2000
   1604e:	jae    0x16092
   16050:	mov    rax,QWORD PTR [rdx+rcx*1-0x8]
   16055:	mov    r10,QWORD PTR [rdx+rcx*1-0x10]
   1605a:	sub    rcx,0x20
   1605e:	mov    QWORD PTR [rcx+0x18],rax
   16062:	mov    QWORD PTR [rcx+0x10],r10
   16066:	mov    rax,QWORD PTR [rdx+rcx*1+0x8]
   1606b:	mov    r10,QWORD PTR [rdx+rcx*1]
   1606f:	dec    r9
   16072:	mov    QWORD PTR [rcx+0x8],rax
   16076:	mov    QWORD PTR [rcx],r10
   16079:	jne    0x16050
   1607b:	and    r8,0x1f
   1607f:	jmp    0x15ff7
   16084:	data16 data16 data16 nop WORD PTR [rax+rax*1+0x0]
   16090:	xchg   ax,ax
   16092:	cmp    rdx,0xfffffffffffff000
   16099:	ja     0x16050
   1609b:	mov    eax,0x20
   160a0:	sub    rcx,0x80
   160a7:	prefetchnta BYTE PTR [rdx+rcx*1]
   160ab:	prefetchnta BYTE PTR [rdx+rcx*1+0x40]
   160b0:	dec    eax
   160b2:	jne    0x160a0
   160b4:	add    rcx,0x1000
   160bb:	mov    eax,0x40
   160c0:	mov    r9,QWORD PTR [rdx+rcx*1-0x8]
   160c5:	mov    r10,QWORD PTR [rdx+rcx*1-0x10]
   160ca:	movnti QWORD PTR [rcx-0x8],r9
   160cf:	movnti QWORD PTR [rcx-0x10],r10
   160d4:	mov    r9,QWORD PTR [rdx+rcx*1-0x18]
   160d9:	mov    r10,QWORD PTR [rdx+rcx*1-0x20]
   160de:	movnti QWORD PTR [rcx-0x18],r9
   160e3:	movnti QWORD PTR [rcx-0x20],r10
   160e8:	mov    r9,QWORD PTR [rdx+rcx*1-0x28]
   160ed:	mov    r10,QWORD PTR [rdx+rcx*1-0x30]
   160f2:	sub    rcx,0x40
   160f6:	movnti QWORD PTR [rcx+0x18],r9
   160fb:	movnti QWORD PTR [rcx+0x10],r10
   16100:	mov    r9,QWORD PTR [rdx+rcx*1+0x8]
   16105:	mov    r10,QWORD PTR [rdx+rcx*1]
   16109:	dec    eax
   1610b:	movnti QWORD PTR [rcx+0x8],r9
   16110:	movnti QWORD PTR [rcx],r10
   16114:	jne    0x160c0
   16116:	sub    r8,0x1000
   1611d:	cmp    r8,0x1000
   16124:	jae    0x1609b
   1612a:	lock or BYTE PTR [rsp],0x0
   1612f:	jmp    0x15fee
   16134:	int3
   16135:	int3
   16136:	int3
   16137:	int3
   16138:	int3
   16139:	int3
   1613a:	int3
   1613b:	int3
   1613c:	int3
   1613d:	int3
   1613e:	int3
   1613f:	int3
   16140:	push   rax
   16141:	add    BYTE PTR [rdi+0x0],ch
   16144:	jb     0x16146
   16146:	je     0x16148
   16148:	rex.WRX add BYTE PTR [rcx+0x0],r12b
   1614c:	ins    DWORD PTR es:[rdi],dx
   1614d:	add    BYTE PTR [rbp+0x0],ah
   16150:	add    BYTE PTR [rax],al
   16152:	int3
   16153:	int3
   16154:	int3
   16155:	int3
   16156:	int3
   16157:	int3
   16158:	int3
   16159:	int3
   1615a:	int3
   1615b:	int3
   1615c:	int3
   1615d:	int3
   1615e:	int3
   1615f:	int3
   16160:	pop    rsp
   16161:	add    BYTE PTR [rax+rax*1+0x6f],al
   16165:	add    BYTE PTR [rbx+0x0],dh
   16168:	add    BYTE PTR [rbp+0x0],r12b
   1616c:	jbe    0x1616e
   1616e:	imul   eax,DWORD PTR [rax],0x650063
   16174:	jae    0x16176
   16176:	pop    rsp
   16177:	add    BYTE PTR [rax],al
   16179:	add    ah,cl
   1617b:	int3
   1617c:	int3
   1617d:	int3
   1617e:	int3
   1617f:	int3
   16180:	and    eax,0x73007700
   16185:	add    BYTE PTR [rip+0x73007700],ah        # 0x7301d88b
   1618b:	add    BYTE PTR [rax],al
   1618d:	add    ah,cl
   1618f:	int3
   16190:	push   rbx
   16191:	add    BYTE PTR [rbp+0x0],al
   16194:	push   rdx
   16195:	add    BYTE PTR [rcx+0x0],cl
   16198:	add    BYTE PTR [r8+rax*1+0x43],cl
   1619d:	add    BYTE PTR [rdi+0x0],cl
   161a0:	rex.WRB add BYTE PTR [r13+0x0],r9b
   161a4:	add    BYTE PTR [rax],al
   161a6:	int3
   161a7:	int3
   161a8:	int3
   161a9:	int3
   161aa:	int3
   161ab:	int3
   161ac:	int3
   161ad:	int3
   161ae:	int3
   161af:	int3
   161b0:	push   rsi
   161b1:	add    BYTE PTR [rbp+0x0],ah
   161b4:	outs   dx,BYTE PTR ds:[rsi]
   161b5:	add    BYTE PTR [rax+rax*1+0x6f],ah
   161b9:	add    BYTE PTR [rdx+0x0],dh
   161bc:	push   rdx
   161bd:	add    BYTE PTR [rbp+0x0],ah
   161c0:	jno    0x161c2
   161c2:	jne    0x161c4
   161c4:	add    BYTE PTR gs:[rbx+0x0],dh
   161c8:	je     0x161ca
   161ca:	push   rsp
   161cb:	add    BYTE PTR [rcx+0x0],ch
   161ce:	ins    DWORD PTR es:[rdi],dx
   161cf:	add    BYTE PTR [rbp+0x0],ah
   161d2:	outs   dx,DWORD PTR ds:[rsi]
   161d3:	add    BYTE PTR [rbp+0x0],dh
   161d6:	je     0x161d8
   161d8:	push   rsi
   161d9:	add    BYTE PTR [rcx+0x0],ah
   161dc:	ins    BYTE PTR es:[rdi],dx
   161dd:	add    BYTE PTR [rbp+0x0],dh
   161e0:	add    BYTE PTR gs:[rax],al
   161e3:	add    ah,cl
   161e5:	int3
   161e6:	int3
   161e7:	int3
   161e8:	int3
   161e9:	int3
   161ea:	int3
   161eb:	int3
   161ec:	int3
   161ed:	int3
   161ee:	int3
   161ef:	int3
   161f0:	push   rbx
   161f1:	add    BYTE PTR [rax+0x0],dh
   161f4:	jb     0x161f6
   161f6:	add    BYTE PTR fs:[rsi+0x0],dl
   161fa:	add    BYTE PTR gs:[rsi+0x0],ch
   161fe:	add    BYTE PTR fs:[rdi+0x0],ch
   16202:	jb     0x16204
   16204:	push   rdx
   16205:	add    BYTE PTR [rbp+0x0],ah
   16208:	jno    0x1620a
   1620a:	jne    0x1620c
   1620c:	add    BYTE PTR gs:[rbx+0x0],dh
   16210:	je     0x16212
   16212:	add    BYTE PTR [rax],al
   16214:	int3
   16215:	int3
   16216:	int3
   16217:	int3
   16218:	int3
   16219:	int3
   1621a:	int3
   1621b:	int3
   1621c:	int3
   1621d:	int3
   1621e:	int3
   1621f:	int3
   16220:	add    BYTE PTR [r8+r8*1+0x63],spl
   16225:	add    BYTE PTR [rbx+0x0],al
   16228:	outs   dx,DWORD PTR ds:[rsi]
   16229:	add    BYTE PTR [rsi+0x0],ch
   1622c:	je     0x1622e
   1622e:	jb     0x16230
   16230:	outs   dx,DWORD PTR ds:[rsi]
   16231:	add    BYTE PTR [rax+rax*1+0x4c],ch
   16235:	add    BYTE PTR [rcx+0x0],ch
   16238:	outs   dx,BYTE PTR ds:[rsi]
   16239:	add    BYTE PTR [rbp+0x0],ah
   1623c:	push   rbx
   1623d:	add    BYTE PTR [rax+rax*1+0x61],dh
   16241:	add    BYTE PTR [rax+rax*1+0x65],dh
   16245:	add    BYTE PTR [rax],al
   16247:	add    ah,cl
   16249:	int3
   1624a:	int3
   1624b:	int3
   1624c:	int3
   1624d:	int3
   1624e:	int3
   1624f:	int3
   16250:	push   rbp
   16251:	add    BYTE PTR [rbx+0x0],dh
   16254:	add    BYTE PTR gs:[rbx+0x0],al
   16258:	outs   dx,DWORD PTR ds:[rsi]
   16259:	add    BYTE PTR [rsi+0x0],ch
   1625c:	je     0x1625e
   1625e:	imul   eax,DWORD PTR [rax],0x75006e
   16264:	outs   dx,DWORD PTR ds:[rsi]
   16265:	add    BYTE PTR [rbp+0x0],dh
   16268:	jae    0x1626a
   1626a:	push   rdx
   1626b:	add    BYTE PTR [rbp+0x0],ah
   1626e:	(bad)
   1626f:	add    BYTE PTR [rax+rax*1+0x0],ah
   16273:	add    ah,cl
   16275:	int3
   16276:	int3
   16277:	int3
   16278:	int3
   16279:	int3
   1627a:	int3
   1627b:	int3
   1627c:	int3
   1627d:	int3
   1627e:	int3
   1627f:	int3
   16280:	push   rdx
   16281:	add    BYTE PTR [rax+0x0],bh
   16284:	rex.RX add BYTE PTR [rcx+0x0],r13b
   16288:	data16 add BYTE PTR [rdi+0x0],ch
   1628c:	push   rbx
   1628d:	add    BYTE PTR [rcx+0x0],ch
   16290:	jp     0x16292
   16292:	add    BYTE PTR gs:[rax],al
   16295:	add    ah,cl
   16297:	int3
   16298:	int3
   16299:	int3
   1629a:	int3
   1629b:	int3
   1629c:	int3
   1629d:	int3
   1629e:	int3
   1629f:	int3
   162a0:	rex.X add BYTE PTR [rbp+0x0],sil
   162a4:	ins    BYTE PTR es:[rdi],dx
   162a5:	add    BYTE PTR [rbx+0x0],ch
   162a8:	rex.WB add BYTE PTR [r14+0x0],bpl
   162ac:	rex.X add BYTE PTR [rbp+0x0],sil
   162b0:	data16 add BYTE PTR [rbx+0x0],dl
   162b4:	imul   eax,DWORD PTR [rax],0x65007a
   162ba:	add    BYTE PTR [rax],al
   162bc:	int3
   162bd:	int3
   162be:	int3
   162bf:	int3
   162c0:	push   rbp
   162c1:	add    BYTE PTR [rbx+0x0],dh
   162c4:	(bad)
   162c5:	add    BYTE PTR [rbp+0x0],al
   162c8:	outs   dx,BYTE PTR ds:[rsi]
   162c9:	add    BYTE PTR [rcx+0x0],ah
   162cc:	(bad)
   162cd:	add    BYTE PTR [rax+rax*1+0x65],ch
   162d1:	add    BYTE PTR [rdx+0x0],bl
   162d4:	rex.WR add BYTE PTR [rax+0x0],r10b
   162d8:	add    BYTE PTR [rax],al
   162da:	int3
   162db:	int3
   162dc:	int3
   162dd:	int3
   162de:	int3
   162df:	int3
   162e0:	pop    rsp
   162e1:	add    BYTE PTR [rax+rax*1+0x65],al
   162e5:	add    BYTE PTR [rsi+0x0],dh
   162e8:	imul   eax,DWORD PTR [rax],0x650063
   162ee:	pop    rsp
   162ef:	add    BYTE PTR [rbx+0x0],dh
   162f2:	jo     0x162f4
   162f4:	jb     0x162f6
   162f6:	add    BYTE PTR fs:[rdi+0x0],bl
   162fa:	jne    0x162fc
   162fc:	jae    0x162fe
   162fe:	(bad)
   162ff:	add    BYTE PTR [rbx+0x0],ah
   16302:	outs   dx,DWORD PTR ds:[rsi]
   16303:	add    BYTE PTR [rbp+0x0],ch
   16306:	ins    DWORD PTR es:[rdi],dx
   16307:	add    BYTE PTR [rdi+0x0],bl
   1630a:	ins    DWORD PTR es:[rdi],dx
   1630b:	add    BYTE PTR [rdi+0x0],ch
   1630e:	add    BYTE PTR fs:[rbp+0x0],ah
   16312:	ins    DWORD PTR es:[rdi],dx
   16313:	add    BYTE PTR [rax],al
   16315:	add    ah,cl
   16317:	int3
   16318:	int3
   16319:	int3
   1631a:	int3
   1631b:	int3
   1631c:	int3
   1631d:	int3
   1631e:	int3
   1631f:	int3
   16320:	and    eax,0x73007700
   16325:	add    BYTE PTR [rip+0x6400],ah        # 0x1c72b
   1632b:	add    ah,cl
   1632d:	int3
   1632e:	int3
   1632f:	int3
   16330:	rex.XB
   16331:	rex.WRXB
   16332:	rex.WRX
   16333:	rex.WRX
   16334:	rex.RB
   16335:	rex.XB push r12
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
   1b06c:	(bad)
   1b06d:	mov    cl,0x0
   1b06f:	add    BYTE PTR [rax],ch
   1b071:	jo     0x1b073
   1b073:	add    BYTE PTR [rax+0xb0],ah
   1b079:	add    BYTE PTR [rax],al
   1b07b:	add    BYTE PTR [rax],al
   1b07d:	add    BYTE PTR [rax],al
   1b07f:	add    BYTE PTR [rdx+rsi*4+0x70000000],dl
	...
   1b09e:	add    BYTE PTR [rax],al
   1b0a0:	data16 mov dl,0x0
   1b0a3:	add    BYTE PTR [rax],al
   1b0a5:	add    BYTE PTR [rax],al
   1b0a7:	add    BYTE PTR [rdx+rsi*4+0x0],dl
   1b0ab:	add    BYTE PTR [rax],al
   1b0ad:	add    BYTE PTR [rax],al
   1b0af:	add    BYTE PTR [rax-0x4e],al
   1b0b2:	add    BYTE PTR [rax],al
   1b0b4:	add    BYTE PTR [rax],al
   1b0b6:	add    BYTE PTR [rax],al
   1b0b8:	jl     0x1b06c
	...
   1b0c6:	add    BYTE PTR [rax],al
   1b0c8:	(bad)
   1b0c9:	mov    cl,0x0
   1b0cb:	add    BYTE PTR [rax],al
   1b0cd:	add    BYTE PTR [rax],al
   1b0cf:	add    BYTE PTR [rdx+0xb1],dh
   1b0d5:	add    BYTE PTR [rax],al
   1b0d7:	add    dl,cl
   1b0d9:	mov    cl,0x0
   1b0db:	add    BYTE PTR [rax],al
   1b0dd:	add    BYTE PTR [rax],al
   1b0df:	add    ah,ah
   1b0e1:	mov    cl,0x0
   1b0e3:	add    BYTE PTR [rax],al
   1b0e5:	add    BYTE PTR [rax],al
   1b0e7:	add    BYTE PTR [rsi+0xb1],al
   1b0ed:	add    BYTE PTR [rax],al
   1b0ef:	add    BYTE PTR [rdx+rsi*4],cl
   1b0f2:	add    BYTE PTR [rax],al
   1b0f4:	add    BYTE PTR [rax],al
   1b0f6:	add    BYTE PTR [rax],al
   1b0f8:	and    al,0xb2
   1b0fa:	add    BYTE PTR [rax],al
   1b0fc:	add    BYTE PTR [rax],al
   1b0fe:	add    BYTE PTR [rax],al
   1b100:	js     0x1b0b3
   1b102:	add    BYTE PTR [rax],al
   1b104:	add    BYTE PTR [rax],al
   1b106:	add    BYTE PTR [rax],al
   1b108:	(bad)
   1b109:	mov    cl,0x0
   1b10b:	add    BYTE PTR [rax],al
   1b10d:	add    BYTE PTR [rax],al
   1b10f:	add    BYTE PTR [rax-0x4f],al
   1b112:	add    BYTE PTR [rax],al
   1b114:	add    BYTE PTR [rax],al
   1b116:	add    BYTE PTR [rax],al
   1b118:	out    dx,al
   1b119:	mov    cl,0x0
   1b11b:	add    BYTE PTR [rax],al
   1b11d:	add    BYTE PTR [rax],al
   1b11f:	add    BYTE PTR [rax],dh
   1b121:	mov    cl,0x0
	...
   1b12f:	add    ch,cl
   1b131:	add    cl,BYTE PTR [rbx+0x65]
   1b134:	rex.XB ins BYTE PTR es:[rdi],dx
   1b136:	gs (bad)
   1b138:	jb     0x1b17f
   1b13a:	jbe    0x1b1a1
   1b13c:	outs   dx,BYTE PTR ds:[rsi]
   1b13d:	je     0x1b13f
   1b13f:	add    BYTE PTR [rdx],al
   1b141:	add    cl,BYTE PTR [rcx+0x6f]
   1b144:	rex.RXB
   1b145:	gs je  0x1b18b
   1b148:	outs   dx,DWORD PTR ds:[rsi]
   1b149:	outs   dx,BYTE PTR ds:[rsi]
   1b14a:	imul   sp,WORD PTR [rdi+0x75],0x6172
   1b150:	je     0x1b1bb
   1b152:	outs   dx,DWORD PTR ds:[rsi]
   1b153:	outs   dx,BYTE PTR ds:[rsi]
   1b154:	rex.WB outs dx,BYTE PTR ds:[rsi]
   1b156:	outs   dx,WORD PTR ds:[rsi]
   1b158:	jb     0x1b1c7
   1b15a:	(bad)
   1b15b:	je     0x1b1c6
   1b15d:	outs   dx,DWORD PTR ds:[rsi]
   1b15e:	outs   dx,BYTE PTR ds:[rsi]
   1b15f:	add    BYTE PTR [rdx+0x6c745205],bh
   1b165:	rex.WB outs dx,BYTE PTR ds:[rsi]
   1b167:	imul   esi,DWORD PTR [rbp+rdx*2+0x6e],0x646f6369
   1b16f:	gs push rbx
   1b171:	je     0x1b1e5
   1b173:	imul   ebp,DWORD PTR [rsi+0x67],0x3650000
   1b17a:	rex.WXB
   1b17b:	gs push rbx
   1b17d:	gs je  0x1b1c5
   1b180:	jbe    0x1b1e7
   1b182:	outs   dx,BYTE PTR ds:[rsi]
   1b183:	je     0x1b185
   1b185:	add    bh,dh
   1b187:	add    cl,BYTE PTR [rbx+0x65]
   1b18a:	rex.WB outs dx,BYTE PTR ds:[rsi]
   1b18c:	imul   esi,DWORD PTR [rcx+rbp*2+0x61],0x657a696c
   1b194:	rex.RB jbe 0x1b1fc
   1b197:	outs   dx,BYTE PTR ds:[rsi]
   1b198:	je     0x1b19a
   1b19a:	xchg   DWORD PTR [rbx],eax
   1b19c:	rex.WXB
   1b19d:	gs push rdi
   1b19f:	(bad)
   1b1a0:	imul   esi,DWORD PTR [rsi+rax*2+0x6f],0x6e695372
   1b1a8:	ins    BYTE PTR es:[edi],dx
   1b1aa:	gs rex.WRXB (bad)
   1b1ad:	push   0x65
   1b1af:	movsxd esi,DWORD PTR [rax+rax*1+0x6b]
   1b1b3:	(bad)
   1b1b4:	push   rdx
   1b1b5:	je     0x1b223
   1b1b7:	push   rdi
   1b1b8:	jb     0x1b223
   1b1ba:	je     0x1b221
   1b1bc:	push   rdx
   1b1bd:	imul   esi,DWORD PTR gs:[ebx+0x74],0x61567972
   1b1c6:	ins    BYTE PTR es:[rdi],dx
   1b1c7:	jne    0x1b22e
   1b1c9:	add    BYTE PTR [rdi+0x5],ah
   1b1cc:	push   rdx
   1b1cd:	je     0x1b23b
   1b1cf:	rex.R
   1b1d0:	gs ins BYTE PTR es:[rdi],dx
   1b1d2:	gs je  0x1b23a
   1b1d5:	push   rdx
   1b1d6:	imul   esi,DWORD PTR gs:[ebx+0x74],0x61567972
   1b1df:	ins    BYTE PTR es:[rdi],dx
   1b1e0:	jne    0x1b247
   1b1e2:	add    BYTE PTR [rax],al
   1b1e4:	(bad)
   1b1e5:	or     BYTE PTR [rbx+0x74],dh
   1b1e8:	jb     0x1b258
   1b1ea:	movsxd ebp,DWORD PTR [rbp+0x70]
   1b1ed:	add    al,cl
   1b1ef:	add    cl,BYTE PTR [rbx+0x65]
   1b1f2:	rex.X jne 0x1b25c
   1b1f5:	rex.XB push 0x456b6365
   1b1fb:	js     0x1b1fd
   1b1fd:	add    BYTE PTR [rsi+0x74],ch
   1b200:	outs   dx,DWORD PTR ds:[rsi]
   1b201:	jae    0x1b26e
   1b203:	jb     0x1b273
   1b205:	ins    BYTE PTR es:[rdi],dx
   1b206:	cs gs js 0x1b26f
   1b20a:	add    BYTE PTR [rax],al
   1b20c:	push   rcx
   1b20d:	add    eax,0x436c7452
   1b212:	outs   dx,DWORD PTR ds:[rsi]
   1b213:	jo     0x1b28e
   1b215:	push   rbp
   1b216:	outs   dx,BYTE PTR ds:[rsi]
   1b217:	imul   esp,DWORD PTR [rbx+0x6f],0x74536564
   1b21e:	jb     0x1b289
   1b220:	outs   dx,BYTE PTR ds:[rsi]
   1b221:	add    BYTE PTR [eax],al
   1b224:	sub    DWORD PTR [rip+0x416c7452],eax        # 0x416e267c
   1b22a:	outs   dx,BYTE PTR ds:[rsi]
   1b22b:	jae    0x1b296
   1b22d:	rex.XB push 0x6f547261
   1b233:	push   rbp
   1b234:	outs   dx,BYTE PTR ds:[rsi]
   1b235:	imul   esp,DWORD PTR [rbx+0x6f],0x68436564
   1b23c:	(bad)
   1b23d:	jb     0x1b23f
   1b23f:	add    BYTE PTR [rax],cl
   1b241:	add    BYTE PTR [rdi+0x64],dl
   1b244:	push   si
   1b246:	gs jb  0x1b2bc
   1b249:	imul   ebp,DWORD PTR [rdi+0x6e],0x69626e55
   1b250:	outs   dx,BYTE PTR ds:[rsi]
   1b251:	add    BYTE PTR fs:[rax],al
   1b254:	(bad)
   1b255:	add    BYTE PTR [rdi+0x64],dl
   1b258:	push   si
   1b25a:	gs jb  0x1b2d0
   1b25d:	imul   ebp,DWORD PTR [rdi+0x6e],0x646e6942
   1b264:	add    BYTE PTR [rax],al
   1b266:	(bad)
   1b267:	add    BYTE PTR [rdi+0x64],dl
   1b26a:	push   si
   1b26c:	gs jb  0x1b2e2
   1b26f:	imul   ebp,DWORD PTR [rdi+0x6e],0x646e6942
   1b276:	rex.XB ins BYTE PTR es:[rdi],dx
   1b278:	(bad)
   1b279:	jae    0x1b2ee
   1b27b:	add    BYTE PTR [rcx],cl
   1b27d:	add    BYTE PTR [rdi+0x64],dl
   1b280:	push   si
   1b282:	gs jb  0x1b2f8
   1b285:	imul   ebp,DWORD PTR [rdi+0x6e],0x69626e55
   1b28c:	outs   dx,BYTE PTR ds:[rsi]
   1b28d:	fs rex.XB ins BYTE PTR es:[rdi],dx
   1b290:	(bad)
   1b291:	jae    0x1b306
   1b293:	add    BYTE PTR [rdi+0x44],dl
   1b296:	rex.RX
   1b297:	rex.WR
   1b298:	rex.R push rdx
   1b29a:	cs push rbx
   1b29c:	pop    rcx
   1b29d:	push   rbx
	...
