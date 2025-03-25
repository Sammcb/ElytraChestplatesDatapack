{
	description = "Elytra chestplates datapack and resourcepack";

	inputs = {
		# Commit does not correspond to a tag.
		# Updating to latest commit generally follows unstable branch.
		nixpkgs.url = "github:NixOS/nixpkgs/3181957f1e76766852006d6d6e0a9045b4bd0104";
		# Commit does not correspond to a tag.
		flake-parts.url = "github:hercules-ci/flake-parts/f4330d22f1c5d2ba72d3d22df5597d123fdb60a9";
		flake-checker = {
			# Commit corresponds to tag v0.2.4.
			url = "github:DeterminateSystems/flake-checker/93ec61a573f9980b480f514132073233bf8eceb9";
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
