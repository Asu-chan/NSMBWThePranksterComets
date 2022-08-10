#ifndef __NEWER_TIMEKEEPER_H
#define __NEWER_TIMEKEEPER_H

class TimeKeeper {
	public:
		u32 *vtable;
		u32 timePlusFFFTimes40000;
		u16 time;
		u8 ambushMaybe;
		u8 timeLessThan100;
		u8 paused;
	   
		static TimeKeeper* instance;

		void setTime(u32 time);
};


#endif

