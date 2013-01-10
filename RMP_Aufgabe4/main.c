/* Compiler:  	GNU
 *
 *
 *          	HAW-Hamburg
 *              Labor für technische Informatik
 *            	Berliner Tor  7
 *            	D-20099 Hamburg
 ********************************************************************/
#include <stdio.h>

#include "lpc24xx.h"
#include "config.h"
#include "ConfigStick.h"
#include "portlcd.h"
#include "fio.h"
#include "stdio.h"
#include "stringsort.h"

char *pMeineStrings[] = {
	"Brombach 5 EUR",
	"Kandinsky 13 EUR",
	"Osman 17 EUR",
	"Haller 25 EUR",
	"Zaluskowski 120 EUR",
	"\0\0"
};

int main (void)
{
    //-- initialize the LPC-Stick, enable UART0, UART2 and CAN
    //--
    BaseStickConfig();
    
    printf("Hallo TI_Labor\n");
    
#ifdef LCD_SUPPORT     
    LCD_puts ( "Hallo TI_Labor" );
#endif
  
    // Strings sortieren
	SortiereStrings( pMeineStrings );
    
	// String Liste ausgeben
	PrintStringliste( pMeineStrings );

    while (1){}
}

/************************************** EOF *********************************/
