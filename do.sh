#!/bin/sh

VERSION=1.0.1
MINECRAFT_VERSION=1.21.3

ZIP_NAME="elytra-chestplates-${VERSION}-${MINECRAFT_VERSION}.zip"

print_info() {
	printf "\e[1;35m$1\e[0m - \e[0;37m$2\e[0m\n"
}

help() {
	print_info help "Display callable targets"
	print_info build "Create a datapack zip file"
	print_info clean "Remove build artifacts"
}

build() {
	local root_directory="datapack"
	clean
	cd ${root_directory}
	zip -q -r "../${ZIP_NAME}" data pack.mcmeta pack.png
	cd ..
}

clean() {
	rm -f ${ZIP_NAME}
}

if [ ${1:+x} ]; then
	$1
else
	help
fi
