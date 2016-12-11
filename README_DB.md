# Copy the Database from Heroku

    $ psql
    mhadley-# drop database dojo_development;
    mhadley-# ^d
    $ PGUSER=dojo heroku pg:pull HEROKU_POSTGRESQL_GRAY dojo_development --app svkc
    
# Create a SQL dump of the database

    $ heroku pg:backups capture
    $ curl -o /tmp/dojo.dump `heroku pg:backups url`
    $ pg_restore /tmp/dojo.dump > /tmp/dojo.sql
    
