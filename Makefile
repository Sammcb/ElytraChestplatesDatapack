.PHONY: build build-datapack build-resourcepack clean lint
.DEFAULT_GOAL: build

DATAPACK_ZIP_NAME := elytra-chestplates.zip
RESOURCEPACK_ZIP_NAME := ElytraChestplates.zip

build: build-datapack build-resourcepack

build-datapack: clean
	(cd datapack && zip -q -r "../$(DATAPACK_ZIP_NAME)" data pack.mcmeta pack.png)

build-resourcepack:
	(cd resourcepack && zip -q -r "../$(RESOURCEPACK_ZIP_NAME)" assets pack.mcmeta pack.png)

clean:
	rm -f $(DATAPACK_ZIP_NAME)
	rm -f $(RESOURCEPACK_ZIP_NAME)

lint:
	zizmor .
	editorconfig-checker
	flake-checker --no-telemetry
	nix flake check
