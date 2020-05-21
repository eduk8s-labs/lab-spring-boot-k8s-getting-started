LAB - Spring Boot 
=====================
Sample workshop for Spring Boot app deployment

# Tooling Setup
Currently **eduk8s** workshop dashboard is setup in a single container where resources such as Theia IDE, Terminal etc are placed in their corresponding specific folders under `/opt/`. Then the `start-container` script of the **Workshop Dashboard** starts Theia IDE, Terminal and other parts of the dashboard including other special resources start up scripts that **Workshop Dashboard** looks for at special locations. (See https://github.com/eduk8s/workshop-dashboard/blob/develop/dashboard/usr/bin/start-container#L106).

Therefore the trick is to override or provide something extra would be store or overwrite the app in a specific folder and then provide the start up shell script for it.

## Initializr
The Spring Initializr app has been modified to generate the project at a specific location locally: `/generate` end point. The Web UI has been changed accordingly to call `/generate` end point when **Generate** button is clicked. The location to store the generated project is to be specified via the property `initializr.initializr.project-location-container`.
- The backend for the modified Spring Initializr - **initializr**: https://github.com/BoykoAlex/initializr branch: **eduk8s**
- The front end serving piece of the modified Initializr - **start.spring.io**: https://github.com/BoykoAlex/start.spring.io branch **eduk8s**
(Build instructions: build **initializr** first `./mvnw clean install -DskipTests` and then **start.spring.io** with the same command. Then `start.spring.io/start-site/target/start-site-exec.jar` is the fat JAR for the Initializr app)

The docker image file for the modified Initializr: https://github.com/BoykoAlex/start.spring.io/blob/eduk8s/start-site/Dockerfile
The published Docker image: **boykoalex/eduk8s-initializr-test**

### Hook up Initializr to eduk8s
The `Dockerfile` copies `initializr.jar` from **boykoalex/eduk8s-initializr-test** Docker image into workshop's Docker image at `/opt/initializr/initializr.jar`. The `Dockerfile` also copies `initializr/start-initializr.sh`script that fires up the Initializr app inside the container into `/opt/eduk8s/etc/setup.d/start-initializr.sh` which is one of the locations being scanned by workshops container start script for various scripts to execute. The Initializr start script starts Initialiazr app on a specific port (**10189** currently) and sets the folder to store generated projects to be `/home/eduk8s` which is the landing location for all workshop session resources for a user.

Now Initializr needs to be integrated into Workshop Dashboard similarly to Theia and other UI bits. Outside traffic needs to be directed to Initializr app running on its port (**10189**). This can be done in `resources/workshop.yaml` file under `session`:
```
    ingresses:
    - name: initializr
      port: 10189
```
(See for more details eduk8s documentation: https://docs.eduk8s.io/en/latest/runtime-environment/workshop-definition.html#defining-additional-ingress-points)

Once traffic redirection has been setup with the help of the ingress setting above the UI can be tweaked to show Initializr UI.

The tab similar to Theia IDE can be setup easily via a small change in `resources/workshop.yaml` file under `session`:
```
    dashboards:
    - name: initializr
      url: "$(ingress_protocol)://$(session_namespace)-initializr.$(ingress_domain)/"      

```
(See for more details eduk8s documentation: https://docs.eduk8s.io/en/latest/runtime-environment/workshop-definition.html#adding-custom-dashboard-tabs)

Lastly, one can even embedd the Initializr UI into workshop content Markdown pages with an iframe element:
```
<iframe style="width:100%;height:900px" src="${INGRESS_PROTOCOL}://${SESSION_NAMESPACE}-initializr.${INGRESS_DOMAIN}/"></iframe>
```
The trick here is that variables in the URL need to be substituted at the session deployment time by a script that would be executed at the session container start up time. The example script is kept in `workshop/setup.d/create-resources.sh`. It takes `workshop/content/exercises/step.md.in` file and substitutes the variables with the values of corresponding environment variables and stores the result in `step2.md` file. Note that the whole workshop folder is placed in the container such that the `create-resources.sh` is executed at the startup time and no further work is required in the `Dockefile`

## Theia IDE with Java and Spring Boot Extensions
Currently Theia IDE in **eduk8s** is setup with 
1. `package.json` file located in the container at `/opt/theia/package.json`
2. The **Workshop Dashboard** `Dockerfile` building Theia executing `yarn` command
3. Theia IDE is started with the shell script: https://github.com/eduk8s/workshop-dashboard/blob/develop/dashboard/opt/eduk8s/sbin/start-theia placed at `/opt/eduk8s/sbin/start-theia`
The `package.json` has just a few extensions and no directory specified for picking up extra extensions as `.vsix` files.

Current state of Theia IDE implies two ways to have Java and Spring Boot extensions:
1. Overwrite `package.json` file in the container with our own contant that includes extensions for Java and Spring Boot. then re-run Theia build
2. Wipe out `/opt/theia` folder entirely and copy there Theia IDE from our STS4 Theia Docker image **kdvolder/sts4-theia-snapshot:stable**

