{
  outputs = { self, nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      sops =
        pkgs.stdenv.mkDerivation rec {
          pname = "sops";
          version = "3.7.3";
          src = pkgs.fetchurl {
            url = "https://github.com/mozilla/sops/releases/download/v${version}/sops-v${version}.darwin.arm64";
            sha256 = "vpziZcfz07U0U10qXve0FgC/K4JBsaT5XkiATSBiiy4=";
          };
          dontUnpack = true;
          phases = ["installPhase"];
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/${pname}
            chmod +x $out/bin/${pname}
          '';
          inherit system;
        };
      sops-secret-generator =
        pkgs.stdenv.mkDerivation rec {
          pname = "sops-secret-generator";
          version = "1.6.0";
          src = pkgs.fetchurl {
            url = "https://github.com/goabout/kustomize-sopssecretgenerator/releases/download/v${version}/SopsSecretGenerator_${version}_darwin_arm64";
            sha256 = "PhzzZw1nESbRY99YD5dYALxkcQtUQBNL++qe4Ckdq18=";
          };
          dontUnpack = true;
          phases = ["installPhase"];
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/${pname}
            chmod +x $out/bin/${pname}
          '';
          inherit system;
        };
      render-config =
        pkgs.writeShellScriptBin "render-config" ''
          kustomize build --enable-alpha-plugins --enable-exec $1
        '';
      apply-config =
        pkgs.writeShellScriptBin "apply-config" ''
          kustomize build --enable-alpha-plugins --enable-exec $1 | kubectl apply -f -
        '';
    in {
      devShells.${system}.default =
        pkgs.mkShell {
          packages = [
            pkgs.kustomize
            pkgs.kubectl
            sops
            sops-secret-generator
            # custom helper commands
            apply-config
            render-config
          ];
        };
    };
}
