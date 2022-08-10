#include <asm_setup.S>

.text
.align 4

.global WindColor
WindColor:
	lwz r3, 4(r23)
	rlwinm r3, r3, 24, 28, 31 # (this->settings >> 8) & 0xF
	cmpwi r3, 1
	beq doWhiteWind # We can add as many colors as we want
	cmpwi r3, 2
	beq doPurpleWind

	# doYellowWind:
	li r3, 0xFF # R
	li r4, 0xDC # G
	li r5, 0x78 # B

	b setWindColor

doWhiteWind:
	li r3, 0xFF # R
	li r4, 0xFF # G
	li r5, 0xFF # B
	b setWindColor

doPurpleWind:
	li r3, 0x6D # R
	li r4, 0x57 # G
	li r5, 0xD4 # B

setWindColor:
	stb r3, 0x5B4(r23)
	stb r4, 0x5B5(r23)
	stb r5, 0x5B6(r23)

	b doneWithWindColor


.global LavaParticlesColor
LavaParticlesColor:
	lwz r4, 4(r17)
	rlwinm r4, r4, 24, 28, 31 # (this->settings >> 8) & 0xF
	cmpwi r4, 1
	beq doGreenLavaParticles # We can add as many colors as we want
	cmpwi r4, 2
	beq doBlueLavaParticles # We can add as many colors as we want

	# doOrangeLavaParticles:
	li r4, 0xFF # R
	li r5, 0xFF # G
	li r6, 0x00 # B

	li r7, 0xFF # R
	li r8, 0x00 # G
	li r9, 0x00 # B

	b setLavaParticlesColor

doGreenLavaParticles:
	li r4, 0xAF # R
	li r5, 0xD3 # G
	li r6, 0x5F # B

	li r7, 0x18 # R
	li r8, 0x35 # G
	li r9, 0x0D # B
	b setLavaParticlesColor

doBlueLavaParticles:
	li r4, 0x00 # R
	li r5, 0xFF # G
	li r6, 0xFF # B

	li r7, 0x00 # R
	li r8, 0x00 # G
	li r9, 0xFF # B

setLavaParticlesColor:
	stb r4, 0x574(r17)
	stb r5, 0x575(r17)
	stb r6, 0x576(r17)

	stb r7, 0x578(r17)
	stb r8, 0x579(r17)
	stb r9, 0x57A(r17)

	li r4, 0xFF
	stb r4, 0x57B(r17) # Restore instruction

	b doneWithLavaParticlesColor


.global InvertedCoinRotation
InvertedCoinRotation:
	clrlslwi r0, r5, 24,10
	lis r5, 0
	ori r5, r5, 0xFFFF
	sub r0, r5, r0
	b doneWithInvertedCoinRotation