
###############################################################################
#			Makefile for ARM Assembly Intro
#	C source files used in ARM Assembly Intro guide
#	Each source file is compiled using gcc, with one of four possible options
#		1. No optimization
#		2. O1 optimization
#		3. O2 optimization
#		4. O3 optimization
#	Each executable is then disassembled using objdump -D and written to
#	a file with filename following the format:
#		dis_$(EXECUTABLE)_$(OPT_LEVEL).txt
#		- where $(EXECUTABLE) is the base name of the executable
#		and $(OPT_LEVEL) is the optimization level selected during 
#		compilation
#
#	all  		- (default) compile all c files in directory
# 	clean  		- clean up compiled object files and executable files
#	
#
#
###############################################################################

EXECUTABLES = 1d_arrays array_reversal bitwise_operators n_lowest_nums nth_term_recursion sum_and_diff sum_of_digits variadic_functions 

SOURCE_FILES = 1d_arrays.c array_reversal.c bitwise_operators.c n_lowest_nums.c nth_term_recursion.c sum_and_diff.c sum_of_digits.c variadic_functions.c 


## TODO: There is almost certainly a way to condense the next 10 lines into one (probably with globbing of some variety); to be modfiied;

SRC_DIR_1D = $(addprefix 1d_arrays_arm/,1d_arrays.c)
SRC_DIR_ARRAY_REV = $(addprefix array_reversal/,array_reversal.c)
SRC_DIR_BITWISE_OPS = $(addprefix bitwise_operators/,bitwise_operators.c)
SRC_DIR_N_LOWEST_NUMS = $(addprefix n_lowest_nums/,n_lowest_nums.c)
SRC_DIR_NTH_TERM_RECURSION = $(addprefix nth_term_recursion/,nth_term_recursion.c)
SRC_DIR_SUM_AND_DIFF = $(addprefix sum_and_diff/,sum_and_diff.c)
SRC_DIR_SUM_OF_DIGITS = $(addprefix sum_of_digits/,sum_of_digits.c)
SRC_DIR_VARIADIC_FUNCTIONS = $(addprefix variadic_functions/,variadic_functions.c)

SRC_DIRS =  $(SRC_DIR_1D) $(SRC_DIR_ARRAY_REV) $(SRC_DIR_BITWISE_OPS) $(SRC_DIR_N_LOWEST_NUMS) $(SRC_DIR_NTH_TERM_RECURSION) $(SRC_DIR_SUM_AND_DIFF) $(SRC_DIR_SUM_OF_DIGITS) $(SRC_DIR_VARIADIC_FUNCTIONS)

DST_DIRS = $(DST_DIR_1D) $(DST_DIR_ARRAY_REV) $(DST_DIR_BITWISE_OPS) $(DST_DIR_N_LOWEST_NUMS) $(DST_DIR_NTH_TERM_RECURSION) $(DST_DIR_SUM_OF_DIGITS) $(DST_DIR_VARIADIC_FUNCTIONS)

DST_DIR_1D = 1d_arrays_arm/
DST_DIR_ARRAY_REV = array_reversal/
DST_DIR_BITWISE_OPS = bitwise_operators/
DST_DIR_N_LOWEST_NUMS = n_lowest_nums/
DST_DIR_NTH_TERM_RECURSION = nth_term_recursion/
DST_DIR_SUM_AND_DIFF = sum_and_diff/
DST_DIR_SUM_OF_DIGITS = sum_of_digits/
DST_DIR_VARIADIC_FUNCTIONS = variadic_functions/

#EXEC_DIRS = $(DST_DIRS:.o=)

GCC = gcc

FLAGS= -g -O -Wall -Wextra -Werror -Wfatal-errors -std=c99

LIBS= -lm

O1_FLAGS= -O1
O2_FLAGS= -O2
O3_FLAGS= -O3

DIS= objdump

DFLAGS= -D


###############################################################################
#
#	Compiling from source on ARM v7 architecture
#
###############################################################################

#all: $(EXEC_DIRS)
all: $(EXECUTABLES)


###############################################################################


clean:
	rm -f $(SRC_DIRS) *.o 



#$(GCC) $(FLAGS) -c $< -o $(addprefix $(<D)/,$(@))
##$(GCC) $(FLAGS) -o $(addprefix $(filter $(<D), $(DST_DIRS)), $@) $< $(LIBS)

###############################################################################


O1_all:
	$(GCC) $(FLAGS) $(O1_FLAGS) -o $(EXEC_DIRS)

O2_all:
	$(GCC) $(FLAGS) $(O2_FLAGS) -o $(EXEC_DIRS)

O3_all:
	$(GCC) $(FLAGS) $(O3_FLAGS) $(EXECUTABLES)

%.o: $(filter %.c, $(SRC_DIRS))
	$(GCC) $(FLAGS) -c $< -o $(addprefix $(filter $(<D), $(DST_DIRS)), $@)

1d_arrays: 1d_arrays_arm/1d_arrays.o
	$(GCC) $(FLAGS) -o $(addprefix $(<D)/, $@) $< $(LIBS)

array_reversal: array_reversal/array_reversal.o
	$(GCC) $(FLAGS) -o $(addprefix $(<D)/, $@) $< $(LIBS)

bitwise_operators: bitwise_operators/bitwise_operators.o 
	$(GCC) $(FLAGS) -o $(addprefix $(<D)/, $@) $< $(LIBS)

n_lowest_nums: n_lowest_nums/n_lowest_nums.o
	$(GCC) $(FLAGS) -o $(addprefix $(<D)/, $@) $< $(LIBS)

nth_term_recursion: nth_term_recursion/nth_term_recursion.o
	$(GCC) $(FLAGS) -o $(addprefix $(<D)/, $@) $< $(LIBS)

sum_and_diff: sum_and_diff/sum_and_diff.o 
	$(GCC) $(FLAGS) -o $(addprefix $(<D)/, $@) $< $(LIBS)

sum_of_digits: sum_of_digits/sum_of_digits.o 
	$(GCC) $(FLAGS) -o $(addprefix $(<D)/, $@) $< $(LIBS)

variadic_functions: variadic_functions/variadic_functions.o 
	$(GCC) $(FLAGS) -o $(addprefix $(<D)/, $@) $< $(LIBS)



###############################################################################

echo:
	echo "$(SRC_DIRS)"
	echo "$(DST_DIRS)"
	echo "$(EXEC_DIRS)"


###############################################################################
dis_1d_arrays: 
	$(DIS) $(DFLAGS) 1d_arrays 
