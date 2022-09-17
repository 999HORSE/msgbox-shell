; call MessageBoxA using manually loaded user32.dll
; asm64
; visual studio masm compiler
; #######################################################
; sources used:
; stackoverflow for annoying asm-specific-differences errors
; on shellcode basics https://securitycafe.ro/2015/10/30/introduction-to-windows-shellcode-development-part1/
; writing shellcode for win64 https://nytrosecurity.com/2019/06/30/writing-shellcodes-for-windows-x64/
; win86 MessageBox shellcode https://marcosvalle.github.io/re/exploit/2019/01/19/messagebox-shellcode.html
; similar example https://github.com/v1k1ngfr/asm-x64/blob/master/x64_MessageBoxA.asm

.code

main PROC

	; find kernel32.dll address from peb
	xor rcx, rcx
	mov rax, gs:[rcx+60h] ;gs:[00h]+60 offset = peb
	mov rax, [rax+18h]    ;loader
	mov rsi, [rax+20h]    ;inmemoryorder modules

	lodsq                ;second module
	xchg rax, rsi
	lodsq                ;third module
	mov rbx, [rax + 20h] ;base addr kernel32

	xor r8, r8
	mov r8d, [rbx + 3Ch]	  ;r8d=dos->e_lfanew OFFSET
	mov rdx, r8				  ;rdx=dos->e_lfanew
	add rdx, rbx			  ;pe header in rdx
	mov r8d, [rdx + 88h]	  ;export table in r8d OFFSET
	add r8, rbx				  ;export table in r8
	xor rsi, rsi
	mov esi, [r8 + 20h]		  ;names table
	add rsi, rbx
	xor rcx, rcx
	mov r9, 41636f7250746547h ; AcorPteG

	getFuncAddr:
		; idk how to explain
		; open up a debugger and see for yourself
		inc rcx
		xor rax, rax
		mov eax, [rsi + rcx * 4h]
		add rax, rbx
		cmp qword ptr [rax], r9 ; GetProcA
		jnz getFuncAddr
		xor rsi, rsi
		mov esi, [r8 + 24h]
		add rsi, rbx
		mov cx, [rsi + rcx * 2h]
		xor rsi, rsi
		mov esi, [r8 + 1ch]
		add rsi, rbx
		xor rdx, rdx
		mov edx, [rsi + rcx * 4h]
		add rdx, rbx
		mov rdi, rdx			; in rdi - getprocaddr func address

	mov rcx, 41797261h		    ; aryA
	push rcx					; push to stack
	mov rcx, 7262694c64616f4Ch  ; LoadLibr
	push rcx				    ; push to stack
	mov rdx, rsp			    ; LoadLibraryA STRING in rcx
	mov rcx, rbx			    ; kernel32.dll base address in rcx
	sub rsp, 30h			    ; allocate stack space for function call
	call rdi				    ; call GetProcAddress 
	add rsp, 30h				; cleanup allocated stack space
	add rsp, 10h				; clean stack space for LoadLibrary string
	mov rsi, rax				; LoadLibrary address saved in rsi

	; call LoadLibraryA("user32.dll")
	; loadlibrary calling convention is so that u have to push the NULL line terminator byte before the lib name
	; otherwise it EXPLODES
	xor rcx, rcx				 ; NULL string terminator
	push rcx					 ; push to stack
	mov rcx, 6c6ch               ; ll
	push rcx                     ; push to stack
	mov rcx, 642e323372657375h   ; user32.d
	push rcx                     ; push to stack
	mov rcx, rsp                 ; user32.dll
	sub rsp, 30h                 ; allocate stack space for function call
	call rsi                     ; call LoadLibraryA
	add rsp, 30h                 ; clean allocated stack space
	add rsp, 10h                 ; clean space for user32.dll string
	mov r15, rax                 ; address of user32.dll in r15

	; call GetProcAddress("MessageBoxA")
	; int MessageBoxA(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType);
	xor rcx, rcx	   ; NULL string terminator
	push rcx		   ; push 0 to stack 
	mov rcx, 41786f41h ; oxA+A
	shr rcx,8		   ; oxA
	push rcx		   ; push to stack
	mov rcx, 426567617373654dh ; MessageB
	push rcx		   ; push to stack
	mov rdx, rsp	   ; MessageBoxA
	mov rcx, r15	   ; user32.dll base address
	sub rsp, 28h	   ; allocate stack space for function call
	call rdi	       ; call GetProcAddress
	add rsp, 28h	   ; cleanup allocated stack space
	add rsp, 18h	   ; clean space for MessageBoxA string
	mov r15, rax	   ; MessageBoxA in r15 (PROCADDRESS)

	; calling convention: MessageBoxA(rcx, rdx, r8, r9) 
	xor rcx,rcx         ; 0
	xor rax, rax
	push rax
	mov  rax, 776f656dh ; lpText ; meow
	push rax
	mov rdx, rsp
	xor rax, rax
	push rax
	mov  rax, 6c6f6ch   ; lpCaption ; lol
	push rax
	mov r8, rsp
	xor r9,r9 ;         ; 0
	call r15      ; call MessageBoxA(0,"meow","lol",0)

	; call GetProcAddress(kernel32.dll, "ExitProcess")
	xor rcx, rcx
	mov rcx, 737365h ; ess
	push rcx
	mov rcx, 636f725074697845h ; ExitProc
	push rcx
	mov rdx, rsp ; ExitProcess
	mov rcx, rbx ; kernel32.dll base address
	sub rsp, 30h ; allocate stack space for function call
	call rdi	 ; call GetProcAddress
	add rsp, 30h ; cleanup allocated stack space
	add rsp, 10h ; clean space for ExitProcess string
	mov r15, rax ; ExitProcess in r15

	; call ExitProcess(0)
	mov rcx, 0
	call r15 ;ExitProcess(0)

main ENDP

END