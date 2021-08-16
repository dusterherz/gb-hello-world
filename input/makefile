ASM = rgbasm
LINKER = rgblink
FIX = rgbfix
BUILD_DIR = build
OUTPUT_DIR = .
SRC = $(wildcard *.asm)
OBJS = $(SRC:.asm=.o)

GAME_NAME = input


all: clean build link fix

build:
	mkdir $(BUILD_DIR)
	$(ASM) -Werror -Weverything -o $(BUILD_DIR)/$(OBJS) $(SRC) 

link:
	$(LINKER) -o $(OUTPUT_DIR)/$(GAME_NAME).gb $(BUILD_DIR)/$(OBJS) -n $(OUTPUT_DIR)/$(GAME_NAME).sym -m $(OUTPUT_DIR)/$(GAME_NAME).map

fix:
	$(FIX) -v -p 0 $(OUTPUT_DIR)/$(GAME_NAME).gb

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OUTPUT_DIR)/$(GAME_NAME).gb
