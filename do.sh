#!/bin/sh

VERSION=1.0.1
MINECRAFT_VERSION=1.21.3

DATAPACK_ZIP_NAME="elytra-chestplates-${VERSION}-${MINECRAFT_VERSION}.zip"
RESOURCEPACK_ZIP_NAME="Elytra Chestplates ${VERSION} ${MINECRAFT_VERSION}.zip"
BUILD_DIRECTORY="build"

print_info() {
	printf "\e[1;35m$1\e[0m - \e[0;37m$2\e[0m\n"
}

help() {
	print_info help "Display callable targets"
	print_info build "Create a datapack and resourcepack zip file"
	print_info clean "Remove build artifacts"
}

build() {
	local datapack_root_directory="datapack"
	local resourcepack_root_directory="resourcepack"
	clean
	mkdir ${BUILD_DIRECTORY}
	cd ${datapack_root_directory}
	zip -q -r "../${BUILD_DIRECTORY}/${DATAPACK_ZIP_NAME}" data pack.mcmeta pack.png
	cd ..
	cd ${resourcepack_root_directory}
	zip -q -r "../${BUILD_DIRECTORY}/${RESOURCEPACK_ZIP_NAME}" assets pack.mcmeta pack.png
	cd ..
}

clean() {
	rm -rf ${BUILD_DIRECTORY}
}

if [ ${1:+x} ]; then
	$1
else
	help
fi
