FROM tomcat:8
# Take the war and copy to webapps of tomca
COPY target/newdock.war /usr/local/tomcat/webapps/
