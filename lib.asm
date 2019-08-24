
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
global listPrintReverse
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
    xor rax, rax

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

; bool strEqual(char *a, char *b)
strEqual:
    push rbp    
    mov rbp,rsp     
    push r12
    push r13

    xor rax, rax                ; inicio contador

.ciclo:
    mov r12b, byte[rdi + rax]   ;cargo una letra de a
    mov r13b, byte[rsi + rax]   ;"      "   "    "  b
    inc rax                     ;incremento contador, rax
    cmp r12b, r13b              ;comparo...
    jne .Distintos
    cmp r12b, 0                 ;fin de caracter???
    je .Iguales
    jmp .ciclo

.Distintos: 
    mov rax, 1
    jmp .fin 

.Iguales:   
    mov rax, 0

.fin:
    pop r13
    pop r12
    pop rbp
    ret

; int32_t strCmp(char* pStringA, char* pStringB)
strCmp:
    push rbp
    mov rbp,rsp     
    push r12
    push r13

    mov r12, rdi
    mov r13, rsi
    call strEqual
    cmp rax, 0
    je .fin
    xor rax, rax                    ; limpio rax para inicializar contador o devolver 0
    xor r9, r9
    xor r8, r8
    
.ciclo:
    mov r8b, byte[r12+rax]          ;r8b = itera sobre a
    mov r9b, byte[r13+rax]          ;r9b = itera sobre b
    inc rax
    cmp r9b, r8b                    ; comparo char by char
    je .ciclo                       ; si son iguales, sigo iterando

    jg .EsMayor                     ; termino si es mayor

    jl .EsMenor                     ; termino si es menor

.EsMayor:
    mov rax, 1
    jmp .fin
.EsMenor:
    mov rax, -1

.fin: 
    pop r13
    pop r12
    pop rbp
    ret

; char* strConcat(char* pStringA, char* pStringB)
strConcat:
push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14

    mov r12, rdi        ; resguardo los punteros a cada char r12 = a
    mov r13, rsi        ; r13 = b
    
    call strLen
    mov rbx, rax        ; rbx = len(a)

    mov rdi, r13
    call strLen        ; rax = len(b)

    mov rdi, rbx        ; rdi = len(a)
    add rdi, rax        ; rdi = len(a) + len(b)
    inc rdi             

    call malloc         ; rax = puntero new struct char (len(a)+len(b))
    xor rcx, rcx        ; contador para new
    xor r8, r8          ; contador para A
    xor r9, r9          ; contador para B

.cicloA:
    mov r14b, byte[r12+r8]
    cmp r14b, 0
    je .CicloB
    inc r8
    mov byte[rax+rcx], r14b
    inc rcx
    jmp .cicloA

.CicloB:
    mov r14b, byte[r13+r9]
    cmp r14b, 0
    je .fin
    inc r9
    mov byte[rax+rcx], r14b
    inc rcx
    jmp .CicloB

.fin:
    mov byte[rax+rcx], NULL
    mov r14, rax
    ;libero memoria de a y b
    cmp r12, r13
    je .saltar              ;si a == b me alcanza con borrar uno de los dos
    mov rdi, r12
    call strDelete
.saltar:
    mov rdi, r13
    call strDelete

    mov rax, r14

    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; void strDelete(char* pString)
strDelete:
    push rbp
    mov rbp, rsp

    cmp rdi, NULL
    je .finish
    call free

    mov rdi, NULL

.finish:
    pop rbp
    ret

; void strPrint(char* pString, FILE *pFile) 
strPrint:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 8

    mov rbx, rdi
    mov rdi, rsi                ;rdi = pfile
    mov rsi, formatoString      ;rsi = formato que quiero imprimir
    mov r8, rbx
    mov r9b, [r8]
    cmp r9b, NULL
    je .PrintNull
    mov rdx, r8                 ;edx = dato que voy a imprimir
    call fprintf
    jmp .fin

.PrintNull: 
    mov rdx, charNull
    call fprintf

.fin:
    add rsp, 8
    pop rbx
    pop rbp     
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                       List                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; list_t* listNew()
listNew:
    push rbp
    mov rbp, rsp

    mov rdi, S_LIST_SIZE         ;tamaño del strcut que voy a pedir a malloc
    call malloc                  ;en Rax tengo puntero a struct

    mov qword[rax+OFFSET_FIRST_L], NULL  
    mov qword[rax+OFFSET_LAST_L], NULL

    pop rbp
    ret

; void listAddFirst(list_t* pList, void* data)
listAddFirst:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    
    mov rbx, rdi                            ;rbx = l
    mov r12, rsi                            ;r12 = data
    mov rdi, S_LIST_ELEM_SIZE               ;para pedir memoria p/ s_listElem 
    call malloc
    mov qword[rax+OFFSET_DATA], r12       ;seteo puntero a data
    mov qword[rax+OFFSET_PREV], NULL        ;anterior es NULL ya que lo agrego al comienzo de la lista

    mov rdi, [rbx+OFFSET_FIRST_L]           ;rdi = first_l
    cmp rdi, NULL                           ;es la lista vacia?. 
    je .agPrim

    mov r8, qword[rbx+OFFSET_FIRST_L]       ;r8 = first_old
    mov qword[r8+OFFSET_PREV], rax          ;r8->prev = nuevo
    mov qword[rax+OFFSET_NEXT], r8          ;nuevo->next = r8
    jmp .fin

.agPrim:
    mov qword[rax+OFFSET_NEXT], NULL
    mov qword[rbx+OFFSET_LAST_L], rax
    
.fin:   
    mov qword[rbx+OFFSET_FIRST_L], rax
    mov rax, rbx
    
    pop r12
    pop rbx
    pop rbp
    ret

; void listAddLast(list_t* pList, void* data)
listAddLast:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov rbx, rdi                                    ;rbx = list
    mov r12, rsi                                    ;r12 = data

    mov rdi, S_LIST_ELEM_SIZE
    call malloc
    mov qword[rax+OFFSET_DATA], r12               ;seteo data en nuevo strucElem
    mov qword[rax+OFFSET_NEXT], NULL                ;rax = new listElem

    mov r8, [rbx+OFFSET_LAST_L]                    ;r8 = actual (itera sobre l)
    cmp r8, NULL
    je .AddFirst

    mov qword[r8+OFFSET_NEXT], rax                 ;last_old->nex = new
    mov qword[rax+OFFSET_PREV], r8                 ;new->prev = last_old
    jmp .terminar

.AddFirst:
    mov qword[rax+OFFSET_PREV], NULL
    mov qword[rbx+OFFSET_FIRST_L], rax

.terminar:
    mov qword[rbx+OFFSET_LAST_L], rax
    mov rax, rbx
    pop r12
    pop rbx
    pop rbp
    ret

; void listAdd(list_t* pList, void* data, funcCmp_t* fc)
listAdd:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    mov rbx, rdi        ;rbx = rdi = l
    mov r12, rsi        ;r12 = rsi = data
    mov r13, rdx        ;r13 = rdx = fc

    mov  r15, qword[rbx+OFFSET_FIRST_L]         ;r15 = iterator (arranca con first)
    cmp r15, NULL                               ;si la lista es vacia llamo a addFirst
    je .agPrim

.while:
    mov rdi, qword[r15+OFFSET_DATA]             ;rdi = actual->data (puede ser int o char)
    mov rsi, r12                                ;rsi = nuevo
    call r13                                    ;llamo a funcCmp
    cmp rax, -1                                  ;si es mayor lo inserte en ese lugar caso contrario ***
    je .agregarAca

    mov r15, qword[r15+OFFSET_NEXT]            ;r15 = actual  
    cmp r15, NULL                              ;si en el siguiente ciclo ya no tengo contra quien comparar lo agrego al final
    je .agUlt
    jmp .while                                 ; *** sigo avanzando

.agPrim: 
    mov rdi, rbx
    mov rsi, r12
    call listAddFirst
    jmp .terminar

.agregarAca:
    mov r8, [rbx+OFFSET_FIRST_L]
    cmp r8, r15
    je .agPrim                                 ;si actual es el primero estaria agregando el nuevo adelante de todos (*)
    mov rdi, S_LIST_ELEM_SIZE
    call malloc

    mov qword[rax+OFFSET_DATA], r12               ;seteo data en nuevo
    mov r14, [r15+OFFSET_PREV]                      ;se que actual->prev nunca puede ser NULL por (*) ya que si no lo estaria agregando como primer elemento
    mov qword[rax+OFFSET_NEXT], r15                 ;nuevo->sig = actual
    mov qword[rax+OFFSET_PREV], r14                 ;nuevo->ant = old_ant
    mov qword[r15+OFFSET_PREV], rax                 ;actual->ant = nuevo
    mov qword[r14+OFFSET_NEXT], rax                 ;old_ant = nuevo
    jmp .terminar

.agUlt:
    mov rdi, rbx
    mov rsi, r12
    call listAddLast

.terminar:
    mov rax, rbx
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; void listRemove(list_t* pList, void* data, funcCmp_t* fc, funcDelete_t* fd)
listRemove:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    mov rbx, rdi        ;rbx = rdi = l
    mov r12, rsi        ;r12 = rsi = data
    mov r13, rdx        ;r13 = rdx = fc
    mov r14, rcx        ;r14 = rxc = fd

    mov r15, qword[rbx+OFFSET_FIRST_L]          ;r15 = iterator (arranca con first)
    
.while:
    cmp r15, NULL                               ;si la lista es vacia, no tengo nada que borrar
    je .terminar
    mov rdi, qword[r15+OFFSET_DATA]           ; rdi = actual->data 
    mov rsi, r12                                ; rsi = aBorrar
    call r13                                    ; llamo a funcCmp
    cmp rax, 0                                  ; si son iguales lo borro
    je .Eliminar
    mov r15, qword[r15+OFFSET_NEXT]            ; r15 = actual  
    jmp .while                                 ; si llegue al final y no hubo coincidencia termino

.Eliminar:
    mov rdi, r15                                ; rdi = elemento a borrar del estruc
    mov r8, qword[rbx+OFFSET_FIRST_L]
    cmp rdi, r8
    je .eliminarPrim
    mov r8, qword[rbx+OFFSET_LAST_L]
    cmp rdi, r8
    je .eliminarUlt
    jmp .eliminar

.eliminarPrim:
    mov r15, qword[r15+OFFSET_NEXT]
    mov rdi, rbx
    mov rsi, r14
    call listRemoveFirst
    jmp .while

.eliminarUlt:
    mov rdi, rbx
    mov rsi, r14
    call listRemoveLast
    jmp .terminar
    
.eliminar:    
    mov rdi, qword[r15+OFFSET_DATA]           ; rdi = puntero aBorrar
    cmp r14, NULL                               ; fd =? NULL
    je .eliminarAmano
    call r14
    jmp .seguir

.eliminarAmano:
    mov rdi, r15                                ;rdi = *data (int o string)
    mov r15, qword[r15+OFFSET_NEXT]             ;actualizo los punteros!!!! 
    
    mov r8, qword[rdi+OFFSET_PREV]              ; r8 = actual->ant (no puede ser NULL porque si no seria el ultimo)
    mov r9, qword[rdi+OFFSET_NEXT]              ; r9 = actual->sig ("    "    "   "     "     "        "el primero)
    mov qword[r8+OFFSET_NEXT], r9
    mov qword[r9+OFFSET_PREV], r8

    mov qword[rdi+OFFSET_DATA], NULL
    mov qword[rdi+OFFSET_NEXT], NULL
    mov qword[rdi+OFFSET_PREV], NULL
    call free
    jmp .while

.seguir:
    mov rdi, r15                                ;rdi = *data (int o string)
    mov r15, qword[r15+OFFSET_NEXT]
                                                ;actualizo los punteros!!!! 
    mov r8, qword[rdi+OFFSET_PREV]              ; r8 = actual->ant (no puede ser NULL porque si no seria el ultimo)
    mov r9, qword[rdi+OFFSET_NEXT]              ; r9 = actual->sig ("    "    "   "     "     "        "el primero)
    mov qword[r8+OFFSET_NEXT], r9
    mov qword[r9+OFFSET_PREV], r8

    mov qword[rdi+OFFSET_DATA], NULL
    mov qword[rdi+OFFSET_NEXT], NULL
    mov qword[rdi+OFFSET_PREV], NULL
    call free
    jmp .while

.terminar:
    mov rax, rbx
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; void listRemoveFirst(list_t* pList, funcDelete_t* fd)
listRemoveFirst:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    
    mov rbx, rdi                                 ;rbx = list
    mov r14, rsi 

    mov r12, [rdi+OFFSET_FIRST_L]                ;r12 = first
    cmp r12, NULL                                ; si la lista es nula no tengo nada que borrar, me voy
    je .fin
    mov r13, [r12+OFFSET_NEXT]                    ;r13 = next, puede ser NULL
    
    mov rdi, [r12+OFFSET_DATA]
    cmp rsi, NULL
    je .continue
    call rsi

.continue:
    mov rdi, r12                                 ; rdi = *data (int o string)
    call free

    mov qword[rbx+OFFSET_FIRST_L], r13
    mov r8, [rbx+OFFSET_FIRST_L]
    cmp r8, NULL
    je .fin
    mov qword[r8+OFFSET_PREV], NULL

.fin:
    mov rax, rbx
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; void listRemoveLast(list_t* pList, funcDelete_t* fd)
listRemoveLast:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14

    mov rbx, rdi                                 ;rbx = list

    mov r12, [rdi+OFFSET_LAST_L]                ;r12 = first
    cmp r12, NULL                                ; si la lista es nula no tengo nada que borrar, me voy
    je .fin
    mov r13, [r12+OFFSET_PREV]                    ;r13 = prev, puede ser NULL
    

    mov rdi, [r12+OFFSET_DATA]
    cmp rsi, NULL
    je .continue
    call rsi

.continue:
    mov rdi, r12                                 ; rdi = *data (int o string)
    call free

    mov qword[rbx+OFFSET_LAST_L], r13
    mov qword[r13+OFFSET_NEXT], NULL
    mov r8, [rbx+OFFSET_FIRST_L]
    cmp r8, NULL
    jne .fin
    mov qword[rbx+OFFSET_FIRST_L], NULL

.fin:
    mov rax, rbx
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; void listDelete(list_t* pList, funcDelete_t* fd)
listDelete:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 8
                                                ;rsi = funcDelete_t*
    mov rbx, rdi                                ;rbx = rdi
    mov r13, rsi                                ;r13 = rsi = fd

.while: 
    mov r12, qword[rbx+OFFSET_FIRST_L]          ;r12 = fisrt(it)
    mov rdi, rbx                                ;recupero list
    mov rsi, r13
    cmp r12, NULL                               ;si r12 es Null termine de recorrer
    je .finish
    call listRemoveFirst
    jmp .while

.finish:                                        ;libero memoria del struct
    mov rdi, rbx
    call free

    add rsp, 8
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; void listPrint(list_t* pList, FILE *pFile, funcPrint_t* fp)
listPrint:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    
    mov rbx, rdi                ;rbx = rdi
    mov r12, rsi                ;r12 = rsi
    mov r14, rdx

    mov rdi, rsi                ;rdi = pfile
    mov rsi, formatoString      ;rsi = formato que quiero imprimir
    mov edx, abrir              ;edx = dato que voy a imprimir
    call fprintf

    mov r13, qword[rbx+OFFSET_FIRST_L] ;r13 = iterador
.ciclo:
    cmp r13, NULL
    je .finish
    mov rdi, qword[r13+OFFSET_DATA]           ;cargo datos para llamar al print de s_element 
    mov rsi, r12                                ;rsi = *pfile
    call r14                                    ;r14 = *Fprint
    mov r13, qword[r13+OFFSET_NEXT]
    cmp r13, NULL
    je .saltar

    mov rdi, r12
    mov rsi, formatoString
    mov edx, coma
    call fprintf
.saltar:
    jmp .ciclo

.finish:
    mov rdi, r12                ;rdi = pfile
    mov rsi, formatoString      ;rsi = formato que quiero imprimir
    mov edx, cerrar             ;edx = dato que voy a imprimir
    call fprintf

    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

listPrintReverse:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    
    mov rbx, rdi                ;rbx = rdi
    mov r12, rsi                ;r12 = rsi
    mov r14, rdx

    mov rdi, rsi                ;rdi = pfile
    mov rsi, formatoString      ;rsi = formato que quiero imprimir
    mov edx, abrir              ;edx = dato que voy a imprimir
    call fprintf

    mov r13, qword[rbx+OFFSET_LAST_L] ;r13 = iterador
.ciclo:
    cmp r13, NULL
    je .finish
    mov rdi, qword[r13+OFFSET_DATA]           ;cargo datos para llamar al print de s_element 
    mov rsi, r12                                ;rsi = *pfile
    call r14                                    ;r14 = *Fprint
    mov r13, qword[r13+OFFSET_PREV]
    cmp r13, NULL
    je .saltar

    mov rdi, r12
    mov rsi, formatoString
    mov edx, coma
    call fprintf
.saltar:
    jmp .ciclo

.finish:
    mov rdi, r12                ;rdi = pfile
    mov rsi, formatoString      ;rsi = formato que quiero imprimir
    mov edx, cerrar             ;edx = dato que voy a imprimir
    call fprintf

    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              		 HashTable                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hashTable_t* hashTableNew(uint32_t size, funcHash_t* funcHash)
hashTableNew:
	push rbp
	mov rbp, rsp
	push r12
	push r13

	mov r12, rdi
	mov r13, rsi

	mov rdi, S_HASH_TABLE_SIZE
	call malloc

	mov qword[rax+OFFSET_LIST], NULL
	mov qword[rax+OFFSET_SIZE], r12
	mov qword[rax+OFFSET_FUNHASH], r13




    ret

; void hashTableAdd(hashTable_t* pTable, void* data)
hashTableAdd:
    ret

; void hashTableDeleteSlot(hashTable_t* pTable, uint32_t slot, funcDelete_t* fd)
hashTableDeleteSlot:
    ret

; void hashTableDelete(hashTable_t* pTable, funcDelete_t* fd)
hashTableDelete:
    ret
