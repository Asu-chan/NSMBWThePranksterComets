#include <asm_setup.S>

.text
.extern doneWithPreGameBRLANNames
.extern doneWithPreGameGroups
.extern doneWithPreGameReplaceStateStruct
.extern doneWithPreGameComeToNewState

.extern PreGameState0
.extern PreGameState1
.extern PreGameState2
.extern PreGameState3
.extern PreGameState4
.extern PreGameState5
.extern PreGameState6
.extern PreGameState7

.extern BufferToCheckIfPlaying
.extern MapSoundPlayer
.extern StopSoundBasic
.extern _restgpr_27
.extern _Z6doShitv

.extern _Z35EmbeddedLayout_CheckIfAnimationIsOnP6Layouti
.extern _Z32EmbeddedLayout_EnableNonLoopAnimP6Layoutib
.extern _Z38EmbeddedLayout_ResetAnimToInitialStateP6Layoutib
.extern doPreGameCometAnim

.global PreGameBRLANNames
PreGameBRLANNames:
	lis r4, BRLANNames@h
	ori r4, r4, BRLANNames@l
	li r5, 9
	b doneWithPreGameBRLANNames


.global PreGameGroups
PreGameGroups:
	lis r4, GroupNames@h
	ori r4, r4, GroupNames@l
	li r6, 0x10
	lis r5, GroupIDs@h
	ori r5, r5, GroupIDs@l
	b doneWithPreGameGroups


.global PreGameReplaceStateStruct
PreGameReplaceStateStruct:
	lis r4, PreGameStateStruct@h
	ori r4, r4, PreGameStateStruct@l
	b doneWithPreGameReplaceStateStruct

.global PreGameComeToNewState
PreGameComeToNewState:
	lis r3, doPreGameCometAnim@h
	ori r3, r3, doPreGameCometAnim@l
	lbz r3, 0(r3)
	cmpwi r3, 0
	beq dontDoPreGameComeToNewState
	
	lis r3, BufferToCheckIfPlaying@ha
	lwz r3, BufferToCheckIfPlaying@l(r3)
	li r4, 2000 # STRM_BGM_SABAKU, replaced with the comet sound
	li r5, 1
	bl MapSoundPlayer

	mr r3, r31
	li r4, 0xF
	li r5, 0
	bl _Z38EmbeddedLayout_ResetAnimToInitialStateP6Layoutib

	mr r3, r31
	li r4, 0xF
	li r5, 0
	bl _Z32EmbeddedLayout_EnableNonLoopAnimP6Layoutib
	li r0, 8

	b doneWithPreGameComeToNewState
dontDoPreGameComeToNewState:
	li r0, 3
	b doneWithPreGameComeToNewState


.global PreGameState8
PreGameState8:
	stwu r1, -0x10(r1)
	mflr r0
	li r4, -1
	stw r0, 0x14(r1)
	stw r31, 0xC(r1)

	mr r31, r3
	bl _Z35EmbeddedLayout_CheckIfAnimationIsOnP6Layouti
	cmpwi r3, 0
	bne return
	li r0, 3
	stw r0, 0x2E4(r31)
	
return:
	lwz r0, 0x14(r1)
	lwz r31, 0xC(r1)
	mtlr r0
	addi r1, r1, 16
	blr


.global PreGameLoadFile
PreGameLoadFile:
	mr r16, r3

	lwz r4, 0x2E2(r28)
	cmpwi r4, 0
	beq dontPlaySFX

	#lis r3, BufferToCheckIfPlaying@ha
	#lwz r3, BufferToCheckIfPlaying@l(r3)
	#li r4, 1284 # STRM_BGM_SABAKU, replaced with the comet sound
	#li r5, 1
	#bl MapSoundPlayer

dontPlaySFX:
	mr r3, r16
	addi r11, r1, 32
	bl _restgpr_27
	lwz r0, 0x24(r1)
	mtlr r0
	addi r1, r1, 32
	blr


.data
.global T_x_00
T_x_00: .string "T_x_00"
.global P_bat_00
P_bat_00: .string "P_bat_00"

.global BRLANNames
BRLANNames:
	.long aPregame_19_int					# "preGame_19_inTitle.brlan"
	.long aPregame_19_ino					# "preGame_19_inOtasuke.brlan"
	.long aPregame_19_loo					# "preGame_19_loopOtasuke.brlan"
	.long aPregame_19_inw					# "preGame_19_inWindow.brlan"
	.long aPregame_19_inb					# "preGame_19_inBattery.brlan"
	.long aPregame_19_wei					# "preGame_19_weitWindow.brlan"
	.long aPregame_19_out					# "preGame_19_outWindow.brlan"
	.long aPregame_19_sli					# "preGame_19_slide_Title.brlan"
	.long aPregame_19_Com					# "preGame_19_Comet.brlan"

.global GroupNames
GroupNames:
	.long aC00_title_0						# "C00_title"
	.long aD00_otasuke						# "D00_otasuke"
	.long aD00_otasuke						# "D00_otasuke"
	.long aA00_battery_0					# "A00_battery"
	.long aB00_playerin_0					# "B00_PlayerInfo"
	.long aB01_playerin_0					# "B01_PlayerInfo"
	.long aB02_playerin_0					# "B02_PlayerInfo"
	.long aB03_playerin_0					# "B03_PlayerInfo"
	.long aA00_battery_0					# "A00_battery"
	.long aB00_playerin_0					# "B00_PlayerInfo"
	.long aB01_playerin_0					# "B01_PlayerInfo"
	.long aB02_playerin_0					# "B02_PlayerInfo"
	.long aB03_playerin_0					# "B03_PlayerInfo"
	.long aA00_battery_0					# "A00_battery"
	.long aC01_title						# "C01_title"
	.long aC02_comet						# "C02_comet"

.global GroupIDs
GroupIDs:
	.long 0, 1, 2, 3
	.long 4, 4, 4, 4
	.long 5, 5, 5, 5
	.long 5, 6, 7, 8
	.long 0

.global PreGameStateStruct
PreGameStateStruct:
	.long 0, -1, PreGameState0
	.long 0, -1, PreGameState1
	.long 0, -1, PreGameState2
	.long 0, -1, PreGameState3
	.long 0, -1, PreGameState4
	.long 0, -1, PreGameState5
	.long 0, -1, PreGameState6
	.long 0, -1, PreGameState7
	.long 0, -1, PreGameState8

aPregame_19_int:.string "preGame_19_inTitle.brlan"
aPregame_19_ino:.string "preGame_19_inOtasuke.brlan"
aPregame_19_loo:.string "preGame_19_loopOtasuke.brlan"
aPregame_19_inw:.string "preGame_19_inWindow.brlan"
aPregame_19_inb:.string "preGame_19_inBattery.brlan"
aPregame_19_wei:.string "preGame_19_weitWindow.brlan"
aPregame_19_out:.string "preGame_19_outWindow.brlan"
aPregame_19_sli:.string "preGame_19_slide_Title.brlan"
aPregame_19_Com:.string "preGame_19_Comet.brlan"

aC00_title_0:.string "C00_title"
aD00_otasuke:.string "D00_otasuke"
aA00_battery_0:.string "A00_battery"
aB00_playerin_0:.string "B00_PlayerInfo"
aB01_playerin_0:.string "B01_PlayerInfo"
aB02_playerin_0:.string "B02_PlayerInfo"
aB03_playerin_0:.string "B03_PlayerInfo"
aC01_title:.string "C01_title"
aC02_comet:.string "C02_comet"