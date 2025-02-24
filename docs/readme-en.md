# k0s-vagrant-example

Create a k0s cluster with Node-local load balancing and Control plane load balancing on VMs provisioned by vagrant.

Tested only on a machine with Ubuntu installed.

## What you need

- [vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant)
- [virrualbox](https://www.virtualbox.org/wiki/Downloads)
- [k0sctl](https://github.com/k0sproject/k0sctl)
- [yq](https://github.com/mikefarah/yq)

## How to build

Edit Vagranfile and k0sctl.yml as needed.

```bash
vagrant up
SSH_KNOWN_HOSTS=/dev/null k0sctl apply -c k0sctl.yml --trace
# replace a server address with control plane VIP
k0sctl kubeconfig | yq '.clusters[0].cluster.server="https://192.168.56.200:6443"' > kubeconfig
export KUBECONFIG=./kubeconfig

➜ kubectl get pods  -A      
NAMESPACE     NAME                              READY   STATUS    RESTARTS   AGE
kube-system   coredns-7d4f7fbd5c-lzs42          1/1     Running   0          104s
kube-system   coredns-7d4f7fbd5c-wk269          1/1     Running   0          104s
kube-system   konnectivity-agent-42dx7          1/1     Running   0          115s
kube-system   konnectivity-agent-gklx9          1/1     Running   0          115s
kube-system   kube-proxy-54vng                  1/1     Running   0          115s
kube-system   kube-proxy-8zntn                  1/1     Running   0          115s
kube-system   kube-router-7x7gs                 1/1     Running   0          115s
kube-system   kube-router-fg2cw                 1/1     Running   0          115s
kube-system   metrics-server-7778865875-pbndv   1/1     Running   0          2m16s
kube-system   nllb-server4                      1/1     Running   0          115s
kube-system   nllb-server5                      1/1     Running   0          115s

# delete k0s cluster
SSH_KNOWN_HOSTS=/dev/null k0sctl reset -c k0sctl.yml --trace
vagrant destroy -f

```

## Notes

If you get public key denined errors, ssh-agent may be the cause.

<https://github.com/k0sproject/k0sctl/issues/142>

you may need to

- unset SSH_AUTH_SOCK
- Add private keys to ssh-agent

## References

<https://docs.k0sproject.io/stable/k0sctl-install/> | Using k0sctl - Documentation

<https://github.com/k0sproject/k0sctl?tab=readme-ov-file#k0sctl> | k0sproject/k0sctl: A bootstrapping and management tool for k0s clusters.

<https://github.com/k0sproject/k0sctl/issues/142> | 0.8.4 fails to connect with ssh key to vagrant host · Issue #142 · k0sproject/k0sctl
