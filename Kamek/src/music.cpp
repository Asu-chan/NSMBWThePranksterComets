#include <game.h>
#include <sfx.h>
#include "music.h"

struct HijackedStream {
	//const char *original;
	//const char *originalFast;
	u32 stringOffset;
	u32 stringOffsetFast;
	u32 infoOffset;
	u8 originalID;
	int streamID;
};

struct Hijacker {
	HijackedStream stream[2];
	u8 currentStream;
	u8 currentCustomTheme;
};



const char* SongNameList [] = {
	"new/Purple",		// 100
	"new/Speedy",
	"new/Cosmic",
	"new/StarWaiting",
	"new/Chimp",
	"new/BAD_APPLE",		// 105
	"new/STRM_BGM_CHIJOU",
	"new/",
	"new/",
	"new/",
	"new/",		// 110
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",		// 115
	"new/",
	"new/",
	"new/",
	"new/",
	"new/SONG_120",		// 120
	"new/SONG_121",
	"new/SONG_122",
	"new/SONG_123",
	"new/SONG_124",
	"new/SONG_125",
	"new/SONG_126",
	"new/SONG_127",
	"new/SONG_128",
	"new/SONG_129",
	"new/SONG_130",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"new/",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"new/BOSS_CASTLE",
	"new/BOSS_AIRSHIP",
	NULL	
};



// Offsets are from the start of the INFO block, not the start of the brsar.
// INFO begins at 0x212C0, so that has to be subtracted from absolute offsets
// within the brsar.

#define _I(offs) ((offs)-0x212C0)

Hijacker Hijackers[2] = {
	{
		{
			{/*"athletic_lr.n.32.brstm", "athletic_fast_lr.n.32.brstm",*/ _I(0x4A8F8), _I(0x4A938), _I(0x476C4), 4, STRM_BGM_ATHLETIC},
			{/*"BGM_SIRO.32.brstm", "BGM_SIRO_fast.32.brstm",*/ _I(0x4B2E8), _I(0x4B320), _I(0x48164), 10, STRM_BGM_SHIRO}
		},
		0, 0
	},

	{
		{
			{/*"STRM_BGM_CHIJOU.brstm", "STRM_BGM_CHIJOU_FAST.brstm",*/ _I(0x4A83C), _I(0x4A8B4), 0, 1, STRM_BGM_CHIJOU},
			{/*"STRM_BGM_CHIKA.brstm", "STRM_BGM_CHIKA_FAST.brstm",*/ _I(0x4A878), _I(0x4A780), 0, 2, STRM_BGM_CHIKA},
		},
		0, 0
	}
};

extern void *SoundRelatedClass;
inline char *BrsarInfoOffset(u32 offset) {
	return (char*)(*(u32*)(((u32)SoundRelatedClass) + 0x5CC)) + offset;
}

int currentUse = 0;
bool forceReset = false;

void FixFilesize(u32 streamNameOffset);

u8 hijackMusicWithSongName(const char *songName, int themeID, bool hasFast, int channelCount, int trackCount, int *wantRealStreamID) {
	return hijackMusicWithSongName(songName, themeID, hasFast, channelCount, trackCount, wantRealStreamID, false, false);
}

u8 hijackMusicWithSongName(const char *songName, int themeID, bool hasFast, int channelCount, int trackCount, int *wantRealStreamID, bool doTheResetThing, bool overwriteCurrent) {
	Hijacker *hj = &Hijackers[channelCount==4?1:0];

	// do we already have this theme in this slot?
	// if so, don't switch streams
	// if we do, NSMBW will think it's a different song, and restart it ...
	// but if it's just an area transition where both areas are using the same
	// song, we don't want that
	if(!doTheResetThing) {
		if(!forceReset) {
			if ((themeID >= 0) && hj->currentCustomTheme == themeID) {
				return hj->stream[hj->currentStream].originalID;
			}
		}
		else {
			forceReset = false;
		}
	}

	// which one do we use this time...?
	int toUse = (hj->currentStream + 1) & 1;

	if(overwriteCurrent) {
		toUse = currentUse;
		forceReset = true;
	}
	else
		currentUse = toUse;

	hj->currentStream = toUse;
	hj->currentCustomTheme = themeID;

	// write the stream's info
	HijackedStream *stream = &hj->stream[hj->currentStream];

	if (stream->infoOffset) {
		u16 *thing = (u16*)(BrsarInfoOffset(stream->infoOffset) + 4);
		OSReport("Modifying stream info, at offset %x which is at pointer %x\n", stream->infoOffset, thing);
		OSReport("It currently has: channel count %d, track bitfield 0x%x\n", thing[0], thing[1]);
		thing[0] = channelCount;
		thing[1] = (1 << trackCount) - 1;
		OSReport("It has been set to: channel count %d, track bitfield 0x%x\n", thing[0], thing[1]);
	}

	sprintf(BrsarInfoOffset(stream->stringOffset), "%s.brstm", songName);
	sprintf(BrsarInfoOffset(stream->stringOffsetFast), hasFast?"%s_F.brstm":"%s.brstm", songName);

	// update filesizes
	FixFilesize(stream->stringOffset);
	FixFilesize(stream->stringOffsetFast);

	// done!
	if (wantRealStreamID)
		*wantRealStreamID = stream->streamID;

	return stream->originalID;
}


//oh for fuck's sake
#include "fileload.h"
//#include <rvl/dvd.h>

void FixFilesize(u32 streamNameOffset) {
	char *streamName = BrsarInfoOffset(streamNameOffset);

	char nameWithSound[80];
	snprintf(nameWithSound, 79, "/Sound/%s", streamName);

	s32 entryNum;
	DVDHandle info;
	
	if ((entryNum = DVDConvertPathToEntrynum(nameWithSound)) >= 0) {
		if (DVDFastOpen(entryNum, &info)) {
			u32 *lengthPtr = (u32*)(streamName - 0x1C);
			*lengthPtr = info.length;
		}
	} else
		OSReport("What, I couldn't find \"%s\" :(\n", nameWithSound);
}



extern "C" u8 after_course_getMusicForZone(u8 realThemeID) {
	if (realThemeID < 100)
		return realThemeID;

	bool usesDrums = (realThemeID >= 200);
	const char *name = SongNameList[realThemeID - (usesDrums ? 200 : 100)];
	// OSReport("num: %d\n", realThemeID - (usesDrums ? 200 : 100));
	// OSReport("name: %s\n", name);
	return hijackMusicWithSongName(name, realThemeID, true, usesDrums?4:2, usesDrums?2:1, 0, false, false);
}

const char* SFXNameList [] = {
	"sfx/original",
	"sfx/pranskter_comet",	//2000
	"sfx/purple_coin",
	"sfx/CM-Appear",
	"sfx/CM-Die",
	"sfx/CM-Provoke",
	"sfx/CM-LetsGo",		//2005
	"sfx/Countdown",
	"sfx/TimerSignal",
	"sfx/TimerLastSignal",
	"sfx/TimerAlarm1",
	"sfx/TimerAlarm2",		//2010
	"sfx/TimerAlarm3",
	"sfx/PlusClock",
	"sfx/StarAppear",
	"sfx/StarWait",
	"sfx/CM-Laugh",			//2015
	"sfx/PageFlip",
	"sfx/ButtonPress",
	"sfx/CharactersWooo",
	"sfx/CharactersHappy",
	"sfx/BowserThunder",	//2020
	"sfx/CharactersGo",
	"sfx/Chimp_AwfulNoise",
	"sfx/Chimp_Dissatisfied",
	"sfx/Chimp_FailClap",
	"sfx/Chimp_FailFull",	//2025
	"sfx/Chimp_HandClap",
	"sfx/Chimp_Laugh",
	"sfx/Chimp_Surprised",
	"sfx/Chimp_Talk",
	"sfx/doubleDate/beat",					//2030
	"sfx/doubleDate/kick_slap",
	"sfx/doubleDate/kick",
	"sfx/doubleDate/kick_rugby",
	"sfx/doubleDate/kick_miss",
	"sfx/doubleDate/bounce_football",		//2035
	"sfx/doubleDate/bounce_basketball",
	"sfx/doubleDate/bounce_rugby",
	"sfx/doubleDate/bounce_grass1",
	"sfx/doubleDate/bounce_grass2",
	"sfx/doubleDate/bounce_grass3",			//2040
	"sfx/doubleDate/squirrel",
	"sfx/doubleDate/get_rekt",
	NULL	
};

int currentSFX = -1;
u32 *currentPtr = 0;

extern void loadFileAtIndex(u32 *filePtr, u32 fileLength, u32* whereToPatch);

// static FileHandle handle;
extern u32* GetCurrentPC();


extern "C" u32 NewSFXTable[];
extern "C" u32 NewSFXIndexes;

void loadAllSFXs() {
	u32 currentIdx = (u32)&NewSFXIndexes;

	FileHandle handle;
	for(int sfxIndex = 0; sfxIndex < (sizeof(SFXNameList)-1)/sizeof(SFXNameList[0]); sfxIndex++) {
		char nameWithSound[80];
		snprintf(nameWithSound, 79, "/Sound/%s.rwav", SFXNameList[sfxIndex]);

		u32 filePtr = (u32)LoadFile(&handle, nameWithSound);

		// OSReport("currentIdx: %p\n", currentIdx);
		NewSFXTable[sfxIndex] = currentIdx;
		loadFileAtIndex((u32*)filePtr, handle.length, (u32*)currentIdx);
		currentIdx += handle.length;
		currentIdx += (currentIdx % 0x10);

		FreeFile(&handle);
	}
}

int hijackSFX(int SFXNum) {
	int nameIndex = SFXNum - 1999;
	if(currentSFX == nameIndex) {
		return 189;
	}

	currentPtr = (u32*)NewSFXTable[nameIndex];

	/*char nameWithSound[80];
	snprintf(nameWithSound, 79, "/Sound/%s.rwav", SFXNameList[nameIndex]);

	// OSReport("Opening File %s\n", nameWithSound);

	// if(currentPtr) {
	// 	FreeFile(&handle);
	// }
	FileHandle handle;
	currentPtr = (u32*)LoadFile(&handle, nameWithSound);

	OSReport("PChijack: %p\n", GetCurrentPC());
	u32 *ohwell = (u32*)((u32)((u32*)*(u32*)(*(u32*)(*(u32*)(((*(u32*)(((u32)SoundRelatedClass) + 0x61C))) - 0x20)))) + 0x78EBE0);
	OSReport("ohwell: %p\n", ohwell);*/

/*
	u32 rwavPtr1 = (*(u32*)(((u32)SoundRelatedClass) + 0x61C));
	u32 rwavPtr2 = *(u32*)(rwavPtr1 - 0x20);
	u32 rwavPtr3 = *(u32*)rwavPtr2;
	u32 *rwavPtr4 = (u32*)*(u32*)rwavPtr3;
	u32 *rwavPtr5 = (u32*)((u32)rwavPtr4 + 0x957E40);

	u32 *rwavPtr6 = (u32*)((u32)rwavPtr4 + 0x78EBE0);

	OSReport("Val %p\n", rwavPtr6);

	// OSReport("oFILE ADDR: %X\n", rwavPtr4);
	// OSReport("oRWAV ADDR: %X\n", rwavPtr5);
	// OSReport("nRWAV ADDR: %X\n", outPtr);
	loadFileAtIndex(outPtr, handle.length, rwavPtr5);

*/
	// OSReport("Hijacked.\n");

	currentSFX = nameIndex;

	return 189;
}

static nw4r::snd::StrmSoundHandle yoshiHandle;

void fuckingYoshiStuff() {
	PlaySoundWithFunctionB4(SoundRelatedClass, &yoshiHandle, 189, 1);
}