Setting up the database
=======================

Install Postgres
----------------

Add the postgres repo to the sources list in APT, then update and install postgres and postgis.

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

Postgres installs fairly easily. Now just add the user and the database.

```sh
su - postgres
createuser -d pitstop -P
psql -c "CREATE DATABASE pedals;"
psql -c "GRANT ALL PRIVILEGES ON DATABASE pedals TO pitstop;"
psql -c "CREATE EXTENSION postgis;"
```

Edit `/etc/postgresql/9.3/main/pg_hba.conf` to include the correct domain of computers you want to have access to the database.

```sh
# IPv4 local connections:
host    all         all         131.252.0.0/16        md5

# IPv6 local connections:
host    all         all         2610:10::/32          md5
```

Finally, edit `/etc/postgresql/9.3/main/postgresql.conf` to allow outside connections

```sh
listen_addresses = '*'
```
