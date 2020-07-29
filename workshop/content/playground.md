{% include "code-server/package.liquid" %}


Spring Boot is a great way to write an application in Java. This workshop shows you how to create a Spring Boot application and run it in Kubernetes with as little fuss and bother as possible. And there's no YAML. To do this we need to do three things:

1. Create a Spring Boot application
2. Containerize it, and push the container to a registry
3. Deploy it to Kubernetes

You will need a few minutes of time.

We don't cover all the features of Spring and Spring Boot. For that you could go to the [Spring guides](https://spring.io/guides) or [Spring project homepages](https://spring.io/projects).

We also don't cover all the options available for building containers. There is a [Spring Boot topical guide](https://spring.io/guides/topicals/spring-boot-docker) covering some of those options in more detail.

When it comes to deploying the application to Kubernetes, there are far too many options to cover them all in one tutorial. We can look at one or two, but the emphasis will be on getting something working as quickly as possible, not on how to deploy to a production cluster.

## How to use this Guide


When you see a block of code like below, you can click on it to automatically paste it into an editor:

<pre class="pastable" data-file="/home/eduk8s/Dockerfile" data-prefix="COPY --from">
# Multiple lines
# of stuff
# to paste
</pre>

Or paste into a new file works too:

<pre class="pastable" data-file="/tmp/deploy.yml">
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nother
          piece: here
        - name: nginx
          image: nginx:1.14.2
          ports:
          - containerPort: 80
</pre>

Text can also be pasted into a specific 'yaml path' location inside an existing yaml file.
For example, the following pasts an extra container definition into the
file created in the previous step:

<pre class="pastable" data-file="/tmp/deploy.yml" data-yaml-path="spec.template.spec.containers">
- name: another-container
  image: blah
  ports:
  - containerPort: 6677
</pre>

Links like below can be clicked to open a file in the editor:

- {% render "code-server/open-file-widget.liquid", file: "/home/eduk8s/Dockerfile", lineno: 8 %}
- {% render "code-server/open-file-widget.liquid", file: "/home/eduk8s/exercises/.empty" %}
- <span class="editor_link" data-file="/home/eduk8s/Dockerfile" data-line="8"/>
- <span class="editor_link" data-file="/home/eduk8s/exercises/.empty"/>
- <span class="editor_link" data-file="/home/eduk8s/Dockerfile" data-line="10">Click me</span>

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

As well as the terminal, to the right of this text you will see 2 additional tabs:

* "Console": the Kubernetes console - a web application for exploring a Kubernetes cluster
* "Editor": an embedded IDE with Java and Spring Boot tooling. You don't need to use it to complete the guide, but if you want to edit code in Java or YAML it will be useful.

> NOTE: The first time you open the IDE it might take a minute to warm up. If you are using the Java languange extensions they will also initialize lazily, when you first open an editor with some Java source.

Some code blocks are copyable with one click, so you can use those to transfer content from the workshop notes to an editor or terminal (in the terminal use `CTRL-SHIFT-V` to paste):

```copy
echo "Text to copy"
```

You may also see links that can be clicked to open a file in the editor: {% render "code-server/open-file-widget.liquid", file: "/home/eduk8s/Dockerfile", lineno: 8 %}

There are also links to execute commands in the IDE, e.g: <span class="editor_command_link" data-command="workbench.action.terminal.toggleTerminal">Open Terminal</span>.

Links to execute commands in the editor:
- <span class="editor_command_link" data-command="spring.initializr.maven-project">Create Spring Boot Maven Project 
    <parameter>
    {
        "language": "Java",
        "dependencies": ["actuator", "web", "devtools"],
        "artifactId": "web-project",
        "groupId": "com.eduk8s.example"
    }
    </parameter>
</span>

List of all parameters for Initializr Create Project command can be found [here](https://github.com/BoykoAlex/vscode-spring-initializr/blob/customize/src/handler/GenerateProjectHandler.ts#L20).
