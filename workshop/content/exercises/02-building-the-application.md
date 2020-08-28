We are now ready to build the application source code. We will first do this direct into the local directory.

Change to the ``demo`` sub directory.

```execute
cd ~/exercises/demo
```

Then run Maven to start the build.

```execute
./mvnw install
```

> NOTE: It can take a couple of minutes the first time, but once the dependencies are all cached, subsequent builds would be faster.

When the build has completed, build artefacts including the application JAR file, can be found in the `target` sub directory.

```execute
tree target
```

To test that the application works, run Java with the application JAR file:

```execute
java -jar target/*.jar
```

Because we added the `actuator` module as a dependency, a number of HTTP endpoints already exists.

To test the application and see what endpoints were added, run:

```execute-2
curl -s localhost:8080/actuator | jq .
```

The output should be similar to the following:

```
{
  "_links": {
    "self": {
      "href": "http://localhost:8080/actuator",
      "templated": false
    },
    "health-path": {
      "href": "http://localhost:8080/actuator/health/{*path}",
      "templated": true
    },
    "health": {
      "href": "http://localhost:8080/actuator/health",
      "templated": false
    },
    "info": {
      "href": "http://localhost:8080/actuator/info",
      "templated": false
    }
  }
}
```

We no longer need the local instance of the application, so you can kill it:

```terminal:interrupt
```
