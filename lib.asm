
extern malloc
extern free
extern fprintf

global strLen
global strClone
global strCmp
global strConcat
global strDelete
global strPrint
global listNew
global listAddFirst
global listAddLast
global listAdd
global listRemove
global listRemoveFirst
global listRemoveLast
global listDelete
global listPrint
global hashTableNew
global hashTableAdd
global hashTableDeleteSlot
global hashTableDelete

;/** define puntero **/
    %define NULL 0

%define S_LIST_ELEM_SIZE    24  ; 8*(3 PUNTEROS)
%define S_LIST_SIZE         16  ; 2*8bytes
%define S_HASH_TABLE_SIZE   24  ; 2*8bytes + 4bytes (no es packet, hay que alineaar)

; Los siguientes OFFSET corresponden a los datos declarados en struct s_listElem()
%define OFFSET_DATA         0 
%define OFFSET_NEXT         8 
%define OFFSET_PREV         16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Los siguientes OFFSET corresponden con los datos declarados en struct s_list
%define OFFSET_FIRST_L      0 ;; struct enum 4byte
%define OFFSET_LAST_L       8 ;; puntero a funcion 8bytes

; Los siguiente OFFSET se corresponde con los datos declarados en struct s_Hash_Table()
%define OFFSET_LIST         0 
%define OFFSET_SIZE         8 
%define OFFSET_FUNHASH      16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .rodata ;Aca van las constantes
section .data

formatoInt: DB '%i', 0
formatoString:  DB '%s', 0
formatoChar: DB '%c', 0
charNull:   DB 'NULL', 0
endline:    DB 10, 0
abrir:      DB '[',0
cerrar:     DB ']',0
coma:       DB ',',0

section .text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        String                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;uint32_t strLen(char* pString)
strLen:     ;rdi = pSting
    push rbp
    mov rbp, rsp
    ;alineado (si pusheo #reg impares)

.ciclo:
    mov r8b, byte[rdi+rax]  
    cmp r8b, 0              ; llegue al final del string?
    je .fin                 ; si es asi, termine
    inc rax                 ; si no, incremeto rax y vuelvo a iterar
    jmp .ciclo

.fin:
    pop rbp
    ret

;char* strClone(char* pString)
strClone:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8

    xor rax, rax

    mov r12, rdi            ; r12 = *a (para llamar a strLen)
    call strLen             ; eax = len(a)
    mov r13, rax            ; r13 = eax = len(a)
    mov rdi, rax            ; solo lo uso para llamar a malloc! puedo usarlo tmb en .ciclo con loop
    inc rdi                 ; aumento la long en 1 para terminar el string en "0"
    call malloc             ; rax = puntero al nuevo string *new
    mov r8, rax             ; resguardo el puntero a res
    xor rcx, rcx            ; contador para long

    cmp r13, 0

.ciclo:
    mov r14b, byte[r12+rcx]
    mov [rax+rcx], r14b
    cmp r14b, 0             ; me fijo que no sea string vacio
    je .fin                 ; si lo es, termino!
    inc rcx
    cmp rcx, r13
    jne .ciclo
    ;jmp .ciclo
    mov byte[rax+rcx], NULL

.fin:
    mov rax, r8             ; devuelve puntero *a
    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

strCmp:
    ret

strConcat:
    ret

strDelete:
    ret
 
strPrint:
    ret
    
listNew:
    ret

listAddFirst:
    ret

listAddLast:
    ret

listAdd:
    ret

listRemove:
    ret

listRemoveFirst:
    ret

listRemoveLast:
    ret

listDelete:
    ret

listPrint:
    ret

hashTableNew:
    ret

hashTableAdd:
    ret
    
hashTableDeleteSlot:
    ret

hashTableDelete:
    ret
