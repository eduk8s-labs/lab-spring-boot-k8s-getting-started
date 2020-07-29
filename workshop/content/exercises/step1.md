{% include "code-server/package.liquid" %}

The first thing we will do is create a Spring Boot application. If you have one you prefer to use already in github, you could clone it in the terminal (`git` and `java` are installed already). Or you can create an application from scratch using [start.spring.io](https://start.spring.io).

Click on <span class="editor_command_link" data-command="spring.initializr.maven-project">this link to open the IDE
<parameter>
    {
        "language": "Java",
        "dependencies": ["actuator", "webflux"],
        "artifactId": "demo",
        "groupId": "com.example"
    }
    </parameter>
</span> and generate some code using start.spring.io - select the defaults for all options except the dependencies, where you will need webflux and actuator. If you don't want to use the IDE wizard you can use curl in the terminal:

```execute
mkdir -p demo && (cd demo; curl https://start.spring.io/starter.tgz -d dependencies=webflux,actuator | tar -xzvf -)
```

You can then <span class="editor_link" data-file="/home/eduk8s/exercises/demo/src/main/java/com/example/DemoApplication.java">open up the main application class</span> and have a look at it. And you can build the application in the IDE or on the command line (make sure you are in the correct directory - `demo` if you used the links above):

```execute
cd demo && ./mvnw install
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

or visit them [in your browser](//{{ session_namespace }}-application.{{ ingress_domain }}/actuator).

Finally shut down the app:

```execute
<ctrl-c>
```
