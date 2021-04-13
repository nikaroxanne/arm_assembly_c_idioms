# arm_assembly_c_idioms
This repository contains all scripts used in the "Intro to Arm Assembly" guide featured on my website: https://nikaroxanne.github.io/projects/reverseEngineeringFirmware/arm_assembly_c_idioms

The format of this repo is as follows:

Each directory contains the source code for a simple program written in C that illustrates one or more programming "idioms" for the C language. Within this directory, are one or more disassembly files, generated as output from executing objdump -marm -d {program_name} > dis_program_name.txt

A more detailed overview of the contents of this repo is outlined below.

For these examples, I used programs in C that I had written for technical interview practice exercises on HackerRank, and compiled and disassembled each program on a Raspberry Pi, running on an ARMv7 core. Of course, the output for the assembly (or disassembly) will depend upon different factors, including the architecture of the machine, the assembler or disassembler used, and, in the case of disassembly, the type of disassembly pass implemented (i.e. linear or recursive disassembly).


Machine specs: Raspberry Pi, Model B, running Kali Linux; ARMv7 architecture

For each program, I generated the ARM executable file for each C source code program, by compiling with gcc using one of four optimization levels (O0, O1, O2, O3) and then disassembling the resultant executable using objdump. Compilation was performed with a Makefile and a compile script, which are both included in the Github repo for this page.  The Makefile and the compile script are essentially equivalent (the compile script is actually more verbose), and my explanation for the redundancy is that honestly I just like writing bash scripts and this one was fun.


Since the disassembly of a program can also vary depending on compiler optimizations used at compile time, I have included five files produced as output from assembly and/or disassembly of the same program:


For all programs in this repo, let example.c represent a member of that set, and let the following five files be derived from that input example.c source


1. example_O0
the compiled ARM binary executable file compiled using gcc with -O0 flag, from source example.c; gcc {$FLAGS} example.c
2. example_O1
the compiled ARM binary executable file compiled using gcc with -O1 flag, from source example.c; gcc {$FLAGS} example.c
3. example_O2
The compiled ARM binary executable file compiled using gcc with -O2 flag, from source example.c; gcc {$FLAGS} example.c
4. example_O3
the compiled ARM binary executable file compiled using gcc with -O3 flag, from source example.c; gcc {$FLAGS} example.c
5. dis_example_O0.txt, 
the disassembled binary compiled with default -O0 optimization; objdump -d example_O0

For the sake of simplicity, the write ups in the C Idioms section will all use the disassembly of the compiled program with the default -O0 optimization.

For consistency, I used objdump for disassembly for each of these programs. This also provides another view of what you might encounter if you are reverse engineering a compiled ARM binary.


I chose these programs because they are all relatively small and straightforward, and they implement some common programming constructs, as well as well-known algorithms. I think that their generality makes them a prime candidate to use for disassembly. These programs aren’t particularly spectacular or novel — they implement staples of programming, and are thus less overwhelming than jumping right into disassembling firmware.


All pages in the C Idioms section use the following format: present the C source code and a relevant excerpt of the disassembled binary, compiled from the C source file with default -O0 optimization. I have not included the entire disassembly output, for the sake of not overwhelming the reader with an even larger wall of text. On each page, the C source code will be shown in a column to the left and the relevant ARM assembly will be in a column to the right — unless you are viewing this on mobile, in which case, the columns will be stacked and the C source will be in a column above the ARM assembly. The entire disassembly file is available in the GitHub repo linked above. 


Each page features as verbose a walkthrough of the disassembly as I determined was relevant to understanding the inner workings of the ARM assembly and its relationship to its C source equivalent. In most cases, I go line by line and explain what each ARM instruction is doing and how it relates to a specific C idiom. In some cases, the later walkthroughs specifically, I only highlight the most important instructions as they pertain to the idioms in question. At the end of each walkthrough, I have included a section to ~*apply what you’ve learned*~ where I present the disassembled output for a different but related C program, as an exercise for the reader. You can work through the ARM assembly and ~*reverse engineer*~ the original C program. To check if you have the right idea, the corresponding ARM disassembly is available to view by toggling the button at the bottom of that section. 
