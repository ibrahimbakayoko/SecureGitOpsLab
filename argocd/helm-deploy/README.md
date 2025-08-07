📦 helm-deploy – Chart Helm NGINX & valeurs par environnement
Ce dossier contient le chart Helm utilisé pour déployer NGINX dans différents environnements (Dev, Staging, Prod) avec des fichiers de valeurs (values.yaml) adaptés à chaque contexte.

Ce chart est réutilisé par toutes les applications enfant Argo CD définies dans le dossier nginx/.

📁 Arborescence
```bash
helm-deploy/
└── overlays/
    ├── chart/                     # Chart Helm commun à tous les environnements
    │   ├── Chart.yaml              # Métadonnées du chart (nom, version, description)
    │   ├── templates/              # Templates Kubernetes Helm
    │   │   ├── deployment.yaml     # Déploiement NGINX
    │   │   └── service.yaml        # Service NGINX
    │   └── values.yaml             # Valeurs par défaut du chart
    │
    ├── dev/                        # Environnement Développement
    │   └── dev-values.yaml         # Config spécifique Dev
    │
    ├── staging/                    # Environnement Staging
    │   └── staging-values.yaml     # Config spécifique Staging
    │
    └── prod/                       # Environnement Production
        └── prod-values.yaml        # Config spécifique Prod
```
⚙️ Rôle des fichiers
Fichier / Dossier	Description
chart/Chart.yaml	Métadonnées du chart Helm (nom, version, dépendances éventuelles).
chart/templates/deployment.yaml	Manifest Kubernetes pour le déploiement NGINX (pods, labels, etc.).
chart/templates/service.yaml	Manifest Kubernetes pour exposer NGINX (ClusterIP, NodePort, LoadBalancer).
chart/values.yaml	Valeurs par défaut communes à tous les environnements.
dev/dev-values.yaml	Variables spécifiques pour l'environnement Dev (réplicas, image tag, ressources…).
staging/staging-values.yaml	Variables spécifiques pour l'environnement Staging.
prod/prod-values.yaml	Variables spécifiques pour l'environnement Prod (réplicas élevés, ressources optimisées).

🔄 Flux d’utilisation avec Argo CD
Les applications enfant Argo CD (dans nginx/) utilisent :

repoURL : le dépôt Git de ce projet.

path : helm-deploy/overlays/chart.

valueFiles : chemin vers le fichier *-values.yaml spécifique à l’environnement.

Exemple de configuration dans une app enfant :

```yaml
source:
  repoURL: https://github.com/mon-compte/mon-repo.git
  targetRevision: HEAD
  path: helm-deploy/overlays/chart
  helm:
    valueFiles:
      - ../../dev/dev-values.yaml
```
🚀 Commandes utiles
📦 Tester le chart localement

```bash
helm install nginx-dev ./overlays/chart -f overlays/dev/dev-values.yaml
```
🔍 Prévisualiser les manifests Kubernetes

```bash
helm template nginx-dev ./overlays/chart -f overlays/dev/dev-values.yaml
```
📊 Avantages de cette organisation
Réutilisation maximale : un seul chart Helm commun.

Paramétrage par environnement : chaque fichier *-values.yaml ajuste les configs.

Facilité de maintenance : modifications centralisées dans chart/.

Compatibilité GitOps : entièrement pilotable via Argo CD.

📚 Référence utile : Documentation Helm

