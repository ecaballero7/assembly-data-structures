#include "lib.h"

/** STRING **/

char* strSubstring(char* pString, uint32_t init, uint32_t end) 
{

	uint32_t len = strLen(pString);

	if(init > end) return pString;

    if(init > len)
    {
    	char* vacio = malloc(1);
    	vacio[1] = '\0';
    	return vacio;
    } 
    if(end > len) end = len;

    uint32_t size = (end-init) + 1;

	char* new = malloc(size + 1);
	new[size] = '\0';
	
	uint32_t k = 0;
	uint32_t j = init;
    while(j <= end)
    {
    	new[k] = pString[j];
    	k++;
    	j++;
    }
    strDelete(pString);
    return new;

}

/** Lista **/



/** HashTable **/

uint32_t strHash(char* pString) {
  if(strLen(pString) != 0)
      return (uint32_t)pString[0] - 'a';
  else
      return 0;
}

void hashTableRemoveAll(hashTable_t* pTable, void* data, funcCmp_t* fc, funcDelete_t* fd) 
{
	for(uint32_t i = 0; i < pTable->size ; i++)
	{
		hashTableDeleteSlot2(pTable, i, data, fd);
	}

}

void hashTableDeleteSlot2(hashTable_t* pTable, uint32_t i, void* data, funcDelete_t* fd)
{
	return 0;
}

void hashTablePrint(hashTable_t* pTable, FILE *pFile, funcPrint_t* fp) 
{
	list_t** slots = pTable->listArray;

	for(uint32_t i = 0; i < pTable->size; i++)
	{
		fprintf(pFile, "%d", i ); fprintf(pFile, "=" );
		listPrint(slots[i], pFile, fp);
		fprintf(pFile, "\n");
	}
}
