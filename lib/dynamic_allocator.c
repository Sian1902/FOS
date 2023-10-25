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
	if (size == 0) {
		return NULL;
	}
	struct BlockMetaData* iterator;
	LIST_FOREACH(iterator,&Heap_MetaBlock)
	{
		uint32 avlbl_size = iterator->size;
		uint8 is_space_free = iterator->is_free;
		//		cprintf("avsize: %d: ,isFree: %d\n", avlbl_size, is_space_free);
		if (is_space_free) {
			if (avlbl_size >= (size + sizeOfMetaData())) {
				iterator->is_free = 0;
				if ((avlbl_size - size) >= sizeOfMetaData()) {
					struct BlockMetaData* newMeta =
							(struct BlockMetaData*) ((uint32) iterator
									+ (size + sizeOfMetaData()));
					newMeta->is_free = 1;
					newMeta->size = avlbl_size - (size + sizeOfMetaData());
					iterator->size = (size + sizeOfMetaData());
					LIST_INSERT_AFTER(&Heap_MetaBlock, iterator, newMeta);
				}
				struct BlockMetaData* address =
						(struct BlockMetaData*) ((uint32) iterator
								+ sizeOfMetaData());
				return address;
				//				// iterator->size = size+size	OfMetaData();
			}
		}
	}
	if (sbrk(size + sizeOfMetaData()) == (void*) -1) {
		return NULL;
	}
	struct BlockMetaData* newMeta =
			(struct BlockMetaData*) ((uint32) Heap_MetaBlock.lh_last
					+ Heap_MetaBlock.lh_last->size);
	newMeta->is_free = 1;
	newMeta->size = size + sizeOfMetaData();
	LIST_INSERT_AFTER(&Heap_MetaBlock, Heap_MetaBlock.lh_last, newMeta);
	struct BlockMetaData*address = (struct BlockMetaData*) ((uint32) newMeta
			+ sizeOfMetaData());
	return address;
}

//void *alloc_block_FF(uint32 size) {
//	//
//	//TODO: [PROJECT'23.MS1 - #6] [3] DYNAMIC ALLOCATOR - alloc_block_FF()
//	//	panic("alloc_block_FF is not implemented yet");
//	if (size == 0)
//		return NULL;
//	struct BlockMetaData *blk, *tmpBlk;
//	//	tmpBlk->size = 0;
//	LIST_FOREACH(blk, &Heap_MetaBlock)
//	{
//		//need to compaction ?
//
//		//blk size is found -> allocate
//		if ((blk->size - sizeOfMetaData()) >= size && blk->is_free == 1) {
//			//blk size is not enough to hold data -> no split
//			if ((blk->size - (sizeOfMetaData() + size)) < sizeOfMetaData()) {
//				blk->is_free = 0;
//				return (struct BlockMetaData *) ((uint32) blk + sizeOfMetaData());
//			}
//			//blk size is big enough to hold data -> split
//			else {
//				tmpBlk = blk;
//				blk = (struct BlockMetaData *) ((uint32) blk
//						+ (size + sizeOfMetaData()));
//				blk->size = tmpBlk->size - (size + sizeOfMetaData());
//				blk->is_free = 1;
//
////				cprintf("blk: %x\ntmp: %x\n", blk, tmpBlk);
//				LIST_INSERT_AFTER(&Heap_MetaBlock, tmpBlk, blk);
//				tmpBlk->size = size + sizeOfMetaData();
//				tmpBlk->is_free = 0;
//				return (struct BlockMetaData *) ((uint32) tmpBlk
//						+ sizeOfMetaData());
////				 tmpBlk = blk;
////				                struct BlockMetaData *newBlk = (struct BlockMetaData *)((uint32)blk + (size + sizeOfMetaData()));
////				                newBlk->size = tmpBlk->size - (size + sizeOfMetaData());
////				                newBlk->is_free = 1;
////				                LIST_INSERT_AFTER(&memBlocks, tmpBlk, newBlk);
////				                tmpBlk->size = size + sizeOfMetaData();
////				                tmpBlk->is_free = 0;
////				                return (struct BlockMetaData *)((uint32)tmpBlk + sizeOfMetaData());
//			}
//		}
//	}
//	//no free space for required size -> no allocate + no space
//	uint32* ptr = (uint32 *) sbrk((size + sizeOfMetaData()));
//	if (ptr != (uint32 *) -1) {
//		tmpBlk = (struct BlockMetaData *) ((uint32) Heap_MetaBlock.lh_last);
//		tmpBlk->size = size + sizeOfMetaData();
//		tmpBlk->is_free = 0;
//		return (struct BlockMetaData *) ((uint32) tmpBlk + sizeOfMetaData());
//	}
//	return NULL;
//
//}

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

	struct BlockMetaData *currBlock = ((struct BlockMetaData *) va - 1);
	struct BlockMetaData *nextBlock = currBlock->prev_next_info.le_next;
	struct BlockMetaData *prevBlock = currBlock->prev_next_info.le_prev;
	if (va == NULL) {
		//cpritf("Enter a valid address");
		return;
	} else if (is_free_block(va)) {
		//cpritf("block is already free");
		return;
	} else if (!is_free_block(va) && !nextBlock->is_free
			&& !prevBlock->is_free) {
		currBlock->is_free = 1;
	} else if (prevBlock->is_free && !nextBlock->is_free) {
		prevBlock->size += currBlock->size;
		nextBlock->prev_next_info.le_prev = prevBlock;
		prevBlock->prev_next_info.le_next = nextBlock;

	} else if (!prevBlock->is_free && nextBlock->is_free) {
		currBlock->size += nextBlock->size;
		nextBlock->prev_next_info.le_next->prev_next_info.le_prev = currBlock;
		currBlock->prev_next_info.le_next = nextBlock->prev_next_info.le_next;
	} else if (prevBlock->is_free && nextBlock->is_free) {
		prevBlock->size += nextBlock->size + currBlock->size;
		nextBlock->prev_next_info.le_next->prev_next_info.le_prev = prevBlock;
		prevBlock->prev_next_info.le_next = nextBlock->prev_next_info.le_next;
	}

	//struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;

}

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size) {
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	return NULL;
}
