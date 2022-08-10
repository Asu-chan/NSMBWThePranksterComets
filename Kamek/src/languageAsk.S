.text
#include <asm_setup.S>
.align 4

.extern doneWithAlternateCRSINLYTSetup
.extern doneWithAlternateCRSINLYTSetup2
.extern doneWithAlternateCRSINLYTExecute
.extern doneWithAlternateCRSINLYTExecute2
.extern doneWithAlternateCRSINLYTDraw
.extern doneWithAlternateCRSINLYTDraw2
.extern doneWithAlternateCRSINLYTDelete
.extern doneWithAlternateCRSINLYTDelete2
.extern doneWithSetAlternateCRSINLYTByte
.extern doneWithNoCRSINWipe
.extern doneWithNoCRSINWipe2

.extern GetGameLanguage

.extern _ZN18LanguageAskHandler5setupEv
.extern _ZN18LanguageAskHandler7executeEv
.extern _ZN18LanguageAskHandler4drawEv
.extern _ZN18LanguageAskHandler4freeEv

.global AlternateCRSINLYTSetup
AlternateCRSINLYTSetup:
	stw r0, 0x14(sp)

	lis r4, IsAlternateCRSINEnabled@h
	ori r4, r4, IsAlternateCRSINEnabled@l
	lbz r4, 0(r4)

	cmpwi r4, 0
	beq _doneWithAlternateCRSINLYTSetup

	bl _ZN18LanguageAskHandler5setupEv
	b doneWithAlternateCRSINLYTSetup2
_doneWithAlternateCRSINLYTSetup:
	b doneWithAlternateCRSINLYTSetup


.global AlternateCRSINLYTExecute
AlternateCRSINLYTExecute:
	addi r3, r31, 0xB0

	lis r4, IsAlternateCRSINEnabled@h
	ori r4, r4, IsAlternateCRSINEnabled@l
	lbz r4, 0(r4)

	cmpwi r4, 0
	beq _doneWithAlternateCRSINLYTExecute

	bl _ZN18LanguageAskHandler7executeEv
	b doneWithAlternateCRSINLYTExecute2
_doneWithAlternateCRSINLYTExecute:
	b doneWithAlternateCRSINLYTExecute


.global AlternateCRSINLYTDraw
AlternateCRSINLYTDraw:
	stw r0, 0x14(sp)

	lis r4, IsAlternateCRSINEnabled@h
	ori r4, r4, IsAlternateCRSINEnabled@l
	lbz r4, 0(r4)

	cmpwi r4, 0
	beq _doneWithAlternateCRSINLYTDraw

	bl _ZN18LanguageAskHandler4drawEv
	b doneWithAlternateCRSINLYTDraw2
_doneWithAlternateCRSINLYTDraw:
	b doneWithAlternateCRSINLYTDraw


.global AlternateCRSINLYTDelete
AlternateCRSINLYTDelete:
	addi r3, r3, 0xB0

	lis r4, IsAlternateCRSINEnabled@h
	ori r4, r4, IsAlternateCRSINEnabled@l
	lbz r5, 0(r4)

	cmpwi r5, 0
	beq _doneWithAlternateCRSINLYTDelete

	bl _ZN18LanguageAskHandler4freeEv
	li r5, 0
	stb r5, 0(r4)

	b doneWithAlternateCRSINLYTDelete2
_doneWithAlternateCRSINLYTDelete:
	b doneWithAlternateCRSINLYTDelete

.global SetAlternateCRSINLYTByte
SetAlternateCRSINLYTByte:
	bl GetGameLanguage
	
	lis r4, IsAlternateCRSINEnabled@h
	ori r4, r4, IsAlternateCRSINEnabled@l

	lbz r5, 1(r4)
	cmpwi r5, 1
	beq returnFromSetAlternateCRSINLYTByte

	cmpwi r3, 1
	ble returnFromSetAlternateCRSINLYTByte

	li r5, 1
	stb r5, 0(r4)

returnFromSetAlternateCRSINLYTByte:
	mr r4, r31
	b doneWithSetAlternateCRSINLYTByte


.global PatchNoPreGameShit
PatchNoPreGameShit:
	lis r4, IsAlternateCRSINEnabled@h
	ori r4, r4, IsAlternateCRSINEnabled@l
	lbz r4, 1(r4)
	cmpwi r4, 0
	beq NoPreGame

	li r5, 1
	b doneWithPatchNoPreGameShit
NoPreGame:
	li r5, 0
	b doneWithPatchNoPreGameShit


.global NoCRSINWipe
NoCRSINWipe:
	lis r3, IsAlternateCRSINEnabled@h
	ori r3, r3, IsAlternateCRSINEnabled@l
	lbz r3, 0(r3)
	cmpwi r3, 1
	beq noWipe

	li r3, 0
	b doneWithNoCRSINWipe
noWipe:
	b doneWithNoCRSINWipe2


.global _Z17callLanguageStateP18LanguageAskHandlerj
_Z17callLanguageStateP18LanguageAskHandlerj:
	stwu sp, -0x10(sp)
	mflr r0
	stw r0, 0x14(sp)
	stw r31, 0xC(sp)

	lis r5, languageStates@h
	ori r5, r5, languageStates@l
	mulli r4, r4, 0xC
	add r12, r5, r4
	bl __ptmf_scall

	lwz r0, 0x14(sp)
	lwz r31, 0xC(sp)
	mtlr r0
	addi sp, sp, 16
	blr
	

.global BlockGameLanguage
BlockGameLanguage:
	lis r4, IsAlternateCRSINEnabled@h
	ori r4, r4, IsAlternateCRSINEnabled@l
	lbz r4, 1(r4)
	cmpwi r4, 0
	beq returnFromBlockGameLanguage

	li r3, 1

returnFromBlockGameLanguage:
	lwz r0, 0x14(sp)
	b doneWithBlockGameLanguage


.data
.global IsAlternateCRSINEnabled
IsAlternateCRSINEnabled:
	.byte 0
	.byte 0

.global languageStates
languageStates:
	.long 0, -1, _ZN18LanguageAskHandler27state0_WaitForEndOfAnimOpenEv
	.long 0, -1, _ZN18LanguageAskHandler29state1_WaitForEndOfButtonOpenEv
	.long 0, -1, _ZN18LanguageAskHandler19state2_WaitForPressEv
	.long 0, -1, _ZN18LanguageAskHandler30state3_WaitForEndOfWindowCloseEv