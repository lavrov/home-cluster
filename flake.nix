{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:
    let forSystem = system:
      let
        pkgs = import nixpkgs { inherit system; };
        sops =
          let
            platform =
              if system == "x86_64-linux"
              then { suffix = "linux.amd64"; checkSum = "DWVmD754Vkf/Txdk1/ae31mPedbXnrvvSlAZCbb/a4I="; }
              else { suffix = "darwin.arm64"; checkSum = "cvnVm4JaIKwAGfNwwYsyZWCLGwonG8BS9gB8RblSEv0="; };
          in
            pkgs.stdenv.mkDerivation rec {
              pname = "sops";
              version = "3.9.0";
              src = pkgs.fetchurl {
                url = "https://github.com/mozilla/sops/releases/download/v${version}/sops-v${version}.${platform.suffix}";
                sha256 = platform.checkSum;
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
          let
            platform =
              if system == "x86_64-linux"
              then { suffix = "linux_amd64"; checkSum = "eBj5tYLLrs33eHc5xds/faManS6fuOfL+HpBCtiIoKU="; }
              else { suffix = "darwin_arm64"; checkSum = "PhzzZw1nESbRY99YD5dYALxkcQtUQBNL++qe4Ckdq18="; };
          in
          pkgs.stdenv.mkDerivation rec {
            pname = "sops-secret-generator";
            version = "1.6.0";
            src = pkgs.fetchurl {
              url = "https://github.com/goabout/kustomize-sopssecretgenerator/releases/download/v${version}/SopsSecretGenerator_${version}_${platform.suffix}";
              sha256 = platform.checkSum;
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
          let
            platform =
              if system == "x86_64-linux"
              then { suffix = "Linux_x86_64"; checkSum = "qgVPEY+LkbX3jor2KQcqx1JYxYLhl9A6L54MDzhR2ew="; }
              else { suffix = "Darwin_arm64"; checkSum = "wMveLlD9xx7mceMRFHKYPQeLfptTAXvgcCTfes09b40="; };
          in
            pkgs.stdenv.mkDerivation rec {
              pname = "ksops";
              version = "3.0.2";
              src = pkgs.fetchurl {
                url = "https://github.com/viaduct-ai/kustomize-sops/releases/download/v${version}/ksops_${version}_${platform.suffix}.tar.gz";
                sha256 = platform.checkSum;
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
        devShells.default =
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
    in
      flake-utils.lib.eachDefaultSystem forSystem;
}
