## **Paramètres de Haute Disponibilité (HA) sur un Cluster Proxmox**
Dans un cluster Proxmox, les délais de détection des défaillances et de redémarrage des machines virtuelles sur un autre nœud sont principalement définis par les paramètres suivants :

### **1. Détection d'un nœud en panne :**
- **`watchdog-timeout`** : Définit le temps après lequel un nœud est considéré comme en panne. Par défaut, ce paramètre est généralement **10 secondes**.
- **`shutdown-policy`** : Contrôle la manière dont les VM sont arrêtées en cas d'arrêt d'un nœud.
- **`crm-retransition-delay`** : Définit le délai avant qu'un redémarrage de service ne soit tenté. Par défaut, il est généralement de **60 secondes**.

### **2. Redémarrage des VMs sur un autre nœud :**
- **`recovery-timeout`** : Délai avant que Proxmox tente de redémarrer une VM après une panne. Il est généralement fixé à **30 secondes**.
- **`max_restart`** : Nombre maximum de tentatives de redémarrage avant de marquer la VM comme défaillante. La valeur par défaut est **1**.
- **`max_relocate`** : Nombre de tentatives pour déplacer une VM vers un autre nœud avant de considérer l’opération comme un échec. La valeur par défaut est **1**.

Ces valeurs sont ajustables via la configuration HA de Proxmox.

## **Voir les logs de la HA sur un cluster Proxmox**
Il existe plusieurs façons d'observer les événements HA dans Proxmox.

### **1. Journal des événements HA**
Vous pouvez voir l’état du cluster et les événements HA avec la commande suivante :
```bash
ha-manager status
```

### **2. Logs détaillés du service HA**
Les logs spécifiques à la haute disponibilité sont stockés dans `changement de dossier log`. Vous pouvez les afficher avec :

En cours de construction

### **3. Logs du gestionnaire de cluster (Corosync)**
Les logs de Corosync peuvent également fournir des informations sur la perte de nœuds ou la communication entre les membres du cluster :
```bash
journalctl -u corosync --no-pager -n 50
```

### **4. Logs du service de gestion HA (pve-ha-lrm et pve-ha-crm)**
Le **Resource Manager (pve-ha-lrm)** et le **Cluster Resource Manager (pve-ha-crm)** sont responsables du fonctionnement de la HA :
```bash
journalctl -u pve-ha-lrm --no-pager -n 50
journalctl -u pve-ha-crm --no-pager -n 50
```

### **5. Logs d'une VM spécifique en HA**
Si vous voulez voir pourquoi une VM spécifique a été déplacée ou redémarrée, vous pouvez rechercher son nom ou son ID dans les logs :
```bash
grep "VMID" /var/log/pve-ha.log
```
(remplacez **VMID** par l'ID de la VM concernée)

---

Si tu veux modifier les paramètres HA, il faut ajuster le fichier de configuration situé dans :
```bash
/etc/pve/ha/resources.cfg
```
Et utiliser la commande suivante après modification :
```bash
ha-manager reload
```

 :rocket:


# **:pushpin: Où modifier les paramètres HA dans Proxmox ?**

Les paramètres de haute disponibilité (HA) dans Proxmox sont configurables principalement via les fichiers de configuration dans `/etc/pve/ha/` et à travers l'interface en ligne de commande avec `ha-manager`

Les valeurs des délais de HA sont définies dans deux fichiers de configuration principaux :

### **1. Configuration des ressources HA (`/etc/pve/ha/resources.cfg`)**
Ce fichier définit les machines virtuelles ou les conteneurs qui sont gérés par HA.

- **Modifier le comportement d’une VM en HA :**
  ```bash
  nano /etc/pve/ha/resources.cfg
  ```
  Exemples de configurations possibles :
  ```ini
  vm: 100
    max_restart 2
    max_relocate 1
  ```
  - `max_restart` : Nombre maximum de tentatives de redémarrage d’une VM avant d’abandonner.
  - `max_relocate` : Nombre de tentatives pour déplacer une VM sur un autre nœud avant d’abandonner.

---

### **2. Configuration du gestionnaire HA (`/etc/pve/ha/groups.cfg`)**
Ce fichier définit les groupes de HA et les nœuds où les VM/CT peuvent être migrés.

- **Modifier les règles de migration HA :**
  ```bash
  nano /etc/pve/ha/groups.cfg
  ```
  Exemple :
  ```ini
  group: ha-group1
    nodes node1,node2,node3
    nofailback 1
  ```
  - `nodes` : Liste des nœuds où les VMs peuvent être relancées.
  - `nofailback` : Empêche le retour automatique d'une VM vers son nœud d'origine après une pannne.

## **3. Configuration avancée des délais de HA**
Les délais critiques pour la détection des pannes et le redémarrage des services HA sont configurés dans :

### **:tools: Paramètres généraux HA (`/etc/pve/ha/manager.cfg`)** :warning:  N'existe plus dans la version Proxmox 8.3
- **Éditer le fichier :**
  ```bash
  nano /etc/pve/ha/manager.cfg
  ```
  Exemples de paramètres modifiables :
  ```ini
  watchdog-timeout 10
  crm-retransition-delay 60
  recovery-timeout 30
  ```
  - `watchdog-timeout` : Temps (en secondes) avant qu'un nœud soit considéré comme mort.
  - `crm-retransition-delay` : Délai avant qu’un redémarrage de service ne soit tenté.
  - `recovery-timeout` : Temps avant que Proxmox tente de redémarrer une VM après une panne.

Après modification, recharge la configuration HA avec :
```bash
ha-manager reload
```

---

## **:arrows_counterclockwise: Modifier les paramètres HA via l'interface en ligne de commande**
Tu peux aussi modifier certains paramètres directement via `ha-manager` :

1. **Lister les ressources HA :**
   ```bash
   ha-manager status
   ```

2. **Ajouter une VM en HA avec des paramètres spécifiques :**
   ```bash
   ha-manager add vm:100 --max_restart 2 --max_relocate 1
   ```

3. **Modifier un paramètre d’une VM existante :**
   ```bash
   ha-manager set vm:100 --max_restart 3
   ```

4. **Supprimer une ressource HA :**
   ```bash
   ha-manager remove vm:100
   ```

---

## **:bulb: Bonnes pratiques**
- **Vérifie toujours l'état du cluster avant de modifier la HA :**
  ```bash
  pvecm status
  ha-manager status
  ```
- **Test les logs après modification :**
  ```bash
  tail -f /var/log/pve-ha.log
  ```
- **Ne baisse pas trop `watchdog-timeout` pour éviter les faux positifs !**


# **:open_file_folder: Où sont stockés ces paramètres ?**
Dans **Proxmox 8.3**, les configurations HA sont stockées dans la base de données interne de **`pve-cluster`**, et non plus dans un fichier texte modifiable. Tu peux voir ces paramètres en listant les ressources HA :

```bash
ha-manager status
```
et en affichant les services HA :
```bash
cat /etc/pve/ha/resources.cfg
```

Si tu veux modifier la configuration manuellement, tu peux toujours éditer `/etc/pve/ha/resources.cfg`, mais la méthode recommandée est d'utiliser `ha-manager`.

---

### **:pushpin: Vérifier et appliquer les changements**
Après toute modification, il est bon de vérifier les logs HA :
```bash
tail -f /var/log/pve-ha.log
```
Et si nécessaire, recharger la configuration HA :
```bash
ha-manager reload
```


@everyone 

# :warning: HA VM - Par défaut, le delai de redémarrage d'une VM via la HA après qu'une node soit DOWN est de 1 minutes et 20 secondes.

Additionner les temps du manager HA:
  ```ini
  watchdog-timeout 10
  crm-retransition-delay 60
  recovery-timeout 30
  ```

- `watchdog-timeout` : Temps (en secondes) avant qu'un nœud soit considéré comme mort.
- `crm-retransition-delay` : Délai avant qu’un redémarrage de service ne soit tenté.
- `recovery-timeout` : Temps avant que Proxmox tente de redémarrer une VM après une panne.

## Soit 10sec + 60sec + 40sec = 100sec > Soit 1 min 20 sec d'attentes :slight_smile:
