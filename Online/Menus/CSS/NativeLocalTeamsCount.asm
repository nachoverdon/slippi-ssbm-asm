# Address: 0x802641CC # CSS setup: choose native four-cursor/menu path.
.include "Common/Common.s"
.include "Online/Online.s"
lbzu r0, 2(r3) # original instruction, advances CSS data pointer
getMinorMajor r12
cmpwi r12, SCENE_ONLINE_CSS
bne EXIT
loadwz r12, CSSDT_BUF_ADDR
cmpwi r12, 0
beq EXIT
lbz r12, CSSDT_LOCAL_TEAMS_STATUS + LTS_NATIVE(r12)
cmpwi r12, 0
beq EXIT
li r0, 0 # only the cursor/menu-path comparison, NOT the online scene/mode
stwu r1, -32(r1)
stw r4, 8(r1)
stw r5, 12(r1)
stw r6, 16(r1)
stw r7, 20(r1)
stw r8, 24(r1)
loadwz r12, CSSDT_BUF_ADDR
subi r4, r3, 2
li r5, 0 # slot
li r6, 0 # sheikMask
li r8, 0x12 # CKIND_ZELDA
NATIVE_SHEIK_SAVE_LOOP:
mulli r7, r5, 0x24
add r7, r4, r7
lbz r7, 0x70(r7)
cmpwi r7, 0x13 # CKIND_SHEIK
bne NATIVE_SHEIK_SAVE_NEXT
mulli r7, r5, 0x24
add r7, r4, r7
stb r8, 0x70(r7)
li r7, 1
slw r7, r7, r5
or r6, r6, r7
NATIVE_SHEIK_SAVE_NEXT:
addi r5, r5, 1
cmpwi r5, 4
blt NATIVE_SHEIK_SAVE_LOOP
stb r6, CSSDT_NATIVE_SHEIK_MASK(r12)
load r4, 0x803F0CC8
stb r8, 1(r4)
lwz r4, 8(r1)
lwz r5, 12(r1)
lwz r6, 16(r1)
lwz r7, 20(r1)
lwz r8, 24(r1)
addi r1, r1, 32
EXIT:
