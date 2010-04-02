; vers.26-3-2010 
; _0xb1t_

; file: first.asm
; Dato un intero b e un indice i, implementare un programma assembly
; che, a richiesta dell'utente, ponga l'i-mo bit a 0, 1 o lo complementi
;

%include "asm_io.inc"
	 
segment .data			; dati inizializzati in .data

;stringhe di output
prompt_b db    "Inserisci b: ", 0	;don't forget nul terminator
prompt_i db    "Inserisci indice del bit da modificare: ", 0
prompt_sc	db	"0=set:0 - 1=set:1 - 2=complementa ", 0

outmsg_b db 	"b(originale): ", 0
outmsg_bn db	"b(nuovo): ", 0

 
segment .bss			; dati non inizializzati in .bss

input_b  	resd 1		;variabile numero b
input_i 	resd 1		;variabile per indice i
input_sc	resd 1		;variabile scelta
b_new		resd 1		;variabile nuovo numero b


segment .text			; codice in .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha
;;;;input b
        mov     eax, prompt_b     	;stampa prompt
        call    print_string		;
        call    read_int          	;legge numero
        mov     [input_b], eax     	;memorizza b

;;;;input i
        mov     eax, prompt_i	  	;stampa prompt
        call    print_string		;
        call    read_int          	;legge un intero da tastiera
        mov     [input_i], eax     	;memorizza i

;;;;scelta (0 - 1 - 2)
;	0: imposta a zero l'iesimo bit
;	1: imposta a uno l'iesimo bit
; 	2: complementa l'iesimo bit
	mov     eax, prompt_sc	  	;stampa prompt
        call    print_string		;
        call    read_int          	;legge un intero da tastiera
        mov     [input_sc], eax     	;memorizza input_sc

;;;; 	calcolo maschera NON COMPILA ERRORE COFF (su cl)
;;;;	ebx contiene la maschera
;		mov 	ebx, 1b			;setta ebx a 000..01
;		mov 	cl, indice_i		;numero indice per shift
;		shl 	ebx, cl			;shift a sinistra = i

	;ciclo for(ecx=i ; ecx>0 ; ecx--)
		mov 	ecx, [input_i]
		mov		ebx, 1b		;setta ebx a 000..01	
	ciclo: ;*
		cmp		ecx, 0
		je		fineciclo	;se ecx=0 esce
		shl		ebx,1		;shift a sinistra di un posto
		dec		ecx		;decrementa ecx
		jmp 	ciclo			;ritorna a ciclo*
	fineciclo:

;;;; calcolo b
		mov 	eax, [input_b]		;eax contiene b
		mov		edx, [input_sc]	;edx contiene scelta

		cmp		edx, 2		;edx = scelta
		jge		L2		;se >= 2 vai a L2
		cmp		edx, 1
		jl		L0		;se < 1 vai a L0
						;altrimenti vai a L1
	;L1	
			or eax, ebx		;setta a 1 il bit scelto
			mov [b_new], eax	;salva nuovo b
			jmp	fine
	L0:
			not ebx			;inverte maschera di bit
			and	eax, ebx	;setta a 0 il bit scelto
			mov [b_new], eax	;salva nuovo b
			jmp fine
	L2:
			xor eax, ebx		;complementa iesimo bit
			mov [b_new], eax	;salva nuovo b
		
; visualizza i risultati di output
fine:
        mov     eax, outmsg_b
        call    print_string      
        mov     eax, [input_b]     
        call    print_int      	;stampa b
		call    print_nl		;new_line
        mov     eax, outmsg_bn
        call    print_string      
        mov     eax, [b_new]
        call    print_int      			;stampa il nuovo b
        call    print_nl			;new_line

;routine di uscita        
        popa
        mov     eax, 0
        leave                     
        ret

