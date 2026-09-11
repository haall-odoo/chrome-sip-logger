.PHONY: default build clean
.SILENT:

default: build

build:
	@echo "Compiling source files..."
	@sudo mk-build-deps -i -r debian/control
	@echo "Dependencies loaded"


clean:
	@echo "Cleaning source build artifacts..."