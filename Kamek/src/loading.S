.text
#include <asm_setup.S>

.extern ContinueFromLoadingCRSIN
.global aI_kinoko_3, aI_fireflower_2, aI_iceflower_0, aI_star_0, aI_propeller_0, aI_penguin, aI_hammer_0, aCometStar_0

.global LoadThisShit
LoadThisShit:
	lis r5, LoadListArray@h
	ori r5, r5, LoadListArray@l
	b ContinueFromLoadingCRSIN


.data
.global LoadListArray
LoadListArray: 
	.long aMario_0								# "Mario"
	.long aLuigi_0								# "Luigi"
	.long aKinopio_0							# "Kinopio"
	.long aYoshi_1								# "Yoshi"
	.long aP_rcha_2								# "P_rcha"
	.long aL_rcha_0								# "L_rcha"
	.long aK_rcha_0								# "K_rcha"
	.long aY_rcha_0								# "Y_rcha"
	.long aY_texgreen_0							# "Y_TexGreen"
	.long aY_texred_0							# "Y_TexRed"
	.long aY_texyellow_0						# "Y_TexYellow"
	.long aY_texblue_0							# "Y_TexBlue"
	.long aObj_coin_3							# "obj_coin"
	.long aBalloon_0							# "balloon"
	.long aI_kinoko_3							# "I_kinoko"
	.long aI_fireflower_2						# "I_fireflower"
	.long aI_iceflower_0						# "I_iceflower"
	.long aI_star_0								# "I_star"
	.long aI_propeller_0						# "I_propeller"
	.long aI_penguin							# "I_penguin"
	.long aI_yoshi_egg_0						# "I_yoshi_egg"
	.long aBlock_tsuta							# "block_tsuta"
	.long aTeresa_0								# "teresa"
	.long aJump_step							# "jump_step"
	.long aIce_4								# "ice"
	.long aIce_piece_0							# "ice_piece"
	.long aObj_dokan_6							# "obj_dokan"
	.long aObj_door_3							# "obj_door"
	.long aObj_kusa_0							# "obj_kusa"
	.long aObj_hana								# "obj_hana"
	.long aObj_hana_dai_0						# "obj_hana_daishizen"
	.long aBlock_jump_0							# "block_jump"
	.long aObj_chikuwa__0						# "obj_chikuwa_block"
	.long aLift_rakka_a_0						# "lift_rakka_ashiba"
	.long aMask_3								# "Mask"
	.long aI_hammer_0							# "I_hammer"
	.long aBros_0								# "bros"
	.long aCometStar_0							# "cometStar"
	.long aSilverstar_0							# "silverstar"
#	.long aOpeningPics_0						# "OpeningPics"
	

aMario_0:
	.string "Mario"

aLuigi_0:
	.string "Luigi"

aKinopio_0:
	.string "Kinopio"

aYoshi_1:
	.string "Yoshi"

aP_rcha_2:
	.string "P_rcha"

aL_rcha_0:
	.string "L_rcha"

aK_rcha_0:
	.string "K_rcha"

aY_rcha_0:
	.string "Y_rcha"

aY_texgreen_0:
	.string "Y_TexGreen"

aY_texred_0:
	.string "Y_TexRed"

aY_texyellow_0:
	.string "Y_TexYellow"

aY_texblue_0:
	.string "Y_TexBlue"

aObj_coin_3:
	.string "obj_coin"

aBalloon_0:
	.string "balloon"

aI_kinoko_3:
	.string "I_kinoko"

aI_fireflower_2:
	.string "I_fireflower"

aI_iceflower_0:
	.string "I_iceflower"

aI_star_0:
	.string "I_star"

aI_propeller_0:
	.string "I_propeller"

aI_penguin:
	.string "I_penguin"

aI_yoshi_egg_0:
	.string "I_yoshi_egg"

aBlock_tsuta:
	.string "block_tsuta"

aTeresa_0:
	.string "teresa"

aJump_step:
	.string "jump_step"

aIce_4:
	.string "ice"

aIce_piece_0:
	.string "ice_piece"

aObj_dokan_6:
	.string "obj_dokan"

aObj_door_3:
	.string "obj_door"

aObj_kusa_0:
	.string "obj_kusa"

aObj_hana:
	.string "obj_hana"

aObj_hana_dai_0:
	.string "obj_hana_daishizen"

aBlock_jump_0:
	.string "block_jump"

aObj_chikuwa__0:
	.string "obj_chikuwa_block"

aLift_rakka_a_0:
	.string "lift_rakka_ashiba"

aMask_3:
	.string "Mask"

aI_hammer_0:
	.string "I_hammer"

aBros_0:
	.string "bros"

aCometStar_0:
	.string "cometStar"
	
aSilverstar_0:
	.string "silverstar"
	
#aOpeningPics_0:
#	.string "OpeningPics"