PROJECT=
SOURCES=$(PROJECT).c
MMCU=atmega328p
F_CPU=16000000UL

CFLAGS=-mmcu=$(MMCU) -DF_CPU=$(F_CPU) -Os -c -o

$(PROJECT).hex: $(PROJECT).o
	avr-gcc -mmcu=$(MMCU) $(PROJECT).o -o $(PROJECT)
	avr-objcopy -O ihex -R .eeprom $(PROJECT) $(PROJECT).hex

$(PROJECT).o: $(SOURCES)
	avr-gcc $(CFLAGS) $(PROJECT).o $(SOURCES)

all-in-one: $(PROJECT).hex
	"C:\Program Files (x86)\Arduino\hardware\tools\avr\bin\avrdude.exe" -F -V -C "C:\Program Files\avrdude\avrdude.conf" -c arduino -p ATMEGA328P -P COM5 -b 115200 -U flash:w:$(PROJECT).hex