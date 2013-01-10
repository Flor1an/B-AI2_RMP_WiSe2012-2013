

#include <stdio.h> 
#include "stringsort.h"

/***************** stringsort.c *****************/
/* Ausdrucken der Stringliste */
void PrintStringliste(char **list ) {
    int i=0;
    while(list[i][0]!= '\0'){
        printf("%s \n",list[i]);
        i++; 
    }
    printf("\n");	
}

/* Sortieren einer Stringliste nach der Grˆﬂe */
/* der Zahl im String. */
void SortiereStrings( char **list  ) {
    
	// Bubble Sort verfahren
    char *tmp;
	int i, getauscht = 1;
    
	while (getauscht==1){
       
		getauscht=0; i=0;
        
		while (list[i+1][0] != '\0') { // So lange noch nicht am Ende
            
			if (getNum_asm(list[i]) > getNum_asm(list[i+1])) { // Vergleiche zwei Zahlen aus Strings
				tmp = list[i];                          // Ggf. tauschen
				list[i] = list[i + 1];
				list[i + 1] = tmp;
				getauscht = 1;
			}
			i++;
            
		}
	}
}

int getNum(char *ps){
	int num = 0;
	int i = 0;
	while (ps[i] != '\0') { // So lange das Ende nicht erreicht wurde
		if (ps[i]>='0' && ps[i]<='9') { // Wenn Zeichen eine Zahl ist
			num = num * 10 + (ps[i] - '0'); // Multipliziere aktuelle Zahl mit 10, da diese eine Stelle gewinnt und Addiere neue Zahl
		}
		i++;
	}
	return num;
}