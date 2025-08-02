# ⚙️ ArgoCD GitOps Configuration

Ce dossier contient la configuration GitOps pour piloter le déploiement d'applications dans un cluster Kubernetes à l’aide d’ArgoCD, selon le modèle **App of Apps hiérarchique**.

---

## 📁 Arborescence

```bash
argocd/
├── apps/
│   ├── apps-of-apps.yaml         # Application racine globale
│   ├── security.yaml             # App parent : sécurité (trivy, kyverno)
│   ├── ci-cd.yaml                # App parent : CI/CD (gitlab-runner)
│   └── observabilite.yaml        # App parent : observabilité (prometheus, grafana...)
├── securite/
│   ├── trivy.yaml
│   └── kyverno.yaml
├── cicd/
│   └── gitlab-runner.yaml
├── observabilite/
│   ├── prometheus.yaml
│   ├── grafana.yaml
│   └── alertmanager.yaml
└── README.md
```
🚀 Déploiement automatisé avec Makefile
À la racine du projet, tu disposes d’un Makefile :


# Création du cluster local k3d
```bash
make k3d-up
```
# Installation d’ArgoCD (namespace argocd + service LoadBalancer)
```bash
make bootstrap
```
# Déploiement GitOps de toutes les applications via App of Apps
```bash
make deploy
```
🌐 Accès à l’interface ArgoCD
URL locale : http://localhost:8081

🔐 Récupérer le mot de passe admin :
```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```
🧩 Architecture GitOps : App of Apps hiérarchique
Le modèle App of Apps permet une gestion modulaire et évolutive des composants via ArgoCD :

apps/apps-of-apps.yaml : point d'entrée GitOps global

Chacun des fichiers .yaml dans apps/ agit comme une app parent, pointant vers ses enfants organisés dans des dossiers dédiés (securite/, cicd/, etc.)

📦 Composants déployés
App Parent	Sous-applications	Catégorie
security	trivy, kyverno	Sécurité
ci-cd	gitlab-runner	CI/CD
observabilite	prometheus, grafana, alertmanager	Observabilité

🔄 Commandes utiles
Lister toutes les applications ArgoCD :

```bash
kubectl get applications -n argocd
```
Forcer la synchronisation d'une app :
```bash
argocd app sync <app-name>
```
🧠 Bonnes pratiques
🗂️ Organiser les enfants dans des répertoires thématiques

🔁 Garder apps-of-apps.yaml minimal pour une meilleure maintenabilité

✅ Suivre le modèle déclaratif et GitOps : tout est versionné

📚 Références utiles
Documentation officielle ArgoCD

Modèle App of Apps

