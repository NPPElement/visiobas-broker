#!/bin/sh

echo "APPLICATION KEYSTORE IS DELETED"
 rm $JBOSS_HOME/standalone/configuration/application.keystore

echo "ADDING AN APPLICATION KEYSTORE"
cd $JBOSS_HOME/standalone/configuration/
 keytool -genkeypair   -keystore application.keystore   -alias server   -keyalg RSA   -keysize 3072   -validity 36500  -storepass password  -keypass password  -dname "CN=localhost, OU=QE, O=$$WILDFLY_HOST, L=Brno, C=CZ"

#echo "ADDING AN MYSQL APPLICATION"
# $JBOSS_HOME/bin/jboss-cli.sh --connect --command="module add --name=com.mysql.driver  --dependencies=javax.api,javax.transaction.api --resources=/opt/jboss/wildfly/modules/system/layers/base/com/mysql/main/driver/mysql-connector-java-5.1.46.jar" && \
# $JBOSS_HOME/bin/jboss-cli.sh --connect --command=:shutdown 
