.text
#include <asm_setup.S>

.extern doneWithLoadCometArc
.extern doneWithFreeCometArc

.global LoadCometArc
LoadCometArc:
	lis r5, WorldmapObjectLoadTable@h
	ori r5, r5, WorldmapObjectLoadTable@l
	add r5, r5, r31
	b doneWithLoadCometArc

.global FreeCometArc
FreeCometArc:
	lis r4, WorldmapObjectLoadTable@h
	ori r4, r4, WorldmapObjectLoadTable@l
	add r4, r4, r26
	b doneWithFreeCometArc


.data
.global WorldmapObjectLoadTable
WorldmapObjectLoadTable:
	.long aTeresa_3									# "teresa"
	.long aI_kinoko_5								# "I_kinoko"
	.long aI_fireflower_3							# "I_fireflower"
	.long aI_propeller_1							# "I_propeller"
	.long aI_iceflower_1							# "I_iceflower"
	.long aI_penguin_1								# "I_penguin"
	.long aI_star_1									# "I_star"
	.long aCometStar_1								# "cometStar"

.global aTeresa_3
aTeresa_3:
	.string "teresa"

.global aI_kinoko_5
aI_kinoko_5:
	.string "I_kinoko"
	
.global aI_fireflower_3
aI_fireflower_3:
	.string "I_fireflower"
	
.global aI_propeller_1
aI_propeller_1:
	.string "I_propeller"
	
.global aI_iceflower_1
aI_iceflower_1:
	.string "I_iceflower"
	
.global aI_penguin_1
aI_penguin_1:
	.string "I_penguin"
	
.global aI_star_1
aI_star_1:
	.string "I_star"
	
.global aCometStar_1
aCometStar_1:
	.string "cometStar"