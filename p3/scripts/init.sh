sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "alias sudo='sudo env PATH=$PATH'" >> /home/vagrant/.bashrc
alias sudo='sudo -E env PATH=$PATH'

sudo /usr/local/bin/k3d cluster create p3 --api-port 6443 -p 8080:80@loadbalancer

echo "export KUBECONFIG=$(sudo /usr/local/bin/k3d kubeconfig write p3)" >> /home/vagrant/.bashrc
export KUBECONFIG=$(sudo /usr/local/bin/k3d kubeconfig write p3)

sudo /usr/local/bin/kubectl create namespace argocd
sudo /usr/local/bin/kubectl create namespace dev

sudo /usr/local/bin/kubectl apply -n argocd -f /vagrant/confs/argocd.yaml
sudo /usr/local/bin/kubectl apply -n argocd -f /vagrant/confs/argocd-ingress.yaml

sudo /usr/local/bin/kubectl -n argocd patch secret argocd-secret -p '{"stringData": {
  "admin.password": "$2a$12$ZMgNhElmwKsa9THZekEF2un3YkE73UajpDCqGrHmbguSLatxmmE7G",
  "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }
}'

sudo /usr/local/bin/kubectl apply -n argocd -f /vagrant/confs/project.yaml
sudo /usr/local/bin/kubectl apply -n argocd -f /vagrant/confs/application.yaml

sudo /usr/local/bin/kubectl wait --for=condition=Ready pods --all -n argocd --timeout=100s

# sudo /usr/local/bin/kubectl port-forward svc/wil-playground -n dev 8888:8888
