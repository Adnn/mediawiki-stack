# Mediawiki-Stack

Defines a Docker stack starting adnn/Mediawiki with a MySQL backend


## Usage

A prerequesite to stack stack deployment is starting a swarm manager. If not already done:

    docker swarm init

Deploy the swarm

    [env VAR=VALUE ... see table below] docker stack deploy -c mediawiki.yml mediawiki

|environment variable   |default      |
|-----------------------|-------------|
| MYSQL_DATABASE        | mediawiki   |
| MYSQL_USER            | mediawiki   |
| MYSQL_PASSWORD        |             |
| MYSQL_ROOT_PASSWORD   |             |
| WIKI_NAME             | wiki        |
| WIKI_USER             | admin       |
| WIKI_PASSWORD         |             |
| WIKI_DB_PREFIX        |             |
| WIKI_DOMAIN           |             |

### Backups

The container links /mediawiki_backups to ./backups on the host, to allow exchange of backup archives.

Making a backup, then available in ./backups on the host:

    docker exec mediawiki_mediawiki.xxx MediaWiki_Backup/backup.sh       \
                                                  -d /mediawiki_backups/ \
                                                  -w ./                  \
                                                  -s

Restoring a backup, ${BACKUP_FILE} being first copied to ./backups on the host:

    docker exec mediawiki_mediawiki.xxx MediaWiki_Backup/restore.sh            \
                                          -a /mediawiki_backups/${BACKUP_FILE} \
                                          -w ./                                \
                                          -p ${MYSQL_ROOT_PWD}


## Customization points

### Mediawiki local settings

A `LocalSettings.local.php` inside the *adnn/mediawiki* container, at */var/www/html/*, would be included by the already installed `LocalSettings.php`

It allows to define new settings or override existing values.
