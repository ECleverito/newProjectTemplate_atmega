PROJECT=

GCC = avr-gcc
MMCU = atmega328p
F_CPU = 16000000UL

CFLAGS = -mmcu=$(MMCU) -DF_CPU=$(F_CPU) -Os -c -o

DEPS = uart.o eepromIO.o

$(PROJECT).hex: $(PROJECT).o uart.o eepromIO.o
	$(GCC) -mmcu=$(MMCU) $(PROJECT).o $(DEPS) -o $(PROJECT)
	avr-objcopy -O ihex -R .eeprom $(PROJECT) $@

$(PROJECT).o: $(DEPS)
	$(GCC) $(CFLAGS) $@ $(PROJECT).c
	
%.o:%.c
	$(GCC) $(CFLAGS) $@ $<

all-in-one: $(PROJECT).hex
	"C:\Program Files (x86)\Arduino\hardware\tools\avr\bin\avrdude.exe" -F -V -C "C:\Program Files\avrdude\avrdude.conf" -c arduino -p ATMEGA328P -P COM5 -b 115200 -U flash:w:$(PROJECT).hex

clean:
	-rm *.o *.hex
