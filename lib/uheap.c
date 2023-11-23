#include <inc/lib.h>

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
	if(FirstTimeFlag)
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
	}
}
struct marked{
	uint32 startAddr;
	uint32 size;
	LIST_ENTRY(marked) prev_next_info;
};
LIST_HEAD(MarkedLIST, marked);
struct MarkedLIST *marked_list;
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
	return (void*) sys_sbrk(increment);
}

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
	if (size == 0) return NULL ;
	//==============================================================
	//TODO: [PROJECT'23.MS2 - #09] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	if(size<=DYN_ALLOC_MAX_BLOCK_SIZE){
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
			alloc_block_FF(size);
		}
		else if(sys_isUHeapPlacementStrategyBESTFIT()){
			alloc_block_BF(size);
		}
	}
	else{
		int pagesToAllocate=ROUNDUP(size,PAGE_SIZE);
		int sizeToAllocate=pagesToAllocate;
		pagesToAllocate/=PAGE_SIZE;
		uint32 u_hard_limit= sys_hard_limit();
		uint32 pageAllocStart=u_hard_limit+PAGE_SIZE;
		uint32 pageAllocEnd=USER_HEAP_MAX;
		uint32 cntAvailablePages=0;
		uint32 low=pageAllocStart;
		uint32 high=low;
		uint32 startVa;
		bool startOfVa=0;
		while(high<pageAllocEnd){
			uint32 permission= sys_get_perm(high);
			if(permission==0){
				high+=PAGE_SIZE;
				cntAvailablePages++;
				if(startOfVa==0){
					startVa=low;
				}
		    }
		    else{
		    	high+=PAGE_SIZE;
		    	low=high;
		    	cntAvailablePages=0;
		    	startOfVa=0;
		    	continue;
		    }
		}
		if(cntAvailablePages==pagesToAllocate){
			sys_allocate_user_mem(startVa,sizeToAllocate);
		}


	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	}
	return NULL;
}

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	/*if (virtual_address >= (void*) kheap_start
		      && virtual_address < (void*) kheap_segment_break) {
		    free_block(virtual_address);
		  }
	else if (virtual_address
		      >= (void*) (kheap_hard_limit + PAGE_SIZE)&& virtual_address <(void*)KERNEL_HEAP_MAX){
			 uint32* ptr_page_table;
			 uint32 framesToBeFreed=get_frame_info(ptr_page_directory , (uint32)virtual_address ,&ptr_page_table)->numOfPages;
			 uint32 startOfProcess=get_frame_info(ptr_page_directory , (uint32)virtual_address ,&ptr_page_table)->va;
			 for(int i=0;i<framesToBeFreed;i++){
				 unmap_frame(ptr_page_directory,startOfProcess);
				 sys_free_user_mem();
				 startOfProcess+=PAGE_SIZE;
			 }

		 }
		 else{
			 panic("can't free");
		 }
*/
	panic("asdazsd");
}


//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
	if (size == 0) return NULL ;
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
	return NULL;
}

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
	return NULL;
}


//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//=================================
// REALLOC USER SPACE:
//=================================
//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to malloc().
//	A call with new_size = zero is equivalent to free().

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
	return NULL;

}


//=================================
// FREE SHARED VARIABLE:
//=================================
//	This function frees the shared variable at the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from main memory then switch back to the user again.
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
}


//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
	panic("Not Implemented");

}
void shrink(uint32 newSize)
{
	panic("Not Implemented");

}
void freeHeap(void* virtual_address)
{
	panic("Not Implemented");

}
