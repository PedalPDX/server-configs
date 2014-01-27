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

We also want to use the postgres JDBC plugin for talking to the postgres server.

```sh
wget http://jdbc.postgresql.org/download/postgresql-9.3-1100.jdbc4.jar
cp ./postgres-9.3-1100.jdbc4.jar /usr/share/tomcat7/lib/
```

And Assuming weve already got the postgres database up, lets make our user
```sh
su - postgres
psql
CREATE USER icescrum WITH PASSWORD somePass;
CREAT DATABASE icescrum;
GRANT ALL PRIVILEGES ON DATABASE icescrum TO icescrum;
```

no lets add our configuration to the `config.groovy` file in the icescrum homedir
```sh
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
icescrum.alerts.default.from = "some@email

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
                                However, it's enabled only for projects 
                                where web services are enabled */
icescrum.cors.allow.origin.regex = "*"  /* Use double backslash for escaping
                                           e.g. (http://|.+\\.)mydomain\\.com */


dataSource.driverClassName = "org.postgresql.Driver"
dataSource.url = "jdbc:postgresql://localhost:5432/icescrum"
dataSource.username = "icescrum"
dataSource.password = "somePass"
```

We have to download and place the Icescrum.war file in the webapps folder of tomcat7

```sh
wget http://www.icescrum.org/downloads/icescrum_R6_12.1_war.zip
unzip ./icescrum_R6_12.1_war.zip
cp ./icescrum*.war /var/lib/tomcat7/webapps/
```



restart tomcat and navigate to `http://hostname:8080` and proceed to the app-manager to check the status of Icescrum

