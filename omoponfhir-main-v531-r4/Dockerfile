#Build the Maven project
FROM maven:3.6.3-openjdk-17 as builder
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN mvn clean install

# Build the Tomcat container
FROM tomcat:9.0.65-jre17

# Set environment variables below and uncomment the line. Or, you can manually
# set your environment on your server. Note that we use `host.docker.internal` rather 
# than `localhost` because the latter will not work from inside the docker container.
ENV JDBC_URL=jdbc:postgresql://pdbmedcit.services.brown.edu:5432/synpuf_omop_on_fhir 
ENV JDBC_DRIVER=org.postgresql.Driver
ENV JDBC_USERNAME=omop_admin_user
ENV JDBC_PASSWORD=postgres
ENV AUTH_BEARER=token123
ENV AUTH_BASIC_ENABLED=true
ENV AUTH_BASIC=username:password
ENV FHIR_READONLY=true
ENV SMART_INTROSPECTURL="http://localhost:8080/smart/introspect"
ENV SMART_AUTHSERVERURL="http://localhost:8080/smart/authorize"
ENV SMART_TOKENSERVERURL="http://localhost:8080/smart/token"


RUN curl -O https://jdbc.postgresql.org/download/postgresql-42.6.0.jar 
RUN mv postgresql-42.6.0.jar $CATALINA_HOME/lib/

# Copies updated server.xml to increase HTTP Header Length allowed
COPY server.xml $CATALINA_HOME/conf/

# Copy GT-FHIR war file to webapps.
COPY --from=builder /usr/src/app/omoponfhir-r4-server/target/omoponfhir-r4-server.war $CATALINA_HOME/webapps/ROOT.war

EXPOSE 8080
