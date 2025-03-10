# k0s-vagrant-example

[English](/docs/readme-en.md)

vagrantを使って作成したVMでNode-local load balancing と Control plane load balancingを有効化したk0sクラスタを建てる.

Ubuntuをインストールしたマシンでのみ動作検証済.

## 必要なもの

- [vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant)
- [virrualbox](https://www.virtualbox.org/wiki/Downloads)
- [k0sctl](https://github.com/k0sproject/k0sctl)
- [yq](https://github.com/mikefarah/yq)

## 構築方法

必要に応じてVagranfileやk0sctl.ymlは編集する.

```base
# VMを建てる
vagrant up
# k0sクラスタを構築する
SSH_KNOWN_HOSTS=/dev/null k0sctl apply -c k0sctl.yml --trace
# kubeconfigのアドレスをVIPに置き換える.
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

## k0sクラスタを削除するとき
SSH_KNOWN_HOSTS=/dev/null k0sctl reset -c k0sctl.yml --trace
# VMを削除する
vagrant destroy -f

```

## 注意

もし上記設定でsshが失敗する場合, ssh-agentが原因の可能性がある.

<https://github.com/k0sproject/k0sctl/issues/142>

上記イシューの通り,

- SSH_AUTH_SOCKをunsetする
- ssh-addで必要な鍵を全て追加する

で対応できる.

## 参考

<https://docs.k0sproject.io/stable/k0sctl-install/> | Using k0sctl - Documentation

<https://github.com/k0sproject/k0sctl?tab=readme-ov-file#k0sctl> | k0sproject/k0sctl: A bootstrapping and management tool for k0s clusters.

<https://github.com/k0sproject/k0sctl/issues/142> | 0.8.4 fails to connect with ssh key to vagrant host · Issue #142 · k0sproject/k0sctl
