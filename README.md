# home-cluster
Infrastructure as code for RPi4 k8s cluster.

## Boostrap k8s cluster

1. Flash [Ubuntu Server](https://ubuntu.com/download/raspberry-pi) onto microSD card.
2. Edit _/boot/firmware/cmdline.txt_ file on the card appending `cgroup_enable=memory cgroup_memory=1` parameters to enabled container support.
    ```
    cat /boot/firmware/cmdline.txt 
    net.ifnames=0 dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=LABEL=writable rootfstype=ext4 elevator=deadline rootwait fixrtc cgroup_enable=memory cgroup_memory=1
    ```
3. Boot the Pi up
4. [Boostrap](https://rancher.com/docs/k3s/latest/en/quick-start/) k8s master node.
    ```
    curl -sfL https://get.k3s.io | sh -
    ```
5. Bootstrap worker nodes.
    ```
    curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -
    ```
6. Copy kube config from master node to your development machine altering server address.
    ```
    scp ubuntu@<ip-address>:/etc/rancher/k3s/k3s.yaml ~/.kube/config
    ```
   This gives you `kubectl`.

## Deploy workloads

Run within this repository:
```
kubectl apply -k .
```