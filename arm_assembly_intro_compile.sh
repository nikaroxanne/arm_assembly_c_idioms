#!/bin/bash

###############################################################################
#	Compile
#	Compile script for C source files used in ARM Assembly Intro guide
#	Each source file is compiled into ARM Assembly, using gcc, with one of
#	four possible options
#		1. No optimization
#		2. O1 optimization
#		3. O2 optimization
#		4. O3 optimization
#
#
#
###############################################################################


###############################################################################
#	Setup
###############################################################################

CC=gcc

FLAGS="-g -Wall -Wextra -Werror -Wfatal-errors -std=gnu99"
ASSEMBLY_FLAG="-S"



O_DEFAULT_FLAG="-O0"
O1_FLAGS="-O1"
O2_FLAGS="-O2"
O3_FLAGS="-O3"
OPT_FLAGS=("$O_DEFAULT_FLAG" "$O1_FLAGS" "$O2_FLAGS" "$O3_FLAGS")



ASSEMBLY_EXT="_O0.s"
O1_S_EXTENSION="_O1.s"
O2__S_EXTENSION="_O2.s"
O3_S_EXTENSION="_O3.s"
OPT_S_EXTS=("$ASSEMBLY_EXT" "$O1_EXTENSION" "$O2_EXTENSION" "$O3_EXTENSION")

C_EXT=".c"
OBJ_EXT="_O0.o"
O1_EXTENSION="_O1.o"
O2_EXTENSION="_O2.o"
O3_EXTENSION="_O3.o"
OPT_OBJ_EXTS=("$OBJ_EXT" "$O1_EXTENSION" "$O2_EXTENSION" "$O3_EXTENSION")

EXEC_EXT="_O0"
O1_EXEC_EXTENSION="_O1"
O2_EXEC_EXTENSION="_O2"
O3_EXEC_EXTENSION="_O3"
OPT_EXTS=("$EXEC_EXT" "$O1_EXEC_EXTENSION" "$O2_EXEC_EXTENSION" "$O3_EXEC_EXTENSION")

LIBS="-lm"



###############################################################################
#		Cleanup old object files before compiling
#
###############################################################################

rm -f *.o


###############################################################################
#
#	Compiling from source to ARM Assembly
#
###############################################################################



OPT_RANGE=0

case $# in 
	0) set *.c ;;
esac


case $1 in
	0) 
		echo "${OPT_EXTS[0]}"
		;;
	1|2|3)
		let OPT_RANGE=$1
		echo "Opt range is: $OPT_RANGE"
		;;
esac	

COMPILATION_PHASE=4

##Compilation Phases enum{PREPROCESSING, COMPILATION, ASSEMBLY, LINKING}
##Default value is 4; unless specified by user

link=all

case $2 in
	#2|a|-a|-assemble) 
	2) 
		let COMPILATION_PHASE=$2
		echo "generating assembly files"
		link=none; shift;;
	3)
		let COMPILATION_PHASE=$2
		echo "generating object files"
		link=none; shift;;
esac
	
set *.c


for cfile
do
	if [ $COMPILATION_PHASE -eq "2" ]; then
		ASSEMBLY_FILE=${cfile%$C_EXT}$ASSEMBLY_EXT
		$CC $FLAGS $O_DEFAULT_FLAG $ASSEMBLY_FLAG $cfile -o $ASSEMBLY_FILE
		echo "original filename: $cfile"
		echo "output assembly file filename: $ASSEMBLY_FILE"
	fi

	O0_OBJ_FILE=${cfile%$C_EXT}$OBJ_EXT
	$CC $FLAGS $O_DEFAULT_FLAG -c $cfile -o $O0_OBJ_FILE
	echo "original filename: $cfile"
	
	for index in `seq 1 "$OPT_RANGE"`
	do
		if [ $COMPILATION_PHASE -eq 2 ]; then
			ASSEMBLY_FILE=${cfile%$C_EXT}$ASSEMBLY_EXT
			$CC $FLAGS $O_DEFAULT_FLAG $ASSEMBLY_FLAG $cfile -o $ASSEMBLY_FILE
			echo "original filename: $cfile"
			echo "output assembly file filename: $ASSEMBLY_FILE"
		fi
		NEW_O_OBJ_FILE=${cfile%$C_EXT}${OPT_OBJ_EXTS[$index]}
		$CC $FLAGS $O_FLAG -c $cfile -o $NEW_O_OBJ_FILE
	done
done




###############################################################################
#	Linking object files and libraries to create executables
#
###############################################################################

case $link in
	all|array_reversal) 
		$CC $FLAGS $O_DEFAULT_FLAG -o array_reversal_O0 array_reversal_O0.o $LIBS
		linked=yes;;
esac

case $link in
	all|bitwise_operators) 
		$CC $FLAGS $O_DEFAULT_FLAG -o bitwise_operators_O0 bitwise_operators_O0.o $LIBS
		linked=yes;;
esac

case $link in
	all|sum_and_diff) 
		$CC $FLAGS $O_DEFAULT_FLAG -o sum_and_diff_O0 sum_and_diff_O0.o $LIBS
		linked=yes;;
esac


case $link in
	all|sum_of_marks) 
		$CC $FLAGS $O_DEFAULT_FLAG -o sum_of_marks_O0 sum_of_marks_O0.o $LIBS
		linked=yes;;
esac

case $link in
	all|sum_of_digits) 
		$CC $FLAGS $O_DEFAULT_FLAG -o sum_of_digits_O0 sum_of_digits_O0.o $LIBS
		linked=yes;;
esac

case $link in
	all|variadic_functions) 
		$CC $FLAGS $O_DEFAULT_FLAG -o variadic_functions_O0 variadic_functions_O0.o $LIBS
		linked=yes;;
esac

case $link in
	all|1d_arrays) 
		$CC $FLAGS $O_DEFAULT_FLAG -o 1d_arrays_O0 1d_arrays_O0.o $LIBS
		linked=yes;;
esac

case $link in
	all|variadic_functions) 
		$CC $FLAGS $O_DEFAULT_FLAG -o variadic_functions_O0 variadic_functions_O0.o $LIBS
		linked=yes;;
esac

case $link in
	all|sum_and_diff) 
		for index in `seq 0 "$OPT_RANGE"`
		do
			NEW_O_EXEC_FILE=${cfile%$C_EXT}${EXEC_EXTS[$index]}
			echo "$NEW_O_EXEC_FILE"
			O_OBJ_FILE=${cfile%$C_EXT}${OPT_OBJ_EXTS[$index]}
			echo "$O_OBJ_FILE"
			$CC $FLAGS $O_DEFAULT_FLAG -o $NEW_O_EXEC_FILE $O_OBJ_FILE $LIBS
			#$CC $FLAGS $O_DEFAULT_FLAG -o sum_and_diff_O0 sum_and_diff_O0.o $LIBS
			linked=yes
		done
		;;
esac


###############################################################################
#	For each executable, generate corresponding disassembly using objdump
#	save objdump output to appropriately named file
#
###############################################################################


for file in *_O0
do
	DISASSEMBLY_FILE="dis_"$file".txt"
	echo "DISASSEMBLY FILE: $DISASSEMBLY_FILE"
	objdump -d $file > $DISASSEMBLY_FILE
done


###############################################################################
