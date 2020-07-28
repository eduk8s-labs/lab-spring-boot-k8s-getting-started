{% include "code-server/package.liquid" %}

Before you can start, you need to install and start the Kubernetes cluster. In this environment we have already taken care of that for you. The lab is running in a Kubernetes cluster and you have access to your own namespace in the same cluster.

Check that you have a Kubernetes cluster running:

```execute
kubectl version
```

```
Client Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.5", GitCommit:"e0fccafd69541e3750d460ba0f9743b90336f24f", GitTreeState:"clean", BuildDate:"2020-04-16
T11:44:03Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.4+vmware.1", GitCommit:"2e240196fa7251c7f1ff96392db857c281f534e5", GitTreeState:"clean", BuildDate:"2
020-04-16T04:00:11Z", GoVersion:"go1.13.8", Compiler:"gc", Platform:"linux/amd64"}
```

You will notice in the output that you see information of the version of your server Kubernetes cluster.

Now we can deploy our Spring Boot application.

To prepare for the deployment there is a secret that we need to apply once, so that Kubernetes can pull images from the private repo we have been using:

```execute
kubectl create secret generic registry-credentials --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
```

You have a container that runs and exposes port 8080, so all you need to make Kubernetes run it is some YAML. To avoid having to look at or edit YAML, for now, you can ask `kubectl` to generate it for you. The only thing that might vary here is the `--image` name. If you deployed your container to your own repository, use its tag instead of this one:

```execute
kubectl create deployment demo --image={{ REGISTRY_HOST }}/springguides/demo --dry-run -o=yaml > deployment.yaml
```

Patch the deployment to add image pull secrets for our private registry:

```execute
sed -i '/    spec:/a \      imagePullSecrets:\n      - name: registry-credentials' deployment.yaml
```

Now create a service (TCP endpoint) for the application by appending to the YAML we already have:

```execute
echo --- >> deployment.yaml
```

```execute
kubectl create service clusterip demo --tcp=8080:8080 --dry-run -o=yaml >> deployment.yaml
```

You can <span class="editor_link" data-file="/home/eduk8s/exercises/demo/deployment.yaml">open up the YAML in the IDE</span> and have a look at it. You can edit it there, or you can just apply it from the command line:

```execute
kubectl apply -f deployment.yaml
```

```
deployment.apps/demo created
service/demo created
```

> NOTE: You can also use the Kubernetes extension in the IDE to deploy YAML files, to inspect the cluster, forward ports, etc.

Check that the application is running:

```execute
kubectl get all
```

```
NAME                             READY     STATUS      RESTARTS   AGE
pod/demo-658b7f4997-qfw9l        1/1       Running     0          146m

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/kubernetes   ClusterIP   10.43.0.1       <none>        443/TCP    2d18h
service/demo         ClusterIP   10.43.138.213   <none>        8080/TCP   21h

NAME                   READY     UP-TO-DATE   AVAILABLE   AGE
deployment.apps/demo   1/1       1            1           21h

NAME                              DESIRED   CURRENT   READY     AGE
replicaset.apps/demo-658b7f4997   1         1         1         21h
d
```

> TIP: Keep doing `kubectl get all` until the demo pod shows its status as "Running".

Now you need to be able to connect to the application, which you have exposed as a Service in Kubernetes. One way to do that, which works great at development time, is to create an SSH tunnel:

```execute
kubectl port-forward svc/demo 8080:8080
```

then you can verify that the app [is running](//{{ session_namespace }}-application.{{ ingress_domain }}/actuator/health):

```execute-2
curl localhost:8080/actuator/health
```

```
{"status":"UP"}
```
