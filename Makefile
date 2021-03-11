
###############################################################################
#						Makefile for ARM Assembly Intro
#	Compile script for C source files used in ARM Assembly Intro guide
#	Each source file is compiled into ARM Assembly, using gcc, with one of
#	four possible options
#		1. No optimization
#		2. O1 optimization
#		3. O2 optimization
#		4. O3 optimization
#
#	all  		- (default) compile all c files in directory
# 	clean  		- clean up compiled object files and executable files
#	
#
#
###############################################################################

EXECUTABLES = basic_for_loop_number_check print_pattern_loops basic_conditionals array_reversal bitwise_operators sum_and_diff sum_of_digits sum_of_marks variadic_functions 

SOURCE_FILES = basic_for_loop_number_check.c print_pattern_loops.c basic_conditionals.c array_reversal.c bitwise_operators.c sum_and_diff.c sum_of_digits.c sum_of_marks.c variadic_functions.c 

GCC = gcc

FLAGS= -S -Wall -Wextra -Werror -Wfatal-errors -std=c99

O1_FLAGS="-O1"
O2_FLAGS="-O2"
O3_FLAGS="-O3"


###############################################################################
#
#	Compiling from source to ARM Assembly
#
###############################################################################

all: $(EXECUTABLES)


###############################################################################


clean:
	rm -f $(EXECUTABLES) *.o 




###############################################################################


O1_all:
	$(GCC) $(FLAGS) $(O1_FLAGS) $(EXECUTABLES)

O2_all:
	$(GCC) $(FLAGS) $(O2_FLAGS) $(EXECUTABLES)

O3_all:
	$(GCC) $(FLAGS) $(O3_FLAGS) $(EXECUTABLES)

basic_for_loop: basic_for_loop_arm.c 
	$(GCC) $(FLAGS) 


bitwise_operators: bitwise_operatos.c 
	$(GCC) $(FLAGS) 
	

sum_and_diff: sum_and_diff.c 
	$(GCC) $(FLAGS) 

sum_of_digits: sum_of_digits.c 
	$(GCC) $(FLAGS) 

sum_of_marks: sum_of_marks.c 
	$(GCC) $(FLAGS) 

array_reversal: array_reversal.c 
	$(GCC) $(FLAGS) 

print_pattern_loops: print_pattern_loops.c 
	$(GCC) $(FLAGS) 

n_lowest_nums: n_lowest_nums.c 
	$(GCC) $(FLAGS) 


###############################################################################




