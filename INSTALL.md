# Setup needed before installing CAS Management
The setup precondition for this webapp is having a running Tomcat instance with the CAS server within it. So, we encourage you to follow the available instructions at [/inab/ldap-rest-cas4-overlay/blob/master/INSTALL.md](RD-Connect CAS repository), as the installation of this webapp depends on the installation decisions previously taken for RD-Connect CAS.

# CAS Management Maven Overlay Installation
* Clone git project with the simple overlay template here
```bash
git clone https://github.com/inab/cas4-management-overlay.git /tmp/cas4-management-4.1.x
```	

* Inside the checked-out directory, run `mvn clean package` in order to generate the war:
```bash
cd /tmp/cas4-management-4.1.x
mvn clean package
```

* Now, depending on whether you are using a system or an user Tomcat, you have to slightly change your installation procedure.

  * (SYSTEM) Be sure that directories /etc/cas and /var/log/cas do exist, and they belong to `tomcat` user. Copy `log4j2-cas-management.system.xml` renaming it:
  ```bash
  install -o tomcat -g tomcat -m 755 -d /etc/cas
  install -o tomcat -g tomcat -m 755 -d /var/log/cas
  install -D -o tomcat -g tomcat -m 644 /tmp/cas4-management-4.1.x/etc/log4j2-cas-management.system.xml /etc/cas/log4j2-cas-management.xml
  ```
  
  * (USER) Be sure that directories ${HOME}/etc/cas and ${HOME}/cas-log do exist. Copy `log4j2-cas-management.user.xml` renaming it:
  ```bash
  mkdir -p "${HOME}"/etc/cas "${HOME}"/cas-log
  cp -p /tmp/cas4-management-4.1.x/etc/log4j2-cas-management.user.xml "${HOME}"/etc/cas/log4j2-cas-management.xml
  ```

* (SYSTEM, USER) Last, deploy it using the provided ant script. You have to copy `etc/tomcat-deployment.properties.template` to `etc/tomcat-deployment.properties`, and put there the password you assigned to the Tomcat user `cas-tomcat-deployer` when you installed Tomcat for the CAS server:

```bash
cd /tmp/cas4-management-4.1.x
cp etc/tomcat-deployment.properties.template etc/tomcat-deployment.properties
# Apply the needed changes to etc/tomcat-deployment.properties

# Now deploy the application, using the keystore previously generated
ANT_OPTS="-Djavax.net.ssl.trustStore=/etc/tomcat/cas-tomcat-server.jks -Djavax.net.ssl.trustStorePassword=cas.Keystore.Pass" ant deploy
```

# By default, CAS management setup establish that users belonging to group `cn=admin,ou=groups,dc=rd-connect,dc=eu` are the only ones allowed to use this webapp. Although `cn=root,ou=admins,ou=people,dc=rd-connect,dc=eu` should be allowed to use it, as it already belongs to the group, it is highly discouraged.
