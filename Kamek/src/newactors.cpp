#include <game.h>
#include <common.h>

extern "C" u32 ObjectProfileList;

extern "C" u32 PatchLastActorID1;
extern "C" u32 PatchLastActorID2;
extern "C" u32 PatchLastActorID3;
extern "C" u32 PatchLastActorID4;
extern "C" u32 PatchLastActorID5;
extern "C" u32 PatchLastActorID6;
extern "C" u32 PatchLastActorID7;
extern "C" u32 PatchLastActorID8;
extern "C" u32 PatchLastActorID9;
extern "C" u32 PatchLastActorID10;
extern "C" u32 PatchLastActorID11;
extern "C" u32 PatchLastActorID12;
//extern "C" u32 PatchLastActorID13;
extern "C" u32 PatchLastActorID14;

extern "C" u32 PatchLastActorID15;
extern "C" u32 PatchLastActorID16;
extern "C" u32 PatchLastActorID17;
extern "C" u32 PatchLastActorID18;
extern "C" u32 PatchLastActorID19;
extern "C" u32 PatchLastActorID20;

extern "C" u16 PatchLastActorID21;
extern "C" u16 PatchLastActorID22;
extern "C" u16 PatchLastActorID23;
extern "C" u16 PatchLastActorID24;
extern "C" u16 PatchLastActorID25;

u32 newProfileList[751];

void putNewList() {
	if(ObjectProfileList != (u32)&newProfileList) {
		for(int i = 0; i < 750; i++) {
			newProfileList[i] = ((u32*)ObjectProfileList)[i];
		}
		newProfileList[750] = ((u32*)ObjectProfileList)[749];

		ObjectProfileList = (u32)&newProfileList;

		PatchLastActorID1++;
		PatchLastActorID2++;
		PatchLastActorID3++;
		PatchLastActorID4++;
		PatchLastActorID5++;
		PatchLastActorID6++;
		PatchLastActorID7++;
		PatchLastActorID8++;
		PatchLastActorID9++;
		PatchLastActorID10++;
		PatchLastActorID11++;
		PatchLastActorID12++;
		//PatchLastActorID13++;
		PatchLastActorID14++;

		PatchLastActorID15 = 0x02EE02EC;
		PatchLastActorID16 = 0x02EF0000;
		PatchLastActorID17 = 0x02EF02EF;
		PatchLastActorID18 = 0x02EF0000;
		PatchLastActorID19 = 0x02EB02EE;
		PatchLastActorID20 = 0x02EF0000;

		if(PatchLastActorID21 == 0x02EE) PatchLastActorID21++;
		if(PatchLastActorID22 == 0x02EE) PatchLastActorID22++;
		if(PatchLastActorID23 == 0x02EE) PatchLastActorID23++;
		if(PatchLastActorID24 == 0x02EE) PatchLastActorID24++;
		if(PatchLastActorID25 == 0x02EE) PatchLastActorID25++;
	}
}