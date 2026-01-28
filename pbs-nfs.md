# Montage NFS PBS

Installer un serveur NFS directement sur l'hôte Proxmox (PVE) est une solution efficace pour partager du stockage, même si certains préfèrent le faire dans un conteneur LXC pour isoler les services.

Voici la marche à suivre étape par étape pour configurer votre serveur NFS sur Proxmox.

---

## 1. Installation des paquets nécessaires

Connectez-vous en SSH à votre serveur Proxmox (192.168.1.X) ou utilisez le shell via l'interface Web, puis mettez à jour les dépôts et installez le serveur NFS :

```bash
apt update
apt install nfs-kernel-server -y

```

## 2. Création du répertoire de partage

Nous allons créer le dossier `/srv/nfs/pbs` et ajuster les permissions pour que les clients puissent y écrire.

```bash
mkdir -p /srv/nfs/pbs
# Donner les droits à l'utilisateur 'nobody' (standard pour NFS)
chown -R nobody:nogroup /srv/nfs/pbs
chmod 777 /srv/nfs/pbs

```

## 3. Configuration des autorisations (Exports)

C'est ici que vous définissez qui a le droit d'accéder au dossier. Modifiez le fichier `/etc/exports` :

```bash
nano /etc/exports

```

Ajoutez la ligne suivante à la fin du fichier pour autoriser tout votre sous-réseau :

`/srv/nfs/pbs 192.168.1.0/24(rw,sync,no_subtree_check)`

### Détails des options :

* **rw** : Autorise la lecture et l'écriture.
* **sync** : Force l'écriture des données sur le disque avant de confirmer l'opération (plus sûr).
* **no_subtree_check** : Améliore la fiabilité si des fichiers sont renommés.

## 4. Application de la configuration

Une fois le fichier enregistré, il faut forcer le serveur NFS à lire les modifications et redémarrer le service :

```bash
exportfs -ra
systemctl restart nfs-kernel-server

```

---

Voici la suite de la procédure pour configurer votre VM **Proxmox Backup Server (PBS) 4.1** afin qu'elle utilise ce partage NFS comme espace de stockage.

Puisque PBS est basé sur Debian, la procédure se fait principalement en ligne de commande via la console ou SSH.

### 1. Préparer la VM PBS (Client)

Connectez-vous à votre VM PBS en SSH ou via la console.

**Installation du client NFS :**
Bien que PBS inclue déjà de nombreux outils, assurez-vous que le paquet nécessaire est présent :

```bash
apt update
apt install nfs-common -y

```

### 2. Créer le point de montage

C'est le dossier local sur la VM où le stockage distant apparaîtra.

```bash
mkdir -p /mnt/nfs_backup

```

### 3. Configurer le montage automatique (fstab)

Pour que le partage NFS se reconnecte automatiquement à chaque redémarrage de la VM PBS, il faut modifier le fichier `/etc/fstab`.

Ouvrez le fichier :

```bash
nano /etc/fstab

```

Ajoutez la ligne suivante à la fin du fichier (remplacez `192.168.1.X` par l'IP réelle de votre serveur Proxmox hôte) :

```text
192.168.1.X:/srv/nfs/pbs  /mnt/nfs_backup  nfs  defaults,vers=3  0  0

```

> *Note : J'ai ajouté `vers=3` car c'est souvent plus stable pour du trafic lourd en local, mais vous pouvez le retirer pour utiliser la version par défaut (NFSv4).*

Enregistrez et quittez (`Ctrl+O`, `Enter`, `Ctrl+X`).

### 4. Monter et vérifier

Activez le montage sans redémarrer :

```bash
mount -a

```

Vérifiez que le dossier est bien accessible et que vous avez les droits d'écriture :

```bash
df -h /mnt/nfs_backup
touch /mnt/nfs_backup/testfile
rm /mnt/nfs_backup/testfile

```

*Si la commande `touch` ne renvoie pas d'erreur, c'est que la liaison est opérationnelle.*

---

### 5. Ajouter le Datastore dans l'interface PBS

Maintenant que le stockage est monté localement sur la VM, vous devez dire à PBS de l'utiliser.

1. Connectez-vous à l'interface web de votre PBS (https://IP-DE-VOTRE-VM-PBS:8007).
2. Allez dans le menu latéral gauche et cliquez sur **"Datastore"** > **"Add Datastore"**.
3. Remplissez les champs :
* **Name** : `NFS-PVE` (ou le nom de votre choix).
* **Backing Path** : `/mnt/nfs_backup` (le dossier créé à l'étape 2).


4. Cliquez sur **Add**.

Votre PBS va maintenant commencer à créer sa structure de fichiers (`.chunks`, etc.) sur le serveur NFS.

**Conseil pour la performance :**
Comme le stockage est réseau (NFS), la latence peut impacter les performances de "Garbage Collection" et de "Pruning" de PBS. Si possible, assurez-vous que le réseau entre la VM et l'hôte est rapide (virtio network device sur la VM).

Souhaitez-vous que je vous aide à rédiger la commande `mount` pour connecter vos clients Linux à ce nouveau partage ?
