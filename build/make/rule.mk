.DEFAULT_GOAL := all
all : ${TARGET}.elf ${TARGET}.bin move

${TARGET}.elf : ${OBJS}
	@${LD} $^ -T ./layout.ld -o $@ 

${TARGET}.bin : ${TARGET}.elf
	@${OBJCOPY} -O binary $< $@	

%.o : %.s
	@${AS} $< -mcpu=cortex-m3 -mthumb -g -o $@ 

%.o : %.c
	@${CC} $< -mcpu=cortex-m3 -mthumb -g -nostartfiles -c -o $@  

move:
	@mkdir -p ${OUTPUT_PATH}
	@mv *.o *.elf *.bin -t ${OUTPUT_PATH}
.PHONY : move

debug : all
	@echo "completely shutdown qemu"
	@bash ./close-qemu.sh
	@echo "restart qemu"
	@${QEMU} -M stm32vldiscovery -nographic -kernel ${OUTPUT_PATH}/${TARGET}.bin -s -S & 
	@${GDB} ${OUTPUT_PATH}/${TARGET}.elf -q -x ./gdbinit
	@echo "completely shutdown qemu"
	@bash ./close-qemu.sh
.PHONY : debug

readelf : obj= 
readelf : 
ifeq (${obj},)
	@echo "need to specify the object, use command \"make $@ file\""
else
	@${READELF} ${obj} -SW
endif
.PHONY : readelf

objdump : obj=
objdump :  
ifeq (${obj},)
	@echo "need to specify the object, use command \"make $@ file\""
else
	@${OBJDUMP} ${obj} -S 
endif
.PHONY : objdump

clean : 
	@rm -rf ${OUTPUT_PATH}
.PHONY : clean
