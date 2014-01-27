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
psql -c "GRANT ALL PRIVILEGES ON DATABASE pedals TO pitstop;"
```

edit `/etc/postgresql/9.3/main/pg_hba.conf` to include the correct domain

```sh
# IPv4 local connections:
host    all         all         131.252.0.0/16        md5

# IPv6 local connections:
host    all         all         2610:10::/32          md5
```

and then edit *** to allow outside connections

```sh
listen_addresses = '*'
```


TODO:
installing Postgis

