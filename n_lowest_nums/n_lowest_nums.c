#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
*
*	n_lowest_nums takes as input:
*		1. an unsigned int (length) - the length of a list
*		2. an unsigned short int (nLowest) - the n lowest numbers to choose from that list
*		3. a list of signed integers (integerList)
*
*	n_lowest_nums then calls PrintLowestNumbers
*
*	PrintLowestNumbers takes as input
*		1. an array of integers
*		2. an unsigned int (length)
*		3. an unsigned short int (nLowest)
*	Print LowestNumbers calls quicksort, to sort integerList in ascending order
*	PrintLowestNumbers then prints the values in the sorted array at indices [0,n)
*
*	quicksort_nums is an implementation of the Quicksort sorting algorithm,
*	an in-place sorting algorithm that uses an in-place divide-and-conquer strategy to sort an array 
*	in O(nlogn) time and O(n) space
*	
*
*/

int partition_new(int* arr, int low, int high){
    if (low >= high) {
        return low;
    }
    
    int left = low + 1;
    int right = high;

    int pivot_index = low;
    int final_index = left;
    int arr_pivot = arr[pivot_index];

    while (left < right){
        while((arr_pivot <= arr[right]) && (right > left)){
            right--;
        }
        while((arr_pivot > arr[left]) && (right > left)) {
            left++;
        }
        if ((arr_pivot <= arr[left]) && (arr_pivot > arr[right]) && ((left < right) && (left > pivot_index))) {
            int tmp = arr[left];
            arr[left] = arr[right];
            arr[right] = tmp;
        } 
        else{
            break;
        }
    }
    final_index = left;

    if (arr_pivot > arr[final_index]){
        int piv_tmp = arr[left];
        arr[left] = arr_pivot;
        arr[pivot_index] = piv_tmp;
        return final_index;
    } else{
        return pivot_index;
    }
}


void quicksort_nums(int* arr, int low, int high){
    if (low < high) {
        int partition_index = partition_new(arr, low, high);
        quicksort_nums(arr, low, partition_index - 1);
        quicksort_nums(arr, partition_index + 1, high);
    }
}

void PrintNLowestNumbers(int* arr, unsigned int length, unsigned short nLowest)
{
	int low = 0;
	int high = length - 1;
	quicksort_nums(arr, low, high);
	for(int i =0; i < nLowest; i++){
	       printf("%d ", arr[i]);
	}
	printf("\n");	
}

int main()
{
	unsigned int length;
	unsigned short nLowest;
	scanf("%hu %u", &nLowest, &length);
	int* integerList;
	integerList= (int*) malloc(length * sizeof(int));
	for (unsigned int i=0; i<length; i++){
		scanf("%d", integerList + i);
	}
	PrintNLowestNumbers(integerList, length, nLowest);
	free(integerList);
	return 0;
}
