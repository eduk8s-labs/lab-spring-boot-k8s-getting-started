The first thing we will do is create a Spring Boot application. If you have one you prefer to use already in github, you could clone it in the terminal (`git` and `java` are installed already). Or you can create an application from scratch using start.spring.io.

Click on the `Initializr` tab above the terminals to generate the code. This is an embedded version of the application that powers [start.spring.io](https://start.spring.io). Select the webflux and actuator checkboxes and hit "Generate". Or you can use curl in the terminal:

```execute
mkdir demo && cd demo && curl https://start.spring.io/starter.tgz -d dependencies=webflux,actuator | tar -xzvf -
```

You can then build the application:

```execute
./mvnw install
```

> NOTE: It will take a couple of minutes the first time, but then once the dependencies are all cached it will be fast.

And you can see the result of the build. If the build was successful, you should see a JAR file, something like this:

```execute
ls -l target/*.jar
```

```
-rw-r--r-- 1 root root 19463334 Nov 15 11:54 target/demo-0.0.1-SNAPSHOT.jar
```

The JAR is executable:

```execute
java -jar target/*.jar
```

The app has some built in HTTP endpoints by virtue of the "actuator" dependency we added when we downloaded the project. So you will see something like this in the logs on startup:

```
...
2019-11-15 12:12:35.333  INFO 13912 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 2 endpoint(s) beneath base path '/actuator'
2019-11-15 12:12:36.448  INFO 13912 --- [           main] o.s.b.web.embedded.netty.NettyWebServer  : Netty started on port(s): 8080
...
```

So you can curl the endpoints:

```execute-2
curl localhost:8080/actuator | jq .
```

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

Finally:

```execute
<ctrl-c>
```
