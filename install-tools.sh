#!/bin/bash

set -euo pipefail

echo "=============================="
echo "🚀 DEVOPS BOOTSTRAP MACHINE"
echo "=============================="

# =========================
# SYSTEM UPDATE
# =========================
echo "📦 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "🧰 Installing base tools..."
sudo apt install -y curl git make ca-certificates gnupg lsb-release unzip

# =========================
# DOCKER
# =========================
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker $USER
else
  echo "✔ Docker already installed"
fi

# =========================
# KUBECTL
# =========================
echo "☸️ Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
else
  echo "✔ kubectl already installed"
fi

# =========================
# K3D
# =========================
echo "📦 Installing k3d..."
if ! command -v k3d &> /dev/null; then
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
  echo "✔ k3d already installed"
fi

# =========================
# HELM
# =========================
echo "⛵ Installing Helm..."
if ! command -v helm &> /dev/null; then
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
  echo "✔ Helm already installed"
fi

# =========================
# VERIFY INSTALLS
# =========================
echo "🔎 Verifying tools..."

docker --version
kubectl version --client
k3d version
helm version
git --version
make --version

echo ""
echo "🎉 MACHINE READY FOR DEVOPS STACK"
echo "👉 Next step: make k3d-up"