#!/bin/sh

#echo "APPLICATION KEYSTORE IS DELETED"
rm $JBOSS_HOME/standalone/configuration/application.keystore

echo "ADDING AN APPLICATION KEYSTORE"
cd $JBOSS_HOME/standalone/configuration/
 keytool -genkeypair   -keystore application.keystore   -alias server   -keyalg RSA   -keysize 3072   -validity 36500  -storepass password  -keypass password  -dname "CN=localhost, OU=QE, O=$$WILDFLY_HOST, L=Brno, C=CZ"
