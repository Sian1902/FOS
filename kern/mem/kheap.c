#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"
#define DYNAMIC_ALLOCATOR_DS 0 //ROUNDUP(NUM_OF_KHEAP_PAGES * sizeof(struct MemBlock), PAGE_SIZE)
#define INITIAL_KHEAP_ALLOCATIONS (DYNAMIC_ALLOCATOR_DS + KERNEL_SHARES_ARR_INIT_SIZE + KERNEL_SEMAPHORES_ARR_INIT_SIZE) // + ROUNDUP(num_of_ready_queues * sizeof(uint8), PAGE_SIZE) + ROUNDUP(num_of_ready_queues * sizeof(struct Env_Queue), PAGE_SIZE))
#define ACTUAL_START ((KERNEL_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE) + INITIAL_KHEAP_ALLOCATIONS)


int initialize_kheap_dynamic_allocator(uint32 daStart, uint32 initSizeToAllocate, uint32 daLimit)
{
  //TODO: [PROJECT'23.MS2 - #01] [1] KERNEL HEAP - initialize_kheap_dynamic_allocator()
    //Initialize the dynamic allocator of kernel heap with the given start address, size & limit
    kheap_start = daStart;
    kheap_segment_break =  (daStart + initSizeToAllocate);
    kheap_hard_limit =  daLimit;



    if(kheap_segment_break>kheap_hard_limit)
    {

      return E_NO_MEM;
    }

    //All pages in the given range should be allocated
    uint32 iterator = kheap_start;


    while(iterator!=kheap_segment_break)
    {
      struct FrameInfo *ptr_frame_info;
      int ret = allocate_frame(&ptr_frame_info) ;

      if(ret==0)
      {
          map_frame(ptr_page_directory,ptr_frame_info,iterator,PERM_WRITEABLE);
          ptr_frame_info->va=iterator;
      }
      else{

        return E_NO_MEM;
      }
      iterator+=PAGE_SIZE;
    }

    //Remember: call the initialize_dynamic_allocator(..) to complete the initialization
    initialize_dynamic_allocator(daStart,initSizeToAllocate);

    //Return:
    //	On success: 0
    //	Otherwise (if no memory OR initial size exceed the given limit): E_NO_MEM

    //Comment the following line(s) before start coding...
    //panic("not implemented yet");
    return 0;
}
void* sbrk(int increment) {
    // ... (existing code)

    uint32 lastBreak=kheap_segment_break;
    if(kheap_segment_break+increment>kheap_hard_limit){

        return (void*)-1 ;
    }
    if(increment==0){

        return (void*)lastBreak;
      }
    else if(increment>0){

    	//increment=ROUNDUP(increment,PAGE_SIZE);
    	int inc=ROUNDUP(increment,PAGE_SIZE);
      inc/=PAGE_SIZE;
      kheap_segment_break+= increment;
      kheap_segment_break=ROUNDUP(kheap_segment_break,PAGE_SIZE);
      uint32 iterator=lastBreak;
      for(int i=0;i<inc;i++){
         struct FrameInfo *ptr_frame_info;
         int ret=allocate_frame(&ptr_frame_info) ;
         if(ret==0){
           map_frame(ptr_page_directory,ptr_frame_info,iterator,PERM_WRITEABLE);
           ptr_frame_info->va=iterator;
         }
         else{
           panic("no space");

         }
          iterator+=PAGE_SIZE;
       }
      return (void*)lastBreak;
    }
    else{
      int dec = ROUNDDOWN(increment*-1,PAGE_SIZE);
      dec/=PAGE_SIZE;
      kheap_segment_break+= increment;
        uint32 *ptr_page_table;
       for(int i=1;i<=dec;i++)
       {
        get_frame_info(ptr_page_directory,kheap_segment_break+(i*PAGE_SIZE),&ptr_page_table)->va=0;
         unmap_frame(ptr_page_directory,kheap_segment_break+(i*PAGE_SIZE));

       }


       return (void*)kheap_segment_break;
    }
    if(increment > (kheap_segment_break - kheap_hard_limit)|| kheap_segment_break == KERNEL_HEAP_MAX){
       panic("break lower than start");
    }
}

void* kmalloc(unsigned int size) {
uint32 start=kheap_hard_limit+PAGE_SIZE;
// TODO: [PROJECT'23.MS2 - #03] [1] KERNEL HEAP - kmalloc()
  // refer to the project presentation and documentation for details
  // use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy

  // change this "return" according to your answer
  // kpanic_into_prompt("kmalloc() is not implemented yet...!!");
  // return NULL;
  if(size<=DYN_ALLOC_MAX_BLOCK_SIZE){

        if(isKHeapPlacementStrategyFIRSTFIT()){\


        return alloc_block_FF(size);

        }
        if(isKHeapPlacementStrategyBESTFIT()){
          return alloc_block_BF(size);
        }
      }

      int pagesToAllocate= ROUNDUP(size,PAGE_SIZE);
      int sizeToAllocate=pagesToAllocate;
      pagesToAllocate/=PAGE_SIZE;
      if(sizeToAllocate>=KERNEL_HEAP_MAX-ACTUAL_START+1)
      {
        return NULL;
       }
      uint32 pageAllocStart=kheap_hard_limit+PAGE_SIZE;
      uint32 pageAllocEnd=KERNEL_HEAP_MAX;
      uint32 cntAvailablePages=0;
      uint32 low=pageAllocStart;
      uint32* ptr_page_table;
      uint32 high=low;
      while(high<pageAllocEnd){
    	  struct FrameInfo *candidateFrame = get_frame_info(ptr_page_directory , high ,&ptr_page_table);

    	   if(candidateFrame==NULL){

    		   high+=PAGE_SIZE;
    		   cntAvailablePages++;

    	   }
    	   else{
    		   high+=PAGE_SIZE;
    		   low=high;
    		   cntAvailablePages=0;
    		   continue;
   	   }

    	  if(cntAvailablePages==pagesToAllocate){

    		   high=low;
    		   for(int i=0;i<pagesToAllocate;i++){
    			   struct FrameInfo *ptr_frame_info;

    			   allocate_frame(&ptr_frame_info);

    	            map_frame(ptr_page_directory,ptr_frame_info,high,PERM_WRITEABLE);
    			   ptr_frame_info->va=high;
    			   if(i==0){
    				   ptr_frame_info->numOfPages=pagesToAllocate;
    			   }
    			   else{
    				   ptr_frame_info->numOfPages=0;
    			   }

    			  high+=PAGE_SIZE;
    		   }
    		   return (uint32*)low;
    	  }
      }
      return NULL;

}



void kfree(void* virtual_address)
{
   	 if (virtual_address >= (void*) kheap_start
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
			 startOfProcess+=PAGE_SIZE;
		 }

	 }
	 else{
		 panic("can't free");
	 }
}

unsigned int kheap_virtual_address(unsigned int physical_address)
{
            unsigned int offset=physical_address%PAGE_SIZE;
            unsigned int addressStart=physical_address-offset;
            struct FrameInfo *frameToBeFound=to_frame_info(addressStart);
            unsigned int va=frameToBeFound->va;
            if(frameToBeFound->references !=0){
                return frameToBeFound->va+offset;

        }


        return 0;
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
			unsigned int offset=virtual_address%PAGE_SIZE;
			unsigned int addressStart=virtual_address-offset;
			unsigned int *ptr_page_table;
			struct FrameInfo *frameToBeFound= get_frame_info(ptr_page_directory,addressStart,&ptr_page_table);
			if(frameToBeFound!=0)
			{
				return to_physical_address(frameToBeFound)+offset;
			}
	        return 0;
}


void kfreeall()
{
  panic("Not implemented!");

}

void kshrink(uint32 newSize)
{
  panic("Not implemented!");
}

void kexpand(uint32 newSize)
{
  panic("Not implemented!");
}




//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size)
{
  //TODO: [PROJECT'23.MS2 - BONUS#1] [1] KERNEL HEAP - krealloc()
  // Write your code here, remove the panic and write your code
  return NULL;
  panic("krealloc() is not implemented yet...!!");
}
