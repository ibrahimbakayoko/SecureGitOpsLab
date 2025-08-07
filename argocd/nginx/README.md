Dossier nginx – Déploiement multi-environnements avec Argo CD
🎯 Objectif
Le dossier nginx contient les applications enfant Argo CD qui permettent de déployer NGINX dans trois environnements distincts :

Développement (nginx-dev.yaml)

Staging (nginx-staging.yaml)

Production (nginx-prod.yaml)

Ces applications enfant sont orchestrées par un App-of-Apps (nginx.yaml) situé dans apps/.
Chaque application enfant va chercher :

Le chart Helm dans helm-deploy/overlays/chart/

Son fichier values.yaml spécifique à l’environnement dans helm-deploy/overlays/{env}/

📁 Structure des fichiers
bash
nginx/
├── nginx-dev.yaml        # Application enfant Argo CD pour l'environnement Dev
├── nginx-staging.yaml    # Application enfant Argo CD pour l'environnement Staging
└── nginx-prod.yaml       # Application enfant Argo CD pour l'environnement Prod

Ces fichiers définissent les manifestes Kubernetes pour Argo CD, avec :

repoURL : dépôt Git contenant ce projet

path : chemin vers le chart Helm (helm-deploy/overlays/chart)

valueFiles : chemin vers le fichier de valeurs spécifique à l’environnement

destination.namespace : namespace cible pour le déploiement

syncPolicy : activation de la synchro automatique et du CreateNamespace

🔄 Flux de déploiement
App-of-Apps

Dans apps/nginx.yaml, on définit une application Argo CD principale qui référence les trois applications enfant (nginx-dev, nginx-staging, nginx-prod).

Applications enfant

Chaque YAML du dossier nginx/ est une Application Argo CD qui déploie NGINX dans son environnement dédié.

Les enfants pointent vers le même chart Helm mais avec des valeurs différentes.

Helm Chart et valeurs

Le chart Helm est défini ici :

bash
helm-deploy/overlays/chart/

Les valeurs spécifiques à chaque environnement sont dans :

bash
helm-deploy/overlays/dev/dev-values.yaml
helm-deploy/overlays/staging/staging-values.yaml
helm-deploy/overlays/prod/prod-values.yaml

🚀 Commandes utiles
Déployer toutes les applications enfant
bash
kubectl apply -f nginx/
Déployer un seul environnement (ex: Dev)
bash
kubectl apply -f nginx/nginx-dev.yaml
Vérifier les applications dans Argo CD
bash
kubectl get applications -n argocd
📊 Avantages de cette organisation
Séparation claire des environnements

Réutilisation du même chart Helm

App-of-Apps pour orchestrer facilement plusieurs déploiements

Automatisation via Argo CD (sync + self-heal)
