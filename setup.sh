#!/bin/bash

#Get the files
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/webgoat/WebGoat-5.4.war
wget http://mirror.vorboss.net/apache/tomcat/tomcat-7/v7.0.69/bin/apache-tomcat-7.0.69.tar.gz

#Get Java home
JAVALOC=$(readlink -f $(which java))
THROWOUT="jre/bin/java"
JAVAHOME=${JAVALOC%$THROWOUT}
#echo $JAVAHOME

#Put javahome into enviroment
echo "JAVAHOME=${JAVAHOME}" >> /etc/enviroment

#Sort out tomcat
tar xvfz apache-tomcat-7.0.69.tar.gz -C /usr/local/
echo "CATALINA_HOME=/usr/local/apache-tomcat-7.0.69/" >> /etc/enviroment

#move the war file to tomcat
cp WebGoat-5.4.war /usr/local/apache-tomcat-7.0.69/webapps/WebGoat-5.4.war

# Create the tomcat user
FIND='<tomcat-users>'
REPLACE='<tomcat-users><role rolename="webgoat_admin"\/><user username="webgoat" password="Sec3rt" roles="webgoat_admin"\/>'
sed -i -e "s/$FIND/$REPLACE/g" /usr/local/apache-tomcat-7.0.69/conf/tomcat-users.xml

#Start the service
/usr/local/apache-tomcat-7.0.69/bin/startup.sh

#Done echo the details
echo "url: http://localhost:8080/WebGoat-5.4/attack"
echo "Username: webgoat"
echo "Password: Sec3rt"
