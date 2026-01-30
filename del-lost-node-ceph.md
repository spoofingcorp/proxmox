# Supprimer une node non accessible avec Ceph

Lors d'un nettoyage manuel ("hard removal") parce que `pvecm delnode` a échoué, le gestionnaire de haute disponibilité (HA) garde souvent en cache l'état du nœud mort dans son fichier de statut, ce qui peut empêcher l'élection d'un nouveau maître ou bloquer des services.

Voici la **procédure complète et corrigée**, étape par étape, pour retirer proprement un nœud mort (Crash/Perte totale) d'un cluster Proxmox + Ceph.

> **⚠️ AVERTISSEMENT CRITIQUE** : Cette procédure implique l'édition manuelle de fichiers système vitaux.
> Avant de commencer, faites une copie de sauvegarde de la base de données du cluster sur un nœud survivant :
> `cp /var/lib/pve-cluster/config.db /root/backup_config.db`
> `cp /etc/pve/corosync.conf /root/backup_corosync.conf`

---

### Phase 1 : Nettoyage du Cluster (Corosync)

C'est la priorité. Tant que le nœud est dans `corosync.conf`, le cluster le cherchera.

1. **Sur un des nœuds survivants**, arrêtez les services Cluster pour couper la synchronisation :
```bash
systemctl stop pve-ha-lrm
systemctl stop pve-ha-crm
systemctl stop pve-cluster   # (s'il vous reste seulement 2 noeuds actifs)
systemctl stop corosync      # (s'il vous reste seulement 2 noeuds actifs)

```


2. **Passez le système de fichier en mode Local (Standalone)** pour autoriser l'écriture sans Quorum :
```bash
pmxcfs -l   # (s'il vous reste seulement 2 noeuds actifs)

```


3. **Éditez manuellement la configuration Corosync :**
```bash
nano /etc/pve/corosync.conf

```


* **Action A :** Supprimez tout le bloc `node { ... }` correspondant au serveur mort.
* **Action B (CRUCIALE) :** Cherchez la ligne `config_version: X` et incrémentez le numéro (ex: passez de 3 à 4). Sans cela, les autres nœuds rejetteront votre modification au redémarrage.
* **Action C :** Vérifiez la section `nodelist` pour vous assurer que le nœud mort n'y est plus.
* Sauvegardez et quittez (`Ctrl+O`, `Enter`, `Ctrl+X`).


4. **Nettoyez les fichiers spécifiques au nœud mort :**
Toujours en mode local, supprimez le dossier contenant la config du nœud (qemu-server, lxc, réseau) :
```bash
rm -rf /etc/pve/nodes/<NOM_DU_NOEUD_MORT>

```


*Note : Assurez-vous d'avoir récupéré les fichiers `.conf` des VMs si vous comptez les restaurer ailleurs, sinon elles seront perdues de l'interface.*
5. **Tuez le mode local :**
```bash
killall pmxcfs  # (s'il vous reste seulement 2 noeuds actifs)

```



---

### Phase 2 : Nettoyage du HA Manager (Le point que vous avez soulevé)

Le fichier `manager_status` contient l'état runtime du cluster HA. S'il contient des références au nœud mort, le CRM peut boucler.

1. **Assurez-vous que le service CRM est stoppé sur TOUS les nœuds survivants :**
```bash
# À faire sur TOUS les nœuds restants
systemctl stop pve-ha-crm
systemctl stop pve-ha-lrm

```


2. **Supprimez le fichier de statut (sur un seul nœud, la réplication fera le reste plus tard) :**
Puisque `pmxcfs` est arrêté (étape précédente), redémarrez d'abord le cluster en mode normal sur ce nœud pour accéder à `/etc/pve`.
```bash
systemctl start corosync
systemctl start pve-cluster

```


Une fois le quorum atteint (ou forcé via `pvecm expected 1` si vous n'avez pas assez de nœuds survivants), supprimez le fichier :
```bash
rm /etc/pve/ha/manager_status

```


*Ce fichier sera régénéré automatiquement et proprement au démarrage du service.*
3. **Redémarrez les services HA sur TOUS les nœuds :**
```bash
systemctl start pve-ha-lrm
systemctl start pve-ha-crm

```



---

### Phase 3 : Nettoyage Ceph (Monitors & OSDs)

Ceph stocke sa propre carte du cluster (Map). Il faut retirer le nœud mort de cette carte.

1. **Supprimer le moniteur (MON) du nœud mort :**
Dans `/etc/pve/ceph.conf` (ou via l'interface si accessible), vérifiez si le nœud mort avait un MON.
```bash
ceph mon remove <NOM_DU_NOEUD_MORT>

```


2. **Supprimer les OSDs du nœud mort :**
Le nœud est mort, ses disques sont perdus.
Listez les OSDs appartenant au nœud mort via `ceph osd tree`. Pour chaque OSD (ex: osd.1, osd.2) :
```bash
# Marquer l'OSD comme "Out" (normalement déjà fait si down)
ceph osd out osd.<ID>

# Supprimer l'OSD de la carte CRUSH
ceph osd crush remove osd.<ID>

# Supprimer la clé d'authentification
ceph auth del osd.<ID>

# Supprimer l'OSD du cluster
ceph osd rm osd.<ID>

```


3. **Supprimer le nœud de la CRUSH Map :**
Maintenant que le nœud est vide dans l'arbre Ceph :
```bash
ceph osd crush remove <NOM_DU_NOEUD_MORT>

```



---

### Phase 4 : Nettoyage SSH et Clés

Pour éviter les conflits lors d'une éventuelle réinstallation future ou des erreurs de logs.

1. **Sur chaque nœud restant**, nettoyez les `known_hosts` :
```bash
ssh-keygen -f "/root/.ssh/known_hosts" -R <NOM_DU_NOEUD_MORT>
ssh-keygen -f "/root/.ssh/known_hosts" -R <IP_DU_NOEUD_MORT>

```


2. **Vérifiez la liste des clés autorisées du cluster :**
Regardez dans `/etc/pve/priv/authorized_keys` si la clé du nœud mort y est encore (c'est rare après suppression du dossier `/etc/pve/nodes/`, mais possible).

---

### Phase 5 : Vérification Finale

1. Vérifiez que le cluster Proxmox ne voit plus le nœud :
```bash
pvecm status
pvecm nodes

```


2. Vérifiez que le HA Manager est sain et sans traces du fantôme :
```bash
ha-manager status

```


*(Le nœud mort ne doit plus apparaître dans la liste des nœuds, ni en "unknown", ni en "dead").*
3. Vérifiez la santé Ceph :
```bash
ceph -s

```
