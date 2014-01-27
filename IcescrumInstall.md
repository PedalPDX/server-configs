Installing and configuring Icescrum
===================================

Setup
-----

Install The necessary packages.

```sh
sudo apt-get update
sudo apt-get install openjdk-7-jre unzip tomcat7 tomcat7-admin
```



Configure Tomcat
----------------

Give the `tomcat7` user the ownership of its respective directories

```sh
chown -R tomcat7:root /var/lib/tomcat7
chown -R tomcat7:root /usr/share/tomcat7
```


Add The following lines to `/etc/tomcat7/tomcat-users.xml` so that you may log into the tomcat
webapp manager

```sh
  <role rolename="manager-gui"/>
  <user username="tomcat" password="SomePass" roles="admin-gui"/>
```


Edit `/var/lib/tomcat7/conf/server.xml` to include the NIO protocol by replacing the Connector stanza:
```sh
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           URIEncoding="UTF-8"
           redirectPort="8443" />
```
with these lines:
```sh
    <Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol"
           connectionTimeout="20000"
           URIEncoding="UTF-8"
           redirectPort="8443" />
```

Excellent, that should be enough fiddling with tomcat. 



Prepping for Icescrum
---------------------

Add the following line to the top of `/usr/share/tomcat7/bin/catalina.sh`

```sh
CATALINA_OPTS="-Dicescrum.log.dir=/home/icescrum/ -Duser.timezone=UTC -Dicescrum_config_location=/home/icescrum/config.groovy -Xmx512m -XX:MaxPermSize=256m"
```


Make a homedir for icescrum, so it has a place to organize its files and remember to grant `tomcat7` ownership.

```sh
mkdir -p /home/icescrum
chown tomcat7:root /home/icescrum
```


To use Postgres with Icescrum, Download and install the JDBC plugin for talking to the postgres database.

```sh
wget http://jdbc.postgresql.org/download/postgresql-9.3-1100.jdbc4.jar
cp ./postgres-9.3-1100.jdbc4.jar /usr/share/tomcat7/lib/
chown tomcat7:root /usr/share/tomcat7/lib/postgresql-9.3-1100.jdbc4.jar
```


Assuming the postgres database is installed, make the icescrum database and user.

```sh
su - postgres
psql
CREATE USER icescrum WITH PASSWORD somePass;
CREAT DATABASE icescrum;
GRANT ALL PRIVILEGES ON DATABASE icescrum TO icescrum;
```


Add the following configuration to the `config.groovy` file in the icescrum homedir.
make sure to edit in the appropriate credentials and emails where necessary.
```sh
touch /home/icescrum/config.groovy
chown tomcat7:root /home/icescrum/config.groovy
cat << EOF > /home/icescrum/config.groovy

icescrum.project.import.enable = true
icescrum.project.export.enable = true
icescrum.project.creation.enable = true
icescrum.project.private.enable = true
icescrum.project.private.default = false

icescrum.gravatar.secure = false
icescrum.gravatar.enable = false
icescrum.registration.enable = true
icescrum.login.retrieve.enable = true

icescrum.auto_follow_productowner = true
icescrum.auto_follow_stakeholder  = true
icescrum.auto_follow_scrummaster  = true
icescrum.alerts.errors.to = "some@email"
icescrum.alerts.subject_prefix = "[icescrum]"
icescrum.alerts.enable = true
icescrum.alerts.default.from = "some@email"

icescrum.attachments.enable = true

grails.serverURL = "http://yourServer:8080/icescrum"
                   /* Changing the port will require to change 
                     it in the Tomcat server.xml Connector*/

icescrum.debug.enable = true
icescrum.securitydebug.enable = true

icescrum.baseDir = "/home/icescrum"
                   /* Use a custom directory where Tomcat has write rights
                      (not webapps!!). Path must use '/' (forward slash) */

icescrum.cors.enable = true  /* CORS is enabled by default
                                However, its enabled only for projects 
                                where web services are enabled */
icescrum.cors.allow.origin.regex = "*"  /* Use double backslash for escaping
                                           e.g. (http://|.+\\.)mydomain\\.com */


dataSource.driverClassName = "org.postgresql.Driver"
dataSource.url = "jdbc:postgresql://localhost:5432/icescrum"
dataSource.username = "icescrum"
dataSource.password = "somePass"

EOF
```

Install
-------

Download and place the Icescrum.war file in the `/var/lib/tomcat7/webapps`

```sh
wget http://www.icescrum.org/downloads/icescrum_R6_12.1_war.zip
unzip ./icescrum_R6_12.1_war.zip
cp ./icescrum*.war /var/lib/tomcat7/webapps/
```

Restart tomcat and navigate to `http://hostname:8080` and proceed to the app-manager to check the status of Icescrum

`servive tomcat7 restart`

I suggest using `tail -F /home/icescrum/icescrum.log` to watch for errors.


