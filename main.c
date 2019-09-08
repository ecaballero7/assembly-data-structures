#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"

char* strings[33] = {"W","Y",";",":","Z","X", "V", "queso", "true", "vino", "nomo", "siu", "uva", "war", "casa", "flor", "kuhn", "lorena", "gato", "hilo", "jardin", "isla", "mama", "ala","dedo","edgar","pauli", "beso", "zz", "yy", "xx", "oso", "rata"};

void test_hashTable(FILE *pfile)
{
//Crear una HashTable vacı́a de tamaño 33.
//Agregar un string en todos los slots.
//Imprimir la HashTable.
    hashTable_t* ht;
    char* *a, *b, *c;
    ht = hashTableNew(33, (funcHash_t*)&strHash);
	for(int s=0;s<4;s++) {
        for(int i=0;i<33;i++) {
            hashTableAdd(ht, strClone(strings[i]));}}
    fprintf(pfile,"==> hashTableRemoveAll\n");
    hashTablePrint(ht,pfile,(funcPrint_t*)&strPrint);
    hashTableDelete(ht,(funcDelete_t*)&strDelete);

}

int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    test_hashTable(pfile);
    fclose(pfile);
    return 0;
}