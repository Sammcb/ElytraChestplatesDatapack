{
	description = "Elytra chestplates datapack and resourcepack";

	inputs = {
		# Commit does not correspond to a tag.
		# Updating to latest commit generally follows unstable branch.
		nixpkgs.url = "github:NixOS/nixpkgs/ac3f8faff5c1a4191489c7b2f006d9adf4797425";
		# Commit does not correspond to a tag.
		flake-parts.url = "github:hercules-ci/flake-parts/2cccadc7357c0ba201788ae99c4dfa90728ef5e0";
		flake-checker = {
			# Commit corresponds to tag v0.2.10.
			url = "github:DeterminateSystems/flake-checker/9eecc66959dde5efc621cd7063538971177d303c";
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
