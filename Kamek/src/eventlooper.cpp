#include <game.h>
#include <common.h>



class dEventLooper_c : public dActorState_c {
public:
	int onCreate();
	int onExecute();
	int onDelete();
	// int onDraw();

	u64 eventFlag;
	u64 eventActive;
	u8 delay;
	u8 delayCount;

	static dEventLooper_c *build();
};


dEventLooper_c *dEventLooper_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dEventLooper_c));
	dEventLooper_c *c = new(buffer) dEventLooper_c;
	return c;
}

#include <profile.h>
const SpriteData eventLooperData = {ProfileId::NEWER_EVENTLOOPER, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2};
Profile eventLooperProfile = Profile((buildFunc)&dEventLooper_c::build, SpriteId::NEWER_EVENTLOOPER, &eventLooperData, ProfileId::NEWER_EVENTLOOPER, ProfileId::NEWER_EVENTLOOPER, 0x12, "NEWER_EVENTLOOPER", 0);


int dEventLooper_c::onCreate() {
	char eventStart	= (this->settings >> 24)	& 0xFF;
	char eventEnd	= (this->settings >> 16)	& 0xFF;

	// Putting all the events into the flag
	int i;
	u64 q = (u64)0;
	for(i=eventStart;i<(eventEnd+1);i++)
	{
		q = q | ((u64)1 << (i - 1));
	}
		
	this->eventFlag = q;
	
	this->delay		= (((this->settings) & 0xFF) + 1) * 10;
	this->delayCount = 0;
	
	char tmpEvent= (this->settings >> 8)	& 0xFF;
	if (tmpEvent == 0)
	{
		this->eventActive = (u64)0xFFFFFFFFFFFFFFFF;
	}
	else
	{
		this->eventActive = (u64)1 << (tmpEvent - 1);
		
	}
	

	if (dFlagMgr_c::instance->flags & this->eventActive)
	{
		u64 evState = (u64)1 << (eventStart - 1);
		dFlagMgr_c::instance->flags |= evState;
	}

	this->onExecute();

	return true;
}

int dEventLooper_c::onExecute() {
	if ((dFlagMgr_c::instance->flags & this->eventActive) == 0)
		return true;

	// Waiting for the right moment
	if (this->delayCount < this->delay) 
	{

		this->delayCount = this->delayCount + 1;
		return true;
	}	
	
	// Reset the delay
	this->delayCount = 0;
	
	// Find which event(s) is/are on
	u64 evState = dFlagMgr_c::instance->flags & this->eventFlag;
	
	// Turn off the old events
	dFlagMgr_c::instance->flags = dFlagMgr_c::instance->flags & (~this->eventFlag);
	
	// Shift them right if they can, if not, reset!
	evState = evState << 1;
	if (evState < this->eventFlag)
	{
		dFlagMgr_c::instance->flags = dFlagMgr_c::instance->flags | evState;
	}
	
	else
	{
		char eventStart	= (this->settings >> 24) & 0xFF;
		evState = (u64)1 << (eventStart - 1);
		dFlagMgr_c::instance->flags = dFlagMgr_c::instance->flags | evState;
	}

	return true;
}

int dEventLooper_c::onDelete() {
	return true;
}

// int dEventLooper_c::onDraw() {
// 	return true;
// }