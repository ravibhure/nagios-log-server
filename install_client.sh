#!/bin/bash
# Provide nagios_log_server host in argument
SERVERHOST=$1

if [ -z $SERVERHOST ]; then
  echo "Usage: $0 <nagios_log_server ip/fqdn>"
  exit 1
fi  

export PATH=$PATH:/usr/bin
sudo apt-get update
sudo apt-get -y install software-properties-common python-software-properties debconf-utils git python-crypto sshpass python-pip libssl-dev openssl
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' | sudo debconf-set-selections
echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true' | debconf-set-selections
sudo apt-get install -y oracle-java8-installer ant
sudo apt-get -y install tomcat7 tomcat7-docs tomcat7-admin tomcat7-examples apache2
for i in proxy proxy_ajp proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html ;do a2enmod $i ;done
echo 1 > /proc/sys/vm/overcommit_memory
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export CATALINA_HOME=/usr/share/tomcat7
cat >>~/.bashrc<<-EOF
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export CATALINA_HOME=/usr/share/tomcat7
EOF

source ~/.bashrc
echo JAVA_OPTS=\"\$JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512m -XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC\" >> /etc/default/tomcat7

cp /etc/tomcat7/server.xml /etc/tomcat7/server.xml-$(date +%d%m%y%H%M%S)
cat >/etc/tomcat7/server.xml<<-EOF
<?xml version='1.0' encoding='utf-8'?>
<Server port="8005" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.core.JasperListener" />

  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />
  <GlobalNamingResources>
    <!-- Editable user database that can also be used by
         UserDatabaseRealm to authenticate users
    -->
    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>

  <!-- A "Service" is a collection of one or more "Connectors" that share
       a single "Container" Note:  A "Service" is not itself a "Container",
       so you may not define subcomponents such as "Valves" at this level.
       Documentation at /docs/config/service.html
   -->
  <Service name="Catalina">
    <Connector port="8080" protocol="HTTP/1.1"
               address="127.0.0.1"
               connectionTimeout="20000"
               URIEncoding="UTF-8"
               redirectPort="8443" />
    <Engine name="Catalina" defaultHost="localhost">
      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <!-- This Realm uses the UserDatabase configured in the global JNDI
             resources under the key "UserDatabase".  Any edits
             that are performed against this UserDatabase are immediately
             available for use by the Realm.  -->
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>

      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log." suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />

      </Host>
    </Engine>
  </Service>
</Server>
EOF

cp /etc/tomcat7/tomcat-users.xml /etc/tomcat7/tomcat-users.xml-$(date +%d%m%y%H%M%S)
cat >/etc/tomcat7/tomcat-users.xml<<-EOF
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
<role rolename="manager-gui"/>
<user username="ravi" password="password" roles="manager-gui"/>
</tomcat-users>
EOF

sudo /etc/init.d/tomcat7 restart

cat >/etc/apache2/sites-enabled/000-default.conf <<-EOF
<VirtualHost *:80>
    ProxyPreserveHost On
        ProxyPass / http://127.0.0.1:8080/
        xyPassReverse / http://127.0.0.1:8080/

        ServerName localhost
        ServerAdmin webmaster@localhost
        #DocumentRoot /var/www/html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

/etc/init.d/apache2 restart

# Setting up nagios_log_server client
curl -s -o /tmp/setup-linux.sh -O http://$SERVERHOST/nagioslogserver/scripts/setup-linux.sh
sudo bash /tmp/setup-linux.sh -s $SERVERHOST -p 5544
sudo bash /tmp/setup-linux.sh -s $SERVERHOST -p 5544 -f '/var/log/httpd/access_log' -t apache_access

