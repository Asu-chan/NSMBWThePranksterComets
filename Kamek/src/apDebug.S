.text
#include <asm_setup.S>

.global AddInstanceToTheLinkedList
AddInstanceToTheLinkedList:
    stw r0, 0xE8(r30) # Restore instruction

    mr r3, r30
    b addBcToList

.global RemoveInstanceFromTheLinkedList
RemoveInstanceFromTheLinkedList:
    # Push stack manually
    stwu r1, -0x10(r1)
    mflr r0
    stw r0, 0x14(r1)
    stw r4, 0xC(r1)

    # Call CPP function
    bl removeBcFromList

    # Pop stack manually
    lwz r4, 0xC(r1)
    lwz r0, 0x14(r1)
    mtlr r0
    addi r1, r1, 0x10

    # Restore registers
    mr r3, r31
    cmpwi r4, 0
    blr