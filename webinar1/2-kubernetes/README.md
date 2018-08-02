### Prerequisites.
- Required tools
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  - [terrafrom](https://www.terraform.io/intro/getting-started/install.html)

- You Must have a DigitalOcean account. Personal Access Token must be generated on [DigitalOcean](https://www.digitalocean.com/docs/api/create-personal-access-token/).
- You must have linked your SSH key to [DigitalOcean] (https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/create-with-openssh/)
- We are asuming your public keys and private keys are located at `~/.ssh/id_rsa.pub` and `~/.ssh/id_rsa`
### Create Kubernetes cluster on DigitalOcean.

- Clone the Repository
``` 
$ git clone https://github.com/vishalcloudyuga/digitalocean-cloudyuga-cicd-k8s-webinars.git
```

- Go to the Terrafrom script directory.
```
$ cd digitalocean-cloudyuga-cicd-k8s-webinars/webinar1/2-kubernetes/1-Terrafrom/
```

- Get a Fingerprint of Your SSH public key.(SSH key must be linked with DO)
```
$ ssh-keygen -lf ~/.ssh/id_rsa.pub
2048 c6:94:77:7b:4f:69:5c:1e:43:74:2c:5a:1c:38:7f:eb /root/.ssh/id_rsa.pub (RSA)
```

- Export a Fingerprint.
```
$ export fingerprint=c6:94:77:7b:4f:69:5c:1e:43:74:2c:5a:1c:38:7f:eb
```

- Export your DO Personal Access Token.
```
$ export token= ##########<Your Digital Ocean Personal Access Token>##########
```

- Now take a look at the directory.
```
$ ls
cluster.tf  destroy.sh  outputs.tf  provider.tf  script.sh
```
- Simply run the script.
```
./script.sh
```

- When your script execution get completed your kubectl will get configured to use the kubernetes cluster.
```
$ kubectl get nodes
NAME                STATUS    ROLES     AGE       VERSION
k8s-matser-node     Ready     master    2m        v1.10.0
k8s-worker-node-1   Ready     <none>    1m        v1.10.0
k8s-worker-node-2   Ready     <none>    57s       v1.10.0
```

### Create a Kubernetes Deployment and Service.

- Lets create Nginx deployment.
```
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
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80

```

- Deploy the deployment.
```
$ kubectl apply -f deployment.yaml
```

- List the deployments.
```
$ kubectl get deployments
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3         3         3            3           29s
```

- List the pods.
```
$ kubectl get pod
NAME                                READY     STATUS      RESTARTS   AGE
nginx-deployment-75675f5897-nhwsp   1/1       Running     0          1m
nginx-deployment-75675f5897-pxpl9   1/1       Running     0          1m
nginx-deployment-75675f5897-xvf4f   1/1       Running     0          1m

```

- Create service for above deployment.
```
kind: Service
apiVersion: v1
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  type: NodePort
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30111
```

- Deploy the service.
```
$ kubectl apply -f service.yaml
```

- List the Services.
```
$ kubectl get service
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        5h
nginx-service   NodePort    10.100.98.213   <none>        80:30111/TCP   7s
```

You can access the Nginx application at 30111 port of Node/Master's IP address.


### Clean Up.
```
$ kubectl delete deployment nginx-deployment
$ kubectl delete service nginx-service
```


### Delete Cluster.
```
$ ./destroy.sh
```

