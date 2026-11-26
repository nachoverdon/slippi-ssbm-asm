# Address: 0x80261B8C # VS cursor's team-button hit test.
.include "Common/Common.s"
.include "Online/Online.s"
getMinorMajor r12
cmpwi r12, SCENE_ONLINE_CSS
bne EXIT
loadwz r12, CSSDT_BUF_ADDR
lbz r11, CSSDT_LOCAL_TEAMS_STATUS + LTS_NATIVE(r12)
cmpwi r11, 0
beq EXIT
# Keyboard A/confirm edges must never edit a previously captured team. The
# primary pad stays live for code entry and CSS can resume before the next poll.
lbz r11, -0x49aa(r13)
cmpwi r11, 0
bne SKIP_TEAM_CHANGE
lbz r11, CSSDT_LOCAL_TEAMS_STATUS + 5(r12) # selecting only
cmpwi r11, 0
bne SKIP_TEAM_CHANGE
# Keep each confirmed player's menu team equal to the pick sent to Slippi.
# Other unready locals can still choose their own team before pressing Start.
lbz r12, CSSDT_LOCAL_TEAMS_STATUS + 4(r12) # confirmed player mask
lbz r11, 4(r31)
srw r12, r12, r11
andi. r12, r12, 1
bne SKIP_TEAM_CHANGE
lbz r12, 4(r31) # this native cursor's logical index
mulli r12, r12, 36
load r11, 0x803F0DFC
add r12, r12, r11
cmpw r12, r25 # this cursor can only change its own team
bne SKIP_TEAM_CHANGE
lfs f1, 0x0c(r31)
lfs f0, 0x1c(r25)
fcmpo cr0, f1, f0
ble SKIP_TEAM_CHANGE
lfs f0, 0x20(r25)
fcmpo cr0, f1, f0
bge SKIP_TEAM_CHANGE
loadwz r12, CSSDT_BUF_ADDR
lbz r11, 4(r31)
slwi r11, r11, 2
addi r12, r12, CSSDT_NATIVE_TEAM_TOP_Y
lfsx f0, r12, r11
lfs f1, 0x10(r31)
fcmpo cr0, f1, f0
bge SKIP_TEAM_CHANGE
addi r12, r12, CSSDT_NATIVE_TEAM_BOT_Y - CSSDT_NATIVE_TEAM_TOP_Y
lfsx f0, r12, r11
fcmpo cr0, f1, f0
ble SKIP_TEAM_CHANGE
branch r12, 0x80261BBC # full card hitbox matched; cycle team without snapping cursor Y
SKIP_TEAM_CHANGE:
branch r12, 0x80261BFC
EXIT:
lfs f0, 0x1c(r25) # original instruction
