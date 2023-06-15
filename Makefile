AS = nasm
ASFLAGS = -f elf64 -g
LD = ld
LDFLAGS =
SOURCES = $(wildcard *.asm)
OBJECTS = $(SOURCES:.asm=.o)
EXECUTABLE = arun

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf *.o $(EXECUTABLE)
