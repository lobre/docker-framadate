# docker-framadate

Docker container and compose file for firing a Framadate instance

The first time, you need to migrate browsing to `http://www.mydomain.fr/admin/migration.php`.

To clean cache for regenerating templates: `docker exec -ti framadate bash -c "rm /var/www/html/tpl_c/*"`.