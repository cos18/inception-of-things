curl -sfL https://get.k3s.io/ | sh -s - --cluster-init --node-ip=192.168.56.110 --write-kubeconfig-mode 644
echo 'alias k="kubectl"' >> ~/.bashrc
source ~/.bashrc

# Install helm
curl -o helm-v3.12.3-linux-amd64.tar.gz https://get.helm.sh/helm-v3.12.3-linux-amd64.tar.gz
chmod 777 helm-v3.12.3-linux-amd64.tar.gz
tar -zxvf helm-v3.12.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf *

sudo yum install -y git