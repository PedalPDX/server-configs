Installing and configuring Icescrum
===================================

Installing the Pacakges
-----------------------

```sh
sudo apt-get update
sudo apt-get install openjdk-7-jre unzip tomcat7 tomcat7-admin
```

Configuring Tomcat
----------------

Give the `tomcat7` user the ownership of its respective directories

```sh
chown -R tomcat7:root /var/lib/tomcat7
chown -R tomcat7:root /usr/share/tomcat7
```

Add The following two Lines to `/etc/tomcat7/tomcat-users.xml`

```sh
  <role rolename="manager-gui"/>
  <user username="tomcat" password="SomePass" roles="admin-gui"/>
```

go to /var/lib/tomcat7/conf/ and edit `server.xml`. replace the line:
```sh
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           URIEncoding="UTF-8"
           redirectPort="8443" />
```
with the line: 
```sh
    <Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol"
           connectionTimeout="20000"
           URIEncoding="UTF-8"
           redirectPort="8443" />
```

Prepping for Icescrum
---------------------

we also need to add the following line to the top of `/usr/share/tomcat7/bin/catalina.sh`

```sh
CATALINA_OPTS="-Dicescrum.log.dir=/home/icescrum/ -Duser.timezone=UTC -Dicescrum_config_location=/home/icescrum/config.groovy -Xmx512m -XX:MaxPermSize=256m"
```

lets now make a homedir for icescrum, so it has a place to organize its files

```sh
mkdir -p /home/icescrum
chown tomcat7:root /home/icescrum
```

We have to download and place the Icescrum.war file in the webapps folder of tomcat7

```sh
wget http://www.icescrum.org/downloads/icescrum_R6_12.1_war.zip
unzip ./icescrum_R6_12.1_war.zip
cp ./icescrum*.war /var/lib/tomcat7/webapps/
```

restart tomcat and navigate to `http://hostname:8080` and proceed to the app-manager to check the status of Icescrum

