# 🔐 SecureGitOpsLab

[![GitHub stars](https://img.shields.io/github/stars/ibrahimbakayoko/SecureGitOpsLab?style=social)](https://github.com/ibrahimbakayoko/SecureGitOpsLab)
[![GitHub forks](https://img.shields.io/github/forks/ibrahimbakayoko/SecureGitOpsLab?style=social)](https://github.com/ibrahimbakayoko/SecureGitOpsLab)
[![GitHub issues](https://img.shields.io/github/issues/ibrahimbakayoko/SecureGitOpsLab)](https://github.com/ibrahimbakayoko/SecureGitOpsLab/issues)

---

## 👋 Présentation
🚀 **Projet GitOps sécurisé et observable de bout en bout**  
Dans le cadre de mon parcours **#DevOpsOpenJourney**, SecureGitOpsLab illustre comment automatiser, sécuriser et superviser un cluster Kubernetes et ses applications.

<img src="./docs/securegitopslab-illustration.png" alt="SecureGitOpsLab Architecture" style="width:100%; border-radius:10px;"/>

---

## 🎯 Objectifs
- 🟢 Déployer une **architecture Kubernetes complète** et automatisée
- 🟢 Mettre en place **GitOps avec ArgoCD**
- 🟢 Sécuriser les déploiements avec **Trivy, Kyverno, Cosign et SBOM**
- 🟢 Assurer une **observabilité complète** avec Prometheus, Grafana, Loki et Alertmanager
- 🟢 Industrialiser le déploiement applicatif via **Helm & Kustomize**
- 🟢 Automatiser les pipelines CI/CD (**GitLab CI / GitHub Actions**)

---

## 🧩 Stack technique

| Domaine | Technologies |
|---------|--------------|
| 🐳 Orchestration & Conteneurs | Docker, Kubernetes (K3d local / EKS cloud), Helm |
| ⚙️ Automatisation & IaC | Terraform, Ansible, Bash |
| 🔁 CI/CD | Jenkins, GitLab CI, GitHub Actions |
| 📈 Observabilité & Monitoring | Prometheus, Grafana, Loki, Alertmanager |
| 🔐 Sécurité DevSecOps | Trivy, Kyverno, Cosign, SBOM |

---

## 🗂️ Structure du projet

| Dossier         | Contenu |
|----------------|---------|
| `/terraform`   | Déploiement d’infrastructure cloud (EKS) ou local |
| `/argocd`      | Manifests App of Apps & bootstrap GitOps |
| `/kustomize`   | Manifests Kubernetes (base & overlays) |
| `/helm-charts` | Charts Helm personnalisés |
| `/security`    | Scans Trivy, policies Kyverno, signatures Cosign |
| `/observability` | Stack Prometheus / Grafana / Loki |
| `/ci-cd`       | Pipelines GitLab CI ou GitHub Actions |
| `/docs`        | Diagrammes, captures d’écran, README |

---

## 📊 Résultats clés
- ✅ Monitoring complet **infrastructure + applicatif**
- ✅ Dashboards Grafana prêts à l’emploi
- ✅ Alertes en temps réel pour anomalies applicatives
- ✅ Déploiements sécurisés et automatisés via GitOps
- ✅ Environnement multi-cluster et multi-environnement industrialisé

<img src="./docs/grafana-dashboard.png" alt="Dashboard Grafana" style="width:100%; border-radius:10px;"/>

---

## 🚀 Projets liés
- **Taskmanager Helm Chart** : Application Node.js déployée sur K3s via Helm  
- **AWS Terraform-Ansible Lab** : Infrastructure AWS automatisée avec Terraform & Ansible

---

## 📚 En ce moment
- 🎓 Préparation du **Certified Kubernetes Administrator (CKA)**  
- 🏗 Développement de la V2 de **#DevOpsOpenJourney (100% Cloud AWS)**  
- ✍️ Partage d’expériences DevOps sur LinkedIn

---

## 🙌 Auteur
**Brahima Bakayoko**  
💬 Contributions, retours et échanges bienvenus !  
📌 Continuité de **#DevOpsOpenJourney**

📧 ibra.bakayoko82@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/bakayoko-ibrahim)  
🔗 [GitHub](https://github.com/ibrahimbakayoko)

---
