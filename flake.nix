{
  outputs = { self, nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      sops =
        pkgs.stdenv.mkDerivation rec {
          pname = "sops";
          version = "3.9.0";
          src = pkgs.fetchurl {
            url = "https://github.com/mozilla/sops/releases/download/v${version}/sops-v${version}.darwin.arm64";
            sha256 = "cvnVm4JaIKwAGfNwwYsyZWCLGwonG8BS9gB8RblSEv0=";
          };
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
          phases = ["installPhase"];
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/${pname}
            chmod +x $out/bin/${pname}
          '';
          inherit system;
        };
      # wait for it to support KRM functions
      # https://github.com/viaduct-ai/kustomize-sops/issues/141
      ksops =
        pkgs.stdenv.mkDerivation rec {
          pname = "ksops";
          version = "3.0.2";
          src = pkgs.fetchurl {
            url = "https://github.com/viaduct-ai/kustomize-sops/releases/download/v${version}/ksops_${version}_Darwin_arm64.tar.gz";
            sha256 = "wMveLlD9xx7mceMRFHKYPQeLfptTAXvgcCTfes09b40=";
          };
          phases = ["unpackPhase" "installPhase"];
          setSourceRoot = "sourceRoot=`pwd`";
          installPhase = ''
            mkdir -p $out/bin
            cp ksops $out/bin/${pname}
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
      apply-config-server-side =
        pkgs.writeShellScriptBin "apply-config-server-side" ''
          kustomize build --enable-alpha-plugins --enable-exec $1 | kubectl apply --server-side=true -f -
        '';
    in {
      devShells.${system}.default =
        pkgs.mkShell {
          packages = [
            pkgs.kustomize
            pkgs.kubectl
            sops
            sops-secret-generator
            ksops
            # custom helper commands
            apply-config
            apply-config-server-side
            render-config
          ];
        };
    };
}
