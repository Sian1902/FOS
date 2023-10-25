/*
 * dynamic_allocator.c
 *
 *  Created on: Sep 21, 2023
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va) {
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
	return curBlkMetaData->size;
}

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va) {
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *) va - 1);
	return curBlkMetaData->is_free;
}

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY) {
	void *va = NULL;
	switch (ALLOC_STRATEGY) {
	case DA_FF:
		va = alloc_block_FF(size);
		break;
	case DA_NF:
		va = alloc_block_NF(size);
		break;
	case DA_BF:
		va = alloc_block_BF(size);
		break;
	case DA_WF:
		va = alloc_block_WF(size);
		break;
	default:
		cprintf("Invalid allocation strategy\n");
		break;
	}
	return va;
}

//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list) {
	cprintf("=========================================\n");
	struct BlockMetaData* blk;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free);
	}
	cprintf("=========================================\n");

}

//
////********************************************************************************//
////********************************************************************************//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart,
		uint32 initSizeOfAllocatedSpace) {
	//=========================================
	//DON'T CHANGE THESE LINES=================
	if (initSizeOfAllocatedSpace == 0)
		return;
//	LIST_INIT(&Heap_MetaBlock);
	//=========================================
	//=========================================

	//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
	//panic("initialize_dynamic_allocator is not implemented yet");
	struct BlockMetaData *firstMeta = (struct BlockMetaData *) daStart;
	//Heap_MetaBlock.lh_first = firstMeta;
	firstMeta->size = initSizeOfAllocatedSpace;
	firstMeta->is_free = 1;
	LIST_INSERT_HEAD(&Heap_MetaBlock, firstMeta);

}

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================


void *alloc_block_FF(uint32 size) {
	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
	//panic("alloc_block_FF is not implemented yet");
	if(size==0){
		return NULL;
	}
	struct BlockMetaData* iterator;
	uint32 sizeToAllocate=size+sizeOfMetaData();
	LIST_FOREACH(iterator,&Heap_MetaBlock){
		if(!iterator->is_free){
			continue;
		}
		else if(iterator->size<sizeToAllocate){
			continue;
		}
		else if(iterator->size==sizeToAllocate&&iterator->is_free){
			iterator->is_free=0;
			return (struct BlockMetaData*)((uint32)iterator+sizeOfMetaData());
		}
		else if(iterator->size>sizeToAllocate+sizeOfMetaData()&&iterator->is_free){

		struct BlockMetaData* splitingBlock;

		splitingBlock=(struct BlockMetaData*)((uint32)iterator+sizeToAllocate);
		splitingBlock->is_free=1;
		splitingBlock->size=iterator->size-sizeToAllocate;
		LIST_INSERT_AFTER(&Heap_MetaBlock,iterator,splitingBlock);
		iterator->is_free=0;
		iterator->size=sizeToAllocate;
		return (struct BlockMetaData*)((uint32)iterator+sizeOfMetaData());
		}
	}
	if (sbrk(sizeToAllocate) == (void*) -1) {
				return NULL;
			}
	struct BlockMetaData* extendingBlock;
	extendingBlock=(struct BlockMetaData*)((uint32)Heap_MetaBlock.lh_last+Heap_MetaBlock.lh_last->size);
	extendingBlock->is_free=0;
	extendingBlock->size=sizeToAllocate;
	return (struct BlockMetaData*)((uint32)extendingBlock+sizeOfMetaData());
}


//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size) {
	//TODO: [PROJECT'23.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF()
	panic("alloc_block_BF is not implemented yet");
	return NULL;
}

//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size) {
	panic("alloc_block_WF is not implemented yet");
	return NULL;
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size) {
	panic("alloc_block_NF is not implemented yet");
	return NULL;
}

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va) {
	//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
	//	panic("free_block is not implemented yet");

	struct BlockMetaData *currBlock = ((struct BlockMetaData *) va - 1);
	struct BlockMetaData *nextBlock= currBlock->prev_next_info.le_next;
	struct BlockMetaData *prevBlock= currBlock->prev_next_info.le_prev;
	//address is null or block is already free
	if(currBlock->is_free||currBlock==NULL){
		return;
	}
	else{
		//freeing the block
		currBlock->is_free=1;
		//next is free
		if(nextBlock!=NULL&&nextBlock->is_free){
			currBlock->size+=nextBlock->size;
			nextBlock->is_free=0;
			nextBlock->size=0;
		}
		//prev is free or prev and next are free
		if(prevBlock!=NULL&&prevBlock->is_free){
			prevBlock->size+=currBlock->size;
			currBlock->size=0;
			currBlock->is_free=0;
		}
	}

}

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size) {
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	return NULL;
}
