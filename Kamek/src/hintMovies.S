.text
#include <asm_setup.S>

.global ChangeReplayDataPtr
ChangeReplayDataPtr:
	lis r28, replayDataPtr@ha
	lwz r28, replayDataPtr@l(r28)
	blr