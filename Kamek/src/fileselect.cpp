#include <game.h>
#include <common.h>


static u8 *PathAvailabilityData = 0;
static u8 *NodeAvailabilityData = 0;

void ClearOldPathAvailabilityData() {
	// This is called by File Select
	if (PathAvailabilityData) {
		delete[] PathAvailabilityData;
		PathAvailabilityData = 0;
	}
	if (NodeAvailabilityData) {
		delete[] NodeAvailabilityData;
		NodeAvailabilityData = 0;
	}
}

u8 MaybeFinishingLevel[2] = {0xFF,0xFF};
u8 LastLevelPlayed[2] = {0xFF,0xFF};
bool CanFinishCoins = false;
bool CanFinishExits = false;
bool CanFinishWorld = false;
bool CanFinishAlmostAllCoins = false;
bool CanFinishAllCoins = false;
bool CanFinishAllExits = false;
bool CanFinishEverything = false;
void ResetAllCompletionCandidates() {
	// This is called by File Select, btw
	MaybeFinishingLevel[0] = 0xFF;
	LastLevelPlayed[0] |= 0x80;
	CanFinishCoins = false;
	CanFinishExits = false;
	CanFinishWorld = false;
	CanFinishAlmostAllCoins = false;
	CanFinishAllCoins = false;
	CanFinishAllExits = false;
	CanFinishEverything = false;
}