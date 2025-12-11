# Commandes Utiles pour Proxmox en Shell

## Commandes Générales Proxmox

### `pveversion`
- Affiche la version actuelle de Proxmox installée sur le système.

### `pvecm` *(Proxmox VE Cluster Manager)*
- Commandes liées à la gestion du cluster :
  - `pvecm status` : Affiche l'état actuel du cluster.
  - `pvecm nodes` : Liste les nœuds du cluster.
  - `pvecm add <IP>` : Ajoute un nœud à un cluster existant.
  - `pvecm delnode <nodename>` : Supprime un nœud du cluster.

### `pvesr` *(Proxmox VE Storage Replication)*
- Gestion de la réplication entre nœuds :
  - `pvesr status` : Vérifie le statut des réplications configurées.
  - `pvesr create <jobid>` : Crée une tâche de réplication.
  - `pvesr delete <jobid>` : Supprime une tâche de réplication.

### `pve-firewall`
- Gestion du pare-feu de Proxmox :
  - `pve-firewall status` : Vérifie le statut du pare-feu.
  - `pve-firewall start` : Active le pare-feu.
  - `pve-firewall stop` : Désactive le pare-feu.

### `pveum` *(Proxmox VE User Manager)*
- Gestion des utilisateurs et rôles :
  - `pveum user list` : Liste tous les utilisateurs.
  - `pveum group list` : Liste les groupes.
  - `pveum role list` : Liste les rôles disponibles.
  - `pveum user add <user>@<realm>` : Ajoute un utilisateur.
  - `pveum role add <role>` : Crée un nouveau rôle.

---

## Commandes liées aux Machines Virtuelles (VM)

### `qm` *(Qemu Machine)*
- Gestion des machines virtuelles :
  - `qm list` : Liste toutes les machines virtuelles.
  - `qm config <vmid>` : Affiche la configuration d'une VM.
  - `qm start <vmid>` : Démarre une VM.
  - `qm stop <vmid>` : Arrête une VM.
  - `qm create <vmid>` : Crée une nouvelle VM.
  - `qm destroy <vmid>` : Supprime une VM.
  - `qm snapshot <vmid> <snapshotname>` : Crée un snapshot pour une VM.
  - `qm restore <vmid> <backup>` : Restaure une VM à partir d'un backup.

---

## Commandes liées aux Conteneurs (LXC)

### `pct` *(Proxmox Container Tools)*
- Gestion des conteneurs :
  - `pct list` : Liste tous les conteneurs.
  - `pct start <ctid>` : Démarre un conteneur.
  - `pct stop <ctid>` : Arrête un conteneur.
  - `pct create <ctid> <template>` : Crée un conteneur à partir d'un template.
  - `pct destroy <ctid>` : Supprime un conteneur.
  - `pct config <ctid>` : Affiche la configuration d'un conteneur.

---

## Commandes Réseau

### `ifconfig` ou `ip a`
- Vérifie les interfaces réseau disponibles et leurs adresses IP.

### `bridge-utils`
- Gestion des ponts réseau :
  - `brctl show` : Affiche les ponts réseau configurés.

### `ethtool`
- Vérifie les paramètres des interfaces réseau.

## Commandes de Stockage

### `pvesm` *(Proxmox VE Storage Manager)*
- Gestion des stockages :
  - `pvesm list <storage>` : Liste les fichiers sur un stockage spécifique.
  - `pvesm status` : Affiche le statut des stockages.
  - `pvesm create <type> <name>` : Crée un nouveau stockage.
  - `pvesm remove <name>` : Supprime un stockage.

---

## Commandes pour la Haute Disponibilité (HA)

### `ha-manager`
- Gestion des ressources HA :
  - `ha-manager status` : Vérifie le statut des ressources HA.
  - `ha-manager add <resource>` : Ajoute une ressource à HA.
  - `ha-manager remove <resource>` : Supprime une ressource de HA.


  
