#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

int sum_of_digits(int n) {
    if (n < 10) {
        return n;
    }
    else {
        int new_n = (n / 10);
        return (n % 10) + sum_of_digits(new_n);
    }
}


int main() {
	
    int n;
    scanf("%d", &n);
    int sum_val = sum_of_digits(n);
    printf("%d \n", sum_val);
    return 0;
}