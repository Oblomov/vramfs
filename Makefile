CPPFLAGS_FUSE != pkg-config fuse --cflags
LDLIBS_FUSE != pkg-config fuse --libs

CPPFLAGS = -Iinclude/ $(CPPFLAGS_FUSE)

LDFLAGS = -flto
LDLIBS = $(LDLIBS_FUSE) -lOpenCL

CXXFLAGS_DEBUG_1 = -g -DDEBUG
CXXFLAGS_DEBUG_0 = -march=native -O2

DEBUG ?= 0

CXXFLAGS = -Wall -Wpedantic -Werror -std=c++11
CXXFLAGS += $(CXXFLAGS_DEBUG_${DEBUG})

bin/vramfs: build/util.o build/memory.o build/entry.o build/file.o build/dir.o build/symlink.o build/vramfs.o | bin
	$(LINK.cc) -o $@ $^ $(LDLIBS)

build bin:
	@mkdir -p $@

build/%.o: src/%.cpp | build
	$(COMPILE.cc) -o $@ $<

.PHONY: clean
clean:
	rm -rf build/ bin/
