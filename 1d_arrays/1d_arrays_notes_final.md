1d_arrays_notes


The program 1d_arrays.c initializes an int n and then defines the value of that variable n as the value that it reads from stdin using scanf("%d", &n). Then, the program allocates an array of integers, arr, of length n. 
Then, n integers are read from stdin (again, using scanf) and those values are stored in the newly created array arr, at the indices corresponding to the order in which those numbers are read from stdin.

So, if n is 3, int* array arr is allocated with size 3.
Then, three integers are read from stdin. The first integer is stored in arr[0], the second in arr[1], the third in arr[2].

Recap to this point, 1d_arrays allocates an array of integers of size n, reads n integers from stdin and stores those integers at their corresponding indices in the array arr. 

Then, an integer, sum, is initialized to 0, and the values in arr are read and added to that accumulator integer sum. Then, this value sum is printed to stdout, the memory allocated for array arr is freed and the program exits.

Creates an array of integers, arr, of size n, allocated on the heap using <em> malloc() </em>
Calculates the sum of all of the integers in arr, using a <em> for loop </em>
Prints the value of that sum to stdout, using <em> printf() </em>
Frees the memory allocated for array arr and exits, using <em> malloc() </em>



***

Okay, so let's start translating the ARM assembly, and try to find where some of those C idioms are found in the ARM binary and how they have been translated.


On line 7, there is a sub instruction which substracts 24 from our stack pointer. This tells us that the size of the stack frame for this function (main), is 24. 

On line 8, we have an instruction that adds sp (a pointer) plus 0, so sp, to the value at r7. So the instruction on line 9 is adding the value &(*(sp - 24)) to r7. So r7 now points to the bottom of our stack frame, it is our base pointer (approximately equivalent to EBP in x86).


r7 + 24 ->  {r7}
			{lr}
r7 + 8
r7 + 4
r7 --> 		sp



On line 9, the adds instruction evaluates (r7 + 4), and this value is added to the register r3. We know that r7 stores an address (the base of the stack, sp), so (r7 + 4) is an address with an offset of 4. 

On line 10, the value r3 is stored in r1.

On line 11, the value [pc + 132] is stored in r3. This is a value from the literal pool, located at the end of main. So this is loading a literal value into the register r3.

On line 12, the value $pc is added to r3.
And on line 13, r3 is stored in register r0.

Then on line 14, there is a call to scanf, which we can see because this is not a stripped binary, so we have all of our symbolic info. You're welcome.

In C, the function scanf expects at least one argument (const char* format), and then can take a variable number of successive arguments. The string format.

So we know that the first argument to scanf will be that format string, and any subsequent arguments will be the addresses of where to store the value(s) that satisfy the requirements of that format string.

Recall from lines 7-13 that r1 contains the address (r7 + 4), and r0 contains the value from our literal pool that corresponds to our format string. The next register used for passing arguments, r2, is not mentioned before the call to scanf, so we can pretty safely assume that r0 and r1 are the only two arguments being passed to scanf.

On line 15, after returning from scanf, there is a load instruction, that takes the value pointed to by the pointer at [r7 + 4], and loads it into the register r3. 

On line 16, there is the lsls instruction, which performs a logical shift left (signed), and the result lsls r3 r3, #3, evaluates r3 << 3 (equivalent to r3 * 2^3, or r3 * 8), and stores that resultant value in r3. So, r3 *= 8.

On line 17, r3 is moved into r0.
On line 18, there is a call to malloc.

In C, the malloc function accepts one argument, an integer value corresponding to the size of memory to be allocated on the heap. The format for this integer value typically follows the pattern (n * sizeof(type)), where type is the type of data (i.e. int, char) and n is the number of elements of that type. 

So line 18 calls malloc and returns an array of integers, int* arr, that has size n. When malloc returns, arr is returned in r0.
So on line 19, the mov instruction moves this array arr, from r0 to r3.
Then on line 20, r3 (meaning r0, meaning arr), is stored at the address [r7 + 8].
So arr is now stored in the stack frame at offset [r7 + 8].

On line 21, there is a mov instruction, which moves the literal value 0 into r3. So, this zeroes out the r3 register.
Then on line 22, there is another str instruction, which stores the new value in r3 (0), to the address [r7 + 20]

Now our stack looks like this:

r7 + 24
r7 + 20			0
r7 + 16
r7 + 12			
r7 + 8			arr
r7 + 4			n
r7

On line 23, there is an unconditional branch instruction (b), which jumps execution of the program to line 36 (0x5f6).

Continuing after this branch, on line 36, there is a load instruction that loads the value at [r7 + 4] into register r3. Remember that [r7 + 4] is the address of the variable n, so r3 = n.
On line 37, there is a similar load instruction that loads the value at [r7 + 20] into register r2. The value stored at the address [r7 + 20] is i (current value 0), so r2 = i = 0.

To recap these previous two lines, now r2 = 0, and r3 = n
On line 38, there is a cmp instruction which compares the values in r2 and r3 by evaluating (r2 -r3), and setting the appropriate flags.


So, what is the equivalent of the ARM Assembly lines 36-38 in the C program?
Line 12! This is the conditional for the first for loop, that checks whether (int i < n) evalutes to true and, if so, branches and continues execution inside the loop. If the conditional evaluates to true, then the program jumps to line 24, so let's do that.


On lines 24-39, we have the main body of the first loop in the C program (lines 12-14 in 1d_arrays_.c)

On line 24, [r7 + 20] is loaded into r3. Again, [r7 + 20] is where i is stored, so r3 = i = 0.
On line 25, the value at r3 is shifted left by 2, so (r3 << 2) or (r3 * 2^2, or (r3 * 4)


On line 26, [r7 + 8] is loaded into r2

On line 27, r2 is added to r3, so r3+= r2. Since we know that r3 contains an address, and r2 contains an integer value, we can deduce that this operation is moving the pointer r3 by an offset of r2. We know that the value in r3 is the address of the int array arr, so this instruction is moving the array to point to the element at the index designated by the value in r2 (i).

So why the lsls instruction from earlier on line 25?
Because we need to move the address by an offset that corresponds to the size of the data that is in each element of the array in memory. So, since the array arr is an array of integers, each element will have size 4, so the address of each element in the array will be aligned by a 4-byte offset. So accessing the element at arr[i] is equivalent to calculating &arr + 4(i).

This is equivalent to accessing an element in an array.

On line 28, the value in r3, the address of arr[i], or &(*(arr + i)), is moved into register r1

On line 29, we have another similar load instruction to the instruction from line 11, that loaded a value from the literal pool, that corresponded to the string "%d." If we look in the literal pool at the specified offset, and then reference this with the value in the .data section, we can see that this is the same "%d" string. Hello hello is this a pattern we're seeing?! (IT IS)

Again, as with lines 12-13, on lines 30-31, the value $pc is added to the value in r3, and r3 is moved to r0.
Then, on line 32, there's the same scanf call as before, this time passing r0 ("%d") and r1 (&(*(arr + i))).

On line 33, the value [r7 + 20] is loaded into r3. Remember that [r7 + 20] is the address of the variable i. So r3 = i
On line 34, the value 1 is added to r3. So, r3 += 1
Then, on line 35, this new value of r3 is stored back at the same address [r7 + 20].

So, lines 33-35 are the i+= 1 of the loop!

On lines 36 and 37, the values in [r7 + 20] and [r7 + 4] are loaded into registers r3 and r2 respectively. We know that the values at these addresses are i and the address of n respectively. Then, on line 38, there is another cmp instruction... oh wait! We've seen this before. We were literally already on these lines. This is the evaluation of (i < n), ah another pattern!!


So, now we know that the loop will continue executing lines 24-39 until the condition (i < n) is no longer met. 

Okay, so we've read n integers from stdin using scanf and stored those integers in the array arr allocated earlier. 
Let's continue.

On line 40, we load the value 0 into the register r3. 
On line 41, we store that value in r3 at the address [r7 + 16].
We do the same thing on lines 42-43: load 0 into r3, store that value at an address, though this time the address is [r7 + 12].

So we have just initialized two variables and stored them on the stack. These are sum (in r2) and j (in r3).

On line 44, we have another unconditional branch (b) to address 61e (line 56), so let's jump (ha, still funny) down to that address.

On line 56, the value at address [r7 + 4] is loaded into r3.
On line 57, the value at address [r7 + 12] is loaded into r2.
Then, on line 58, those two values are compared, appropriate flags set.
On line 59, we have a conditional branch, blt (branch if less than). So if (r2 < r3), then branch to address 0x608 (line 45).

This feels familiar...
Oh wait, it's the same structure of the for loop from earlier!
And sure enough, since r2 = j and r3 = n, this is the conditional of the for loop on line 17 in the C program.
If (j < n), then we take the branch to continue execution at line 56. Let's do that.

On 45-48, we're performing the same instructions as earlier (lines 24-27), load value at [r7 + 12] into r3, perform a logical left shift by 4 on r3, load value at [r7 + 8] into r2, and add r2 and r3 and store the value in r3.
Again, this is process of calculating the address of the element at index i in array arr.

On line 49, we load the value at address [r3 + 0]. Recall from lines 45-48 that the value in r3 now is the element arr[i] at the address computed earlier. We are performing *(arr + i), so r3 = arr[i]
On line 50, we load the value at address [r7 + 16]. The value stored at [r7 + 16] is 0, which is the initial value of the variable sum in our C program.

On line 51,  there is an add instruction, which performs add r3 r2. This is equivalent to r3 = arr[i] + 0, or r3 = arr[i] + sum. So we are calculating computing the sum of the elements in the array thus far!

On line 52, this newly computed value in r3 (the current sum), is stored at address [r7 + 16]. This makes sense, because this is the address where we stored our initialized sum variable earlier, so now we are updating the value at that address to reflect the current sum.

On line 53, the value at [r7 + 12] is loaded into r3. So r3 = j = 0
On line 54, there is an add instruction, which adds 1 to the value stored in r3. This is equivalent to r3 += 1. 
What does this recall? The sequence of instructions from lines 33-35, where we incremented the value of the integer i after each iteration of the for loop. Here, the program is doing the same thing, but with the variable j of the current for loop.
So j+= 1.

As with before, on line 55, we store this newly incremented variable value back to the address [r7 + 12].

And then on lines 56-58, we are performing the same routine as noted above, load value at address [r7 + 4] into r3, load value at address [r7 + 12] into r2, compare and then either take a conditional branch or continue at the next instruction, depending on the truth value of the evaluation of the expression (j < n).

So, the body of the second for loop on lines 45-59, continues to add the values of the elements of the array arr to the accumulator variable sum, and the exits the body of the loop once the index of the array element j == n, (in other words, once all elements have been read from the array and added to sum).

Okay, so we've computed the sum of all of the elements in the array... let's continue execution at line 60, after the conditional (j < n) evalutes to false.

On line 60, the value at address [r7 + 16] is loaded into r1. This is the address of the variable sum, so r3 = sum.
On line 61, the value at address [pc + 32] is loaded into r2. As with before, we know that this address corresponds to the literal pool. If we cross-reference this with the value in the .data section, we can see that this, again, is the same "%d" string. So r2 = "%d"
On line 62 and 63, just as before on lines 12-13 and lines 30-31, $pc is added to r3 and the value in r3 is moved to r0.

On line 64, there is a call to printf. As with scanf, printf takes one or more arguments, the first of which is a const char* format string specifier, and any additional arguments will correspond to the values that satisfy the parameters of that format string. So, as with our previous calls to scanf, r0 is "%d", and this time, r1 contains the value of the variable sum. 
So our printf call looks like this: printf("%d", sum);
And in our C program, we see that this is the exact call made on line 21 of 1d_arrays.c

~* SIQ *~

On line 65, the value at address [r7 + 8] is loaded into r0. Recall that this is the address of the first element of our array arr. 
So r0 = *arr

And on line 66, there is a call to free(). Similar to malloc, free takes one argument, the address of the allocated heap memory to be freed.
So this is the call to free(arr) because we love effective memory management in C.
Memory leaks? Not today, Satan!! 

Okay, we're almost at the end of our program now... let's perform our last few housekeeping tasks.

On line 67, the value 0 is moved into r3. So r3 = 0.
On line 68, the value in r3 is moved into r0. So r0 = 0. Since we are near the end of our function, we know that this is setting the value of the return variable once the program exits from main(). This corresponds roughly to line 23 in our C program, return 0.

On line 69, there is an add instruction, which adds 24 to r7. Recall from the beginning of this whole endeavor that there was a call to sub r7 #24 to set up our stack frame. So this is the complementary instruction, to add 24 to r7 and realign our stack pointer to point to the initially saved return address from the function.

And on line 70, this newly re-aligned value of r7 is moved to sp. 

So now our stack frame looks like


sp -> 			{r7} 
				{lr}



And finally, on line 71, we pop {r7, pc}. Why don't we pop {lr}? We would, if this were a normal function outside the body of main. But since this is main, and there are no more calls, there is no need to branch to the link register. 

So, pop {r7}, exit from main, return 0... we're done!!

WOW WHAT AN ADVENTURE

DID YOU HAVE FUN?!

Well, I had fun. That was a journey. I'm glad we made it out alive.

That was our first exploration of C idioms in ARM Assembly. 


***

Okay, so we've learned some idioms... let's see if we can find some ?? la Waldo in a different binary.

Below is the disassembly for a different ARM binary, that was compiled from a different C program that I wrote, that implements similar functionality but with additional complexity.

See if you can find Waldo in this binary...

Did you find the C idioms? Do you want a hint? Do you want me to just tell you? Did you even make it this far or did you just scroll through all the text above and now you're startled that I've called you out so abruptly? 

Well, if you want to see the original C source code, just click the link below and enter your credit card information and pay the small fee of $49.99 + the cost of shipping and handling...

Just kidding, just click the button to the right of the screen.

<button> Show me the MONEY </button>
