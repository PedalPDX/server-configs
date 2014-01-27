Installing the Postgres Database
================================

Download and install all of the necessary dependencies
------------------------------------------------------

first we need to add the postgres repo to the sources list so that we
can get it using apt, then update, and install.

```sh
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" \
	> /etc/apt/sources.list.d/postgres.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc \
	| apt-key add -
sudo apt-get update
sudo apt-get install postgresql-9.3 postgreql-9.3-postgis-2.1
```

Postgres Config
---------------

Postgres installs really nicely. Now we just have to go in and add our user and the database.

```sh
su - postgres
createuser -d pitstop -P
psql -c "CREATE DATABASE pedals;"
psql -c "GRANT ALL PRIVILEGES ON DATABASE pedals TO pitstop;"

```


TODO:
installing Postgis
Sharing the datbase to users on a network

