Build the container image, giving it a tag (choose your own ID instead of "{{ REGISTRY_HOST }}/springguides" if you are going to push to Dockerhub):

```execute
./mvnw package spring-boot:build-image -Dspring-boot.build-image.imageName={{ REGISTRY_HOST }}/springguides/demo
```

Note that you did not need a `Dockerfile`. You can run the container on the command line using `docker`:

```execute
docker run -p 8080:8080 {{ REGISTRY_HOST }}/springguides/demo
```

Sample output:

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v2.2.1.RELEASE)

2019-11-27 11:32:48.296  INFO 1 --- [           main] com.example.demo.DemoApplication         : Starting DemoApplication on 9f7d342794b4with PID 1 (/app started by root in /)
2019-11-27 11:32:48.313  INFO 1 --- [           main] com.example.demo.DemoApplication         : No active profile set, falling back to default profiles: default
2019-11-27 11:32:51.782  INFO 1 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 2 endpoint(s) beneath base path'/actuator'
2019-11-27 11:32:52.851  INFO 1 --- [           main] o.s.b.web.embedded.netty.NettyWebServer  : Netty started on port(s): 8080
2019-11-27 11:32:52.864  INFO 1 --- [           main] com.example.demo.DemoApplication         : Started DemoApplication in 5.662 seconds(JVM running for 6.273)
```

Check that it works:

```execute-2
curl localhost:8080/actuator/health
```

```
{"status":"UP"}
```

Finish off by killing the container:

```execute-1
<ctrl-c>
```

> NOTE: In this tutorial environment, you will be able to push the image even though you did not authenticate with Dockerhub (`docker login`). If you are running locally you can change the image label and push to Dockerhub, or there's an image `springguides/demo` already there that should work if you want to skip this step.

```execute
docker push {{ REGISTRY_HOST }}/springguides/demo
```

The image needs to be pushed to an accessible registry because Kubernetes pulls the image from inside its Kubelets (nodes), which are not in general connected to the local docker daemon.
