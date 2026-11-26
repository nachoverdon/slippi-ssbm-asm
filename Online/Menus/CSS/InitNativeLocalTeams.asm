# Address: 0x80266830 # End of native CSS initialization, before restoring registers.
.include "Common/Common.s"
.include "Online/Online.s"
b CODE_START
DATA:
blrl
# Original HMN/team hitboxes; restore on every CSS, including ordinary VS.
.float -35.6,-28.6,-26.8,-21.0
.float -19.4,-13.4,-11.4,-6.0
.float -4.2,2.2,3.5,9.4
.float 11.0,17.0,19.0,24.6
# N=1/2/3/4 horizontal card-center shifts. N=2/3/4 stay inside [X0-7.25, X0+25.25].
.float 0,0,0,0
.float 0,2.6,5.2,7.8
.float -2.175,-6.4,-10.625,0
.float -3.4075,-10.5358,-17.6642,-24.7925
.float 0.5,-3.4 # team-marker midpoint / cursor height
.set NATIVE_DIGIT_GLYPHS, 0x88
# 1-P: replace only the eight-pixel digit, retain the stock hyphen/P/ring.
.long 0x00005dd0,0x0009fff0,0x02dffff0,0x08fffff0,0x048ffff0,0x000ffff0,0x000ffff0,0x000ffff0,0x000ffff0,0x000ffff0,0x000ffff0,0x000ffff0,0x000ffff0
# 2-P: replace only the eight-pixel digit, retain the stock hyphen/P/ring.
.long 0x00dfffd0,0x0dfffffd,0x0dfffffd,0x00000dfd,0x00000dfd,0x0000dfd0,0x000dfd00,0x00dfd000,0x0dfd0000,0x0dfd0000,0x0dfffffd,0x0dfffffd,0x0dfffffd
# 3-P: replace only the eight-pixel digit, retain the stock hyphen/P/ring.
.long 0x00dfffd0,0x0dfffffd,0x0dfffffd,0x00000dfd,0x00000dfd,0x000dffd0,0x000dffd0,0x00000dfd,0x00000dfd,0x00000dfd,0x0dfffffd,0x0dfffffd,0x00dfffd0
# 4-P: replace only the eight-pixel digit, retain the stock hyphen/P/ring.
.long 0x0000dfd0,0x000dffd0,0x00dfffd0,0x00dfffd0,0x0dfd0dd0,0x0dfd0dd0,0x0dfd0dd0,0x0dfffffd,0x0dfffffd,0x0000dfd0,0x0000dfd0,0x0000dfd0,0x0000dfd0
CARD_TEXT_DATA:
blrl
.set CTD_Z_STEPS, 0
.float 0.0, -0.03, -0.06, -0.09
.set CTD_CARD_SCALES, 16
.float 1.0, 1.0, 0.70, 0.53
.set CTD_ORIG_CENTERS, 32
.float -23.1, -7.7, 7.7, 23.1
.set CTD_HALF_REF_BOX, 48
.float 4.64
.set CTD_ANCHOR_Y, 52
.float -3.4
.set CTD_ANCHOR_TY_OFF, 56
.float -14.1
.set CTD_PORT_REL_X, 60
.float -6.30
.set CTD_PORT_Y_OFFS, 64
.float -1.80, -1.80, -1.65, -1.55
.set CTD_PORT_Z_OFF, 80
.float 0.005
.set CTD_PORT_SCALE_X, 84
.float 0.105
.set CTD_PORT_SCALE_Y, 88
.float 0.085
.set CTD_NAME_REL_X, 92
.float -5.52
.set CTD_NAME_REL_Y, 96
.float 14.24
.set CTD_NAME_Z_OFF, 100
.float 0.025
.set CTD_NAME_BOX_W, 104
.float 240.0
.set CTD_NAME_BOX_H, 108
.float 32.0
.set CTD_NAME_SCALE, 112
.float 0.046
.set CTD_NAME_SUB_X, 116
.float 120.0
.set CTD_FLOAT_0, 120
.float 0.0
.set CTD_FLOAT_1, 124
.float 1.0
.set CTD_OUTLINE_OFFS, 128
.float -2.0, 0.0
.float 2.0, 0.0
.float 0.0, -2.0
.float 0.0, 2.0
.float 0.0, 0.0
.set CTD_CURSOR_OFF_X, 168
.float -5.0
.set CTD_CURSOR_OFF_Y, 172
.float 1.25
.set CTD_CARD_HALF_W, 176
.float 7.25
.set CTD_FALLBACK_ANCHOR_TY, 180
.float 3.4
.set CTD_COLOR_PORT, 184
.long 0x00000078
.set CTD_COLOR_BLACK, 188
.long 0x000000FF
.set CTD_COLOR_WHITE, 192
.long 0xFFFFFFFF
.set CTD_STR_EMPTY, 196
.string ""
.set CTD_STR_PORT_FMT, CTD_STR_EMPTY + 1
.string "P%d"
.set CTD_STR_NAME_FMT, CTD_STR_PORT_FMT + 4
.string "%s"
.align 2
CODE_START:
backup BKP_DEFAULT_FREE_SPACE_SIZE, 7
bl DATA
mflr r31
li r30, 0
load r29, 0x803F0DFC
RESET_BOUNDS:
mulli r3, r30, 16
add r3, r31, r3
lwz r4, 0(r3)
stw r4, 0x14(r29)
lwz r4, 4(r3)
stw r4, 0x18(r29)
lwz r4, 8(r3)
stw r4, 0x1c(r29)
lwz r4, 12(r3)
stw r4, 0x20(r29)
addi r29, r29, 36
addi r30, r30, 1
cmpwi r30, 4
blt RESET_BOUNDS
getMinorMajor r3
cmpwi r3, SCENE_ONLINE_CSS
bne DONE
loadwz r28, CSSDT_BUF_ADDR
cmpwi r28, 0
beq DONE
lbz r3, CSSDT_LOCAL_TEAMS_STATUS + LTS_NATIVE(r28)
cmpwi r3, 0
beq NATIVE_CLEAR_LOADING
# The multiplayer menu has different frame/title meshes. Slippi's title
# animation expects SingleMenu UVs, so transplant those two unskinned DObj lists.
lwz r3, -0x49c8(r13)
lwz r3, 0x60(r3)
branchl r12, 0x80370e44 # HSD_JObjLoadJoint
mr r26, r3
li r25, 0
NATIVE_RESTORE_HEADER:
li r5, 1 # outer Teams frame
cmpwi r25, 0
beq NATIVE_HEADER_LOOKUP
li r5, 36 # mode title; Slippi still animates this live joint
NATIVE_HEADER_LOOKUP:
mr r24, r5
mr r3, r26
addi r4, sp, 0x30
li r6, -1
branchl r12, JObj_GetJObjChild
lwz r23, 0x30(sp)
lwz r3, -0x49e0(r13)
addi r4, sp, 0x30
mr r5, r24
li r6, -1
branchl r12, JObj_GetJObjChild
lwz r22, 0x30(sp)
lwz r3, 0x18(r22)
branchl r12, 0x8035e24c # HSD_DObjRemoveAll
lwz r3, 0x18(r23)
stw r3, 0x18(r22)
li r3, 0
stw r3, 0x18(r23) # transferred ownership, do not free with temporary root
addi r25, r25, 1
cmpwi r25, 2
blt NATIVE_RESTORE_HEADER
mr r3, r26
branchl r12, 0x80371590 # HSD_JObjRemoveAll
# The first SingleMenu title DObj is the stock "10-Man Melee" texture.
# Slippi animates the second title DObj; hide only that stray stock heading.
lwz r3, 0x18(r22)
lwz r4, 0x14(r3)
ori r4, r4, 1 # DOBJ_HIDDEN
stw r4, 0x14(r3)
# Keep the original bold "-P" lettering and circle. Patch only the digit
# before its first upload; the same narrow I4 block is used at every count.
lwz r3, -0x49e0(r13)
addi r4, sp, 0x30
li r5, 1
li r6, -1
branchl r12, JObj_GetJObjChild
lwz r3, 0x30(sp)
lwz r3, 0x18(r3) # DObj
lwz r3, 8(r3) # MObj
lwz r3, 8(r3) # TObj
lwz r3, 0x58(r3) # ImageDesc
lwz r4, 4(r3)
load r5, 0x00680048 # original 104x72 frame
cmpw r4, r5
bne NATIVE_FRAME_CLEAR_DONE
lwz r4, 8(r3)
cmpwi r4, 0 # GX_TF_I4
bne NATIVE_FRAME_CLEAR_DONE
lwz r26, 0(r3)
lbz r3, CSSDT_LOCAL_TEAMS_STATUS + 1(r28)
addi r3, r3, -1
mulli r3, r3, 52 # thirteen packed eight-pixel rows per digit
addi r24, r31, NATIVE_DIGIT_GLYPHS
add r24, r24, r3
li r25, 17
NATIVE_FRAME_DIGIT_ROW:
srwi r3, r25, 3
mulli r3, r3, 416 # 13 eight-pixel blocks per row, 32 bytes/block
addi r3, r3, 64 # digit spans x16..23, third eight-pixel block
andi. r4, r25, 7
slwi r4, r4, 2
add r3, r3, r4
lwz r4, 0(r24)
stwx r4, r26, r3
addi r24, r24, 4
addi r25, r25, 1
cmpwi r25, 30
blt NATIVE_FRAME_DIGIT_ROW
NATIVE_FRAME_CLEAR_DONE:
# Restore any Sheik picks that NativeLocalTeamsCount temporarily mapped to Zelda,
# and leave Slippi's Zelda icon default on Sheik (0x13).
lbz r26, CSSDT_NATIVE_SHEIK_MASK(r28)
li r3, 0
stb r3, CSSDT_NATIVE_SHEIK_MASK(r28)
li r27, 0x13
load r4, 0x803F0CC8
stb r27, 1(r4)
cmpwi r26, 0
beq NATIVE_SHEIK_RESTORE_DONE
lwz r25, -0x49F0(r13)
cmpwi r25, 0
beq NATIVE_SHEIK_RESTORE_DONE
li r30, 0
NATIVE_SHEIK_RESTORE_LOOP:
srw r3, r26, r30
andi. r3, r3, 1
beq NATIVE_SHEIK_RESTORE_NEXT
mulli r3, r30, 0x24
add r3, r25, r3
stb r27, 0x70(r3)
mr r3, r30
branchl r12, 0x8025DB34 # CSS_CursorHighlightUpdateCSPInfo
NATIVE_SHEIK_RESTORE_NEXT:
addi r30, r30, 1
cmpwi r30, 4
blt NATIVE_SHEIK_RESTORE_LOOP
NATIVE_SHEIK_RESTORE_DONE:
bl CARD_TEXT_DATA
mflr r25
li r30, 0
NATIVE_INIT_PORT:
load r3, 0x804A0BC0
slwi r4, r30, 2
lwzx r3, r3, r4
lbz r4, CSSDT_LOCAL_TEAMS_STATUS + 1(r28)
cmpw r30, r4
blt NATIVE_VISIBLE_PORT
lwz r3, 0(r3) # cursor GObj -> JObj
lwz r3, 0x28(r3)
li r4, 0x10
branchl r12, JObj_SetFlagsAll
load r3, 0x804A0BD0
slwi r4, r30, 2
lwzx r3, r3, r4
lwz r3, 0(r3)
lwz r3, 0x28(r3)
li r4, 0x10
branchl r12, JObj_SetFlagsAll
b NATIVE_INIT_NEXT
NATIVE_VISIBLE_PORT:
# Preserve normal native doors/portraits. Disable CPU/HMN switching.
load r29, 0x803F0DFC
mulli r3, r30, 36
add r29, r29, r3
li r3, 0
stb r3, 0x0b(r29)
load r3, 0x447a0000 # out-of-range hitbox, 1000f
stw r3, 0x14(r29)
stw r3, 0x18(r29)
lbz r3, CSSDT_LOCAL_TEAMS_STATUS + 1(r28)
subi r3, r3, 1
mr r6, r3
slwi r4, r3, 2
addi r4, r4, CTD_CARD_SCALES
lfsx f29, r25, r4
slwi r3, r3, 4
addi r3, r3, 64
slwi r4, r30, 2
add r3, r3, r4
lfsx f31, r31, r3
load r3, 0x803F0E8C
mulli r4, r30, 12
lwzx r3, r3, r4
cmpwi r3, 0
beq NATIVE_FALLBACK_CENTER
lwz r3, 0(r3)
cmpwi r3, 0
beq NATIVE_FALLBACK_CENTER
lfs f28, 0x00(r3)
lfs f30, CTD_HALF_REF_BOX(r25)
fadds f28, f28, f30
lfs f25, 0x04(r3)
lfs f30, CTD_ANCHOR_TY_OFF(r25)
fadds f25, f25, f30
b NATIVE_CENTER_READY
NATIVE_FALLBACK_CENTER:
slwi r4, r30, 2
addi r4, r4, CTD_ORIG_CENTERS
lfsx f28, r25, r4
lfs f25, CTD_FALLBACK_ANCHOR_TY(r25)
NATIVE_CENTER_READY:
fadds f26, f28, f31
lfs f30, CTD_CURSOR_OFF_X(r25)
fadds f26, f26, f30 # cursor_cx = new_world_cx - 5.0
lfs f30, CTD_CARD_HALF_W(r25)
fmuls f30, f30, f29 # half_w = 7.25 * card_scale
fsubs f27, f26, f30
stfs f27, 0x1c(r29)
fadds f27, f26, f30
stfs f27, 0x20(r29)
slwi r4, r6, 2
addi r4, r4, CTD_PORT_Y_OFFS
lfsx f30, r25, r4
fadds f30, f25, f30
fneg f30, f30
lfs f27, CTD_CURSOR_OFF_Y(r25)
fadds f30, f30, f27 # top_y = -(anchor_ty + port_y_off) + 1.25
slwi r4, r30, 2
addi r5, r28, CSSDT_NATIVE_TEAM_TOP_Y
stfsx f30, r5, r4
lfs f30, CTD_NAME_REL_Y(r25)
fmadds f30, f29, f30, f25
fneg f30, f30
fadds f30, f30, f27 # bot_y = -(anchor_ty + 14.24 * scale) + 1.25
addi r5, r28, CSSDT_NATIVE_TEAM_BOT_Y
stfsx f30, r5, r4
# Preserve existing on-screen hands across roster reloads; spawn new/unclaimed
# local hands on their own moved team markers, including P1 on fresh entry.
load r3, 0x804A0BC0
slwi r4, r30, 2
lwzx r27, r3, r4
li r3, 1
slw r3, r3, r30
lbz r4, CSSDT_LOCAL_TEAMS_STATUS + LTS_JOINED(r28)
and. r3, r3, r4
beq NATIVE_SPAWN_DEFAULT
addi r3, r30, CSSDT_LOCAL_TEAMS_STATUS + LTS_PORTS
lbzx r4, r28, r3
cmplwi r4, 4
bge NATIVE_SPAWN_DEFAULT
load r5, CSS_SAVED_CURSORS_ADDR
lwz r6, SAVED_CURSORS_MASK(r5)
li r3, 1
slw r3, r3, r4
and. r3, r3, r6
beq NATIVE_SPAWN_DEFAULT
slwi r4, r4, 2
addi r6, r5, SAVED_CURSORS_X
lwzx r3, r6, r4
stw r3, 0x0c(r27)
addi r6, r5, SAVED_CURSORS_Y
lwzx r3, r6, r4
stw r3, 0x10(r27)
b NATIVE_CURSOR_POS_DONE
NATIVE_SPAWN_DEFAULT:
lfs f30, 0x1c(r29)
lfs f31, 0x20(r29)
fadds f30, f30, f31
lfs f31, 128(r31)
fmuls f30, f30, f31
stfs f30, 0x0c(r27)
lfs f31, 132(r31)
stfs f31, 0x10(r27)
NATIVE_CURSOR_POS_DONE:
# Force the first visible token to use its assigned adapter-port label.
load r3, 0x804A0BD0
slwi r4, r30, 2
lwzx r3, r3, r4
li r4, 40
stb r4, 7(r3)
li r3, 1
slw r3, r3, r30
lbz r4, CSSDT_LOCAL_TEAMS_STATUS + LTS_JOINED(r28)
and. r3, r3, r4
bne NATIVE_CACHE_PORT
# Waiting cards have their native objects ready, but no visible hand/token.
load r3, 0x804A0BC0
slwi r4, r30, 2
lwzx r3, r3, r4
lwz r3, 0(r3)
lwz r3, 0x28(r3)
li r4, 0x10
branchl r12, JObj_SetFlagsAll
load r3, 0x804A0BD0
slwi r4, r30, 2
lwzx r3, r3, r4
lwz r3, 0(r3)
lwz r3, 0x28(r3)
li r4, 0x10
branchl r12, JObj_SetFlagsAll
NATIVE_CACHE_PORT:
# Cache three native leaf joints, original transforms, and pivot offsets.
lfs f27, CTD_ANCHOR_Y(r25)
li r27, 0
NATIVE_CACHE_JOINT:
li r5, 41 # background / character name
cmpwi r27, 0
beq NATIVE_CACHE_LOOKUP
li r5, 51 # character portrait
cmpwi r27, 1
beq NATIVE_CACHE_LOOKUP
li r5, 56 # team marker
NATIVE_CACHE_LOOKUP:
add r5, r5, r30
lwz r3, -0x49e0(r13)
addi r4, sp, 0x30
li r6, -1
branchl r12, JObj_GetJObjChild
lwz r3, 0x30(sp)
mulli r4, r30, 12
slwi r5, r27, 2
add r4, r4, r5
addi r5, r28, CSSDT_NATIVE_JOINTS
stwx r3, r5, r4
cmpwi r27, 0
bne NATIVE_CACHE_SKIP_Z
lwz r6, 0x40(r3)
slwi r7, r30, 2
addi r5, r28, CSSDT_NATIVE_ORIGINAL_Z
stwx r6, r5, r7
NATIVE_CACHE_SKIP_Z:
lwz r6, 0x38(r3)
addi r5, r28, CSSDT_NATIVE_ORIGINAL_X
stwx r6, r5, r4
lwz r6, 0x3C(r3)
addi r5, r28, CSSDT_NATIVE_ORIGINAL_Y
stwx r6, r5, r4
lwz r6, 0x2C(r3)
addi r5, r28, CSSDT_NATIVE_ORIGINAL_SX
stwx r6, r5, r4
lwz r6, 0x30(r3)
addi r5, r28, CSSDT_NATIVE_ORIGINAL_SY
stwx r6, r5, r4
lfs f30, CTD_FLOAT_0(r25)
fmr f25, f30
mr r6, r3
NATIVE_PIVOT_WALK:
cmpwi r6, 0
beq NATIVE_PIVOT_DONE
lfs f0, 0x38(r6)
fadds f30, f30, f0
lfs f0, 0x3C(r6)
fadds f25, f25, f0
lwz r6, 0x0C(r6)
b NATIVE_PIVOT_WALK
NATIVE_PIVOT_DONE:
fsubs f30, f30, f28
addi r5, r28, CSSDT_NATIVE_PIVOT_DX
stfsx f30, r5, r4
fsubs f25, f25, f27
addi r5, r28, CSSDT_NATIVE_PIVOT_DY
stfsx f25, r5, r4
addi r27, r27, 1
cmpwi r27, 3
blt NATIVE_CACHE_JOINT
NATIVE_INIT_NEXT:
addi r30, r30, 1
cmpwi r30, 4
blt NATIVE_INIT_PORT
addi r3, r28, CSSDT_CARD_PORT_TEXTS
li r4, 32
branchl r12, Zero_AreaLength
li r3, -1
stw r3, CSSDT_CARD_PORT_CACHE(r28)
lbz r29, CSSDT_LOCAL_TEAMS_STATUS + 1(r28)
subi r30, r29, 1
NATIVE_CARD_TEXT_LOOP:
cmpwi r30, 0
blt NATIVE_CARD_TEXT_DONE
load r3, 0x803F0E8C
mulli r4, r30, 12
lwzx r3, r3, r4
cmpwi r3, 0
beq NATIVE_CARD_TEXT_NEXT
lwz r3, 0(r3)
cmpwi r3, 0
beq NATIVE_CARD_TEXT_NEXT
lfs f29, 0x00(r3)
lfs f1, CTD_HALF_REF_BOX(r25)
fadds f29, f29, f1 # card_cx
lfs f28, 0x04(r3)
lfs f1, CTD_ANCHOR_TY_OFF(r25)
fadds f28, f28, f1 # anchor_ty
subi r3, r29, 1
slwi r4, r3, 2
addi r4, r4, CTD_CARD_SCALES
lfsx f25, r25, r4 # card scale
slwi r3, r3, 4
addi r3, r3, 64
slwi r4, r30, 2
add r3, r3, r4
lfsx f31, r31, r3
fadds f26, f29, f31 # new_cx = card_cx + shift
slwi r3, r30, 2
addi r4, r28, CSSDT_NATIVE_ORIGINAL_Z
lfsx f27, r4, r3
cmpwi r29, 2
ble NATIVE_CARD_Z_READY
slwi r3, r30, 2
lfsx f1, r25, r3
fadds f27, f27, f1
NATIVE_CARD_Z_READY:
li r3, 0
li r4, 0
branchl r12, Text_CreateStruct
mr r26, r3
cmpwi r26, 0
beq NATIVE_CARD_TEXT_NEXT
slwi r4, r30, 2
addi r5, r28, CSSDT_CARD_PORT_TEXTS
stwx r26, r5, r4
li r4, 0
stb r4, 0x48(r26)
stb r4, 0x4A(r26)
li r4, 1
stb r4, 0x49(r26)
stb r4, 0x4C(r26)
stb r4, 0x4D(r26) # drawn inside DrawNativeLocalTeams per-card pass
lwz r4, CTD_COLOR_PORT(r25)
stw r4, 0x30(r26) # text_color RGBA (Text_ChangeTextColor leaves alpha at 0xFF)
lfs f2, CTD_PORT_REL_X(r25)
fmadds f1, f25, f2, f26
stfs f1, 0x00(r26)
subi r3, r29, 1
slwi r4, r3, 2
addi r4, r4, CTD_PORT_Y_OFFS
lfsx f2, r25, r4
fadds f1, f28, f2
stfs f1, 0x04(r26)
lfs f1, CTD_PORT_Z_OFF(r25)
fadds f1, f27, f1
stfs f1, 0x08(r26)
lfs f1, CTD_PORT_SCALE_X(r25)
fmuls f1, f1, f25
stfs f1, 0x24(r26)
lfs f1, CTD_PORT_SCALE_Y(r25)
fmuls f1, f1, f25
stfs f1, 0x28(r26)
mr r3, r26
addi r4, r25, CTD_STR_EMPTY
lfs f1, CTD_FLOAT_0(r25)
lfs f2, CTD_FLOAT_0(r25)
branchl r12, Text_InitializeSubtext
mr r23, r3
mr r3, r26
mr r4, r23
lfs f1, CTD_FLOAT_1(r25)
lfs f2, CTD_FLOAT_1(r25)
branchl r12, Text_UpdateSubtextSize
mr r3, r26
mr r4, r23
addi r5, r25, CTD_COLOR_PORT
branchl r12, Text_ChangeTextColor
addi r3, r30, CSSDT_LOCAL_TEAMS_STATUS + LTS_PORTS
lbzx r6, r28, r3
cmplwi r6, 4
blt NATIVE_CARD_PORT_NUM_READY
mr r6, r30
NATIVE_CARD_PORT_NUM_READY:
addi r6, r6, 1
addi r3, r28, CSSDT_CARD_PORT_CACHE
stbx r6, r3, r30
mr r3, r26
mr r4, r23
addi r5, r25, CTD_STR_PORT_FMT
branchl r12, Text_UpdateSubtextContents
li r3, 0
li r4, 0
branchl r12, Text_CreateStruct
mr r26, r3
cmpwi r26, 0
beq NATIVE_CARD_TEXT_NEXT
slwi r4, r30, 2
addi r5, r28, CSSDT_CARD_NAME_TEXTS
stwx r26, r5, r4
li r4, 1
stb r4, 0x48(r26)
stb r4, 0x49(r26)
stb r4, 0x4A(r26)
stb r4, 0x4C(r26)
stb r4, 0x4D(r26) # drawn inside DrawNativeLocalTeams per-card pass
lfs f2, CTD_NAME_REL_X(r25)
fmadds f1, f25, f2, f26
stfs f1, 0x00(r26)
lfs f2, CTD_NAME_REL_Y(r25)
fmadds f1, f25, f2, f28
stfs f1, 0x04(r26)
lfs f1, CTD_NAME_Z_OFF(r25)
fadds f1, f27, f1
stfs f1, 0x08(r26)
lfs f1, CTD_NAME_BOX_W(r25)
stfs f1, 0x0C(r26)
lfs f1, CTD_NAME_BOX_H(r25)
stfs f1, 0x10(r26)
lfs f1, CTD_NAME_SCALE(r25)
fmuls f1, f1, f25
stfs f1, 0x24(r26)
stfs f1, 0x28(r26)
mulli r22, r30, LOCAL_TEAMS_NAME_SIZE
addi r22, r22, CSSDT_LOCAL_TEAMS_NAMES
add r22, r28, r22
li r24, 0
NATIVE_CARD_NAME_SUBTEXT_LOOP:
slwi r3, r24, 3
addi r3, r3, CTD_OUTLINE_OFFS
add r4, r25, r3
lfs f1, 0(r4)
lfs f2, 4(r4)
lfs f0, CTD_NAME_SUB_X(r25)
fadds f1, f0, f1
mr r3, r26
addi r4, r25, CTD_STR_EMPTY
branchl r12, Text_InitializeSubtext
mr r23, r3
mr r3, r26
mr r4, r23
lfs f1, CTD_FLOAT_1(r25)
lfs f2, CTD_FLOAT_1(r25)
branchl r12, Text_UpdateSubtextSize
mr r3, r26
mr r4, r23
addi r5, r25, CTD_COLOR_BLACK
cmpwi r24, 4
blt NATIVE_CARD_NAME_COLOR_READY
addi r5, r25, CTD_COLOR_WHITE
NATIVE_CARD_NAME_COLOR_READY:
branchl r12, Text_ChangeTextColor
mr r3, r26
mr r4, r23
addi r5, r25, CTD_STR_NAME_FMT
mr r6, r22
branchl r12, Text_UpdateSubtextContents
addi r24, r24, 1
cmpwi r24, 5
blt NATIVE_CARD_NAME_SUBTEXT_LOOP
NATIVE_CARD_TEXT_NEXT:
subi r30, r30, 1
b NATIVE_CARD_TEXT_LOOP
NATIVE_CARD_TEXT_DONE:
li r3, 1
stb r3, CSSDT_NATIVE_INITIALIZED(r28)
lbz r3, CSSDT_LOCAL_TEAMS_STATUS + 1(r28)
stb r3, CSSDT_NATIVE_VISIBLE_COUNT(r28) # commit layout with the newly spawned fields/cursors
# Clear CSSDT_LOADING and saved cursor mask first so any subsequent VI-retrace
# IRQ immediately remaps physical ports into logical slots 0..count-1.
li r3, 0
load r4, CSS_SAVED_CURSORS_ADDR
stw r3, SAVED_CURSORS_MASK(r4)
stb r3, CSSDT_LOADING(r28)
# Discard raw unremapped pad frames queued while CSSDT_LOADING was 1, and prime
# HSD_PadMasterStatus / HSD_PadCopyStatus so skipped physical ports never read
# err != 0 on Frame 0 (which makes mnCharSel_CursorThink convert them to CPU).
li r3, 1 # HSD_PAD_FLUSH_QUEUE_THROWAWAY
branchl r12, HSD_PadFlushQueue
li r30, 0
lbz r27, CSSDT_LOCAL_TEAMS_STATUS + 1(r28)
NATIVE_INIT_PAD_STATUS:
mulli r29, r30, 0x44
load r3, 0x804C1FAC # HSD_PadMasterStatus
add r3, r3, r29
li r4, 0x44
branchl r12, Zero_AreaLength
load r3, 0x804C20BC # HSD_PadCopyStatus
add r3, r3, r29
li r4, 0x44
branchl r12, Zero_AreaLength
cmpw r30, r27
blt NATIVE_INIT_PAD_NEXT
li r4, -1 # PAD_ERR_NO_CONTROLLER for closed unused slots
load r3, 0x804C1FAC
add r3, r3, r29
stb r4, 0x41(r3)
load r3, 0x804C20BC
add r3, r3, r29
stb r4, 0x41(r3)
NATIVE_INIT_PAD_NEXT:
addi r30, r30, 1
cmpwi r30, 4
blt NATIVE_INIT_PAD_STATUS
b DONE

NATIVE_CLEAR_LOADING:
li r3, 0
load r4, CSS_SAVED_CURSORS_ADDR
stw r3, SAVED_CURSORS_MASK(r4)
stb r3, CSSDT_LOADING(r28)
DONE:
restore BKP_DEFAULT_FREE_SPACE_SIZE, 7
lmw r17, 0x11c(sp) # original instruction
