Before we can deploy the container image to Kubernetes, it needs to be made available via an image registry from which Kubernetes can pull the image when deploying it.

This workshop environment provides you with your own image registry located at `{{ registry_host }}` and the user your workshop environment runs as has already been authenticated against the image registry.

As the container image when built was tagged with the image registry name, we need only push the image to the registry.

```execute
docker push {{ registry_host }}/springguides/demo
```

We now need a Kubernetes cluster. In this workshop environment we have already taken care of that for you. The workshop is running in a Kubernetes cluster and you have access to your own namespace in the same cluster.

To check that you can access the Kubernetes cluster okay, run:

```execute
kubectl version
```

The output should be similar to the following, although the version of Kubernetes may differ.

```
Client Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.5", GitCommit:"e0fccafd69541e3750d460ba0f9743b90336f24f", GitTreeState:"clean", BuildDate:"2020-04-16
T11:44:03Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.4+vmware.1", GitCommit:"2e240196fa7251c7f1ff96392db857c281f534e5", GitTreeState:"clean", BuildDate:"2
020-04-16T04:00:11Z", GoVersion:"go1.13.8", Compiler:"gc", Platform:"linux/amd64"}
```

To deploy our container image, now run:

```execute
kubectl create deployment demo --image={{ registry_host }}/springguides/demo
```

The output should be:

```
deployment.apps/demo created
```

> NOTE: The deployment will use the `default` service account, which already has the image pull secret for the image registry associated with it, so we did not need to provide the pull secret in the deployment.

To monitor the deployment, run:

```execute
kubectl rollout status deployment/demo
```

To see all the resources which were created, run:

```execute
kubectl get all
```

The output should be similar to:

```
NAME                             READY     STATUS      RESTARTS   AGE
pod/demo-658b7f4997-qfw9l        1/1       Running     0          1m

NAME                   READY     UP-TO-DATE   AVAILABLE   AGE
deployment.apps/demo   1/1       1            1           1m

NAME                              DESIRED   CURRENT   READY     AGE
replicaset.apps/demo-658b7f4997   1         1         1         1m
```

To test that the deployment is working, we need to be able to connect to the application. Normally you would have created a service for the application, as well as exposed it outside of the cluster using an ingress or via a load balancer. Since we haven't done that, we will set up port forwarding to expose the application to the local environment.

```execute
kubectl port-forward deployment/demo 8080:8080
```

To test the application, run:

```execute-2
curl localhost:8080/actuator/health
```

The output should be:

```
{"status":"UP","groups":["liveness","readiness"]}
```
