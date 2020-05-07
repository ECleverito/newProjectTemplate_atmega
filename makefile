PROJECT=

GCC = avr-gcc
MMCU = atmega328p
F_CPU = 16000000UL

CFLAGS = -mmcu=$(MMCU) -DF_CPU=$(F_CPU) -Os -c -o

VPATH = src:.\myLibs\

#MYLIBS is a list of the source files in the "myLibs\" common tools folder.
#It is an environmental variable that must be defined somehow prior to using
#the make tool. A good way to do this is by adding this action to the appropriate
#".profile" file of the shell being used.
ifdef MYLIBS
DEPS = $(MYLIBS)
else
DEPS = uart.o eepromIO.o
endif

$(PROJECT).hex: $(PROJECT).o uart.o eepromIO.o
	$(GCC) -mmcu=$(MMCU) $(PROJECT).o $(DEPS) -o $(PROJECT)
	avr-objcopy -O ihex -R .eeprom $(PROJECT) $@

$(PROJECT).o: $(DEPS)
	$(GCC) $(CFLAGS) $@ $(PROJECT).c
	
%.o:%.c
	$(GCC) $(CFLAGS) $@ $<

all-in-one: $(PROJECT).hex
	"C:\Program Files (x86)\Arduino\hardware\tools\avr\bin\avrdude.exe" -F -V -C "C:\Program Files\avrdude\avrdude.conf" -c arduino -p ATMEGA328P -P COM5 -b 115200 -U flash:w:$(PROJECT).hex

ifndef PSModulePath
clean:
	-rm *.o *.hex
endif
