{
	description = "Elytra chestplates datapack and resourcepack";

	inputs = {
		# Commit does not correspond to a tag.
		# Updating to latest commit generally follows unstable branch.
		nixpkgs.url = "github:NixOS/nixpkgs/6041ea02f4280e63753c792da9ff533b7ce2193e";
		# Commit does not correspond to a tag.
		flake-parts.url = "github:hercules-ci/flake-parts/49f0870db23e8c1ca0b5259734a02cd9e1e371a1";
		flake-checker = {
			# Commit corresponds to tag v0.2.7.
			url = "github:DeterminateSystems/flake-checker/fc0d03efe300c1e923158831fd6d0a84d3ef75d3";
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
