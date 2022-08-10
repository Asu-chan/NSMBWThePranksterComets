#include <game.h>
#include <common.h>
#include "fileload.h"

extern void loadFileAtIndex(u32 *filePtr, u32 fileLength, u32* whereToPatch);

FileHandle saveFileHandle;

void loadDefaultSaveFile(u32 *ptr) {
	u32 *outPtr = (u32*)LoadFile(&saveFileHandle, "/save/CometSM.sav");

	if(outPtr) {
		loadFileAtIndex(outPtr, saveFileHandle.length, ptr);

		FreeFile(&saveFileHandle);
	}
}