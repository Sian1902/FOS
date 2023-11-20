#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"


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
					map_frame(ptr_page_directory,ptr_frame_info,iterator,PERM_PRESENT|PERM_WRITEABLE|PERM_AVAILABLE|PERM_BUFFERED|PERM_MODIFIED|PERM_USED);
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

			int inc=ROUNDUP(increment,PAGE_SIZE);
			inc/=PAGE_SIZE;
			kheap_segment_break+= increment;
			uint32 iterator=lastBreak;
			for(int i=0;i<inc;i++){
				 struct FrameInfo *ptr_frame_info;
				 int ret=allocate_frame(&ptr_frame_info) ;
				 if(ret==0){
					 map_frame(ptr_page_directory,ptr_frame_info,iterator,PERM_WRITEABLE);
				 }
				 else{
					 panic("no space");

				 }
					iterator+=PAGE_SIZE;
			 }
			return (void*)lastBreak;
		}
		else{
			int dec = ROUNDDOWN(increment,PAGE_SIZE);
			dec/=PAGE_SIZE;
			dec*=-1;
			kheap_segment_break+= increment;
			 for(int i=1;i<=dec;i++)
			 {
				 unmap_frame(ptr_page_directory,kheap_segment_break+(i*PAGE_SIZE));
			 }
			 return (void*)kheap_segment_break;
		}
		if(increment > (kheap_segment_break - kheap_hard_limit)|| kheap_segment_break == KERNEL_HEAP_MAX){
			 panic("break lower than start");
		}
}


uint32 accum=0;
bool head=0;
void* kmalloc(unsigned int size)
{

	uint32 start=kheap_hard_limit+PAGE_SIZE+accum;

	//TODO: [PROJECT'23.MS2 - #03] [1] KERNEL HEAP - kmalloc()
		//refer to the project presentation and documentation for details
		// use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy

		//change this "return" according to your answer
		//kpanic_into_prompt("kmalloc() is not implemented yet...!!");
		//return NULL;

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
		if(sizeToAllocate>=KERNEL_HEAP_MAX - start + 1)
		{
			return NULL;
	    }

		uint32 iterator = start;


		uint32 *firstAddress;
		bool first=0;
		int numPages=pagesToAllocate;

		while(pagesToAllocate--){
			 struct FrameInfo *ptr_frame_info;
			 if(free_frame_list.size<pagesToAllocate){

				 return NULL;
			 }

			 int ret=allocate_frame(&ptr_frame_info) ;
			if(ret==0){

				map_frame(ptr_page_directory,ptr_frame_info,iterator,PERM_PRESENT|PERM_WRITEABLE|PERM_AVAILABLE|PERM_BUFFERED|PERM_MODIFIED|PERM_USED);
                struct page* newPage=(struct page*)iterator;
                newPage->isFree=1;
                newPage->startAddress=iterator;
                if(!head){

                }
                else{
                	LIST_INSERT_AFTER(&page_list,(struct page*)iterator,newPage);
                }
				if(!first){
					first=1;
					 firstAddress=(uint32*)iterator;
					 newPage->isStart=1;
					 newPage->numOfPages=numPages;
				}


			}
			else{
				return NULL;
			}

			iterator+=PAGE_SIZE;
			accum+=PAGE_SIZE;

		}
		start+=accum;

		return firstAddress;
}

void kfree(void* virtual_address)
{
	//TODO: [PROJECT'23.MS2 - #04] [1] KERNEL HEAP - kfree()
	//refer to the project presentation and documentation for details
	// Write your code here, remove the panic and write your code
	panic("kfree() is not implemented yet...!!");
}

unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT'23.MS2 - #05] [1] KERNEL HEAP - kheap_virtual_address()
	//refer to the project presentation and documentation for details
	// Write your code here, remove the panic and write your code
	panic("kheap_virtual_address() is not implemented yet...!!");

	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================

	//change this "return" according to your answer
	return 0;
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT'23.MS2 - #06] [1] KERNEL HEAP - kheap_physical_address()
	//refer to the project presentation and documentation for details
	// Write your code here, remove the panic and write your code
	panic("kheap_physical_address() is not implemented yet...!!");

	//change this "return" according to your answer
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
