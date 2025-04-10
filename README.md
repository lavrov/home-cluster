# home-cluster

HomeLab configuration.
Bare metal runs NixOS. NixOS runs k8s cluster. 

## Boostrap

1. Create a bootable usb drive with [NixOS](https://nixos.org/download.html).
2. Install NixOS on bare metal. Create a user `vitaly` during installation.
3. Boot and login into NixOS.
4. Copy `configuration.nix` to `/etc/nixos/configuration.nix`.
5. Apply configuration
   
       nixos-rebuild switch

6. Copy kube config from master node to your development machine altering server address.

       scp vitaly@<ip-address>:/etc/rancher/k3s/k3s.yaml ~/.kube/config
 
   Change the ip address of the cluster from `127.0.0.1` to the actual cluster address.

## Deploy workloads

Nix Shell is provided to facilitate deployment of workloads:
   
    nix develop

The following tools are available in the shell:
   - `kubectl`
   - `kustomize`
   - `render-config`, script to print out rendered k8s configs
   - `apply-config`, script to apply configurations to the cluster

Run `apply-config` to apply [kustomizations](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/).
One can choose to apply only a certain kustomization by passing a path to it as an argument or changing the current directory to the desired kustomization and running `apply-config` without arguments.
