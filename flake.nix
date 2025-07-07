{
	description = "Elytra chestplates datapack and resourcepack";

	inputs = {
		# Commit does not correspond to a tag.
		# Updating to latest commit generally follows unstable branch.
		nixpkgs.url = "github:NixOS/nixpkgs/24bd6414d8888a861010135c5cb7b576f440d7cd";
		# Commit does not correspond to a tag.
		flake-parts.url = "github:hercules-ci/flake-parts/77826244401ea9de6e3bac47c2db46005e1f30b5";
		flake-checker = {
			# Commit corresponds to tag v0.2.8.
			url = "github:DeterminateSystems/flake-checker/3ecd9ddd3cf1ce0f78447cb0e5b7d8ecb91ee778";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{self, nixpkgs, flake-parts, flake-checker}: flake-parts.lib.mkFlake {inherit inputs;} {
		systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux" "x86_64-darwin"];
		perSystem = {pkgs, system, ...}:
			let
				flakeCheckerPackage = flake-checker.packages.${system}.default;
			in {
				devShells.default = pkgs.mkShellNoCC {
					nativeBuildInputs = [flakeCheckerPackage] ++ (with pkgs; [coreutils gnumake zip editorconfig-checker zizmor cosign trufflehog]);
				};

				devShells.build = pkgs.mkShellNoCC {
					nativeBuildInputs = with pkgs; [gnumake zip];
				};

				devShells.lintWorkflows = pkgs.mkShellNoCC {
					nativeBuildInputs = with pkgs; [zizmor];
				};

				devShells.lintEditorconfig = pkgs.mkShellNoCC {
					nativeBuildInputs = with pkgs; [editorconfig-checker];
				};

				devShells.releaseArtifacts = pkgs.mkShellNoCC {
					nativeBuildInputs = with pkgs; [gh];
				};

				devShells.createChecksums = pkgs.mkShellNoCC {
					nativeBuildInputs = with pkgs; [coreutils];
				};

				devShells.sign = pkgs.mkShellNoCC {
					nativeBuildInputs = with pkgs; [cosign];
				};

				devShells.scanSecrets = pkgs.mkShellNoCC {
					nativeBuildInputs = with pkgs; [trufflehog];
				};
			};
	};
}
