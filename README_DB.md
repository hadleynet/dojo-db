# Copy the Database from Heroku

    $ psql
    mhadley-# drop database dojo_development
    mhadley-# ^d
    $ PGUSER=dojo heroku pg:pull HEROKU_POSTGRESQL_GRAY dojo_development --app svkc
    
