#include <game.h>
#include <common.h>
#include <profile.h>
#include <profileid.h>

// Arrays of data used by the game
extern "C" SpriteData sprites[(SpriteId::AC_BOSS_KOOPA_BG_EFFECT+1)];
SpriteData customSprites[SpriteId::Num - (SpriteId::AC_BOSS_KOOPA_BG_EFFECT)];

extern "C" Profile* profiles[(ProfileId::LASTACTOR+1)];
Profile* customProfiles[ProfileId::Num - (ProfileId::LASTACTOR)];

extern "C" const char** spriteFiles[(SpriteId::AC_BOSS_KOOPA_BG_EFFECT+1)];
const char** customSpriteFiles[SpriteId::Num - (SpriteId::AC_BOSS_KOOPA_BG_EFFECT)];

extern "C" const char* profileNames[(ProfileId::LASTACTOR+1)];
const char* customProfileNames[ProfileId::Num - (ProfileId::LASTACTOR)];

// Custom Profile ctor by AboodXD, edited by myself
Profile::Profile(buildFunc func, u32 spriteId, const SpriteData* spriteData, u16 executeOrderProfileId, u16 drawOrderProfileId, u32 lookAtSettings, const char* name, const char** files) {
    u32 profile;

    // Store variables
    this->func = func;
    this->executeOrderProfileId = executeOrderProfileId;
    this->drawOrderProfileId = drawOrderProfileId;
    this->lookAtSettings = lookAtSettings;

    // If spritedata is not null, store this as a sprite
    if (spriteData) {
        profile = spriteData->profileId;
        if (spriteId < (SpriteId::AC_BOSS_KOOPA_BG_EFFECT+1)) {
            sprites[spriteId] = *spriteData;
            spriteFiles[spriteId] = files;
        } else {
            customSprites[spriteId - (SpriteId::AC_BOSS_KOOPA_BG_EFFECT+1)] = *spriteData;
            customSpriteFiles[spriteId - (SpriteId::AC_BOSS_KOOPA_BG_EFFECT+1)] = files;
        }

    // Else use it as a profile id
    } else
        profile = spriteId;

    // Store profile data
    if (profile < (ProfileId::LASTACTOR+1)) {
        profiles[profile] = this;
        profileNames[profile] = name;
    } else {
        customProfiles[profile - (ProfileId::LASTACTOR+1)] = this;
        customProfileNames[profile - (ProfileId::LASTACTOR+1)] = name;
    }
}

// Profile names hook
const char* ProfileNamesHook(u16 profileId, const char** array) { // 0x801018CC
    if (profileId < (ProfileId::LASTACTOR+1))
        return array[profileId];
    return customProfileNames[profileId - (ProfileId::LASTACTOR+1)];
}
