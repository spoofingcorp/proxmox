

### 1. Introduction et Architecture Générale
Cette section couvre les bases de Proxmox VE, son architecture et la topologie du labo.

*   **Présentation de la solution :** Introduction à Proxmox VE, comparaison avec d'autres hyperviseurs (vSphere, Hyper-V), et présentation de l'interface graphique.

https://drive.google.com/file/d/1EXScXt_k7JE0rH3L5S8QXVWSp5LDxBBJ/view?usp=drivesdk

*   **Guide complet de virtualisation :** Tutoriel complet couvrant l'installation, le stockage, le réseau, la création de VM/CT et la supervision (Zabbix/Grafana).

https://drive.google.com/file/d/1CP1FzBqUH_aI__W5NpYJnIZpdEm6yn22/view?usp=drivesdk


*   **Documentation officielle :** Guide d'administration complet de Proxmox VE (référence technique globale).
*   **Topologies réseau :** Schémas d'architecture réseau incluant les VLANs, le stockage (Ceph/TrueNAS) et les interfaces physiques,.

https://drive.google.com/file/d/1JlAgRC0lf2Irm0DOAlpbZljB7hmtfm6e/view?usp=drivesdk

### 2. Configuration Réseau
Détails sur la configuration des interfaces, des switchs virtuels et du Software-Defined Networking (SDN).

https://drive.google.com/file/d/18ie8wiAlHtGuLu-uzXsxWAGE0xWREMd0/view?usp=drivesdk

https://drive.google.com/file/d/1pEFwpwH5ZZP6d41CXlpjcaGucTB162nc/view?usp=drivesdk


*   **Linux Bridge vs Open vSwitch (OVS) :** Guide comparatif, avantages/inconvénients et cas d'usage pour choisir entre le réseau standard et OVS.

https://docs.google.com/document/d/11T8RLSTjMAvn3IfW-KcPEPKiFad0pUziN76GVqzsXBk/edit?usp=drivesdk

*   **Guide de configuration (Bridge/OVS) :** Mise en place pratique des bridges, du bonding (LACP) et des VLANs.


https://docs.google.com/document/d/1SvPf1erJ8zAS2-LDiJkcmysHVHkowzFN3QUAvL0hgk8/edit?usp=drivesdk

*   **Recommandations réseau :** Bonnes pratiques pour l'isolation des flux (Management, Cluster/Corosync, Stockage, Migration).

https://docs.google.com/document/d/1Tf4QAUuIaB-8HUcgIcic6A6kv1qMSa110CR6o04kreQ/edit?usp=drivesdk


*   **Software-Defined Network (SDN) :**
    *   Introduction aux Zones (Simple, VLAN, VXLAN, EVPN) et VNets.

https://docs.google.com/document/d/1w1xu7hegrkQ9StqCb9g2kpiRNVok4Ry-0JDXf6yOv4E/edit?usp=drivesdk


    *   Extension d'un réseau de niveau 2 (L2) via VXLAN et ponts VLAN-aware.


https://docs.google.com/document/d/1iseSIh7DpxMtUcUpT04JX9jghep4SgjmN0WHbIh_cAk/edit?usp=drivesdk

*   **Architecture avancée :** Simulation d'un "Distributed Switch" VMware avec OVS sans contrôleur SDN.

https://docs.google.com/document/d/1gP2JzxHr6H4phrU33kRZmqEgxX3QVpq9vG9WgDczOc0/edit?usp=drivesdk

*   **Gestion en CLI :** Commandes pour modifier le réseau des VMs (ajout de tags, changement de bridge) en ligne de commande.

https://docs.google.com/document/d/1Zg2HAnD6i-E69Q3BHpqOpdh5zWIR6Oc2TskrjHJ01LM/edit?usp=drivesdk

### 3. Stockage (Storage)
Configuration des différents types de stockage (Local, NAS, SAN, Distribué).


*   **NAS TrueNAS (NFS) :** Guide de configuration d'un partage NFS sur TrueNAS Scale pour Proxmox.

https://docs.google.com/document/d/13XXjIetLUGDpZPN775us-9HeVVYgFpWU1jpQM6eVSUU/edit?usp=drivesdk


*   **SAN Fibre Channel (NetApp) :** Configuration du Multipathing et connexion à une baie NetApp en FC.




*   **SAN iSCSI (QSAN) :** Guide de configuration du stockage iSCSI, MPIO et LVM avec des baies QSAN.
*   **ZFS :** Mise en place de pools ZFS et configuration de la réplication (ZFS Replication) entre nœuds.
*   **Gestion des disques virtuels :**
    *   Guide pour déplacer, agrandir, réassigner, et prendre des snapshots de disques.
    *   Procédures pour l'ajout à chaud (Hot-Add), la migration de stockage (Live Storage Migration) et la conversion de formats (qcow2/raw/vmdk).
    *   Récupération et ré-inventaire d'une VM à partir d'un disque orphelin.

### 4. Machines Virtuelles (VM)
Bonnes pratiques pour la création, l'optimisation et la gestion des VMs.

*   **Linux :** Base de référence et optimisations pour les VMs Linux (Ubuntu/Debian).
*   **Windows Server :** Base de référence et optimisations pour les VMs Windows (VirtIO, Drivers).
*   **Bonnes pratiques générales :** Choix du type de CPU, configuration NUMA, cache disque et options TRIM/Discard.
*   **QEMU Guest Agent :** Importance, installation et interaction avec l'hyperviseur pour des arrêts propres et des backups cohérents.
*   **Migration depuis ESXi :** Procédures d'importation de VMs VMware, conversion OVF/OVA et création de templates.

### 5. Cluster, Haute Disponibilité (HA) et Maintenance
Gestion du cycle de vie du cluster et des nœuds.

*   **Fonctionnement du Cluster :** Comprendre le Quorum, Corosync et les mécanismes de protection (Fencing).
*   **Configuration de la HA :** Mise en place des groupes de haute disponibilité et politiques d'arrêt.
*   **Gestion des Nœuds :**
    *   Procédure pour mettre un nœud en mode maintenance.
    *   Procédure pour supprimer proprement un nœud du cluster.
    *   Procédure (risquée) pour renommer un nœud.
*   **Dépannage Cluster :** Commandes CLI pour diagnostiquer Corosync et les problèmes de Quorum.
*   **Maintenance Opérationnelle (MCO) :** Commandes CLI pour la gestion des verrous (locks), des snapshots et des configurations.

### 6. Sécurité et Gestion des Accès
Sécurisation de l'infrastructure et gestion des utilisateurs.

*   **Pare-feu (Firewall) :**
    *   Guide de configuration du pare-feu à trois niveaux (Datacenter, Nœud, VM) et création d'IPSets.
    *   Gestion du pare-feu en ligne de commande (CLI).
*   **Authentification et Rôles :** Exercices sur la création d'utilisateurs, de rôles personnalisés, de pools de ressources et l'intégration Active Directory.
*   **Double Facteur (2FA/MFA) :**
    *   Mise en place de l'authentification TOTP (Google Authenticator, etc.).
    *   Sécurisation avec des clés matérielles YubiKey.
*   **Certificats SSL :** Installation de certificats (AD CS ou Let's Encrypt).

### 7. Sauvegarde (Backup)
Stratégies et outils de sauvegarde.

*   **Proxmox Backup Server (PBS) :** Installation, configuration des datastores et intégration avec le cluster Proxmox VE.





