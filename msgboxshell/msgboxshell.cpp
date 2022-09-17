#include <iostream>
#include <Windows.h>

//void asm_foo() {
//	__asm { // rewrite to plain cpp
//		xor rcx, rcx
//		mov rax, [gs:rcx + 0x60]
//		//gs:[0x00]+0x60 offset = peb
//		mov rax, [rax + 0x18] //loader
//		mov rax, [rax + 0x20] //inmemoryorder modules
//
//		lodsq //second module
//		xchg rax, rsi
//		lodsq //third module
//		mov rbx, [rax + 0x20] //base addr kernel32
//
//		xor r8, r8
//		mov r8d, [rbx + 0x3C] //r8d=dos->e_lfanew OFFSET
//		mov rdx, r8 //rdx=dos->e_lfanew
//		add rdx, rbx //pe header in rdx
//		mov r8d, [rdx + 0x88] //export table in r8d OFFSET
//		add r8, rbx //export table in r8
//		xor rsi, rsi
//		mov esi, [r8 + 0x20] // names table
//		add rsi, rbx
//		xor rcx, rcx
//		mov r9, 0x41636f7250746547 // AcorPteG
//
//		getNamedFunc:
//		inc rcx
//			xor rax, rax
//			mov eax, [rsi + rcx * 4]
//			add rax, rbx
//			cmd QWORD[rax], r9 // AcorPteG ?
//			jnz getNamedFunc
//			xor rsi, rsi
//			mov esi, [r8 + 0x24]
//			add rsi, rbx
//			mov cx, [rsi + rcx * 2]
//			xor rsi, rsi
//			mov esi, [r8 + 0x1c]
//			add rsi, rbx
//			xor rdx, rdx
//			mov edx, [rsi + rcx * 4]
//			add rdx, rbx
//			mov rdi, rdx // in rdi - getprocaddr
//
//			//Use GetProcAddress to find the address of LoadLibrary
//			mov rcx, 0x41797261 // aryA
//			push rcx // Push on the stack
//			mov rcx, 0x7262694c64616f4c // LoadLibr
//			push rcx // Push on stack
//			mov rdx, rsp // LoadLibraryA
//			mov rcx, rbx // kernel32.dll base address
//			sub rsp, 0x30 // Allocate stack space for function call
//			call rdi // Call GetProcAddress
//			add rsp, 0x30 // Cleanup allocated stack space
//			add rsp, 0x10 // Clean space for LoadLibrary string
//			mov rsi, rax // LoadLibrary saved in RSI
//
//			mov rcx, 0x6c6c // ll (text, not eleven)
//			push rcx // Push on the stack
//			mov rcx, 0x642e323372657375 // user32.d
//			push rcx // Push on stack
//			mov rcx, rsp // user32.dll
//			sub rsp, 0x30 // Allocate stack space for function call
//			call rsi // Call LoadLibraryA
//			add rsp, 0x30 // Cleanup allocated stack space
//			add rsp, 0x10 // Clean space for user32.dll string
//			mov r15, rax // Base address of user32.dll in R15
//
//			//Call GetProcAddress(user32.dll, "SwapMouseButton")
//			xor rcx, rcx // RCX = 0
//			push rcx // Push 0 on stack
//			mov rcx, 0x6e6f7474754265 // eButton
//			push rcx // Push on the stack
//			mov rcx, 0x73756f4d70617753 // SwapMous
//			push rcx // Push on stack
//			mov rdx, rsp // SwapMouseButton
//			mov rcx, r15 // User32.dll base address
//			sub rsp, 0x28 // Allocate stack space for function call
//			call rdi // Call GetProcAddress
//			add rsp, 0x28 // Cleanup allocated stack space
//			add rsp, 0x18 // Clean space for SwapMouseButton string
//			mov r15, rax // SwapMouseButton in R15
//			//Call SwapMouseButton(true)
//			mov rcx, 1
//			call r15 // SwapMouseButton(true)
//
//			// Call GetProcAddress(kernel32.dll, "ExitProcess")
//			xor rcx, rcx
//			mov rcx, 0x737365 // ess
//			push rcx
//			mov rcx, 0x636f725074697845 // ExitProc
//			push rcx
//			mov rdx, rsp // ExitProcess
//			mov rcx, rbx // Kernel32.dll base address
//			sub rsp, 0x30 // Allocate stack space for function call
//			call rdi // Call GetProcAddress
//			add rsp, 0x30 // Cleanup allocated stack space
//			add rsp, 0x10 // Clean space for ExitProcess string
//			mov r15, rax // ExitProcess in R15
//			// Call ExitProcess(0)
//			mov rcx, 0
//			call r15 //ExitProcess(0)
//	};
//}

int main()
{

	return 0;
}