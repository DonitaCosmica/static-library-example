# Nombre de los archivos fuente y libreria
SOURCE = main.c
OBJ_1 = motor.c
OBJ_2 = led.c

# Directorios de archivos generados
BUILD_DIR = build
LIB_DIR = lib
LIB_NAME = process
INCLUDE_DIR = include
SRC_DIR = src

# Configuracion del programador
PROGRAMMER = arduino
PORT = /dev/ttyACM0

# Opciones de compilacon
CC = avr-gcc
OBJCOPY = avr-objcopy
MMCU = atmega328p
F_CPU = 16000000UL
CFLAGS = -Os -DF_CPU=$(F_CPU) -mmcu=$(MMCU) -Wall
LDFLAGS = -mmcu=$(MMCU)

# Nombre del archivo de salida
OUTPUT = main

# Archivos objeto generados
OBJ_1_FILE = $(BUILD_DIR)/$(OBJ_1:.c=.o)
OBJ_2_FILE = $(BUILD_DIR)/$(OBJ_2:.c=.o)

# Librearia estatica dependiendo del SO detectado
# ifeq ($(OS), Windows_NT)
#		LIBRARY = $(LIB_DIR)/lib$(LIB_NAME).lib
# else
#		LIBRARY = $(LIB_DIR)/lib$(LIB_NAME).a
# endif
LIBRARY = $(LIB_DIR)/lib$(LIB_NAME).$(if $(filter Windows_NT, $(OS)),lib,a)

# Compilacion principal
all: create_build_folder $(BUILD_DIR)/$(OUTPUT).hex

$(BUILD_DIR)/$(OUTPUT).hex: $(BUILD_DIR)/$(OUTPUT).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# Crear archivo de enlace para crear un enlace entre la libreria y el codigo principal
$(BUILD_DIR)/$(OUTPUT).elf: $(BUILD_DIR)/$(OUTPUT).o $(LIBRARY)
	$(CC) $(LDFLAGS) -o $@ $< -L$(LIB_DIR) -l$(LIB_NAME)

$(BUILD_DIR)/$(OUTPUT).o: $(SOURCE)
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c -o $@ $<

# Generar libreria estatica a partir de los anteriores archivos objeto
$(LIBRARY): $(OBJ_1_FILE) $(OBJ_2_FILE)
	mkdir -p $(LIB_DIR)
	ar rcs $@ $^

# Archivos objeto para incluir en la libreria
$(OBJ_1_FILE): $(SRC_DIR)/$(OBJ_1)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_2_FILE): $(SRC_DIR)/$(OBJ_2)
	$(CC) $(CFLAGS) -c -o $@ $<

# "make flash" transfiere el archivo .hex al arduino para que este sea ejecutado en el mismo
flash: $(BUILD_DIR)/$(OUTPUT).hex
	avrdude -c $(PROGRAMMER) -p $(MMCU) -P $(PORT) -U flash:w:$<

# Crear la carpeta de compilación (build) si no existe
create_build_folder:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*
	rm -f $(LIBRARY)

# Palabras clave de makefile para que no sean confundidas con algun archivo o carpeta
.PHONY: all flash create_build_folder clean
