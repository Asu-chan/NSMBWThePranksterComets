#include <asm_setup.S>

.extern _Z19loadDefaultSaveFilePj

.global LoadDefaultSave
LoadDefaultSave:
	addi r3, r31, 0x20
	bl _Z19loadDefaultSaveFilePj
	mr r3, r31
	b doneWithLoadDefaultSave