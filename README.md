# FOS

### Table of Contents
- [About The Project](#about-the-project)
- [Built With](#built-with)
- [Modules](#modules)
  - [System Calls](#system-calls)
  - [Memory Manager](#memory-manager)
  - [Fault Handler](#fault-handler)
  - [CPU Scheduler](#cpu-scheduler)
- [Known Issues](#known-issues)
- [Future Enhancements](#future-enhancements)
- [Acknowledgments](#acknowledgments)

---

### About The Project

FOS (FCIS Operating System) is a basic, command-line based operating system developed as part of the OS'23 course at the Faculty of Computer and Information Sciences, Ain Shams University. The project showcases key concepts in operating system development, including memory management, scheduling, and fault handling, aimed at offering hands-on learning for students.

### Built With

- **C**  
- **Makefile** (for easy compilation)

### Modules

#### System Calls
- Implemented system call interface to link user programs with kernel functions.
- Provides key system calls like `read`, `write`, `open`, and `close` for file management.

#### Memory Manager
Managing both user and kernel memory through:
- **Dynamic (Block) Allocator**
  - Allocation using first-fit and best-fit strategies
  - Freeing memory blocks and reallocating using the first-fit strategy
- **Page Allocator**
  - Allocating memory pages and efficiently freeing them
  - Supports lazy allocation and deallocation for user processes

#### Fault Handler
- Detects and validates page faults. If the fault is valid, the system handles it using either:
  - **FIFO** (First In, First Out)
  - **LRU** (Least Recently Used)

#### CPU Scheduler
- **BSD Scheduler:** Manages process scheduling based on priorities.
- Efficiently handles process states and context switching.
- Clock interrupt handler for periodic task management.



![WhatsAppVideo2024-09-21at00 47 12_25e346f6-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/154b3f89-7fab-4a07-b756-746e104f4f68)

