ASM = rgbasm
LINKER = rgblink
FIX = rgbfix
BUILD_DIR = build
OUTPUT_DIR = ..
SRC = $(wildcard *.asm)
OBJS = $(SRC:.asm=.o)

GAME_NAME = hello-world


all: clean build link fix

build:
	mkdir $(BUILD_DIR)
	$(ASM) -o $(BUILD_DIR)/$(OBJS) $(SRC)

link:
	$(LINKER) -o $(OUTPUT_DIR)/$(GAME_NAME).gb $(BUILD_DIR)/$(OBJS)

fix:
	$(FIX) -v -p 0 $(OUTPUT_DIR)/$(GAME_NAME).gb

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OUTPUT_DIR)/$(GAME_NAME).gb
