{% include "code-server/package.liquid" %}

{% render "code-server/open-file-widget.liquid", file: "/home/eduk8s/Dockerfile", lineno: 8 %}
{% render "code-server/open-file-widget.liquid", file: "/home/eduk8s/exercises/.empty" %}

When you see a block like below, you can click on it to paste it into an editor:

<pre class="pastable" data-file="/home/eduk8s/Dockerfile" data-prefix="COPY --from">
# Multiple lines
# of stuff
# to paste
</pre>

Spring Boot is a great way to write an application in Java. This workshop shows you how to create a Spring Boot application and run it in Kubernetes with as little fuss and bother as possible. And there's no YAML. To do this we need to do three things:

1. Create a Spring Boot application
2. Containerize it, and push the container to a registry
3. Deploy it to Kubernetes

You will need a few minutes of time.

We don't cover all the features of Spring and Spring Boot. For that you could go to the [Spring guides](https://spring.io/guides) or [Spring project homepages](https://spring.io/projects).

We also don't cover all the options available for building containers. There is a [Spring Boot topical guide](https://spring.io/guides/topicals/spring-boot-docker) covering some of those options in more detail.

When it comes to deploying the application to Kubernetes, there are far too many options to cover them all in one tutorial. We can look at one or two, but the emphasis will be on getting something working as quickly as possible, not on how to deploy to a production cluster.

## How to use this Guide

A Kubernetes cluster will start for you in the terminal on the right (if you are on a phone or a small device, rotate it to landscape to see the terminal). When the prompt appears you can proceed with the tutorial. 

You can execute shell commands in the guide text by clicking on the little icon to the right of the code block. E.g. like this

```execute
echo Hello World!
```

You should see some output:

```
Hello World!
```

The terminal may occasionally lose its connection to your browser. There is a "Refresh" link on the top right that can be used to rescue the session. There is also a "Restart Session" link in the menu at the top right, in case you want to ditch everything and start again.

As well as the terminal, to the right of this text you will see 3 additional tabs:

* "Console": the Kubernetes console - a web application for exploring a Kubernetes cluster
* "Editor": an embedded IDE with Java and Spring Boot tooling. You don't need to use it to complete the guide, but if you want to edit code in Java or YAML it will be useful.
* "Initializr": an embedded version of [Spring Initializr](https://start.spring.io) that generates code in the lab container instead of downloading to your local machine. You won't need it if you just want to click thrugh the course, but feel free to use it if you want to go off piste.
