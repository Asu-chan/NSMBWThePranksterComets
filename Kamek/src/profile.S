#include <asm_setup.S>
.text
.align 4

#ifdef REGION_TOURNAMENT
.set PROFCNT, 752
#else
.set PROFCNT, 750
#endif

.set SPRITECNT, 483



# ASM Patches to load from the custom lists below

# Spritedata list hooks
.global ReplaceSpriteDataList1
ReplaceSpriteDataList1: # 0x80068440
	# Check if original sprite (using cr7 because cr0 is in use)
	cmpwi cr7, r0, SPRITECNT*0x28
	blt+ cr7, notCustomSDL1

	# Subtract using sub rather than subi because r0
	li r12, SPRITECNT*0x28
	sub r0, r0, r12

	# Override table address
	lis r12, customSprites@h
	ori r12, r12, customSprites@l
	b endSDL1

	# Move r30 to r12 to preserve it
	notCustomSDL1:
	mr r12, r30

	# Modified original instruction
	endSDL1:
	add r28, r12, r0
	blr

.global ReplaceSpriteDataList2
ReplaceSpriteDataList2: # 0x80068E18
	# Check if original sprite
	cmpwi r0, SPRITECNT*0x28
	blt+ notCustomSDL2

	# Subtract using sub rather than subi because r0
	li r12, SPRITECNT*0x28
	sub r0, r0, r12

	# Override table address
	lis r9, customSprites@h
	ori r9, r9, customSprites@l

	# Original instruction
	notCustomSDL2:
	lhzx r0, r9, r0
	blr


.global ReplaceSpriteDataList3
ReplaceSpriteDataList3: # 0x80068F50
	# Check if original sprite
	cmpwi r0, SPRITECNT*0x28;
	blt+ notCustomSDL3

	# Subtract using sub rather than subi because r0
	li r12, SPRITECNT*0x28
	sub r0, r0, r12

	# Override table address
	lis r3, customSprites@h
	ori r3, r3, customSprites@l

	# Original instruction
	notCustomSDL3:
	lhzx r3, r3, r0
	blr


.global ReplaceSpriteDataList4
ReplaceSpriteDataList4: # 0x807FC8D8
	# Check if original sprite
	cmpwi r0, SPRITECNT*0x28;
	blt+ notCustomSDL4

	# Subtract using sub rather than subi because r0
	li r12, SPRITECNT*0x28
	sub r0, r0, r12

	# Override table address
	lis r7, customSprites@h
	ori r7, r7, customSprites@l

	# Original instruction + skipped instruction
	notCustomSDL4:
	lhzx r31, r7, r0
	add r30, r7, r0

	# Return slightly later
	mflr r12
	addi r12, r12, 4
	mtlr r12
	blr


.global ReplaceSpriteDataList5
ReplaceSpriteDataList5: # 0x8006894C
	# Check if original sprite (using cr7 because cr0 is in use)
	cmpwi cr7, r4, SPRITECNT*0x28;
	blt+ cr7, notCustomSDL5

	# Subtract
	subi r4, r4, SPRITECNT*0x28

	# Override table address
	lis r0, customSprites@h
	ori r0, r0, customSprites@l

	# Original instruction
	notCustomSDL5:
	add r31, r0, r4
	blr

# Profile list hooks
.global ProfileListHook1
ProfileListHook1: # 0x8006C7C8
	# Check if original sprite
	cmpwi r0, PROFCNT*4;
	blt+ notCustomPLH1

	# Subtract
	li r12, PROFCNT*4
	sub r0, r0, r12

	# Override table address
	lis r4, customProfiles@h
	ori r4, r4, customProfiles@l

	# Original instruction
	notCustomPLH1:
	lwzx r4, r4, r0
	blr


.global ProfileListHook2
ProfileListHook2: # 0x80161CF4
	# Check if original sprite
	cmpwi r0, PROFCNT*4;
	blt+ notCustomPLH2

	# Subtract
	li r12, PROFCNT*4
	sub r0, r0, r12

	# Override table address
	lis r3, customProfiles@h
	ori r3, r3, customProfiles@l

	# Original instruction
	notCustomPLH2:
	lwzx r3, r3, r0
	blr


.global ProfileListHook3
ProfileListHook3: # 0x80162BC8
	# Check if original sprite
	cmpwi r31, PROFCNT*4;
	blt+ notCustomPLH3

	# Subtract using r12 as r31 needs to be preserved for the next hook
	subi r12, r31, PROFCNT*4

	# Override table address
	lis r7, customProfiles@h
	ori r7, r7, customProfiles@l
	b endPLH3

	# Move index to r12 as r31 needs to be preserved for the next hook
	notCustomPLH3:
	mr r12, r31

	# Modified original instruction
	endPLH3:
	lwzx r0, r7, r12
	blr


.global ProfileListHook4
ProfileListHook4: # 0x80162BE4
	# Check if original sprite
	cmpwi r31, PROFCNT*4;
	blt+ notCustomPLH4

	# Subtract
	subi r31, r31, PROFCNT*4

	# Override table address
	lis r3, customProfiles@h
	ori r3, r3, customProfiles@l

	# Original instruction
	notCustomPLH4:
	lwzx r3, r3, r31
	blr


# File list hook
.global FileListHook
FileListHook: # 0x8091FD3C
	# Check if original sprite
	cmpwi r0, SPRITECNT*4;
	blt+ notCustomFLH

	# Subtract using sub rather than subi because r0
	li r12, SPRITECNT*4
	sub r0, r0, r12

	# Override table address
	lis r12, customSpriteFiles@h
	ori r12, r12, customSpriteFiles@l
	b endFLH

	# Move r25 to r12 to preserve it
	notCustomFLH:
	mr r12, r25

	# Modified original instruction
	endFLH:
	lwzx r21, r12, r0
	blr
