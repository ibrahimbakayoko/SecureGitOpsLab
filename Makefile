# =========================
# VARIABLES
# =========================
CLUSTER_NAME=securegitops
ARGOCD_NAMESPACE=argocd

# =========================
# CLUSTER K3D
# =========================
k3d-up:
	k3d cluster list | grep $(CLUSTER_NAME) && k3d cluster delete $(CLUSTER_NAME) || true
	k3d cluster create $(CLUSTER_NAME) --agents 2 --api-port 6550 -p "8081:80@loadbalancer"
	kubectl cluster-info

# =========================
# BOOTSTRAP ARGOCD (HELM - FIX ANNOTATION ISSUE)
# =========================
bootstrap:
	kubectl create namespace $(ARGOCD_NAMESPACE) || true

	helm repo add argo https://argoproj.github.io/argo-helm || true
	helm repo update

	helm upgrade --install argocd argo/argo-cd \
		-n $(ARGOCD_NAMESPACE)

	kubectl -n $(ARGOCD_NAMESPACE) wait --for=condition=available deployment argocd-server --timeout=300s
	kubectl -n $(ARGOCD_NAMESPACE) wait --for=condition=available deployment argocd-repo-server --timeout=300s
	kubectl -n $(ARGOCD_NAMESPACE) wait --for=condition=available deployment argocd-application-controller --timeout=300s

	kubectl patch svc argocd-server -n $(ARGOCD_NAMESPACE) -p '{"spec": {"type": "LoadBalancer"}}'

# =========================
# DEPLOY APPS (GITOPS ROOT)
# =========================
deploy:
	kubectl apply -f argocd/apps/apps-of-apps.yaml
	kubectl get applications -n $(ARGOCD_NAMESPACE)

# =========================
# STATUS CHECK
# =========================
status:
	kubectl get nodes
	kubectl get pods -n $(ARGOCD_NAMESPACE)
	kubectl get applications -n $(ARGOCD_NAMESPACE)
	k3d cluster list

# =========================
# FULL PIPELINE
# =========================
all: k3d-up bootstrap deploy status