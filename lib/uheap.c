#include <inc/lib.h>
uint32 arrADD[122879]={0};
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
		return alloc_block_FF(size);
	}

	uint32 hardLimit=sys_hard_limit();
	uint32 low =hardLimit+PAGE_SIZE;
	uint32 high=low;

	uint32 PagesToAllocate=ROUNDUP(size,PAGE_SIZE);
	uint32 sizeToAllocate=PagesToAllocate;
	PagesToAllocate/=PAGE_SIZE;
	uint32 cntAvailablePages=0;
    int cntArrADD=0;
	while(high<USER_HEAP_MAX){
		if(arrADD[cntArrADD]==0){

			high+=PAGE_SIZE;
			cntAvailablePages++;
			cntArrADD++;
		}
		else{
		 high+=PAGE_SIZE;
		 low=high;
		 cntAvailablePages=0;
		 cntArrADD++;
		 //continue;
		}

		if(cntAvailablePages==PagesToAllocate){
			if((low)+(cntAvailablePages*PAGE_SIZE)>=USER_HEAP_MAX){
				return NULL;
			}
         for(int cntADDCheck=cntArrADD-cntAvailablePages;cntADDCheck<cntArrADD;cntADDCheck++){
        	 arrADD[cntADDCheck]=low;
         }

			sys_allocate_user_mem(low,PagesToAllocate);
			return(uint32*) low;


		}

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
	uint32 hardLimit=sys_hard_limit();

	if (virtual_address >= (void*) USER_HEAP_START
		      && virtual_address < (void*) hardLimit) {
		    free_block(virtual_address);
		  }
	else if (virtual_address
		      >= (void*) (hardLimit + PAGE_SIZE)&& virtual_address <(void*)USER_HEAP_MAX){
		uint32 numOfPages=0;
		bool found=0;
		for(int cntArrADD = 0 ; cntArrADD<122879;cntArrADD++)
		      {

		    	  if(arrADD[cntArrADD]==(uint32)virtual_address){
		    		  numOfPages++;
		    		  arrADD[cntArrADD]=0;
		    		  found=1;
		    	  }
		    	  else if(found&&(void*)arrADD[cntArrADD]!=virtual_address){
		    		  break;
		    	  }

			/* if(i!=122878 &&(void*)arrADD[i]==virtual_address&&(void*)arrADD[i+1]!=virtual_address)

		    		  break;*/
		      }
		uint32 iterator = (uint32) virtual_address;
		sys_free_user_mem(iterator,numOfPages);
}
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
