; vers.26-3-2010 
; _0xb1t_

; file: first.asm
; Dato un intero n a 32bit, implementare un programma assembly
; che calcoli il numero di bit = 1


%include "asm_io.inc"
	 
segment .data		;dati inizializzati in .data
prompt_n	db		"Inserisci n (intero): ", 0	;don't forget nul terminator
outmsg_nn	db 		"Numero di bit = 1: ", 0

segment .bss		;dati non inizializzati in .bss
n  		resd 1			;variabile numero n
nn		resd 1			;variabile nuovo numero n

segment .text			; codice in .text
        global  _asm_main
_asm_main:
        enter   0,0					; setup routine
        pusha
;;;;input n
        mov     eax, prompt_n		;stampa prompt
        call    print_string		;
        call    read_int          	;legge numero
		mov     [n], eax     		;memorizza n
		mov 	eax, [n]
		xor 	ebx,ebx		;ebx=0

ciclo:
		dump_regs 1
		cmp eax, 0
		je 	esci		;se eax=0 esci
		shr eax, 1		;shift destra
		jnc	ciclo		;se esce 0 ritorna a ciclo
		inc ebx
		jmp ciclo
esci:
		mov [nn], ebx		;salva numero di bit a 1
		
		mov eax, outmsg_nn
		call print_nl
		call print_string
		mov	eax, [nn]
		call print_int

;routine di uscita        
        popa
        mov     eax, 0
        leave                     
        ret
        
        