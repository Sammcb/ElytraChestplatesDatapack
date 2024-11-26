if [ ! -d "${build_directory}" ]; then
	echo "Build directory '${build_directory}' not found, skipping clean..."
	exit 0
fi

echo "Deleting build directory '${build_directory}'..."

rm -r "${build_directory}"
