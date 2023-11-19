#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"
#define DYNAMIC_ALLOCATOR_DS 0 //ROUNDUP(NUM_OF_KHEAP_PAGES * sizeof(struct MemBlock), PAGE_SIZE)
#define INITIAL_KHEAP_ALLOCATIONS (DYNAMIC_ALLOCATOR_DS + KERNEL_SHARES_ARR_INIT_SIZE + KERNEL_SEMAPHORES_ARR_INIT_SIZE)
#define ACTUAL_START ((KERNEL_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE) + INITIAL_KHEAP_ALLOCATIONS)
extern uint32 sys_calculate_free_frames() ;
uint32 kheap_start;
uint32 kheap_segment_break;
uint32 kheap_hard_limit;
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
	struct FrameInfo *ptr_frame_info;

	while(iterator!=kheap_segment_break)
	{
		int ret = allocate_frame(&ptr_frame_info) ;

		if(ret==0)
		{
				map_frame(ptr_page_directory,ptr_frame_info,iterator,PERM_PRESENT|PERM_WRITEABLE|PERM_MODIFIED|PERM_BUFFERED|PERM_USED);
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


void* sbrk(int increment)
{


	//TODO: [PROJECT'23.MS2 - #02] [1] KERNEL HEAP - sbrk()
	/* increment > 0: move the segment break of the kernel to increase the size of its heap,
	 * 				you should allocate pages and map them into the kernel virtual address space as necessary,
	 * 				and returns the address of the previous break (i.e. the beginning of newly mapped memory).
	 * increment = 0: just return the current position of the segment break
	 * increment < 0: move the segment break of the kernel to decrease the size of its heap,
	 * 				you should deallocate pages that no longer contain part of the heap as necessary.
	 * 				and returns the address of the new break (i.e. the end of the current heap space).
	 *
	 * NOTES:
	 * 	1) You should only have to allocate or deallocate pages if the segment break crosses a page boundary
	 * 	2) New segment break should be aligned on page-boundary to avoid "No Man's Land" problem
	 * 	3) Allocating additional pages for a kernel dynamic allocator will fail if the free frames are exhausted
	 * 		or the break exceed the limit of the dynamic allocator. If sbrk fails, kernel should panic(...)
	 */

	//MS2: COMMENT THIS LINE BEFORE START CODING====
/*	return (void*)-1 ;
	panic("not implemented yet");*/
	uint32 *lastBreak=(uint32*)kheap_segment_break;
	if(kheap_segment_break+increment>kheap_hard_limit ){

			return (void*)-1 ;
	}
	if(increment==0){

			return lastBreak;
		}
	else if(increment>0){

		int inc=ROUNDUP(increment,PAGE_SIZE);
		inc/=PAGE_SIZE;
		kheap_segment_break=(uint32)((uint32)lastBreak+inc);
		uint32 iterator=(uint32)lastBreak;

		 for(int i=0;i<inc/PAGE_SIZE;i++){
			 struct FrameInfo *ptr_frame_info;
			 int ret=allocate_frame(&ptr_frame_info) ;
			 if(ret==0){
				 map_frame(ptr_page_directory,ptr_frame_info,iterator,PERM_PRESENT|PERM_WRITEABLE|PERM_MODIFIED|PERM_BUFFERED|PERM_USED);

			 }
			 else{
				 panic("no space");

			 }
				iterator+=PAGE_SIZE;
		 }

		return lastBreak;
	}
	else{

		int dec = ROUNDDOWN(increment,PAGE_SIZE);
		dec/=PAGE_SIZE;
		 for(int i=1;i<=dec/PAGE_SIZE;i++)
		 {
	      struct FrameInfo *frameToBeDeleted= to_frame_info(kheap_segment_break-(i*PAGE_SIZE));/*(struct FrameInfo *) (kheap_segment_break-(i*PAGE_SIZE));*/
	      free_frame(frameToBeDeleted);
	      unmap_frame(ptr_page_directory,kheap_segment_break-(i*PAGE_SIZE));
		 }
		 lastBreak= (uint32*)((uint32)lastBreak-dec);
		 if(lastBreak>=(uint32*)kheap_start){
			 kheap_segment_break=(uint32)lastBreak;

			 return lastBreak;
		 }
		 else{
			 panic("break lower than start");
		 }
	}
}





void* kmalloc(unsigned int size)
{
     cprintf("checkpoint 1\n");
	//TODO: [PROJECT'23.MS2 - #03] [1] KERNEL HEAP - kmalloc()
		//refer to the project presentation and documentation for details
		// use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy

		//change this "return" according to your answer
		//kpanic_into_prompt("kmalloc() is not implemented yet...!!");
		//return NULL;

		if(size<=DYN_ALLOC_MAX_BLOCK_SIZE){
			cprintf("checkpoint 2\n");
			if(isKHeapPlacementStrategyFIRSTFIT()){
				cprintf("checkpoint 3\n");
			return alloc_block_FF(size);

			}
			if(isKHeapPlacementStrategyBESTFIT()){
				return alloc_block_BF(size);
			}
		}
		int pagesToAllocate= ROUNDUP(size,PAGE_SIZE);
		cprintf("checkpoint 4\n");
		pagesToAllocate/=PAGE_SIZE;
		cprintf("checkpoint 5\n");
		/*cprintf("pages to allocate %d\n",pagesToAllocate);*/

	    int x=sys_calculate_free_frames();

		if(size>=KERNEL_HEAP_MAX - ACTUAL_START + 1)
		{
			cprintf("checkpoint 6\n");
			return NULL;
	    }

		uint32 iterator = ACTUAL_START;
		uint32 accum=0;
		uint32 *firstAddress;
		bool first=0;
		cprintf("checkpoint 7\n");
		while(iterator!=KERNEL_HEAP_MAX&&pagesToAllocate!=0){
			 struct FrameInfo *ptr_frame_info;
			 if(free_frame_list.size<pagesToAllocate){

				 return NULL;
			 }

			 int ret=allocate_frame(&ptr_frame_info) ;
			if(ret==0){
				pagesToAllocate--;

				map_frame(ptr_page_directory,ptr_frame_info,iterator,PERM_PRESENT|PERM_WRITEABLE|PERM_MODIFIED|PERM_BUFFERED|PERM_USED);
				/*cprintf("pages to allocate %d\n",pagesToAllocate);*/

				if(!first){
					first=1;
					 firstAddress=(uint32*)iterator;
					 cprintf("first add %d\n",firstAddress);
				}

			}

			iterator+=PAGE_SIZE;

		}
		cprintf("checkpoint 8\n");
        cprintf("allocated %d",x-sys_calculate_free_frames());
        cprintf("checkpoint 9\n");
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
	//TODO: [PROJECT'23.MS2 - BONUS] [1] KERNEL HEAP - krealloc()
	// Write your code here, remove the panic and write your code
	return NULL;
	panic("krealloc() is not implemented yet...!!");
}
