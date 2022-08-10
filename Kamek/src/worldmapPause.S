#include <asm_setup.S>

.text
.align 4

.global ChangeGroupNames
ChangeGroupNames:
	lis r4, CSMGroupNames@h
	ori r4, r4, CSMGroupNames@l
	lis r5, CSMGroupIDs@h
	ori r5, r5, CSMGroupIDs@l
	li r6, 23
	b doneWithChangeGroupNames


.global ChangePicturePaneNames
ChangePicturePaneNames:
	lis r4, CSMPicturePaneNames@h
	ori r4, r4, CSMPicturePaneNames@l
	addi r5, r30, 0x278
	li r6, 7
	b doneWithChangePicturePaneNames


.global AddSettingsBMG
AddSettingsBMG:
	bl _Z6GetBMGv
	mr r31, r3

	addi r3, r30, 0x70
	lis r4, T_corseSelect_00@h
	ori r4, r4, T_corseSelect_00@l
	bl _Z29EmbeddedLayout_FindPaneByNameP6LayoutPKc

	mr r4, r31
	li r5, 0x3EA
	li r6, 1
	li r7, 0
	bl TextBoxSetBmgString

	addi r3, r30, 0x70
	lis r4, T_corseSelectS00@h
	ori r4, r4, T_corseSelectS00@l
	bl _Z29EmbeddedLayout_FindPaneByNameP6LayoutPKc

	mr r4, r31
	li r5, 0x3EA
	li r6, 1
	li r7, 0
	bl TextBoxSetBmgString

	li r3, 1
	b doneWithAddSettingsBMG


.global ChangeSelectCursorStuff
ChangeSelectCursorStuff:
	lis r6, SelectCursorStuff@h
	ori r6, r6, SelectCursorStuff@l
	b doneWithChangeSelectCursorStuff


.global ChangeMenuResults
ChangeMenuResults:
	cmpwi r0, 0
	beq doSettingsStuff
	cmpwi r0, 1
	b doneWithChangeMenuResults

doSettingsStuff:
	lis r3, SoundRelatedClass@h
	ori r3, r3, SoundRelatedClass@l
	lwz r3, 0(r3)
	li r4, 0x7F
	li r5, 1
	bl MapSoundPlayer

	lwz r5, 0x570(r30) # Settings Actor Pointer
	li r0, 1
	stb r0, 0x249(r5) # Settings->isCurrentlyActive

	addi r3, r30, 0x70
	lis r4, _ZN22dCourseSelectManager_c20StateID_SettingsWaitE@h
	ori r4, r4, _ZN22dCourseSelectManager_c20StateID_SettingsWaitE@l
	lwz r12, 0x70(r30)
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl
	b doneWithChangeMenuResults2


.global SpawnSettingsActor
SpawnSettingsActor:
	# stw r3, 0x538(r31) # Restore Instruction - Not needed anymore since the letter actor was removed

	li r3, 663 # WM_TREASURESHIP = Settings Menu
	mr r4, r29
	li r5, 0
	li r6, 0
	bl _Z20CreateParentedObjectsPvic
	stw r3, 0x570(r31)

	li r3, 756 # WM_STARSIGN
	mr r4, r29
	li r5, 0
	li r6, 0
	bl _Z20CreateParentedObjectsPvic
	stw r3, 0x574(r31)

	b doneWithSpawnSettingsActor


.data
.align 4

.global CSMGroupIDs
CSMGroupIDs:
	.long 0, 1
	.long 2, 2, 2, 2, 2
	.long 3, 3, 3, 3, 3
	.long 4, 4, 4, 4, 4
	.long 5, 5, 5, 5, 5
	.long 6

.global CSMGroupNames
CSMGroupNames:
	.long CSMWindow, CSMWindow
	.long CSMButton0, CSMButton1, CSMButton2, CSMButton3, CSMButton4
	.long CSMButton0, CSMButton1, CSMButton2, CSMButton3, CSMButton4
	.long CSMButton0, CSMButton1, CSMButton2, CSMButton3, CSMButton4
	.long CSMButton0, CSMButton1, CSMButton2, CSMButton3, CSMButton4
	.long CSMWindow

.global CSMPicturePaneNames
CSMPicturePaneNames:
	.long P_SBBase_00
	.long P_SBBase_01
	.long P_SBBase_02
	.long P_SBBase_03
	.long P_SBBase_04
	.long P_back
	.long P_backWhite

.global SelectCursorStuff
SelectCursorStuff:
	.long 0, 1, 2, 3, 4

.align 4
.global CSMButton0
CSMButton0: .string  "B00_Button"

.global P_SBBase_00
P_SBBase_00: .string  "P_SBBase_00"

.global T_corseSelect_00
T_corseSelect_00: .string  "T_corseSelect_00"

.global T_corseSelectS00
T_corseSelectS00: .string  "T_corseSelectS00"

.align 4