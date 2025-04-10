{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:
    let forSystem = system:
      let
        pkgs = import nixpkgs { inherit system; };
        render-config =
          pkgs.writeShellScriptBin "render" ''
            kubectl kustomize $1
          '';
        apply-config =
          pkgs.writeShellScriptBin "apply" ''
            kubectl apply -k $1
          '';
      in {
        devShells.default =
          pkgs.mkShell {
            packages = [
              pkgs.kubectl
              pkgs.kubeseal
              pkgs.kustomize
              # custom helper commands
              render-config
              apply-config
            ];
          };
      };
    in
      flake-utils.lib.eachDefaultSystem forSystem;
}
