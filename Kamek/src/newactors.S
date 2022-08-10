.text
#include <asm_setup.S>

.extern _Z10putNewListv

.global ChangeProfileList
ChangeProfileList:
	bl _Z10putNewListv
	lwz r0, 0x14(r1)
	b doneWithChangeProfileList