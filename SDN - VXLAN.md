## SDN distributed Switch Multi Noeud - SDN VXLAN

Procédure consolidée pour mettre en place un réseau SDN VXLAN sur un cluster Proxmox (8.4.1) et valider la communication entre deux hôtes physiques à l'aide de conteneurs Alpine légers.

Cela crée un "réseau overlay" (une couche virtuelle) au-dessus de votre réseau physique existant. Les paquets des VM sont encapsulés et envoyés via le réseau physique d'un hôte à l'autre sans que vos switchs physiques n'aient besoin de configuration complexe (comme des VLANs propagés partout).

Partie 1 : Création de l'Infrastructure SDN (Niveau Datacenter)
Cette étape crée les "tuyaux" virtuels entre vos serveurs physiques.
1. Créer la Zone (Le Tunnel)
 * Allez dans Datacenter > SDN > Zones.
 * Cliquez sur Add > VXLAN.
 * Remplissez les champs :
   * ID : sdn-vxlan (ou le nom de votre choix).
   * Peers Address List : Entrez les adresses IP physiques de gestion de tous vos nœuds Proxmox (ex: 192.168.1.10,192.168.1.11).
   * MTU : Laissez par défaut (généralement 1450) ou ajustez selon votre réseau physique (voir note MTU en bas).
 * Cliquez sur Add.
2. Créer le VNet (Le Switch Virtuel)
 * Allez dans Datacenter > SDN > VNets.
 * Cliquez sur Create.
 * Remplissez les champs :
   * Name : vnet100 (ce sera le nom de l'interface bridge).
   * Zone : sdn-vxlan (celle créée juste avant).
   * Tag : 100 (Identifiant unique du réseau).
 * Cliquez sur Create.
3. Appliquer la configuration (CRUCIAL)
 * Allez dans Datacenter > SDN > Apply.
 * Cliquez sur le bouton Apply.
 * Attendez que la tâche indique "OK". À ce stade, le bridge vnet100 est créé sur tous les nœuds.

Partie 2 : Déploiement des Conteneurs de Test
Nous allons créer deux conteneurs Alpine sur deux nœuds physiques différents.
1. Conteneur A (Sur le Nœud 1)
 * Cliquez sur le Nœud 1 > Create CT.
 * General : Hostname ct-test-01, Password root.
 * Template : Sélectionnez votre image alpine.
 * Network :
   * Bridge : vnet100 (Le réseau SDN).
   * IPv4 : Static.
   * IPv4/CIDR : 10.10.100.1/24
   * MTU : 1450 (Important : alignez-le sur le MTU de la zone SDN pour éviter la fragmentation).
 * Confirmez et Démarrez le CT.
2. Conteneur B (Sur le Nœud 2)
 * Cliquez sur le Nœud 2 > Create CT.
 * General : Hostname ct-test-02, Password root.
 * Template : Sélectionnez votre image alpine.
 * Network :
   * Bridge : vnet100 (Le même réseau SDN).
   * IPv4 : Static.
   * IPv4/CIDR : 10.10.100.2/24
   * MTU : 1450.
 * Confirmez et Démarrez le CT.

Partie 3 : Validation
Il est temps de vérifier que le trafic traverse bien le réseau physique pour relier les deux réseaux virtuels.
 * Ouvrez la Console (Shell) du conteneur ct-test-01 (sur le Nœud 1).
 * Lancez le ping vers le conteneur distant :
<!-- end list -->
ping 10.10.100.2

Si le ping répond :
Votre SDN fonctionne. Le paquet part du CT A, est encapsulé en VXLAN (UDP 4789), traverse votre switch physique, arrive au Nœud 2, est désencapsulé et livré au CT B.
Si le ping échoue :
 * Vérifiez que le port UDP 4789 n'est pas bloqué entre les hôtes Proxmox (Firewall Datacenter ou switchs physiques).
 * Vérifiez dans Datacenter > SDN > Zone que l'état est bien "Available".
Résumé technique pour mémo
| Paramètre | Valeur recommandée pour le test |
|---|---|
| Type de Zone | VXLAN |
| Peers | IPs physiques des hôtes Proxmox |
| VNet Name | vnet100 |
| VNet Tag | 100 |
| IP CT1 | 10.10.100.1/24 |
| IP CT2 | 10.10.100.2/24 |
| MTU Container | 1450 (Si MTU physique = 1500) |
