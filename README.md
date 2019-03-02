
# CrysisUdpsz Simple Hex Fix

64bit Crysis 1.2.1

## Bug

Crysis handles the join packets very badly with the result that is
possible to block the game server with a simple flooding of these
packets.

Practically when a join packet is received are performed some
operations over it and derived by it like the verification of the cdkey
hash with the Gamespy master server.

So after the simple sending of the same join packet (even invalid and
incomplete) with a delay of at least 40 milliseconds (depending by the
computer and the desired effect on the server) was noticed the
increasing of the CPU usage at 100% and, at the same time, the
unavailability of the server which started to ignore the incoming
packets of the other players or not handling them in time.

## Fix

It's not possible to fix these kind of attacks entirely but we can make those attacks do less harm.

### Remove CompleteEmptySuccess

```assembly
loc_396442F6:
cmp     qword ptr [rsi+18h], 0
jz      short loc_3964429E
```
```hex
58 E9 8A 01 00 00 48 83 7E 18 00 74 A1 8B 95 B8
jz short loc_3964429E change to jnz 74 A1 to 75 A1
```

### Remove incoming warning logs

```assembly 
mov     [rsp+arg_8], rbx
push    rbp
push    rsi
push    rdi
push    r12
push    r13
push    r14
push    r15
sub     rsp, 400h
mov     rax, cs:qword_396F04C0
mov     r12d, r8d
mov     r13, rcx
mov     rcx, [rax+0E0h]
mov     rsi, rdx
mov     r8, rdx
movaps  oword ptr [rsp+438h+var_48], xmm6
movss   xmm6, cs:dword_396B376C
movaps  xmm3, xmm6
lea     rdx, [rsp+438h+var_2A8]
call    sub_39642A50
lea     rcx, aDFromS    // "%d from %s"
mov     edx, r12d
mov     r8, [rax+10h]
call    sub_395297B0 // remove this call to disable logs 
mov     rcx, [rsp+438h+var_298]
lea     r11, [rsp+438h+var_290]
cmp     rcx, r11
jz      short loc_39684C03
```
```hex
call sub_395297B0(4C 8B 40 10) change to (90 90 90 90)
```

### Remove inactive connection removal loop
```assembly
loc_3968AFC8:
cmp     rbx, rdi
jnz     loc_3968AEC
```
```hex
18 48 8B D9 48 0F 45 D8 48 3B DF 0F 85 EF FE FF
jnz loc_3968AEC (0F 85 EF FE FF FF) to (90 90 90 90 90 90) 
```

### Remove WSARecv error handling
```assembly
lea     rcx, aWsarecvfromFai // "WSARecvFrom failed: %d"
mov     edx, eax
call    sub_395297B0
movzx   r8d, bx
movzx   eax, r15w
shl     r8d, 10h
mov     dword ptr [r14+20h], 2
mov     [r14+10B8h], edi
mov     rcx, [rsi+10h]  // CompletionPort
or      r8d, eax
mov     r9, r14         // lpOverlapped
add     r8d, 1          // dwCompletionKey
xor     edx, edx        // dwNumberOfBytesTransferred
call    cs:PostQueuedCompletionStatus
test    eax, eax
jnz     loc_39645079
```
```hex
jnz loc_39645079 change to jz and remove the rest of this func
0F 85 0C FF FF FF to 0F 84 0C FF FF FF
```

### Remove CDKey checks
 GameSpy is dead so key check doesnt work anyways
```hex
01 00 00 00 4D 8B E1 8B  EA 48 8B F1 75 52 49 8B
 75 52 to 90 90
 
45 85 C0 4C 89 6C 24 68  4C 89 74 24 70 75 07 44
 75 07 to 90 90
```