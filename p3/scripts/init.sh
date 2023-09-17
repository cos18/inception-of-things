sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "alias sudo='sudo env PATH=$PATH'" >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

sudo k3d cluster create p3 --api-port 6443 -p 8080:80@loadbalancer

echo "export KUBECONFIG=$(sudo k3d kubeconfig write p3)" >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

sudo kubectl create namespace argocd

sudo kubectl apply -n argocd -f /vagrant/confs/argocd.yaml
sudo kubectl apply -n argocd -f /vagrant/confs/argocd-ingress.yaml
