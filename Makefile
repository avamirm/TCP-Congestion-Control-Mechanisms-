CC = g++
BUILD_DIR = build
SRC_DIR = src
INCLUDE_DIR = include
CFLAGS = -std=c++17 -I$(INCLUDE_DIR)

EXE_FILE = main.out

OBJECTS = $(BUILD_DIR)/BBR.o $(BUILD_DIR)/tcpNewReno.o $(BUILD_DIR)/tcpReno.o $(BUILD_DIR)/tcpConnection.o  $(BUILD_DIR)/main.o

all: $(BUILD_DIR) $(EXE_FILE)

$(EXE_FILE): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $(EXE_FILE)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/main.o: $(SRC_DIR)/main.cpp $(INCLUDE_DIR)/tcpConnection.hpp $(INCLUDE_DIR)/tcpReno.hpp $(INCLUDE_DIR)/tcpNewReno.hpp $(INCLUDE_DIR)/BBR.hpp
	$(CC) $(CFLAGS) -c $(SRC_DIR)/main.cpp -o $(BUILD_DIR)/main.o

$(BUILD_DIR)/tcpConnection.o: $(SRC_DIR)/tcpConnection.cpp $(INCLUDE_DIR)/tcpConnection.hpp
	$(CC) $(CFLAGS) -c $(SRC_DIR)/tcpConnection.cpp -o $(BUILD_DIR)/tcpConnection.o

$(BUILD_DIR)/tcpReno.o: $(SRC_DIR)/tcpReno.cpp $(INCLUDE_DIR)/tcpReno.hpp $(INCLUDE_DIR)/tcpConnection.hpp
	$(CC) $(CFLAGS) -c $(SRC_DIR)/tcpReno.cpp -o $(BUILD_DIR)/tcpReno.o

$(BUILD_DIR)/tcpNewReno.o: $(SRC_DIR)/tcpNewReno.cpp $(INCLUDE_DIR)/tcpNewReno.hpp $(INCLUDE_DIR)/tcpConnection.hpp
	$(CC) $(CFLAGS) -c $(SRC_DIR)/tcpNewReno.cpp -o $(BUILD_DIR)/tcpNewReno.o

$(BUILD_DIR)/BBR.o: $(SRC_DIR)/BBR.cpp $(INCLUDE_DIR)/BBR.hpp $(INCLUDE_DIR)/tcpConnection.hpp
	$(CC) $(CFLAGS) -c $(SRC_DIR)/BBR.cpp -o $(BUILD_DIR)/BBR.o

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) *.o *.out
