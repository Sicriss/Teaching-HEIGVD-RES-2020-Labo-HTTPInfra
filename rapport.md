# Laurent Thoeny - Res 2020 - Rapport

_Disclaimer : Désolé j'avais peur de ne pas pousser quelques choses d'utile alors il y a également toute la "polution" made in NodeJS sur mon repo._

Version docker utilisée : ` 19.03.8-ce` 
OS : `Linux 5.6 - Manjaro`

### Step 1 - Static HTTP server with apache httpd

Rien de très différent de la vidéo n'a été fait mis à part le choix du template Boostrap et les modifications qui ont été apportées à ce dernier.

Les commandes notables utilisées sont ci-dessous 

```bash
docker build -t res/apache_php .
docker run -p 9090:80 -d --name landingPage res/apache_php
```

### Step 2 - Dynamic HTTP server with express.js

Ici il est important de préciser que j'ai créé la branche depuis master car j'ai merge ma première branche sur Master entre temps. En espérant que cette différence de workflow ne dérange pas.

La plupart des autres manipulations reste très similaires aux deux vidéos, rien de particulier à commenter.

Ci-dessous ma fonction JavaScript, qui n'est pas la plus originale mais diffère de celle présentée.

```javascript
function getRandomAnimals()
{
    var numberOfAnimals = chance.integer({min : 1, max : 20});

    var animals = [];

    for (var i = 0; i < numberOfAnimals; ++i)
    {
        animals.push({
            animal : chance.animal(), 
            quantity : chance.integer({min : 1, max : 12})
        });
    }

    console.log("About to return some animals o/");
    return animals;
}
```



### Step 3

J'avais déjà nommé des containers "" et "" alors je les ai redemarrés des étapes précédentes, j'ai cependant recréé celui de l'étape 1 afin de supprimer le port-mapping

Il est logique que la configuration statique soit fragile puisqu'on doit hardcoder des adresses dynamiques, et plus ce ne serait pas réalistes si on avait un nombre plus important de serveurs (ce qui est vrai dans la pratique).



### Step 4 - Ajax & jQuery

_Comme pour les étapes précédentes, je ne documente pas tous les détails mais principalement les grosses étapes et/ou différences avec les vidéos._

J'ai ajouté l'installation d'un éditeur de fichier dans mes trois fichiers existants

``` dockerfile
RUN apt-get update && apt-get install -y nano
```

Ensuite j'ai build les trois images avec les modifications

```bash
docker build -t res/apache_php .
docker build -t res/express_students .
docker build -t res/reverse_proxy .
```

J'ai commit ces modifications, puis je relance les trois containers dans l'ordre nécessaire pour les adresses IP. Les noms sont conservés des étapes précédentes.

```bash
docker run -d --name landingPage res/apache_php
docker run -d --name nodeApp res/express_students
docker run -d -p 8080:80 --name reverse res/reverse_proxy
```

J'ai légèrement adapté l'exemple HTML/jQuery du cours (notamment car ma fonction express ne retourne pas la même chose).

```html
<p id="myAnimals"> </p>		<!-- Balise HTML pour récupération par ID -->
<script src="js/animals.js"></script>  <!-- Ajout du script personnel -->
```

Ci-dessous mon script qui créé une liste d'animaux depuis mon API et va les afficher dans la balise `<p>`, rien de très différent de ce qui est proposé dans l'exemple.

```javascript
$(function()
{
    console.log("loading some animals");

    function loadAnimals()
    {
        $.getJSON("/api/animals/", function (animals)
        {
            var message = "Liste des animaux :";

            $.each(animals, function(i, item)
            {
                message = message.concat (' ', animals[i].animal);
            });

            $("#myAnimals").text(message);
        })
    }

    loadAnimals();
    setInterval(loadAnimals, 20000);
});
```

J'ai mis un timing plus haut pour le rafraîchissement vu qu'on charge une liste et que sinon on avait pas le temps de la lire :c

 

### Step 5 - Dynamic Reverse Proxy

_Comme pour les étapes précédentes, je ne documente pas tous les détails mais principalement les grosses étapes et/ou différences avec les vidéos._

Tout d'abord j'ai supprimé mes containers existants pour nettoyer un peu.

```bash
docker rm `docker ps -qa`
```

Pour la première partie j'ai simplement effectué les modifications de la vidéo.

Ensuite, j'ai procédé aux modifications de la seconde vidéo, éditant notamment le fichier `apache2-foreground`. 

Lors du build du container je rencontrais une erreur m'indiquant que `Config variable ${APACHE_RUN_DIR} is not defined`. J'ai pu résoudre cette erreur en allant récupérer le fichier `apache2-foreground` sur GitHub et en éditant ce dernier, qui comprenait des instructions supplémentaires en comparaison à celui de la vidéo (que j'avais naïvement répliqué).

Pour les étapes 3 à 5, mes modifications ne sont pas différentes de celles proposées, à l'exception des variables d'environnement qui s'appellent _NODE_APP_ et _LANDING_PAGE_ afin de rester en accord avec le nommage de mes containers.



### Management UI

Pour la management UI, je connaissais [Portainer](https://www.portainer.io/) et j'ai donc décidé de l'implémenter sur mon système, principalement car j'apprécie l'idée d'avoir un système de gestion qui lui-même est un container.

Pour l'utilisation, rien de très compliqué, tout d'abord il est nécessaire de créer un volume pour les données qui vont être utilisées : `docker volume create portainer_data`.

Ensuite on démarre le container

```bash
docker run -d -p 9000:9000 --name=portainer --restart=always 
-v var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```

À partir de là, une interface est disponible à l'adresse [localhost sur le port 9000](http://localhost:9000).





### Load Balancing, Clusters & Sticky Sessions

Les trois points ci-dessus sont originalement distincts mais seront documentés ensembles. En effet j'ai décidé d'utiliser _Traefik_ afin de gérer ces points et je m'éloigne donc de la découpe d'origine, prévue pour une implémentation via Apache. L'idée d'origine était de faire ceci via _Docker Swarm_ mais avoir plusieurs clusters sur la même machine semblait compliqué et j'ai opté pour une solution plus haut niveau.

_Traefik_ tire profit de labels ajoutés aux containers pour activer des services ou pour son routage, il est entre autre utilisé avec _docker-compose_ mais je vais simplement ajouter les labels correspondants dans mes _dockerfile_ et mes scripts de lancement ce qui fonctionne tout aussi bien.



don't forget .htaccess lel







