; vers.2-4-2010 
; _0xb1t_

; file: first.asm
; Dato un numero intero ed un esponente
; ne calcola il risultato

;eax=numero
;ebx=esponente
;edx=parziale

%include "asm_io.inc"
	 
segment .data		;dati inizializzati in .data
prompt_x	db		"Inserisci un numero (intero): ", 0	;don't forget nul terminator
prompt_y	db		"Inserisci esponente ", 0
outmsg_ris	db 		"Risultato: ", 0

segment .bss		;dati non inizializzati in .bss
x  		resd 1		;variabile numero x
y		resd 1		;variabile esponente y
ris		resd 1		;var risultato

segment .text			; codice in .text
        global  _asm_main
_asm_main:
        enter   0,0			; setup routine
        pusha
;;;;input x
	mov eax, prompt_x
	call print_string
	call read_int
	mov [x], eax
;;;;input y
	mov eax, prompt_y
	call print_string
	call read_int
	mov [y], eax

;CONTROLLO ESPONENTE - se 0, risultato 1
	mov	ebx, [y]
	cmp ebx,0		;se esponente 0
	je	ESP0		;salta a etichetta esp0
	jmp SETUP		;altrimenti calcola

ESP0:
	mov edx,1		;risultato = 1
	jmp FINE		;fine calcolo

SETUP:
	mov	eax, [x]	;eax = numero x
	mov edx, eax	;copia numero in parziale
	jmp CALCOLA		;calcola

CALCOLA:
	cmp ebx,1		;se cont=1
	jng	FINE		;fine del calcolo
	imul edx, eax	;calcolo
	mov [ris], edx	;salva risultato
	dec ebx			;decrementa contatore
	jmp CALCOLA		;ripete ciclo

FINE:
	;edx contiene ancora il risultato
	mov [ris], edx	;salva risultato
	
;STAMPA:
	mov eax, outmsg_ris
	call print_nl
	call print_string
	mov	eax, [ris]
	call print_int

;routine di uscita        
        popa
        mov     eax, 0
        leave                     
        ret
        
 