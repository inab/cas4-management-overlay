RD-Connect CAS Management Overlay (based on CAS Management Overlay template)
============================

Customized CAS management web application Maven overlay for CAS with externalized configuration, managing the services data stored in an LDAP directory.

# Versions

```xml
<cas.version>5.3.x</cas.version>
```

# Requirements

* JDK 1.8+

# Build and deployment

Follow [installation instructions](INSTALL.md).

## External

Deploy resultant `target/cas-management.war` to a servlet container of choice.
