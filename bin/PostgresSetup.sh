#!/bin/bash

# Make sure the script is only run if the user is root
if [ $(whoami) != 'root' ]; then
        echo "Must be root to run $0"
        exit 1;
fi

DEPENDS="postgresql-9.3 postgresql-9.3-postgis-2.1"

# Ensure the repository is in apt's lists and update as necessary
echo "Checking apt/sources"
if [ ! -e /etc/apt/sources.list.d/postgres.list ]; then 
	echo "    Postgres apt repo not installed..."
	echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/postgres.list
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
	apt-get update
	echo "    Psyche..."
else
	echo "    Repository Installed"
fi

# Install Each of the dependencies described above
echo "Ensuring that the Dependencies are installed..."
for PKG in ${DEPENDS}; do
	dpkg-query -l $PKG > /dev/null
	if [ $? ]; then 
		echo "    $PKG is already Installed"	
	else 
		echo "    Installing $PKG..."
		apt-get install -y $PKG
		echo "    $PKG Installed."
	fi
done


# Add the pitstop user to the database
echo "Ensuring 'pitstop' user"
su - postgres -c 'psql -c "SELECT * FROM pg_roles;" | grep pitstop' >> /dev/null
if [ $? ]; then
	echo "    'pitstop' user exists"
else
	echo -n "    creating the 'pitstop' user..."
	su - postgres -c 'createuser -d pitstop -P'
	if [ $? ]; then
		echo "Success"
	else
		echo "Failed"
		exit -2
	fi
fi
	


# TODO Always trys to make the DB
# Add the pedals DB to database
echo -n "Checking to existence of 'pedals' Database...."
su - pitstop -c 'psql -l | grep pedals | wc -l' >> /dev/null 
if [ $? ]; then 
	echo "Creating"
	su - postgres -c 'psql -c "CREATE DATABASE pedals;"'
	su - postgres -c 'psql -c "GRANT ALL PRIVILEGES ON DATABASE pedals TO pitstop;"'
else
	echo "Exists"
fi


#CREATE DATABASE pedals;
#CREATE USER pitstop WITH PASSWORD;
#GRANT ALL PRIVILEDGES ON DATABASE pedals TO pitstop;
#EOF



