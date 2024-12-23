{
	description = "Elytra chestplates datapack and resourcepack";

	inputs = {
		# Commit does not correspond to a tag.
		# Updating to latest commit generally follows unstable branch.
		nixpkgs.url = "github:NixOS/nixpkgs/0e2d2f87f0f61065ee6ccb979a1213691e74dbac";
		# Commit does not correspond to a tag.
		flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";
		flake-checker = {
			# Commit corresponds to tag v0.2.3.
			url = "github:DeterminateSystems/flake-checker/ca7cfb3bb7cc7d758a4ed0766a16e5e3ae7b6762";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {self, nixpkgs, flake-utils, flake-checker}: flake-utils.lib.eachDefaultSystem (system:
		let
			pkgs = import nixpkgs {inherit system;};
			lib = pkgs.lib;

			buildDirectory = ".build";
			datapackName = "elytra-chestplates";
			resourcepackName = "Elytra Chestplates";
			version = "1.1.0";
			minecraftVersion = "1.21.4";

			buildScript = pkgs.writeShellApplication {
				name = "build";
				runtimeInputs = with pkgs; [zip];
				text = lib.strings.concatStringsSep "\n" [
					"build_directory='${buildDirectory}'"
					"datapack_name='${datapackName}'"
					"resourcepack_name='${resourcepackName}'"
					"version='${version}'"
					"minecraft_version='${minecraftVersion}'"
					"${builtins.readFile ./commands/build.sh}"
				];
			};

			flakeCheckerPackage = flake-checker.packages.${system}.default;
		in {
			devShells.default = pkgs.mkShell {
				nativeBuildInputs = [flakeCheckerPackage] ++ (with pkgs; [zip editorconfig-checker zizmor]);
			};

			devShells.zizmor = pkgs.mkShell {
				nativeBuildInputs = with pkgs; [zizmor];
			};

			checks = {
				editorconfig = pkgs.stdenvNoCC.mkDerivation {
					name = "editorconfig-lint";
					src = self;
					dontBuild = true;
					doCheck = true;
					nativeBuildInputs = with pkgs; [editorconfig-checker];
					checkPhase = "editorconfig-checker";
					installPhase = "touch $out";
				};

				zizmor = pkgs.stdenvNoCC.mkDerivation {
					name = "zizmor";
					src = self;
					dontBuild = true;
					doCheck = true;
					nativeBuildInputs = with pkgs; [zizmor];
					checkPhase = "zizmor -q .";
					installPhase = "touch $out";
				};

				# This takes a long time to install in a runner
				# Disabling till nix hopefully allows running individual checks

				# flake = pkgs.stdenvNoCC.mkDerivation {
				# 	name = "flake-checker";
				# 	src = self;
				# 	dontBuild = true;
				# 	doCheck = true;
				# 	nativeBuildInputs = [flakeCheckerPackage];
				# 	checkPhase = "flake-checker --no-telemetry";
				# 	installPhase = "touch $out";
				# };
			};

			packages = {
				default = buildScript;

				build = buildScript;
			};

			apps.clean = {
				type = "app";
				program = lib.getExe (
					pkgs.writeShellApplication {
						name = "clean";
						runtimeInputs = [];
						text = lib.strings.concatStringsSep "\n" [
							"build_directory='${buildDirectory}'"
							"${builtins.readFile ./commands/clean.sh}"
						];
					}
				);
				meta.description = "Cleans up build artifacts";
			};

			apps.build = {
				type = "app";
				program = lib.getExe buildScript;
				meta.description = "Zips up the datapack and/or resourcepack";
			};
		}
	);
}
