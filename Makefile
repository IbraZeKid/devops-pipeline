# IMPORTANT : les lignes de commandes sous les targets
# DOIVENT commencer par une TABULATION (pas des espaces).
# Si tu copies ce fichier, vérifie que c'est bien des tabs.
 
.PHONY: help dev test build scan push deploy infra-init infra-apply clean logs
 
# Valeurs par défaut — modifie selon ton Docker Hub username
DOCKERHUB_USER ?= $(shell echo ${DOCKERHUB_USERNAME})
IMAGE = $(DOCKERHUB_USER)/flask-devops-app
 
# ── help : affiche toutes les commandes disponibles ────────
help:
	@echo ''
	@echo 'Commandes disponibles :'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ''
 
# ── dev : lance l'environnement de développement local ─────
dev: ## Lance la stack complète en local (avec build)
	docker compose up --build
 
dev-bg: ## Lance la stack en arrière-plan (detached)
	docker compose up --build -d
 
# ── test : lance les tests unitaires ───────────────────────
test: ## Lance les tests pytest
	cd app && python -m pytest tests/ -v
 
# ── build : construit l'image Docker ───────────────────────
build: ## Construit l'image Docker de production
	docker build -f docker/Dockerfile -t $(IMAGE):local .
 
# ── scan : analyse de sécurité avec Trivy ──────────────────
scan: build ## Scan de sécurité de l'image (installe Trivy si absent)
	@command -v trivy >/dev/null 2>&1 || \
		(echo 'Installation de Trivy...' && \
		curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin)
	trivy image $(IMAGE):local
 
# ── push : pousse l'image sur Docker Hub ───────────────────
push: ## Pousse l'image sur Docker Hub (nécessite docker login)
	docker push $(IMAGE):local
	docker tag $(IMAGE):local $(IMAGE):latest
	docker push $(IMAGE):latest
 
# ── deploy : lance Ansible sur le VPS ──────────────────────
deploy: ## Configure et déploie sur le VPS via Ansible
	ansible-playbook -i infra/ansible/inventory.ini infra/ansible/playbook.yml
 
# ── Terraform ───────────────────────────────────────────────
infra-init: ## Initialise Terraform (à faire une seule fois)
	cd infra/terraform && terraform init
 
infra-plan: ## Prévisualise les changements d'infrastructure
	cd infra/terraform && terraform plan
 
infra-apply: ## Applique les changements d'infrastructure
	cd infra/terraform && terraform apply
 
# ── logs : affiche les logs des containers ──────────────────
logs: ## Affiche les logs en temps réel
	docker compose logs -f
 
# ── clean : nettoie l'environnement local ───────────────────
clean: ## Arrête et supprime tous les containers et volumes
	docker compose down -v
	docker system prune -f
	@echo 'Nettoyage terminé.'
