#include "cosmicClone.h"
#include "gameDisplay.h"
#include "fileload.h"
#include "boss.h"


extern "C" bool SpawnEffect(const char*, int, Vec*, S16Vec*, Vec*);
extern u32 cosmicKillFlag;
extern u32 cosmicBeginFlag;

const char* CMarcNameList [] = {
    "cosmicmario",
    NULL
};

class daCosmicMario_c : public dEn_c {
    int onCreate();
    int onExecute();
    int onDelete();
    int onDraw();

    mHeapAllocator_c allocator;
    m3d::mdl_c bodyModel;

    nw4r::g3d::ResFile resFileAnim;
    m3d::anmChr_c animationChr;
    m3d::anmChr_c subAnimationChr;
    m3d::anmChrPart_c chrPart;

    mEf::es2 dust;

    FileHandle fileHandle;

    u32 frameCount;
    CosmicBuffer *cosmicBuffer;

    s32 timer;
    s32 timer2;
    s32 scaleTimer;
    u32 previousAnim;
    u32 previousAnim2;
    bool hasStarted;
    bool hasSpawned;
    bool doesBeginSound;
    bool doesEndSound;
    bool hasBeenScaled;
    bool wereDone;

    float gravityConstant;

    u32 delay;

    dAcPy_c* player;
    dPlayerModelBase_c* model;

    static daCosmicMario_c *build();

    void updateModelMatrices();
    void playerCollision(ActivePhysics *apThis, ActivePhysics *apOther);
    void spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther);

    void bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate);
    void bindSubAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate);

    void doCosmicScale();

    bool collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther);
    bool collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther);
    bool collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther);
    bool collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther);

    bool collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther);
    bool collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther);
    bool collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther);
    bool collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther);
    bool collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther);
    bool collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther);

    USING_STATES(daCosmicMario_c);
    DECLARE_STATE(Intro);
    DECLARE_STATE(Run);
};

CREATE_STATE(daCosmicMario_c, Intro);
CREATE_STATE(daCosmicMario_c, Run);

void daCosmicMario_c::playerCollision(ActivePhysics *apThis, ActivePhysics *apOther) {
    this->_vf220(apOther->owner);
}


void daCosmicMario_c::spriteCollision(ActivePhysics *apThis, ActivePhysics *apOther) {

}

bool daCosmicMario_c::collisionCat7_GroundPound(ActivePhysics *apThis, ActivePhysics *apOther) {
    playerCollision(apThis, apOther);
    return true;
}
bool daCosmicMario_c::collisionCat7_GroundPoundYoshi(ActivePhysics *apThis, ActivePhysics *apOther) {
    playerCollision(apThis, apOther);
    return true;
}
bool daCosmicMario_c::collisionCatD_Drill(ActivePhysics *apThis, ActivePhysics *apOther) {
    playerCollision(apThis, apOther);
    return true;
}
bool daCosmicMario_c::collisionCatA_PenguinMario(ActivePhysics *apThis, ActivePhysics *apOther) {
    playerCollision(apThis, apOther);
    return true;
}

bool daCosmicMario_c::collisionCat1_Fireball_E_Explosion(ActivePhysics *apThis, ActivePhysics *apOther) {
    return true;
}
bool daCosmicMario_c::collisionCat2_IceBall_15_YoshiIce(ActivePhysics *apThis, ActivePhysics *apOther) {
    return true;
}
bool daCosmicMario_c::collisionCat9_RollingObject(ActivePhysics *apThis, ActivePhysics *apOther) {
    return true;
}
bool daCosmicMario_c::collisionCat13_Hammer(ActivePhysics *apThis, ActivePhysics *apOther) {
    return true;
}
bool daCosmicMario_c::collisionCat14_YoshiFire(ActivePhysics *apThis, ActivePhysics *apOther) {
    return true;
}

bool daCosmicMario_c::collisionCat3_StarPower(ActivePhysics *apThis, ActivePhysics *apOther) {
    return true;
}



daCosmicMario_c *daCosmicMario_c::build() {
    void *buffer = AllocFromGameHeap1(sizeof(daCosmicMario_c));
    return new(buffer) daCosmicMario_c;
}


void daCosmicMario_c::bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate) {
    nw4r::g3d::ResAnmChr anmChr = this->resFileAnim.GetResAnmChr(name);
    this->animationChr.bind(&this->bodyModel, anmChr, unk);
    this->bodyModel.bindAnim(&this->animationChr, unk2);
    this->animationChr.setUpdateRate(rate);
}


void daCosmicMario_c::bindSubAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate) {
    nw4r::g3d::ResAnmChr anmChr = this->resFileAnim.GetResAnmChr(name);
    this->subAnimationChr.bind(&this->bodyModel, anmChr, unk);
    this->bodyModel.bindAnim(&this->subAnimationChr, unk2);
    this->subAnimationChr.setUpdateRate(rate);
}

extern char CurrentLevel;
extern char CurrentWorld;

int daCosmicMario_c::onCreate() {

    allocator.link(-1, GameHeaps[0], 0, 0x20);

    nw4r::g3d::ResFile rf(getResource("cosmicmario", "g3d/cosmicmario.brres"));
    nw4r::g3d::ResMdl mdl = rf.GetResMdl("CosmicMario");
    bodyModel.setup(mdl, &allocator, 0x224, 1, 0);
    SetupTextures_Player(&bodyModel, 0);


    this->resFileAnim.data = getResource("P_rcha", "g3d/model.brres");
    nw4r::g3d::ResAnmChr anmChr = this->resFileAnim.GetResAnmChr(PlayerAnimStates[0].regularAnim);
    this->animationChr.setup(mdl, anmChr, &this->allocator, 0);
    this->subAnimationChr.setup(mdl, anmChr, &this->allocator, 0);

    this->chrPart.setup(mdl, 2, &this->allocator, 0);
    this->chrPart.attachChr(0, this->animationChr, 1.0);
    this->chrPart.attachChr(1, this->subAnimationChr, 1.0);

    allocator.unlink();

    this->scale = (Vec){0.0, 0.0, 0.0};

    this->pos.x -= 120.0;
    this->pos.z = 3300.0;

    this->previousAnim = -1;
    this->previousAnim2 = -1;

    this->delay = this->settings & 0xFF;
    this->doesEndSound = (this->settings >> 8 & 0xF) & 1;
    this->doesBeginSound = !cosmicBeginFlag;
    cosmicBeginFlag = true;

    this->timer = this->delay;
    this->deleteForever = 1;
    this->base_type = 2;
    this->stageActorType = 3;

    this->gravityConstant = 0.1f;


    char raceFilename[80];
    snprintf(raceFilename, 79, "/Races/%02d-%02d.race", CurrentWorld+1, CurrentLevel+1);

    OSReport("Opening File %s\n", raceFilename);

    cosmicBuffer = (CosmicBuffer*)(u32*)LoadFile(&fileHandle, raceFilename);
    frameCount = fileHandle.length / 0x24;

    player = dAcPy_c::findByID(0);
    model = (dPlayerModelBase_c*)player->modelClass;

    bindAnimChr_and_setUpdateRate(PlayerAnimStates[0].regularAnim, 1, 0.0, 1.0);
    bindSubAnimChr_and_setUpdateRate(PlayerAnimStates[0].regularAnim, 1, 0.0, 1.0);

    doStateChange(&StateID_Intro);

    this->onExecute();
    return true;
}


int daCosmicMario_c::onDelete() {
    FreeFile(&fileHandle);
    return true;
}

int daCosmicMario_c::onDraw() {
    bodyModel.scheduleForDrawing();
    bodyModel._vf1C();
    this->animationChr.process();
    this->subAnimationChr.process();
    return true;
}


void daCosmicMario_c::updateModelMatrices() {
    matrix.translation(pos.x, pos.y, pos.z);
    matrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);

    bodyModel.setDrawMatrix(matrix);
    bodyModel.setScale(&scale);
    bodyModel.calcWorld(false);
}

int daCosmicMario_c::onExecute() {
    acState.execute();
    updateModelMatrices();

    if(!this->hasStarted) {
        if(this->animationChr.isAnimationDone()) {
            this->animationChr.setCurrentFrame(0.0);
        }
    }

    return true;
}



static nw4r::snd::StrmSoundHandle cosmicMarioSoundHandle;

extern Vec twoScale;

// Intro State

void daCosmicMario_c::beginState_Intro() {
    OSReport("IntroBegin\n");

    this->rot = (S16Vec){cosmicBuffer[0].rot.x, (s16)0xD800, cosmicBuffer[0].rot.z};
    this->pos = (Vec){cosmicBuffer[0].pos.x, cosmicBuffer[0].pos.y + 256.0f, cosmicBuffer[0].pos.z};
    bindAnimChr_and_setUpdateRate(PlayerAnimStates[117].regularAnim, 1, 0.0, 1.0); //star_Roll
    
    if(this->doesBeginSound) {
        PlaySoundWithFunctionB4(SoundRelatedClass, &cosmicMarioSoundHandle, SFX_COSMICMARIO_APPEAR, 1);
    }
    Vec effectPos = (Vec){cosmicBuffer[this->timer].pos.x, cosmicBuffer[this->timer].pos.y + 16, cosmicBuffer[this->timer].pos.z};
    SpawnEffect("Wm_en_cloneburst_s", 0, &effectPos, 0, &twoScale);

    MakeMarioEnterDemoMode();
}

void daCosmicMario_c::executeState_Intro() {
    // OSReport("IntroExecute\n");
    if(!this->hasBeenScaled) {
        this->doCosmicScale();
        this->scaleTimer++;
    }

    if(this->pos.y > cosmicBuffer[0].pos.y) {
        OSReport("Lowering\n");
        this->pos.y -= 2 + this->gravityConstant;
        this->gravityConstant += 0.1;
    }
    else {
        this->timer++;
        if(this->timer == 1) {
            OSReport("Provoke\n");
            bindAnimChr_and_setUpdateRate(PlayerAnimStates[136].regularAnim, 1, 0.0, 1.0); //waitR
            PlaySoundWithFunctionB4(SoundRelatedClass, &cosmicMarioSoundHandle, SFX_COSMICMARIO_PROVOKE, 1);
        }
        else if(this->timer == 180) {
            OSReport("Countdown\n");
            dGameDisplay_c::instance->layout.enableNonLoopAnim(2, false);
            bindAnimChr_and_setUpdateRate(PlayerAnimStates[135].regularAnim, 1, 0.0, 1.0); //waitL
            PlaySoundWithFunctionB4(SoundRelatedClass, &cosmicMarioSoundHandle, SFX_COUNTDOWN, 1);
            this->rot.y = 0x2800;
        }
        else if(this->timer == 360) {
            OSReport("Go\n");
            dGameDisplay_c::instance->layout.enableNonLoopAnim(3, false);
            PlaySoundWithFunctionB4(SoundRelatedClass, &cosmicMarioSoundHandle, SFX_COSMICMARIO_LETSGO, 1);
            doStateChange(&StateID_Run);
        }
    }
}

void daCosmicMario_c::endState_Intro() {
    this->pos.y = cosmicBuffer[0].pos.y;
    this->timer = 0;
    this->hasStarted = true;

    MakeMarioExitDemoMode();
}

void daCosmicMario_c::doCosmicScale() {
    float scaleT = (float)this->scaleTimer / 60.0;
    if(scaleT >= 1.0) {
        this->scale = (Vec){1.0, 1.0, 1.0};

        // ActivePhysics::Info HitMeBaby;
        // HitMeBaby.xDistToCenter = 0.0;
        // HitMeBaby.yDistToCenter = 12.0;
        // HitMeBaby.xDistToEdge = 6.0;
        // HitMeBaby.yDistToEdge = 12.0;
        // HitMeBaby.category = 0x5;
        // HitMeBaby.attack = 0x0;
        // HitMeBaby.categoryBitfield = 0x4F;
        // HitMeBaby.attackBitfield = 0xFFFFFFFF;
        // HitMeBaby.miscFlags = 0;
        // HitMeBaby.callback = &dEn_c::collisionCallback;

        // this->aPhysics.initWithStruct(this, &HitMeBaby);
        // this->aPhysics.addToList();

        this->hasBeenScaled = true;
    }
    else {
        this->scale = (Vec){scaleT, scaleT, scaleT};
    }
}

// Run State

extern s16 starRotatingConstant;
extern bool cosmicTouch;
extern dStageActor_c *dPowerStar_c__instance;
Vec startPos;

void daCosmicMario_c::beginState_Run() {

}

void daCosmicMario_c::executeState_Run() {
    if(cosmicKillFlag) {
        if(doesEndSound) {
            PlaySoundWithFunctionB4(SoundRelatedClass, &cosmicMarioSoundHandle, SFX_COSMICMARIO_DIE, 1);
        }

        // this->killedByLevelClear();
        Vec effectPos = (Vec){this->pos.x, this->pos.y + 16, this->pos.z};
        SpawnEffect("Wm_en_cloneburst_s", 0, &effectPos, 0, &twoScale);
        this->Delete(1);
    }

    if(!this->wereDone) {
        this->rot = cosmicBuffer[this->timer].rot;
        this->pos = cosmicBuffer[this->timer].pos;
    }
    else {
        this->rot = (S16Vec){cosmicBuffer[this->timer].rot.x, 0, cosmicBuffer[this->timer].rot.z};
        this->pos = (Vec){startPos.x, (cosmicBuffer[this->timer].pos.y + 672.0f) + startPos.y, startPos.z};
    }

    // OSReport("player: %f %f", player->aPhysics.info.xDistToCenter, player->aPhysics.info.yDistToCenter);
    // OSReport(" %f %f\n", player->aPhysics.info.xDistToEdge, player->aPhysics.info.yDistToEdge);
    if(!hasSpawned && this->timer == 3) {
        hasSpawned = true;
    }

    int anim = cosmicBuffer[this->timer].anim;
    int subAnim = cosmicBuffer[this->timer].subAnim;
    if(previousAnim != anim) {
        previousAnim = anim;
        OSReport("Anim changed to: %d: %s\n", anim, PlayerAnimStates[anim].regularAnim);
        if(anim >= 0) {
            // OSReport(">=0\n");
            bindAnimChr_and_setUpdateRate(PlayerAnimStates[anim].regularAnim, 1, 0.0, 1.0);
        }
        else {
            // OSReport("-1\n");
            anim = 0;
            bindAnimChr_and_setUpdateRate("Rwait", 1, 0.0, 1.0);
        }
    }

    if(previousAnim2 != subAnim) {
        previousAnim2 = subAnim;
        OSReport("SubAnim changed to: %d: %s\n", subAnim, PlayerAnimStates[subAnim].regularAnim);
        if(subAnim >= 0) {
            // OSReport(">=0\n");
            bindSubAnimChr_and_setUpdateRate(PlayerAnimStates[subAnim].regularAnim, 1, 0.0, 1.0);
        }
        else {
            // OSReport("-1\n");
            bindSubAnimChr_and_setUpdateRate(PlayerAnimStates[anim].regularAnim, 1, 0.0, 1.0);
        }
    }

    /*if(this->direction != player->direction) {
        this->direction = player->direction;
    }*/

    this->animationChr.setCurrentFrame(cosmicBuffer[this->timer].animFrame);
    if(subAnim >= 0) {
        this->subAnimationChr.setCurrentFrame(cosmicBuffer[this->timer].subAnimFrame);
    }
    else {
        this->subAnimationChr.setCurrentFrame(cosmicBuffer[this->timer].animFrame);
    }

    if(this->timer < frameCount-1) {
        this->timer++;

        Vec effectPos = (Vec){this->pos.x, this->pos.y + 16, this->pos.z};
        Vec effectScale = (Vec){1.5, 1.5, 1.5};
        dust.spawn("Wm_mr_clonedust", 0, &effectPos, 0, &effectScale);
    }
    else {
        daPlBase_c *mario = GetPlayerOrYoshi(0);
        float playerX = mario->pos.x;
        float distance = this->pos.x - playerX;
        if(distance < 0) {distance *= -1.0f;}

        bool isOnGround = true;
        for(int i = 0; i < 4; i++) {
            if(Player_Active[i]) {
                if(!(GetPlayerOrYoshi(i)->collMgr.isOnTopOfTile())) {
                    // OSReport("Player %d isn't on ground\n", i);
                    isOnGround = false;
                }
            }
        }

        if(distance < 48.0f) {
            if(distance < 24.0f) {
                if(playerX < this->pos.x) {mario->pos.x = this->pos.x - 24.0f; mario->speed.x = 0; mario->direction = 0;}
                else                      {mario->pos.x = this->pos.x + 24.0f; mario->speed.x = 0; mario->direction = 1;}
            }

            if(isOnGround && !this->wereDone) {
                FreeFile(&fileHandle);
                cosmicBuffer = (CosmicBuffer*)(u32*)LoadFile(&fileHandle, "/Races/End.race");
                frameCount = fileHandle.length / 0x24;
                MakeMarioEnterDemoMode();
                this->timer = 0;
                this->wereDone = true;
                startPos = dPowerStar_c__instance->pos;
            }
        }
    }
    
    if(this->timer > frameCount-36 && !this->wereDone) {
        this->pos.z = 300.0f;
        this->rot.y = starRotatingConstant - 0x4000;
    }

    if(this->wereDone) {
        if(this->timer2 == 59) {
            cosmicTouch = true;
        }
        else if(this->timer2 == 115) {
            PlaySoundWithFunctionB4(SoundRelatedClass, &cosmicMarioSoundHandle, SFX_COSMICMARIO_LAUGH, 1); // CM-Laugh
        }

        daPlBase_c *mario = GetPlayerOrYoshi(0);
        float playerX = mario->pos.x;
        float distance = this->pos.x - playerX;
        if(distance < 0) {distance *= -1.0f;}
        
        if(distance < 24.0f) {
            if(playerX < this->pos.x) {mario->pos.x = this->pos.x - 24.0f; mario->speed.x = 0; mario->direction = 0;}
            else                      {mario->pos.x = this->pos.x + 24.0f; mario->speed.x = 0; mario->direction = 1;}
        }

        this->timer2++;
    }


    // int nowHeld = Remocon_GetButtons(GetActiveRemocon());
    // if(nowHeld & WPAD_B) {
    //     daPlBase_c *mario = GetPlayerOrYoshi(0);

    //     mario->pos = this->pos;
    //     mario->removeMyActivePhysics();
    // }

    // OSReport("timers: %d %d\n", this->timer, this->timer);
}
void daCosmicMario_c::endState_Run() {

}