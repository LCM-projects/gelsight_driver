BUILD_DIR = build

CFLAGS_MAIN += `pkg-config --cflags opencv`
LIBS_MAIN += `pkg-config --libs opencv`
LIB_OBJS = $(addprefix $(BUILD_DIR)/, CaptureFrm.o MarkerTrack.o VideoRecord.o WindowDisplay.o)


CFLAGS_DRIVER += `pkg-config --cflags opencv lcm bot2-core`
LIBS_DRIVER += `pkg-config --libs opencv lcm bot2-core`

all: prepare $(LIB_OBJS) $(BUILD_DIR)/main $(BUILD_DIR)/gelsight_depth_driver $(BUILD_DIR)/groundtruth_gen $(BUILD_DIR)/sphere_groundtruth_gen $(BUILD_DIR)/lookup_gen $(BUILD_DIR)/compare_heightmaps

$(BUILD_DIR)/main: $(LIB_OBJS) main.cpp
	g++ -O2 $(CFLAGS_MAIN) $(INCLUDES_MAIN) main.cpp $(LIB_OBJS) $(LIBS_MAIN)  -o $@

$(BUILD_DIR)/gelsight_depth_driver: gelsight_depth_driver.cpp
	g++ -O2 $(CFLAGS_DRIVER) $(INCLUDES_DRIVER) gelsight_depth_driver.cpp $(LIBS_DRIVER) -o $@

$(BUILD_DIR)/groundtruth_gen: gelsight_groundtruth_gen.cpp
	g++ -O2 $(CFLAGS_DRIVER) $(INCLUDES_DRIVER) gelsight_groundtruth_gen.cpp $(LIBS_DRIVER) -o $@

$(BUILD_DIR)/sphere_groundtruth_gen: gelsight_sphere_depth_gen.cpp
	g++ -O2 $(CFLAGS_DRIVER) $(INCLUDES_DRIVER) gelsight_sphere_depth_gen.cpp $(LIBS_DRIVER) -o $@

$(BUILD_DIR)/lookup_gen: gelsight_lookup_gen.cpp
	g++ -O2 $(CFLAGS_DRIVER) $(INCLUDES_DRIVER) gelsight_lookup_gen.cpp $(LIBS_DRIVER) -o $@

$(BUILD_DIR)/compare_heightmaps: gelsight_compare_heightmaps.cpp
	g++ -O2 $(CFLAGS_DRIVER) $(INCLUDES_DRIVER) gelsight_compare_heightmaps.cpp $(LIBS_DRIVER) -o $@

$(BUILD_DIR)/%.o: %.cpp
	g++ -O2 -c -std=c++11 $(CFLAGS) $(INCLUDES) $< -o $@

prepare:
	@mkdir -p build

.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR)
