# Guide MCO Avancé : Proxmox VE & Ceph

Ce guide technique se concentre sur les actions critiques de gestion de cluster, de nettoyage et de dépannage (Maintien en Conditions Opérationnelles).

## 1. Gestion de la Haute Disponibilité (HA)

La gestion fine du service HA est cruciale pour éviter des redémarrages intempestifs de VM (fencing) lors de vos maintenances.

### Mode Maintenance (CRM)

Pour passer un nœud en maintenance vis-à-vis du HA, il est préférable de dire au gestionnaire de cluster (CRM) d'ignorer temporairement ce nœud ou de migrer les services.

> **Note :** Depuis Proxmox VE 6.2+, l'utilisation des **politiques de maintenance (CRS)** est recommandée, mais la méthode manuelle ci-dessous reste valide pour empêcher le Watchdog de tirer (fencer) le nœud lors d'interventions sur le réseau ou Corosync.

**Pour arrêter temporairement le traitement HA sur un nœud :**

```bash
# Arrêter le gestionnaire de ressources local (LRM)
systemctl stop pve-ha-lrm
```

# Si vous devez intervenir sur le gestionnaire de cluster (CRM - Master)
systemctl stop pve-ha-crm

Nettoyer /etc/pve/ha/manager_status après retrait d'un hôte

Ce fichier contient l'état actuel de tous les services et le statut des nœuds vu par le CRM. Si un nœud a été supprimé brutalement ("crash" ou "force removal") et que le cluster HA reste bloqué, il faut parfois purger ce statut.

Procédure de nettoyage :
 * Arrêter le service CRM sur TOUS les nœuds restants :
   systemctl stop pve-ha-crm

 * Supprimer le fichier de statut (sur un seul nœud, car /etc/pve est répliqué) :
   rm /etc/pve/ha/manager_status

 * Redémarrer le service CRM sur tous les nœuds :
   systemctl start pve-ha-crm

   Le fichier sera régénéré proprement avec les membres actuels du cluster.

# 2. Comprendre et Utiliser pmxcfs -l

Cette commande est utile lorsque vous perdez le Quorum et que le système de fichiers /etc/pve devient inaccessible ou en lecture seule.
Contexte

Normalement, /etc/pve est un système de fichiers distribué (pmxcfs) qui nécessite le Quorum pour autoriser l'écriture. Si vous perdez trop de nœuds, vous ne pouvez plus modifier /etc/pve/corosync.conf pour retirer les nœuds morts.

La commande : pmxcfs -l

Le flag -l signifie Local Mode.
 * Arrêter le service cluster :
   Il faut d'abord arrêter le service qui monte normalement le système de fichiers.

   systemctl stop pve-cluster

 * Monter en mode local :
   Cela force le montage de /etc/pve en lecture/écriture en utilisant uniquement la base de données locale (/var/lib/pve-cluster/config.db), en ignorant Corosync.
   pmxcfs -l

 * Effectuer les modifications :
   Vous pouvez maintenant éditer /etc/pve/corosync.conf pour supprimer manuellement les nœuds morts.
 * Quitter et relancer :
   Une fois fini, tuez le processus et relancez le service normal.
   killall pmxcfs
systemctl start pve-cluster

# 3. Nettoyage Ceph après retrait d'un hôte
Après avoir supprimé un nœud Proxmox via pvecm delnode, les traces de ce nœud restent souvent dans la CRUSH Map de Ceph.

La commande : ceph osd crush remove
Si vous avez déjà supprimé les OSDs du nœud, le "bucket" (l'hôte logique) existe toujours.

Procédure complète :
 * Identifier le nom du bucket (hôte) à supprimer :
   ceph osd tree

   Repérez le nom de l'hôte sous la racine (ex: host pve-03).
 * Supprimer le bucket de la CRUSH map :
   ceph osd crush remove <nom-du-noeud>
# Exemple :
ceph osd crush remove pve-03

 * Vérification :
   Relancez ceph osd tree. L'hôte ne doit plus apparaître.
Autres commandes de nettoyage Ceph utiles
 * Supprimer une clé d'authentification obsolète :
   ceph auth list
ceph auth del osd.<id>
ceph auth del mon.<nom-du-noeud>

 * Retirer un Monitor (MON) mort du quorum Ceph :
   ceph mon remove <nom-du-noeud>

# 4. Cheat Sheet : Autres commandes MCO Utiles
Cluster & Corosync

| Commande | Description |
|---|---|
| pvecm status | État global du cluster Proxmox (Quorum, Nœuds). |
| pvecm expected 1 | Danger : Force le cluster à croire qu'il a le quorum avec 1 seul vote (pour réparation temporaire). |
| corosync-cfgtool -s | Vérifie l'état des liens de communication (Knet/Totem). |
Ceph & OSD
| Commande | Description |
|---|---|
| ceph -w | Affiche l'état du cluster et les événements en temps réel. |
| ceph osd set noout | Empêche le rebalancement des données si un OSD tombe. Indispensable avant maintenance. |
| ceph osd unset noout | À lancer une fois la maintenance terminée. |
| ceph osd safe-to-destroy <osd.id> | Vérifie si la suppression d'un disque est sûre (pas de perte de données). |

## Gestion des fichiers de config verrouillés
Si une VM est bloquée (lock) suite à un crash :
## Lister les fichiers
ls -l /etc/pve/qemu-server/

# Déverrouiller une VM (ex: 100)
qm unlock 100


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


## CEPH Commande debug

 `ceph crash archive-all` : Cleaner les evenements dans le Dashboard CEPH Health



  
