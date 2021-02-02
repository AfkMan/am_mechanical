ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OPENSCADPATH=/home/andrew/Hobby/3D/

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

all: board.stl;

%.stl: %.scad
	openscad -m make -o build/$@ -d build/$@.deps $<
