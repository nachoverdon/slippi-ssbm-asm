################################################################################
# Address: 0x8034ded8 # PADControlMotor
################################################################################

.include "Common/Common.s"
.include "Online/Online.s"

# Execute replaced code line
addi r29, r3, 0

# Check if online in-game
getMinorMajor r3
cmpwi r3, SCENE_ONLINE_IN_GAME
bne EXIT

# This function will output whether to change r29 to redirect rumble control
# messages to a different controller
################################################################################
# Function: RedirectPort
#-------------------------------------------------------------------------------
# Outputs:
# r3 - The port to redirect rumble signal to
################################################################################
.set REG_ODB_ADDRESS, 31
.set REG_RUMBLE_PORT, 29

backup

# fetch data to use throughout function
lwz REG_ODB_ADDRESS, OFST_R13_ODB_ADDR(r13) # data buffer address
cmpwi REG_ODB_ADDRESS, 0
beq SKIP_RUMBLE

# Validate Melee slot index (0..3)
cmplwi REG_RUMBLE_PORT, 4
bge SKIP_RUMBLE

# Look up physical controller port + 1 (0 = remote/no rumble, 1..4 = controller port 0..3)
addi r3, REG_ODB_ADDRESS, ODB_RUMBLE_PORT_MAP
lbzx r3, r3, REG_RUMBLE_PORT
cmpwi r3, 0
beq SKIP_RUMBLE
cmplwi r3, 4
bgt SKIP_RUMBLE

# Convert port+1 back to 0-based controller port in r3 (preserved across restore)
subi r3, r3, 1

RESTORE:
restore

# Move new port output to r29
mr r29, r3
b EXIT

SKIP_RUMBLE:
# If this rumble instruction is not for a local player, just exit PADControlMotor
restore
branch r12, 0x8034df44

EXIT:
