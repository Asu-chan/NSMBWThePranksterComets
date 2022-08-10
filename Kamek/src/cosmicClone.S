.text
#include <asm_setup.S>

.extern doneWithtriggerCosmicKillFlag

.global triggerCosmicKillFlag
triggerCosmicKillFlag:
	li r0, 1
	lis r3, cosmicKillFlag@h
	ori r3, r3, cosmicKillFlag@l
	stw r0, 0(r3)

	addi r11, sp, 64
	b doneWithtriggerCosmicKillFlag

.data

.global cosmicKillFlag
cosmicKillFlag:
	.long 0

.global cosmicBeginFlag
cosmicBeginFlag:
	.long 0