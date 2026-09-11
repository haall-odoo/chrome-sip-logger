.PHONY: all clean deps

BUILD_DIR = build
SRC_PATH = src

all: deps
	@echo "Building the chromesiplogger debian package..."
	cd ./$(SRC_PATH) && debuild --no-lintian -us -uc -ui -b
	@echo "Now running lintian..."
	-lintian *.changes
	@echo "Finished running lintian."
	@mkdir -p $(BUILD_DIR)
	@mv *.deb $(BUILD_DIR)/
	@rm -f *.build *.buildinfo *.changes *.dsc *.tar.xz
	@$(MAKE) clean
	@echo "chromesiplogger built and moved to $(BUILD_DIR)"

deps:
	sudo mk-build-deps -i -r $(SRC_PATH)/debian/control

clean:
	cd ./$(SRC_PATH) && fakeroot debian/rules clean