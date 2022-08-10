#include <asm_setup.S>

.text

.extern _savegpr_27
.extern PlaySoundWithFunctionB4_2
.extern _Z9hijackSFXi

.global SFXHax
SFXHax:
	stwu sp, -0x20(sp)
	mflr r0
	stw r0, 0x24(sp)
	addi r11, sp, 32
	bl _savegpr_27

	cmpwi r5, 189
	beq removeHax
	cmpwi r5, 2000
	blt noHax

doHax:
	mr r16, r3
	mr r17, r4
	mr r19, r6
	mr r20, r7
	mr r21, r0

	mr r3, r5

	bl _Z9hijackSFXi

	mr r5, r3

	mr r3, r16
	mr r4, r17
	mr r6, r19
	mr r7, r20

noHax:
	b PlaySoundWithFunctionB4_2

removeHax:
	li r5, 1999
	b doHax


.global _Z15loadFileAtIndexPjjS_ #r3 = file ptr; r4 = file size; r5 = ptr to write on
_Z15loadFileAtIndexPjjS_:
	stwu r1, -0x10(r1)
	mflr r0
	stw r0, 0x14(r1)
	stw r31, 0xC(r1)

	li r6, 0
	b startLoop

continueLoop: #r6 = i; r7 = byte to write
	lwzx r7, r3, r6
	stwx r7, r5, r6

	addi r6, r6, 4

startLoop:
	cmpw r6, r4
	blt continueLoop

	
return2:
	lwz r0, 0x14(r1)
	lwz r31, 0xC(r1)
	mtlr r0
	addi r1, r1, 16
	blr
	

.extern SoundRelatedClass
.extern currentPtr
.extern changedSFX

.global NewSFXHax
NewSFXHax:
	lis r7, SoundRelatedClass@h
	ori r7, r7, SoundRelatedClass@l
	lwz r7, 0(r7)
	lwz r7, 0x61C(r7)
	lwz r7, -0x20(r7)
	lwz r7, 0(r7)
	lwz r7, 0(r7)

	lis r8, 0x78
	ori r8, r8, 0xEBE0
	#addi r7, r7, 0x78EBE0
	add r7, r7, r8

	cmpw r4, r7

	bne retNewSFXHax

	lis r7, currentPtr@h
	ori r7, r7, currentPtr@l
	lwz r4, 0(r7)

retNewSFXHax:
	lwz r0, 0x10(r4)
	b doneWithNewSFXHax


.global LoadAllSFXs
LoadAllSFXs:
	stwu r1, -0x20(r1)
	mflr r0
	stw r0, 0x24(r1)
	stw r31, 0x1C(r1)
	stw r30, 0x18(r1)
	stw r29, 0x14(r1)
	stw r28, 0x10(r1)

	bl _Z11loadAllSFXsv

	lwz r0, 0x24(r1)
	lwz r31, 0x1C(r1)
	lwz r30, 0x18(r1)
	lwz r29, 0x14(r1)
	lwz r28, 0x10(r1)
	mtlr r0
	addi r1, r1, 0x20

	mr r3, r29
	blr