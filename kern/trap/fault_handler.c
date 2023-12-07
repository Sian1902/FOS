/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include "../cpu/sched.h"
#include "../disk/pagefile_manager.h"
#include "../mem/memory_manager.h"

//2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
// 0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;

//===============================
// REPLACEMENT STRATEGIES
//===============================
//2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE)
{
	assert(LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE ;
}
void setPageReplacmentAlgorithmCLOCK(){_PageRepAlgoType = PG_REP_CLOCK;}
void setPageReplacmentAlgorithmFIFO(){_PageRepAlgoType = PG_REP_FIFO;}
void setPageReplacmentAlgorithmModifiedCLOCK(){_PageRepAlgoType = PG_REP_MODIFIEDCLOCK;}
/*2018*/ void setPageReplacmentAlgorithmDynamicLocal(){_PageRepAlgoType = PG_REP_DYNAMIC_LOCAL;}
/*2021*/ void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps){_PageRepAlgoType = PG_REP_NchanceCLOCK;  page_WS_max_sweeps = PageWSMaxSweeps;}

//2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE){return _PageRepAlgoType == LRU_TYPE ? 1 : 0;}
uint32 isPageReplacmentAlgorithmCLOCK(){if(_PageRepAlgoType == PG_REP_CLOCK) return 1; return 0;}
uint32 isPageReplacmentAlgorithmFIFO(){if(_PageRepAlgoType == PG_REP_FIFO) return 1; return 0;}
uint32 isPageReplacmentAlgorithmModifiedCLOCK(){if(_PageRepAlgoType == PG_REP_MODIFIEDCLOCK) return 1; return 0;}
/*2018*/ uint32 isPageReplacmentAlgorithmDynamicLocal(){if(_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmNchanceCLOCK(){if(_PageRepAlgoType == PG_REP_NchanceCLOCK) return 1; return 0;}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt){_EnableModifiedBuffer = enableIt;}
uint8 isModifiedBufferEnabled(){  return _EnableModifiedBuffer ; }

void enableBuffering(uint32 enableIt){_EnableBuffering = enableIt;}
uint8 isBufferingEnabled(){  return _EnableBuffering ; }

void setModifiedBufferLength(uint32 length) { _ModifiedBufferLength = length;}
uint32 getModifiedBufferLength() { return _ModifiedBufferLength;}

//===============================
// FAULT HANDLERS
//===============================

//Handle the table fault
void table_fault_handler(struct Env * curenv, uint32 fault_va)
{

	//panic("table_fault_handler() is not implemented yet...!!");
	//Check if it's a stack page
	uint32* ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory, (uint32)fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//Handle the page fault

void page_fault_handler(struct Env * curenv, uint32 fault_va)
{

	//cprintf("page fault happened add ===================================================%x\n",fault_va);
#if USE_KHEAP
		struct WorkingSetElement *victimWSElement = NULL;
		uint32 wsSize = LIST_SIZE(&(curenv->page_WS_list));
#else
		int iWS =curenv->page_last_WS_index;
		uint32 wsSize = env_page_ws_get_size(curenv);
#endif

	if(isPageReplacmentAlgorithmFIFO())

	{
		struct FrameInfo* frame;
					fault_va = ROUNDDOWN(fault_va,PAGE_SIZE);
									uint32* dir=curenv->env_page_directory;
									int ret=allocate_frame(&frame);

									if(ret!=0){
										sched_kill_env(curenv->env_id);
										cprintf("no free frame -------------------------------");
									}
									map_frame(dir,frame,fault_va,PERM_WRITEABLE|PERM_USER);
									//allocate_user_mem(curenv, fault_va, 1);
									int retpage=pf_read_env_page(curenv,(uint32*)fault_va);
									int permissions=pt_get_page_permissions(dir,fault_va);
									bool notFoudStack=0;
									bool notFoudHeap=0;
									if(retpage==E_PAGE_NOT_EXIST_IN_PF){
										if(fault_va<USER_HEAP_START||fault_va>=USER_HEAP_MAX){
											notFoudHeap=1;
										}
										if(fault_va<USTACKBOTTOM||fault_va>=USTACKTOP){
											notFoudStack=1;
										}

									}


									if(notFoudHeap&&notFoudStack){
										cprintf("fault add %x\n",fault_va);
										cprintf("not heap or stack\n");
										sched_kill_env(curenv->env_id);
										cprintf("no heap or stac -------------------------------");
									}
					struct WorkingSetElement* object =env_page_ws_list_create_element(curenv,fault_va);
		if(wsSize < (curenv->page_WS_max_size))

	{
		//TODO: [PROJECT'23.MS2 - #15] [3] PAGE FAULT HANDLER - Placement

					LIST_INSERT_TAIL(&curenv->page_WS_list, object);
					if((curenv->page_WS_list.size) == (curenv->page_WS_max_size)){
						curenv->page_last_WS_element=curenv->page_WS_list.lh_first;
						curenv->page_last_WS_index=0;
					}
					else{
						curenv->page_last_WS_index++;
						curenv->page_last_WS_element=NULL;
					}
	}
	else
	{
			//TODO: [PROJECT'23.MS3 - #1] [1] PAGE FAULT HANDLER - FIFO Replacement
			struct WorkingSetElement* deleted_element = curenv->page_last_WS_element;
			int chc = 0;
			if(curenv->page_last_WS_element==curenv->page_WS_list.lh_last)
					{
						 curenv->page_last_WS_element=curenv->page_WS_list.lh_first;
						 chc = 1;
					}
			        else
				     {
						curenv->page_last_WS_element = curenv->page_last_WS_element->prev_next_info.le_next;

				     }
			int perms = pt_get_page_permissions(dir,deleted_element->virtual_address);
			if(perms & PERM_MODIFIED)
			{

				uint32* ptr_page;
				get_page_table(dir,deleted_element->virtual_address,&ptr_page);
				struct FrameInfo* temp = get_frame_info(dir,deleted_element->virtual_address,&ptr_page);
				pf_update_env_page(curenv,deleted_element->virtual_address , temp);

			}
            unmap_frame(dir,deleted_element->virtual_address);
            env_page_ws_invalidate( curenv,  deleted_element->virtual_address);
            if(chc==1)
            {
				 LIST_INSERT_TAIL(&curenv->page_WS_list, object);
            }
            else
            {
			    LIST_INSERT_BEFORE(&curenv->page_WS_list, curenv->page_last_WS_element, object);
            }
		}
	}

		if(isPageReplacmentAlgorithmLRU(PG_REP_LRU_LISTS_APPROX))
		{

			//TODO: [PROJECT'23.MS3 - #2] [1] PAGE FAULT HANDLER - LRU Replacement
			if(curenv->ActiveList.size + curenv->SecondList.size < curenv->page_WS_max_size )
			{
				struct FrameInfo* frame;
													fault_va = ROUNDDOWN(fault_va,PAGE_SIZE);
																	uint32* dir=curenv->env_page_directory;
																	int ret=allocate_frame(&frame);

																	if(ret!=0){
																		sched_kill_env(curenv->env_id);
																		cprintf("no free frame -------------------------------");
																	}
																	map_frame(dir,frame,fault_va,PERM_WRITEABLE|PERM_USER);
																	//allocate_user_mem(curenv, fault_va, 1);
																	int retpage=pf_read_env_page(curenv,(uint32*)fault_va);
																	int permissions=pt_get_page_permissions(dir,fault_va);
																	bool notFoudStack=0;
																	bool notFoudHeap=0;
																	if(retpage==E_PAGE_NOT_EXIST_IN_PF){
																		if(fault_va<USER_HEAP_START||fault_va>=USER_HEAP_MAX){
																			notFoudHeap=1;
																		}
																		if(fault_va<USTACKBOTTOM||fault_va>=USTACKTOP){
																			notFoudStack=1;
																		}

																	}


																	if(notFoudHeap&&notFoudStack){

																		sched_kill_env(curenv->env_id);
																	}
													struct WorkingSetElement* object =env_page_ws_list_create_element(curenv,fault_va);
				if(curenv->ActiveList.size==curenv->ActiveListSize)
				{

									struct WorkingSetElement* temp = LIST_LAST(&(curenv->ActiveList));
									LIST_REMOVE(&(curenv->ActiveList), temp);
									LIST_INSERT_HEAD(&(curenv->SecondList), temp);

				}

				LIST_INSERT_HEAD(&(curenv->ActiveList), object);


			}
			else
			{

			}
		//TODO: [PROJECT'23.MS3 - BONUS] [1] PAGE FAULT HANDLER - O(1) implementation of LRU replacement
		}
}

void __page_fault_handler_with_buffering(struct Env * curenv, uint32 fault_va)
{
	panic("this function is not required...!!");
}



