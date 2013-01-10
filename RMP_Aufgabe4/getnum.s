.global getNum_asm
.align

#----------------------------------------
# Inputregister r0 (Stringadresse)
# Outputregister r0 (Zahlenwert)
# Verwendete Register retten und restaurieren
#----------------------------------------

getNum_asm:

	str fp, [sp, #-4]!				@Push FP
	mov fp, sp						@Aktuelle Stackposition in FP merken
	stmfd sp!, {r1-r5, lr}			@Register retten

	mov r1, #0						@Das Ergebnis, r1 (num) = 0
	mov r2, #10						@10 fuer Multiplikation
	
	while_01:						@Lade das i-te Symbol (Byte) aus Adresse r0 in r3
		ldrb r3, [r0], #1			@r0 = r0 + 1, postindex
		cmp r3, #0					@wenn das Symbol ist 0 (Ende des Strings),
		bne do_01					@dann Ende der Schleife, sonst do
		beq endwhile_01
	do_01:
		if_02:						@0x30 = "0", 0x39 = "9"
			cmp r3, #0x30
			blo endif_02			@Wenn r3 < 0x30, dann Endif
			cmp r3, #0x39
			bhi endif_02			@Wenn r3 > 0x39, dann Endif
		then_02:					@Wenn 0x30 <= r3 <= 0x39, dann...
			sub r4, r3, #0x30		@r4 = r3 - 0x30, das Ziffer
			mla r5, r1, r2, r4		@r5 (num) = r1 * 10 + r4
			mov r1, r5
		endif_02:

		b while_01
	endwhile_01:
	
	mov r0, r5						@return num durch r0
	
	ldmfd sp!, {r1-r5, lr}			@Register restaurieren
	ldr fp, [sp], #4				@Pop FP

	bx lr
#----------------------------------------

# Ganz wichtig!
.end