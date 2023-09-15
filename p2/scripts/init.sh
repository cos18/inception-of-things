curl -sfL https://get.k3s.io/ | sh -s - --cluster-init --node-ip=192.168.56.110 --write-kubeconfig-mode 644
echo 'alias k="kubectl"' >> /home/vagrant/.bashrc
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

# Install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm --kubeconfig /etc/rancher/k3s/k3s.yaml ls --all-namespaces

sudo yum install -y git

# k create -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml