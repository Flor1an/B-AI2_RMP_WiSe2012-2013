@ Versuch 3: Reaktionstester
@ --------------------------

.global	main, TestIfPushButtonPressed, OutputLEDBar, LEDBarEndReached, StartText, SafeDelay, Stopped
              .equ    GPIO1_BASE, 0xE0028010

              .equ    GPIO1_PIN,  GPIO1_BASE+0x00
 			  .equ    GPIO1_SET,  GPIO1_BASE+0x04
			  .equ    GPIO1_DIR,  GPIO1_BASE+0x08
			  .equ    GPIO1_CLR,  GPIO1_BASE+0x0C



# --- Initialisierung der Daten ---
.section	.data	
	.align	4

LCDText1:	.asciz	"Zum Start - Taste S7 druecken"
LCDText2:	.asciz	"Achtung!"
LCDText3:	.asciz	"Gestoppt"

# --- Hauptprogramm ---
.section 	.text
	.align	4	



main:


    bl		BaseStickConfig	
	
	@ Timer initialisieren (wichtig für Delay-Funktion)!!
	mov		r0, #0		@ Init. Timer
	bl     	init_delay
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@ Punkt 1 Ports initialisieren @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	
	bl 		ConfigurePorts
	
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@ Punk 2 Starttext anzeigen @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

StartText:

	@ Starttext ausgeben
	bl     	LCD_cls	
	ldr 	r0, =LCDText1
	bl 		LCD_puts

	mov r1, #0 @Auf r1 wird die Balkenlänge gespeichert start=0
	
	mov r0, #0 @r0 = wert des Tasters 
	
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@ Punkt 3 auf Taste S7 warten (durch Polling) @@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	while_02:
		cmp 	r0, #1
		beq 	endwhile_02 @Wenn taster=gedrückt, dann rausspringen

	do_02:
		bl 	TestIfPushButtonPressed
		b 	while_02
	
	endwhile_02:
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@ Punkt 4 Timer initialisieren|"Achtung" ausgeben|LED-Balken löschen
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	bl     	LCD_cls		
	ldr 	r0, =LCDText2
	bl 		LCD_puts

	@ LED-Balken loeschen
	mov 	r0, #0
	bl 		OutputLEDBar
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	
@@@@@@ Punkt 5 3s warten @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	ldr 	r0, =30000
	bl 		SafeDelay

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@ Punkt 6 (1. Bedingung) Balkenlänge = 15? @@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	@ Hauptteil
	while_03: @ Sprige zum Ende, wenn Balken voll
		bl 		LEDBarEndReached
		cmp 	r0, #1
		beq 	Stopped
	
	do_03:
	
		@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		@@@@@@ Punkt 7 Taste S7 abfragen @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		bl 		TestIfPushButtonPressed
		cmp 	r0, #1
		beq 	Stopped 
		
		@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		@@@@@@ Punkt 9 Zeitverzögerung 20ms @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		ldr 	r0, =200
		bl 		SafeDelay
		
		@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		@@@@@@ Punkt 10 Balkenlänge um 1 erhöhen @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		add 	r1, r1, #1
		mov 	r0, r1
		bl 		OutputLEDBar
		
		b 		while_03 @Schleife erneut durchlaufen
		
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@ Punkt 11 "Stopped" anzeigen @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Stopped:
 		bl     	LCD_cls			
		ldr 	r0, =LCDText3
		bl 		LCD_puts
		
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@ Punkt 12 Zeitverzögerung 3s @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		ldr 	r0, =30000
		bl 		SafeDelay
		b 		StartText
		
	endwhile_03:
	b 	StartText	@Wieder von vorne
	
 
loop:     
     b	loop

# ----------------------
# --- Unterprogramme ---
# ----------------------
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Helper: Ports Configurieren           @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ConfigurePorts:

	ldr     r1,=GPIO1_DIR    @ Richtungsregister
	ldr		r2, [r1] 
	ldr     r3,=0b0111111111111111 @ 15 als Eingang (Taster)  und 0-14 als Ausgang
	orr		r3,r2
	str		r3, [r1]		@Auf Board Speichern

	bx lr 

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Helper: Taster prüfen                 @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

TestIfPushButtonPressed:
	mov 	r0, #0
	stmfd 	sp!, {r1, r2, lr} @ r1, r2 sichern
	ldr 	r1, =GPIO1_PIN
	ldr 	r2, [r1] @ Wert der Taster/Leds
	mov 	r2, r2, LSR #15 @ Den wert des Tasters ermitteln.
	and 	r2, #1

	if_01:
			cmp 	r2, #1 
			beq 	endif_01 
	
	then_01:
			mov 	r0, #1 @ Schiebe eine 1 in r0

	endif_01:
	
	ldmfd 	sp!, {r1, r2, lr} @ Register wiederherstellen
		
	bx lr

	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Helper: LED Bar ausgeben              @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

OutputLEDBar:
	
	stmfd 	sp!, {r1, r2, r3, lr} @ Sichere register
	mov 	r1, #0 @ Initialisiere Zaehlvariable
	mov 	r2, #1 @ Intialisiere Binaere Balkenlaenge
	ldr 	r3, =GPIO1_PIN

	while_01:

			cmp		r0, r1 @ Pruefen, ob Zaehlvariable schon = Anzahl der LEDs die leuchten sollen
			beq		endwhile_01 @ Springe zum Ende der Schleife, falls ja
	
	do_01:
	
			mov		r2, r2, LSL #1 @ Shiebe Bits in r2 um eins nach links
			orr		r2, #1 @ Setze das nun vornestehende Bit auf 1
			add		r1, #1 @ Erhoehe die Zaehlvariable um 1
			b		while_01 @ Springe zum Schleifenkopf
	
	endwhile_01:
		
			mov		r2, r2, LSR #1
			str		r2, [r3]	

	ldmfd 	sp!, {r1, r2, r3, lr}

	bx lr
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Helper: Prüfen ob LED Balken leuchtet @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	
LEDBarEndReached:

	stmfd 	sp!, {r1, r2, r3, lr}	
	mov 	r0, #0	
	ldr 	r1, =GPIO1_PIN
	ldr 	r2, [r1]
	ldr 	r3, =0b0111111111111111
	and 	r2, r3
	
	if_02:
			cmp 	r2, r3
			bne 	endif_02

	then_02:
			mov 	r0, #1

	endif_02:

	ldmfd 	sp!, {r1, r2, r3, lr}		

	bx lr
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Helper: Delay aktivieren              @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
SafeDelay:
	
	stmfd 	sp!, {r1-r4, lr}
	bl delay
	ldmfd 	sp!, {r1-r4, lr}

	bx lr


.end

     
@************************************** EOF *********************************