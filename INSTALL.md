* Install Java >= 1.7
* export JAVA_HOME, JAVA_JRE
* Install tomcat7
* export CATALINA_HOME
* Install Apache Maven >=3.0
* Config DNS giving server a name (rdconnectcas.rd-connect.eu). In our case server hostname is rdconnectcas. In client machine we added an entry for rdconnectcas.rd-connect.eu in /etc/hosts


# Certificates (Ubuntu):

* Create CA. We used tinyca2, generating a CA inside rdconnect_demo_CA folder (this is the name given inside the Name (for local storag) parameter during the CA creation).
* Move .TinyCA/rdconnect_demo_CA to /etc/ssl
* Make a backup of /etc/ssl/openssl.cnf just in case...
* Move /etc/ssl/rdconnect_demo_CA/openssl.cnf to /etc/ssl/openssl.cnf
* Edit /etc/ssl/openssl.cnf. Set dir = /etc/ssl/rdconnect_demo_CA

* Create Tomcat Server Certificate:
* keytool -genkey -alias tomcat-server -keyalg RSA -keystore tomcat-server.jks -storepass changeit -keypass changeit -dname "CN=rdconnectcas.rd-connect.eu, OU=Spanish Bioinformatics Institute, O=INB at CNIO, L=Madrid, S=Madrid, C=CN"
* keytool -certreq -keyalg RSA -alias tomcat-server -file tomcat-server.csr -keystore tomcat-server.jks -storepass changeit
* Sign the request
* openssl x509 -req -in tomcat-server.csr -out tomcat-server.pem  -CA /etc/ssl/rdconnect_demo_CA/cacert.pem -CAkey /etc/ssl/rdconnect_demo_CA/cacert.key -days 365 -CAcreateserial -sha1 -trustout  -CA /etc/ssl/rdconnect_demo_CA/cacert.pem -CAkey /etc/ssl/rdconnect_demo_CA/cacert.key -days 365 -CAserial /etc/ssl/rdconnect_demo_CA/serial -sha1 -trustout
* Verify the purpose
* openssl verify -CAfile /etc/ssl/cacert.pem -purpose sslserver tomcat-server.pem
* openssl x509 -in tomcat-server.pem -inform PEM -out tomcat-server.der -outform DER
* Import root certificate:
* keytool -import -alias rdconnect-root -file /etc/ssl/rdconnect_demo_CA/cacert.pem -keystore tomcat-server.jks -storepass changeit
* Import tomcat-server certificate:
* keytool -import -trustcacerts -alias tomcat-server -file tomcat-server.der -keystore tomcat-server.jks -storepass changeit
* keytool -list -v -keystore tomcat-server.jks -storepass changeit


# Configure Tomcat to use certificate:
* Edit conf/server.xml adding:
```xml
	<Connector port="9443" protocol="HTTP/1.1"
                connectionTimeout="20000"
                redirectPort="9443"
                SSLEnabled="true"
                scheme="https"
                secure="true"
                sslProtocol="TLS"
                keystoreFile="/home/acanada/etc/ssl/rdconnect_demo_CA/tomcat-server.jks"
                truststoreFile="/home/acanada/etc/ssl/rdconnect_demo_CA/tomcat-server.jks"
                keystorePass="changeit" />

```
    
# Maven Overlay Installation
* Clone git project with the simple overlay template here
* Execute inside the project folder:  mvn clean package
* Copy simple-cas-overlay-template/target/cas.war to $CATALINA_HOME/webapps/
* Copy etc/* directory to /etc/cas

* If you don’t have any applications running in the 8080 port, you can comment out the lines inside $CATALINA_BASE/conf/server.xml:
```xml
	<Connector port="8080" protocol="HTTP/1.1"
	connectionTimeout="20000"
        redirectPort="9443" />


```
(In order to restrict the traffic only to secure ports)
