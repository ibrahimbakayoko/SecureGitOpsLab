⚙️ Déploiement NGINX multi-environnements avec ArgoCD
Ce dossier contient la configuration GitOps pour déployer NGINX dans trois environnements distincts (Dev, Staging, Prod) via ArgoCD, selon le modèle App of Apps.
--- 
📁 Arborescence
```bash
nginx/
├── nginx-dev.yaml       # Application enfant ArgoCD pour l'environnement Dev
├── nginx-staging.yaml   # Application enfant ArgoCD pour l'environnement Staging
└── nginx-prod.yaml      # Application enfant ArgoCD pour l'environnement Prod
```
📍 Chemins utilisés par les enfants :

Chart Helm : helm-deploy/overlays/chart/

Fichier values spécifique : helm-deploy/overlays/{env}/{env}-values.yaml

🧩 Rôle de chaque composant

1️⃣ App-of-Apps
Dans apps/nginx.yaml, l’application parent ArgoCD référence les trois enfants (nginx-dev, nginx-staging, nginx-prod).

2️⃣ Applications enfants (nginx-dev.yaml, nginx-staging.yaml, nginx-prod.yaml)
Chaque application :

Pointe vers le même chart Helm (helm-deploy/overlays/chart)

Utilise un fichier de valeurs dédié (dev-values.yaml, staging-values.yaml, prod-values.yaml)

Déploie NGINX dans un namespace spécifique

Active :

Sync automatique

Self-heal

Création automatique du namespace (CreateNamespace)

📦 Structure Helm
```bash
helm-deploy/
└── overlays/
    ├── chart/
    │   ├── Chart.yaml
    │   ├── templates/
    │   │   ├── deployment.yaml
    │   │   └── service.yaml
    │   └── values.yaml
    ├── dev/
    │   └── dev-values.yaml
    ├── staging/
    │   └── staging-values.yaml
    └── prod/
        └── prod-values.yaml
chart/ → Chart Helm de base

{env}/{env}-values.yaml → Configurations spécifiques à l’environnement
```
🚀 Déploiement
📌 1. Déployer tous les environnements :
```bash
kubectl apply -f nginx/
```
📌 2. Déployer un seul environnement (exemple : Dev) :
```bash
kubectl apply -f nginx/nginx-dev.yaml
```
📌 3. Vérifier les applications dans ArgoCD :
```bash
kubectl get applications -n argocd
```
🌐 Accès et gestion ArgoCD
Lister toutes les applications :

```bash
kubectl get applications -n argocd
```
Forcer la synchronisation d’une app :

```bash
argocd app sync <app-name>
```
✅ Avantages de cette organisation
Séparation claire des environnements

Réutilisation d’un seul chart Helm

Gestion centralisée via App-of-Apps

Déploiement 100% GitOps (déclaratif et versionné)

