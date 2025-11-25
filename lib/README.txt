MySQL Connector/J Setup Instructions
====================================

1. Download MySQL Connector/J from:
   https://dev.mysql.com/downloads/connector/j/

2. Extract the JAR file (mysql-connector-java-8.0.33.jar)

3. Place the JAR file in this lib/ directory

4. The build.xml script will automatically copy it to WEB-INF/lib/ during deployment

Alternative: You can also manually copy the JAR file to:
WebContent/WEB-INF/lib/mysql-connector-java-8.0.33.jar

Required for:
- Database connectivity
- JDBC operations
- Application deployment
