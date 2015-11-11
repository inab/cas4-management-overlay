cas4-management-overlay
=======================

CAS Management maven war overlay with service definitions stored in LDAP, for CAS 4.x line

# Versions
```xml
<cas.version>4.1.1</cas.version>
```

# Recommended Requirements
* JDK 1.7+
* Apache Maven 3+
* Servlet container supporting Servlet 3+ spec (e.g. Apache Tomcat 7+)

# Configuration
The `etc` directory contains the sample configuration files that would need to be copied to an external file system location (`/etc/cas` or `${user.home}/etc/cas` by default) and configured to satisfy local CAS and CAS Management installation needs. Current files are:

* `log4j2-cas-management.user.xml` or `log4j2-cas-management.system.xml`, depending on a user or a system Tomcat installation.

# Deployment

Follow [INSTALL.md](installation instructions).
