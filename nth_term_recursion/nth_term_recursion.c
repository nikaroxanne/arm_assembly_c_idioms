#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

//Using dynamic programming
int find_nth_term_dynamic(int n, int a, int b, int c, int* terms) {
    if (n == 0 || n == 1 || n == 2 || n == 3){
        return terms[n];
    }
    else {
        if (terms[n] == 0){
            terms[n] = find_nth_term_dynamic((n-1), a, b, c, terms) + find_nth_term_dynamic((n-2), a, b, c, terms) + find_nth_term_dynamic((n-3), a, b, c, terms);
        }
        return terms[n];
    }
}


//Using recursion
int find_nth_term(int n, int a, int b, int c) {
  if (n == a) {
    return a;
  }
  else if (n == b) {
    return b;
  }
  else if (n == c) {
    return c;
  }
  else {
    return find_nth_term((n-1), a, b, c) + find_nth_term((n-2), a, b, c) + find_nth_term((n-3), a, b, c);
  }
}

int main() {
    int n, a, b, c;
  
    scanf("%d %d %d %d", &n, &a, &b, &c);


    terms[1]=a;
    terms[2]=b;
    terms[3]=c;
    int ans = find_nth_term(n, a, b, c);
    int ans_dynamic = find_nth_term_dynamic(n, a, b, c, &terms);
    printf("%d", ans_dynamic);
    return 0;
}
