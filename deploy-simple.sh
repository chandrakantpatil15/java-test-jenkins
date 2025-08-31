#!/bin/bash
# Simple deployment script
WAR_FILE="target/myapp-1.0.0.war"
if [ -f "$WAR_FILE" ]; then
    echo "Copying WAR to Tomcat webapps..."
    docker cp "$WAR_FILE" tomcat-local:/usr/local/tomcat/webapps/myapp.war
    echo "Deployment complete!"
else
    echo "WAR file not found: $WAR_FILE"
fi