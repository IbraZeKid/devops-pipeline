# On déclare les providers nécessaires.
# Un provider = plugin Terraform pour communiquer avec un cloud.
terraform {
  required_version = '>= 1.5.0'
  required_providers {
    oci = {
      source  = 'oracle/oci'
      version = '~> 5.0'
    }
  }
}
 
# ── Variables ─────────────────────────────────────────────
# Les valeurs sensibles ne sont PAS dans ce fichier.
# Elles seront dans terraform.tfvars (ignoré par git).
variable 'tenancy_ocid' { description = 'OCID du compte Oracle Cloud' }
variable 'user_ocid' { description = 'OCID de ton utilisateur' }
variable 'fingerprint' { description = 'Fingerprint de ta clé API Oracle' }
variable 'private_key_path' { description = 'Chemin vers ta clé privée API Oracle' }
variable 'region' {
  description = 'Région Oracle Cloud'
  default     = 'eu-paris-1'
}
variable 'ssh_public_key' { description = 'Clé SSH publique pour accès VM' }
 
# ── Provider Oracle Cloud ──────────────────────────────────
provider 'oci' {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
 
# ── Instance de calcul (la VM) ─────────────────────────────
resource 'oci_core_instance' 'devops_server' {
  compartment_id      = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = 'VM.Standard.A1.Flex'  # Always Free ARM
 
  shape_config {
    ocpus         = 2   # 2 CPUs ARM = gratuit
    memory_in_gbs = 12  # 12 Go RAM = gratuit
  }
 
  source_details {
    source_type = 'image'
    # ID de l'image Ubuntu 22.04 ARM en région eu-paris-1
    # Récupère le bon ID dans : Compute > Images > Platform Images
    source_id   = 'ocid1.image.oc1.eu-paris-1.AAAA...'
  }
 
  display_name = 'devops-pipeline-server'
 
  metadata = {
    # La clé publique SSH autorisée à se connecter
    ssh_authorized_keys = var.ssh_public_key
  }
 
  preserve_boot_volume = false  # Supprime le disque si on détruit la VM
}
 
# ── Data source : récupère les availability domains disponibles ─
data 'oci_identity_availability_domains' 'ads' {
  compartment_id = var.tenancy_ocid
}
 
# ── Output : affiche l'IP après apply ─────────────────────
output 'server_public_ip' {
  value       = oci_core_instance.devops_server.public_ip
  description = 'IP publique du serveur de déploiement'
}
