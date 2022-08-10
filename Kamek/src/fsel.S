.text
#include <asm_setup.S>

.global SetBonusLevelFlag
SetBonusLevelFlag:
	ble SetBonusLevelFlagReturn
	li r0, 1
	lis r4, BonusLevelFlag@h
	ori r4, r4, BonusLevelFlag@l
	stw r0, 0(r4)

SetBonusLevelFlagReturn:
	b doneWithSetBonusLevelFlag


.global CheckForBonusLevelFlag
CheckForBonusLevelFlag:
	andi. r0, r0, 0
	lis r3, BonusLevelFlag@h
	ori r3, r3, BonusLevelFlag@l
	lwz r3, 0(r3)
	cmpwi r3, 0
	beq CheckForBonusLevelFlagReturn

	li r3, 341
	b doneWithCheckForBonusLevelFlag2

CheckForBonusLevelFlagReturn:
	lbz r0, 2(r31) # Restore original instruction
	b doneWithCheckForBonusLevelFlag
	


.data

.global bonusGroup
bonusGroup: .string "F02_bonusLevels"

.global bonusText
bonusText: .string "T_multi_02"

.global bonusTextS
bonusTextS: .string "T_multiS_02"

.global bonusWindow
bonusWindow: .string "W_multiButton_01"

.global BonusLevelFlag
BonusLevelFlag: .long 0