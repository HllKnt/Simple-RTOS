#####
# qemu gdb
#####
# bash close-qemu.sh
# qemu-system-arm -nographic -M netduino2 -kernel ../build/bin/target.bin -s -S &
# arm-none-eabi-gdb ../build/bin/target -q -x gdbinit
# bash close-qemu.sh
#####

#####
# st-link(st-util) gdb  
#####
arm-none-eabi-gdb ../build/bin/target -q -x gdbinit
#####
