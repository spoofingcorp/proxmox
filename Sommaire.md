Voici une version optimisée en Markdown pour GitHub. J'ai ajouté une table des matières, utilisé des icônes pour la lisibilité et transformé les liens bruts en liens cliquables sur les titres pour un rendu plus professionnel.

---

# 📚 Centre de Ressources Proxmox VE

Ce dépôt regroupe l'ensemble de la documentation, des guides de configuration et des supports de formation pour la mise en place et l'administration d'une infrastructure **Proxmox Virtual Environment**.

---

## 📍 Table des Matières

1. [Introduction et Architecture Générale](https://www.google.com/search?q=%231-introduction-et-architecture-g%C3%A9n%C3%A9rale)
2. [Configuration Réseau](https://www.google.com/search?q=%232-configuration-r%C3%A9seau)
3. [Stockage (Storage)](https://www.google.com/search?q=%233-stockage-storage)
4. [Machines Virtuelles (VM)](https://www.google.com/search?q=%234-machines-virtuelles-vm)
5. [Cluster, Haute Disponibilité (HA) et Maintenance](https://www.google.com/search?q=%235-cluster-haute-disponibilit%C3%A9-ha-et-maintenance)
6. [Sécurité et Gestion des Accès](https://www.google.com/search?q=%236-s%C3%A9curit%C3%A9-et-gestion-des-acc%C3%A8s)
7. [Sauvegarde (Backup)](https://www.google.com/search?q=%237-sauvegarde-backup)

---

## 🏗️ 1. Introduction et Architecture Générale

*Cette section couvre les bases de Proxmox VE, son architecture et la topologie du labo.*

* **[Présentation de la solution](https://drive.google.com/file/d/1EXScXt_k7JE0rH3L5S8QXVWSp5LDxBBJ/view?usp=drivesdk)** : Introduction à Proxmox VE, comparaison avec d'autres hyperviseurs (vSphere, Hyper-V) et découverte de l'interface.
* **[Guide complet de virtualisation](https://drive.google.com/file/d/1CP1FzBqUH_aI__W5NpYJnIZpdEm6yn22/view?usp=drivesdk)** : Tutoriel complet (Installation, stockage, réseau, VM/CT et supervision Zabbix/Grafana).
* **[Support de formation : Administration Avancée](https://docs.google.com/document/d/11PGR87DC91-0hleWjD7oEIYov6yfE-k47tn6ipU0i10/edit?usp=sharing)** : Mise en cluster, Ceph/iSCSI, HA et MCO. *(Par Rémi BRUSSE)*.
* **[Support de formation Dawan - Proxmox](https://hedgedoc.dawan.fr/ZKT26S6pRRiRA0YI7U1rhA)** : Notes de formation complémentaires.
* **[Documentation officielle](https://drive.google.com/file/d/1JlAgRC0lf2Irm0DOAlpbZljB7hmtfm6e/view?usp=drivesdk)** : Guide d'administration complet (Référence technique).
* **Topologies réseau :** Schémas d'architecture incluant VLANs, Ceph, TrueNAS et interfaces physiques.
* [Schéma d'architecture 1](https://drive.google.com/file/d/18ie8wiAlHtGuLu-uzXsxWAGE0xWREMd0/view?usp=drivesdk)
* [Schéma d'architecture 2](https://drive.google.com/file/d/1pEFwpwH5ZZP6d41CXlpjcaGucTB162nc/view?usp=drivesdk)



---

## 🌐 2. Configuration Réseau

*Détails sur la configuration des interfaces, des switchs virtuels et du SDN.*

* **[Linux Bridge vs Open vSwitch (OVS)](https://docs.google.com/document/d/11T8RLSTjMAvn3IfW-KcPEPKiFad0pUziN76GVqzsXBk/edit?usp=drivesdk)** : Guide comparatif, avantages/inconvénients et cas d'usage.
* **[Guide de configuration (Bridge/OVS)](https://docs.google.com/document/d/1SvPf1erJ8zAS2-LDiJkcmysHVHkowzFN3QUAvL0hgk8/edit?usp=drivesdk)** : Mise en place pratique des bridges, du bonding (LACP) et des VLANs.
* **[Recommandations réseau](https://docs.google.com/document/d/1Tf4QAUuIaB-8HUcgIcic6A6kv1qMSa110CR6o04kreQ/edit?usp=drivesdk)** : Bonnes pratiques pour l'isolation des flux (Management, Corosync, Stockage, Migration).
* **Software-Defined Network (SDN) :**
* [Introduction aux Zones](https://docs.google.com/document/d/1w1xu7hegrkQ9StqCb9g2kpiRNVok4Ry-0JDXf6yOv4E/edit?usp=drivesdk) : Simple, VLAN, VXLAN, EVPN et VNets.
* [Extension L2 via VXLAN](https://docs.google.com/document/d/1iseSIh7DpxMtUcUpT04JX9jghep4SgjmN0WHbIh_cAk/edit?usp=drivesdk) : Utilisation des ponts VLAN-aware.


* **[Architecture avancée](https://docs.google.com/document/d/1gP2JzxHr6H4phrU33kRZmqEgxX3QVpq9vG9WgDczOc0/edit?usp=drivesdk)** : Simulation d'un "Distributed Switch" VMware avec OVS sans contrôleur.
* **[Gestion en CLI](https://docs.google.com/document/d/1Zg2HAnD6i-E69Q3BHpqOpdh5zWIR6Oc2TskrjHJ01LM/edit?usp=drivesdk)** : Commandes pour modifier le réseau des VMs (tags, bridges) en ligne de commande.

---

## 💾 3. Stockage (Storage)

*Configuration des différents types de stockage (Local, NAS, SAN, Distribué).*

* **[NAS TrueNAS (NFS)](https://docs.google.com/document/d/13XXjIetLUGDpZPN775us-9HeVVYgFpWU1jpQM6eVSUU/edit?usp=drivesdk)** : Configuration d'un partage NFS pour Proxmox.
* **[SAN Fibre Channel (NetApp)](https://docs.google.com/document/d/1WrT0aVb3ufmNfGdwM8wYY92PEPLCIYXE3huL_tSkYYs/edit?usp=drivesdk)** : Multipathing et connexion à une baie NetApp.
* **[SAN iSCSI (QSAN)](https://drive.google.com/file/d/1sJ9EoYFe6wNvJBcu9r1rg31z4i1u3tK6/view?usp=drivesdk)** : Stockage iSCSI, MPIO et LVM avec baies QSAN.
* **[ZFS](https://docs.google.com/document/d/1CM8ecHdIMFeLesBKiz3XrvLcZFEMwgm-90ZbuQvn4wQ/edit?usp=drivesdk)** : Pools ZFS et réplication entre nœuds.
* **Gestion des disques virtuels :**
* [Déplacer, agrandir, snapshots](https://docs.google.com/document/d/1MZDze___325SW3kpxef3Pk_39Ii8RtWuWeJfDsYmzY8/edit?usp=drivesdk) : Guide complet de gestion.
* [Opérations à chaud & Migration](https://docs.google.com/document/d/1nHg94Vv5IZdH84Kl9MQAgJJlx5hFyyZ3Bm4R_s7lIyg/edit?usp=drivesdk) : Hot-Add, Live Storage Migration et conversion de formats (qcow2/raw/vmdk).
* [Récupération de VM](https://docs.google.com/document/d/1dS7m--nmH56NFLsBtw_5g7KRizUM66OfHmWL4YMmoH0/edit?usp=drivesdk) : Ré-inventaire à partir d'un disque orphelin.



---

## 🖥️ 4. Machines Virtuelles (VM)

*Bonnes pratiques pour la création, l'optimisation et la gestion des VMs.*

* **[Optimisation Linux](https://docs.google.com/document/d/1eqsj3saC6P3VpsWoL1pNHPk9GrUfo9LkjtlldgEl42I/edit?usp=drivesdk)** : Base de référence pour Ubuntu/Debian.
* **[Optimisation Windows Server](https://docs.google.com/document/d/1yH413DfJmH-2mT7DnIYuDBZ6vQWW94ZRaopeCToeGjg/edit?usp=drivesdk)** : Drivers VirtIO et configurations spécifiques.
* **[Bonnes pratiques générales](https://docs.google.com/document/d/1hRUDhRb0bSBzcegc91eW7KOWgR-ZiymB-iqdMjOyxKo/edit?usp=drivesdk)** : Choix CPU, NUMA, cache disque et TRIM/Discard.
* **[QEMU Guest Agent](https://docs.google.com/document/d/13ioy7rSHnRiXdYMXszGHMgvxcBeCgV2iR0NrwHoFy7c/edit?usp=drivesdk)** : Installation et interaction pour des backups cohérents.
* **[Migration depuis ESXi](https://docs.google.com/document/d/1fC1xwFgEgL4VO8YIw8J9AIS826nht5RGu42RvqkJJJM/edit?usp=drivesdk)** : Importation VMware, conversion OVF/OVA et templates.

---

## 🛠️ 5. Cluster, Haute Disponibilité (HA) et Maintenance

*Gestion du cycle de vie du cluster et des nœuds.*

* **[Fonctionnement du Cluster](https://docs.google.com/document/d/10J-VeaCyQ-kWviIEB4erEK97Kxb2oV7h96GsW5pwvhI/edit?usp=drivesdk)** : Quorum, Corosync et Fencing.
* **[Configuration de la HA](https://docs.google.com/document/d/14xSnk100VspqOPAtnL0xoYMCgkH45F1m7D-cpSY7cEI/edit?usp=drivesdk)** : Groupes HA et politiques d'arrêt.
* **Gestion des Nœuds :**
* [Mode Maintenance](https://docs.google.com/document/d/1OMitywVnNpt5aOEYF1Xt1N-LxmJbiDvcX46v18H6KUU/edit?usp=drivesdk) : Procédure de mise hors service temporaire.
* [Suppression d'un nœud](https://docs.google.com/document/d/1ebD0lQfE03A7gtiSt-atajVrWodrMC7jY_dDj4NkbxA/edit?usp=drivesdk) : Procédure propre de retrait du cluster.
* [Renommer un nœud](https://docs.google.com/document/d/11z6CR171DUjmHh51tpTSMDhOVAVfX-nuzbe6vI1aV-U/edit?usp=drivesdk) : Guide pas à pas (Procédure sensible).


* **[Dépannage Cluster](https://docs.google.com/document/d/1Y6lowRTuY9KcZoZnATTA9vlmFAvAy7xE7AHPqxfok2w/edit?usp=drivesdk)** : Commandes CLI pour Corosync et Quorum.
* **[Maintenance Opérationnelle (MCO)](https://docs.google.com/document/d/1FM2hgh5QnqgmsaEd5uoYSxyXSLQz6FboARu9Si6gdpg/edit?usp=drivesdk)** : Gestion des verrous (locks), snapshots et fichiers de config via CLI.

---

## 🔒 6. Sécurité et Gestion des Accès

*Sécurisation de l'infrastructure et gestion des utilisateurs.*

* **Pare-feu (Firewall) :**
* [Configuration 3 niveaux](https://docs.google.com/document/d/1-sJwm6MJfYxVjs_RKGTDKnfW8jPgtCZaryPuthbz5fc/edit?usp=drivesdk) : Datacenter, Nœud, VM et IPSets.
* [Gestion via CLI](https://docs.google.com/document/d/1xrqDIPBzpz2yJcWnc_uQpkj7pnm-FyHVEtV9rZ47P9I/edit?usp=drivesdk) : Commandes pour administrer le pare-feu.


* **[Authentification et Rôles](https://docs.google.com/document/d/1DhoeVmZdVaWpUbcboUcOPBRjzruMtXSu1A1kIp7pXdY/edit?usp=drivesdk)** : Utilisateurs, rôles personnalisés, pools et intégration Active Directory.
* **Double Facteur (2FA/MFA) :**
* [Authentification TOTP](https://docs.google.com/document/d/1_IfgsXqbedp-oz1OerOtdSV6SnDWP_dtbF3ErvB-QNk/edit?usp=drivesdk) : Google Authenticator, etc.
* [Clés YubiKey](https://docs.google.com/document/d/1SRhW7xMijO3eFbfzd-ZXzewgadl8sVOH2Das-A-rudg/edit?usp=drivesdk) : Sécurisation matérielle.


* **[Certificats SSL](https://docs.google.com/document/d/1fvO_qEl2kGo6F6fS4YIQcKoLeUWuHomqfMrZ3HyWhF8/edit?usp=drivesdk)** : Installation via AD CS ou Let's Encrypt.

---

## 🛡️ 7. Sauvegarde (Backup)

*Stratégies et outils de sauvegarde.*

* **[Proxmox Backup Server (PBS)](https://docs.google.com/document/d/1c_EmBgeOoi9iWgh-azQNRnJrySnqhvG1PrsRcPv1S0E/edit?usp=drivesdk)** : Installation, configuration des datastores et intégration au cluster.

### 1. Introduction et Architecture Générale
Cette section couvre les bases de Proxmox VE, son architecture et la topologie du labo.

*   **Présentation de la solution :** Introduction à Proxmox VE, comparaison avec d'autres hyperviseurs (vSphere, Hyper-V), et présentation de l'interface graphique.

https://drive.google.com/file/d/1EXScXt_k7JE0rH3L5S8QXVWSp5LDxBBJ/view?usp=drivesdk

*   **Guide complet de virtualisation :** Tutoriel complet couvrant l'installation, le stockage, le réseau, la création de VM/CT et la supervision (Zabbix/Grafana).

https://drive.google.com/file/d/1CP1FzBqUH_aI__W5NpYJnIZpdEm6yn22/view?usp=drivesdk

* **Support de formation complet couvrant l'administration avancée : mise en cluster, stockage distribué (Ceph/iSCSI), haute disponibilité et procédures de maintenance (MCO) - Auteur Rémi BRUSSE**

https://docs.google.com/document/d/11PGR87DC91-0hleWjD7oEIYov6yfE-k47tn6ipU0i10/edit?usp=sharing

* **Support de formation Dawan - Proxmox**

https://hedgedoc.dawan.fr/ZKT26S6pRRiRA0YI7U1rhA

*   **Documentation officielle :** Guide d'administration complet de Proxmox VE (référence technique globale).

https://drive.google.com/file/d/1JlAgRC0lf2Irm0DOAlpbZljB7hmtfm6e/view?usp=drivesdk

*   **Topologies réseau :** Schémas d'architecture réseau incluant les VLANs, le stockage (Ceph/TrueNAS) et les interfaces physiques,.

https://drive.google.com/file/d/18ie8wiAlHtGuLu-uzXsxWAGE0xWREMd0/view?usp=drivesdk

https://drive.google.com/file/d/1pEFwpwH5ZZP6d41CXlpjcaGucTB162nc/view?usp=drivesdk

### 2. Configuration Réseau
Détails sur la configuration des interfaces, des switchs virtuels et du Software-Defined Networking (SDN).

*   **Linux Bridge vs Open vSwitch (OVS) :** Guide comparatif, avantages/inconvénients et cas d'usage pour choisir entre le réseau standard et OVS.

https://docs.google.com/document/d/11T8RLSTjMAvn3IfW-KcPEPKiFad0pUziN76GVqzsXBk/edit?usp=drivesdk

*   **Guide de configuration (Bridge/OVS) :** Mise en place pratique des bridges, du bonding (LACP) et des VLANs.


https://docs.google.com/document/d/1SvPf1erJ8zAS2-LDiJkcmysHVHkowzFN3QUAvL0hgk8/edit?usp=drivesdk

*   **Recommandations réseau :** Bonnes pratiques pour l'isolation des flux (Management, Cluster/Corosync, Stockage, Migration).

https://docs.google.com/document/d/1Tf4QAUuIaB-8HUcgIcic6A6kv1qMSa110CR6o04kreQ/edit?usp=drivesdk


*   **Software-Defined Network (SDN) :**
*   **Introduction aux Zones (Simple, VLAN, VXLAN, EVPN) et VNets.**

https://docs.google.com/document/d/1w1xu7hegrkQ9StqCb9g2kpiRNVok4Ry-0JDXf6yOv4E/edit?usp=drivesdk


*   **Extension d'un réseau de niveau 2 (L2) via VXLAN et ponts VLAN-aware.**


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

https://docs.google.com/document/d/1WrT0aVb3ufmNfGdwM8wYY92PEPLCIYXE3huL_tSkYYs/edit?usp=drivesdk


*   **SAN iSCSI (QSAN) :** Guide de configuration du stockage iSCSI, MPIO et LVM avec des baies QSAN.


https://drive.google.com/file/d/1sJ9EoYFe6wNvJBcu9r1rg31z4i1u3tK6/view?usp=drivesdk

*   **ZFS :** Mise en place de pools ZFS et configuration de la réplication (ZFS Replication) entre nœuds.

https://docs.google.com/document/d/1CM8ecHdIMFeLesBKiz3XrvLcZFEMwgm-90ZbuQvn4wQ/edit?usp=drivesdk


*   **Gestion des disques virtuels :**

*   **Guide pour déplacer, agrandir, réassigner, et prendre des snapshots de disques.**

https://docs.google.com/document/d/1MZDze___325SW3kpxef3Pk_39Ii8RtWuWeJfDsYmzY8/edit?usp=drivesdk

*   **Procédures pour l'ajout à chaud (Hot-Add), la migration de stockage (Live Storage Migration) et la conversion de formats (qcow2/raw/vmdk).**

https://docs.google.com/document/d/1nHg94Vv5IZdH84Kl9MQAgJJlx5hFyyZ3Bm4R_s7lIyg/edit?usp=drivesdk


*   **Récupération et ré-inventaire d'une VM à partir d'un disque orphelin.**

https://docs.google.com/document/d/1dS7m--nmH56NFLsBtw_5g7KRizUM66OfHmWL4YMmoH0/edit?usp=drivesdk


### 4. Machines Virtuelles (VM)
Bonnes pratiques pour la création, l'optimisation et la gestion des VMs.

*   **Linux :** Base de référence et optimisations pour les VMs Linux (Ubuntu/Debian).

https://docs.google.com/document/d/1eqsj3saC6P3VpsWoL1pNHPk9GrUfo9LkjtlldgEl42I/edit?usp=drivesdk

*   **Windows Server :** Base de référence et optimisations pour les VMs Windows (VirtIO, Drivers).

https://docs.google.com/document/d/1yH413DfJmH-2mT7DnIYuDBZ6vQWW94ZRaopeCToeGjg/edit?usp=drivesdk

*   **Bonnes pratiques générales :** Choix du type de CPU, configuration NUMA, cache disque et options TRIM/Discard.

https://docs.google.com/document/d/1hRUDhRb0bSBzcegc91eW7KOWgR-ZiymB-iqdMjOyxKo/edit?usp=drivesdk

*   **QEMU Guest Agent :** Importance, installation et interaction avec l'hyperviseur pour des arrêts propres et des backups cohérents.

https://docs.google.com/document/d/13ioy7rSHnRiXdYMXszGHMgvxcBeCgV2iR0NrwHoFy7c/edit?usp=drivesdk

*   **Migration depuis ESXi :** Procédures d'importation de VMs VMware, conversion OVF/OVA et création de templates.

https://docs.google.com/document/d/1fC1xwFgEgL4VO8YIw8J9AIS826nht5RGu42RvqkJJJM/edit?usp=drivesdk


### 5. Cluster, Haute Disponibilité (HA) et Maintenance
Gestion du cycle de vie du cluster et des nœuds.

*   **Fonctionnement du Cluster :** Comprendre le Quorum, Corosync et les mécanismes de protection (Fencing).

https://docs.google.com/document/d/10J-VeaCyQ-kWviIEB4erEK97Kxb2oV7h96GsW5pwvhI/edit?usp=drivesdk


*   **Configuration de la HA :** Mise en place des groupes de haute disponibilité et politiques d'arrêt.

https://docs.google.com/document/d/14xSnk100VspqOPAtnL0xoYMCgkH45F1m7D-cpSY7cEI/edit?usp=drivesdk

*   **Gestion des Nœuds :**

*   **Procédure pour mettre un nœud en mode maintenance.**

https://docs.google.com/document/d/1OMitywVnNpt5aOEYF1Xt1N-LxmJbiDvcX46v18H6KUU/edit?usp=drivesdk

*   **Procédure pour supprimer proprement un nœud du cluster.**

https://docs.google.com/document/d/1ebD0lQfE03A7gtiSt-atajVrWodrMC7jY_dDj4NkbxA/edit?usp=drivesdk

*   **Procédure (risquée) pour renommer un nœud.**

https://docs.google.com/document/d/11z6CR171DUjmHh51tpTSMDhOVAVfX-nuzbe6vI1aV-U/edit?usp=drivesdk

*   **Dépannage Cluster :** Commandes CLI pour diagnostiquer Corosync et les problèmes de Quorum.

https://docs.google.com/document/d/1Y6lowRTuY9KcZoZnATTA9vlmFAvAy7xE7AHPqxfok2w/edit?usp=drivesdk


*   **Maintenance Opérationnelle (MCO) :** Commandes CLI pour la gestion des verrous (locks), des snapshots et des configurations.

https://docs.google.com/document/d/1FM2hgh5QnqgmsaEd5uoYSxyXSLQz6FboARu9Si6gdpg/edit?usp=drivesdk


### 6. Sécurité et Gestion des Accès
Sécurisation de l'infrastructure et gestion des utilisateurs.

*   **Pare-feu (Firewall) :**

*   **Guide de configuration du pare-feu à trois niveaux (Datacenter, Nœud, VM) et création d'IPSets.**

https://docs.google.com/document/d/1-sJwm6MJfYxVjs_RKGTDKnfW8jPgtCZaryPuthbz5fc/edit?usp=drivesdk

*   **Gestion du pare-feu en ligne de commande (CLI).**

https://docs.google.com/document/d/1xrqDIPBzpz2yJcWnc_uQpkj7pnm-FyHVEtV9rZ47P9I/edit?usp=drivesdk


*   **Authentification et Rôles :** Exercices sur la création d'utilisateurs, de rôles personnalisés, de pools de ressources et l'intégration Active Directory.

https://docs.google.com/document/d/1DhoeVmZdVaWpUbcboUcOPBRjzruMtXSu1A1kIp7pXdY/edit?usp=drivesdk


*   **Double Facteur (2FA/MFA) :**
*   **Mise en place de l'authentification TOTP (Google Authenticator, etc.).**


https://docs.google.com/document/d/1_IfgsXqbedp-oz1OerOtdSV6SnDWP_dtbF3ErvB-QNk/edit?usp=drivesdk

*   **Sécurisation avec des clés matérielles YubiKey.**

https://docs.google.com/document/d/1SRhW7xMijO3eFbfzd-ZXzewgadl8sVOH2Das-A-rudg/edit?usp=drivesdk


*   **Certificats SSL :** Installation de certificats (AD CS ou Let's Encrypt).

https://docs.google.com/document/d/1fvO_qEl2kGo6F6fS4YIQcKoLeUWuHomqfMrZ3HyWhF8/edit?usp=drivesdk

### 7. Sauvegarde (Backup)
Stratégies et outils de sauvegarde.

*   **Proxmox Backup Server (PBS) :** Installation, configuration des datastores et intégration avec le cluster Proxmox VE.

https://docs.google.com/document/d/1c_EmBgeOoi9iWgh-azQNRnJrySnqhvG1PrsRcPv1S0E/edit?usp=drivesdk





