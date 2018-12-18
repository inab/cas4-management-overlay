#!/bin/sh

# CAS Management initial setup

etccasdir="$(dirname "$0")"
case "${etccasdir}" in
	/*)
		true
		;;
	*)
		etccasdir="${PWD}"/"${etccasdir}"
		;;
esac

if [ $# -gt 0 ] ; then
	ldapAdminPass="$1"
else
	ldapAdminPass="changeit"
fi

# This changed on CAS 5.x
destEtcCASDir=/etc/cas/config
destCASLog=/var/log/cas

if [ ! -d "${destEtcCASDir}" -o ! -f "${destEtcCASDir}"/management.properties ] ; then
	# We want it to exit on first error
	set -e
	
	# Setting up basic paths
	install -o tomcat -g tomcat -m 755 -d "${destEtcCASDir}"
	install -o tomcat -g tomcat -m 755 -d "${destEtcCASDir}"/services
	install -o tomcat -g tomcat -m 755 -d "${destCASLog}"
	
	install -D -o tomcat -g tomcat -m 600 "${etccasdir}"/management.properties.template "${destEtcCASDir}"/management.properties
	install -D -o tomcat -g tomcat -m 600 "${etccasdir}"/users.properties "${destEtcCASDir}"/users.properties
	install -D -o tomcat -g tomcat -m 644 "${etccasdir}"/log4j2-cas-management.system.xml "${destEtcCASDir}"/log4j2-management.xml
	install -D -o tomcat -g tomcat -m 600 -t "${destEtcCASDir}"/services "${etccasdir}"/services/*
	
	echo >> "${destEtcCASDir}"/management.properties
	echo "# Parameters automatically added from Dockerfile" >> "${destEtcCASDir}"/management.properties
	echo "cas.resources.dir=${destEtcCASDir}" >> "${destEtcCASDir}"/management.properties
	echo "cas.log.dir=${destCASLog}" >> "${destEtcCASDir}"/management.properties
	
	# Setting up LDAP manager password
	sed -i "s#^cas.mgmt.ldap.bindCredential=.*#cas.mgmt.ldap.bindCredential=${ldapAdminPass}#" "${destEtcCASDir}"/management.properties
	
	# Last, cleanup
fi
