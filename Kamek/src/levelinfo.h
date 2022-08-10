#ifndef __NEWER_LEVELINFO_H
#define __NEWER_LEVELINFO_H

#include <game.h>

class dLevelInfo_c {
public:
	struct header_s {
		u32 magic;
		u32 sectionCount;
		u32 sectionOffsets[1];
	};

	struct entry_s {
		u8 worldSlot;
		u8 levelSlot;
		u8 displayWorld;
		u8 displayLevel;
		u8 nameLength;
		u8 vignette; //unused
		u16 flags;
		u32 nameOffset;
		//u32 creatorOffset;
	};

	struct section_s {
		u32 levelCount;
		entry_s levels[1];
	};

	struct creator_s {
		u32 creatorCount;
		u32 creatorOffsets[1];
	};

private:
	header_s *data;

public:
	void load(void *buffer);

	entry_s *searchBySlot(int world, int level);
	entry_s *searchByDisplayNum(int world, int level);

	u32 sectionCount() {
		return data->sectionCount;
	}

	section_s *getSectionByIndex(u32 index) {
		return (section_s*)(((char*)data) + data->sectionOffsets[index]);
	}

	const wchar_t *getNameForLevel(entry_s *entry) {
		return (const wchar_t*)((u32)data + (u32)entry->nameOffset);
	}

	static dLevelInfo_c s_info;
};


#endif

