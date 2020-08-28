# Data Structures in Raw Assembly

Trabajo realizado en el segundo cuatrimestre del 2019, materia Organizacion del Computador II @UBA-CiencisExactasyNaturales.

Se implementan un conjunto de funciones sobre distintas estructuras de datos. 
Teniendo dos estructuras básicas y una estructura compleja, denominadas String, List y
HashTable respectivamente.
- Las funciones de String serán operaciones sobre cadenas de caracteres, cuya finalización está determinada por la aparición del caracter nulo, es decir, las cadenas terminan en cero. 
- Las funciones de Lists
permitirán crear, agregar, borrar e imprimir elementos de una lista doblemente enlazada. 
- La estructura
HashTable será un vector de listas que permita guardar datos en listas indexadas sobre un vector de
tamaño fijo.

## Funciones a implementar en lenguaje ensamblador

Funciones de `string`:
- [X] `char* strClone(char* pString)` (19 Inst.)
- [X] `uint32_t strLen(char* pString)` (7 Inst.)
- [X] `int32_t strCmp(char* pStringA, char* pStringB)` (25 Inst.)
- [X] `char* strConcat(char* pStringA, char* pStringB)` (42 Inst.)
- [X] `void strDelete(char* pString)` (1 Inst.)
- [X] `void strPrint(char* pString, FILE *pFile)` (7 Inst.)

Funciones de `list_t`:
- [X] `list_t* listNew()` (7 Inst.)
- [X] `void listAddFirst(list_t* l, void* data)` (21 Inst.)
- [X] `void listAddLast(list_t* pList, void* data)` (21 Inst.)
- [X] `void listAdd(list_t* pList, void* data, funcCmp_t* fc)` (54 Inst.)
- [X] `void listRemoveFirst(list_t* pList, funcDelete_t* fd)` (16 Inst.)
- [X] `void listRemoveLast(list_t* pList, funcDelete_t* fd)` (16 Inst.)
- [X] `void listRemove(list_t* pList, void* data, funcCmp_t* fc, funcDelete_t* fd)` (49 Inst.)
- [X] `void listDelete(list_t* pList, funcDelete_t* fd)`(26 Inst.)
- [x] `void listPrint(list_t* pList, FILE *pFile, funcPrint_t* fp)`(40 Inst.)

Funciones de `hashTable_t`:
- [X] `hashTable_t* hashTableNew(uint32_t size, funcHash_t* funcHash)` (32 Inst.)
- [X] `void hashTableAdd(hashTable_t* pTable, void* data)` (13 Inst.)
- [X] `void hashTableDeleteSlot(hashTable_t* pTable, uint32_t slot, funcDelete_t* fd)` (21 Inst.)
- [X] `void hashTableDelete(hashTable_t* pTable, funcDelete_t* fd)` (21 Inst.)


## Funciones a implementar en `C`:
- [X] `char* strSubstring(char* pString, uint32_t inicio, uint32_t fin)` (15 lines)
- [X] `void listPrintReverse(list_t* pList, FILE *pFile, funcPrint_t* fp)` (15 lines)
- [X] `void hashTableRemoveAll(hashTable_t* pTable, void* data, funcCmp_t* fc, funcDelete_t* fd)` (21 lines)
- [X] `void hashTablePrint(hashTable_t* pTable, FILE *pFile, funcPrint_t* fp)` (5 lines)



