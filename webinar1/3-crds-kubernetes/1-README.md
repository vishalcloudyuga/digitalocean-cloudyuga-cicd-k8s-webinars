## CRD or Custom Resource Definition
A `resource` is an endpoint in the `Kubernetes API` that stores a collection of `API objects` . For example, `pods` resource contains a collection of `Pod` objects. A custom resource is nothing but the extension of the Kubernetes API. Custom resources can stor and retrieve the structured data when they are combined with a `controller` then Custom Resource can become a true `declarative API`. With A `declarative API` we can specify the desired state of our resource. 

A `custom controller` is a controller that users can deploy and update CRDs on a running cluster, independent of the cluster’s own controller. `Kubernets Operator` pattern is example of combination of Custom Resource, Custom Controller and Declarative API.


Create a new Custom Resource Definition.

- Create configuration file as below.
```
$ vi crd.yaml

apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: digitaloceans.stable.example.com
spec:
  group: stable.example.com
  version: v1
  scope: Namespaced
  names:
    plural: digitaloceans
    singular: digitalocean
    kind: Digitalocean
    shortNames:
    - do
  
```

- Deploy this CRD.
```
$ kubectl apply -f crd.yaml 
customresourcedefinition.apiextensions.k8s.io/digitaloceans.stable.example.com created

```

- Get the list of CRD.
```
$ kubectl get crd
NAME                               CREATED AT
digitaloceans.stable.example.com   2018-08-03T05:17:27Z
```

- After proxying the Kubernetes API locally using kubectl proxy we can discover the `stable.example.com` API group as follow.
```
$ kubectl proxy &
$ http 127.0.0.1:8001/apis/stable.example.com

HTTP/1.1 200 OK
Content-Length: 244
Content-Type: application/json
Date: Fri, 03 Aug 2018 05:20:34 GMT

{
    "apiVersion": "v1", 
    "kind": "APIGroup", 
    "name": "stable.example.com", 
    "preferredVersion": {
        "groupVersion": "stable.example.com/v1", 
        "version": "v1"
    }, 
    "serverAddressByClientCIDRs": null, 
    "versions": [
        {
            "groupVersion": "stable.example.com/v1", 
            "version": "v1"
        }
    ]
}

```

Next, we will create an instance of the `digitalocean` CRD :

- Configure the instance as follow.
```
$ vim digitalocean.yaml

apiVersion: "stable.example.com/v1"
kind: Digitalocean
metadata:
  name: my-digitalocean-object1
spec:
  name: digitalocean
  image: nginx

```

- Deploy the instance of CRD.
```
$  kubectl apply -f digitalocean.yaml 
digitalocean.stable.example.com/my-digitalocean-object1 created
```

- We can manage our Cloudyuga objects using `kubectl`. For example:
```
$ kubectl get digitalocean
NAME                      CREATED AT
my-digitalocean-object1   24s


$ kubectl get do
NAME                      CREATED AT
my-digitalocean-object1   1m

```

- After proxying the Kubernetes API locally using kubectl proxy we can discover the `digitalocean` CRD we defined in the previous step like so:
```
$ http 127.0.0.1:8001/apis/stable.example.com/v1/namespaces/default/digitaloceans

HTTP/1.1 200 OK
Content-Length: 916
Content-Type: application/json
Date: Fri, 03 Aug 2018 05:25:09 GMT

{
    "apiVersion": "stable.example.com/v1", 
    "items": [
        {
            "apiVersion": "stable.example.com/v1", 
            "kind": "Digitalocean", 
            "metadata": {
                "annotations": {
                    "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"stable.example.com/v1\",\"kind\":\"Digitalocean\",\"metadata\":{\"annotations\":{},\"name\":\"my-digitalocean-object1\",\"namespace\":\"default\"},\"spec\":{\"image\":\"nginx\",\"name\":\"digitalocean\"}}\n"
                }, 
                "clusterName": "", 
                "creationTimestamp": "2018-08-03T05:23:27Z", 
                "generation": 1, 
                "name": "my-digitalocean-object1", 
                "namespace": "default", 
                "resourceVersion": "31807", 
                "selfLink": "/apis/stable.example.com/v1/namespaces/default/digitaloceans/my-digitalocean-object1", 
                "uid": "59c26432-96dd-11e8-b522-0800272c1dad"
            }, 
            "spec": {
                "image": "nginx", 
                "name": "digitalocean"
            }
        }
    ], 
    "kind": "DigitaloceanList", 
    "metadata": {
        "continue": "", 
        "resourceVersion": "31918", 
        "selfLink": "/apis/stable.example.com/v1/namespaces/default/digitaloceans"
    }
}


```
## Delete a Custom Resource Definition.

- Delete CRD instance.
```
$ kubectl delete digitalocean --all
```

- Delete the  CRD.
```
$ kubectl delete crd digitaloceans.stable.example.com
```

### References
- https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/
