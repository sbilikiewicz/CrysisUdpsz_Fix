// ::: Remove CompleteEmptySuccess

loc_396442F6:
cmp     qword ptr [rsi+18h], 0
jz      short loc_3964429E

jz short loc_3964429E//74 A1 to 75 A1

// ::: Remove attack incoming warning logs
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

call sub_395297B0//4C 8B 40 10 change to 90 90 90 90

// ::: Remove inactive connection removal loop

loc_3968AFC8:
cmp     rbx, rdi
jnz     loc_3968AEC

jnz loc_3968AEC //0F 85 EF FE FF FF to 90 90 90 90 90 90 

// ::: Remove WSARecv error handling

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

jnz loc_39645079 //change to jz and remove the rest of this func
//0F 85 0C FF FF FF to 0F 84 0C FF FF FF




