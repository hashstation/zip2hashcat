# Common variables
CFLAGS = -g -O2
TARGET = zip2hashcat

# Detect platform
UNAME_S := $(shell uname -s)

# Default target and compiler based on platform
ifeq ($(UNAME_S), Linux)
    PLATFORM = linux
    CC = gcc
    LDFLAGS = -static
else ifeq ($(UNAME_S), Darwin)
    PLATFORM = mac
    CC = gcc
    LDFLAGS =
else ifeq ($(findstring MINGW,$(UNAME_S)),MINGW)
    PLATFORM = windows
    CC = x86_64-w64-mingw32-gcc
    LDFLAGS = -static
endif

# Command line override for platform
PLATFORM ?= $(PLATFORM)

# Platform-specific settings
ifeq ($(PLATFORM), linux)
    TARGET_EXEC = $(TARGET)_linux
else ifeq ($(PLATFORM), mac)
    TARGET_EXEC = $(TARGET)_mac
else ifeq ($(PLATFORM), windows)
    TARGET_EXEC = $(TARGET)_windows
endif

# List of source files
SOURCES = $(TARGET).c

# Default target
all: $(PLATFORM)

linux: $(TARGET)_linux
mac: $(TARGET)_mac
windows: $(TARGET)_windows

# Build targets for each platform
$(TARGET)_linux: $(SOURCES)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $(TARGET)

$(TARGET)_mac: $(SOURCES)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $(TARGET)

$(TARGET)_windows: $(SOURCES)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $(TARGET).exe

.PHONY: clean
clean:
	rm -f $(TARGET) $(TARGET).exe $(TARGET)_linux $(TARGET)_mac $(TARGET)_windows
