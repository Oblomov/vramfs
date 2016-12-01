CPPFLAGS = -Iinclude/ $(shell pkg-config fuse --cflags)
CXXFLAGS = -Wall -Wpedantic -Werror -std=c++11

LDFLAGS = -flto
LDLIBS = $(shell pkg-config fuse --libs) -lOpenCL

ifeq ($(DEBUG), 1)
	CXXFLAGS += -g -DDEBUG
else
	CXXFLAGS += -march=native -O2
endif

bin/vramfs: build/util.o build/memory.o build/entry.o build/file.o build/dir.o build/symlink.o build/vramfs.o | bin
	$(LINK.cc) -o $@ $^ $(LDLIBS)

build bin:
	@mkdir -p $@

build/%.o: src/%.cpp | build
	$(COMPILE.cc) -o $@ $<

.PHONY: clean
clean:
	rm -rf build/ bin/
