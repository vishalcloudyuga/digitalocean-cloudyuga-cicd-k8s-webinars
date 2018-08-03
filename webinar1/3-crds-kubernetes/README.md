## CRD or Custom Resource Definition
A resource is an endpoint in the Kubernetes API that stores a collection of API objects of a certain kind. For example, the built-in pods resource contains a collection of Pod objects.




Create a new Custom Resource Definition.

Create configuration file as below.
```
$ vi crd.yaml

apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: cloudyugas.stable.example.com
spec:
  group: stable.example.com
  version: v1
  scope: Namespaced
  names:
    plural: cloudyugas
    singular: cloudyuga
    kind: Cloudyuga
    shortNames:
    - cy
```

Deploy this CRD.
```
$ kubectl create -f crd.yaml 
customresourcedefinition "cloudyugas.stable.example.com" created
```

Get the list of CRD.
```
$ kubectl get crd
NAME                            KIND
cloudyugas.stable.example.com   CustomResourceDefinition.v1beta1.apiextensions.k8s.io
```

After proxying the Kubernetes API locally using kubectl proxy we can discover the `stable.example.com` API group as follow.
```
$ kubectl proxy &
$ http 127.0.0.1:8001/apis/stable.example.com

HTTP/1.1 200 OK
Content-Length: 244
Content-Type: application/json
Date: Fri, 03 Nov 2017 08:14:37 GMT

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

Next, we will create an instance of the `cloudyuga` CRD :

Configure the instance as follow.
```
$ vim cy.yaml
apiVersion: "stable.example.com/v1"
kind: Cloudyuga
metadata:
  name: my-cloudyuga-object1
spec:
  name: cloudyuga
  image: nginx

```

Deploy the instance of CRD.
```
$ kubectl create -f cy.yaml 
cloudyuga "my-cloudyuga-object1" created
```

We can manage our Cloudyuga objects using `kubectl`. For example:
```
$ kubectl get cloudyuga
NAME                  KIND
my-cloudyuga-object1   Cloudyuga.v1.stable.example.com

$ kubectl get cy
NAME                  KIND
my-cloudyuga-object1   Cloudyuga.v1.stable.example.com
```

After proxying the Kubernetes API locally using kubectl proxy we can discover the `cloudyuga` CRD we defined in the previous step like so:
```
$ http 127.0.0.1:8001/apis/stable.example.com/v1/namespaces/default/cloudyugas
HTTP/1.1 200 OK
Content-Length: 647
Content-Type: application/json
Date: Fri, 03 Nov 2017 08:31:18 GMT

{
    "apiVersion": "stable.example.com/v1", 
    "items": [
        {
            "apiVersion": "stable.example.com/v1", 
            "kind": "Cloudyuga", 
            "metadata": {
                "clusterName": "", 
                "creationTimestamp": "2017-11-03T08:28:00Z", 
                "deletionGracePeriodSeconds": null, 
                "deletionTimestamp": null, 
                "name": "my-cloudyuga-objecti1", 
                "namespace": "default", 
                "resourceVersion": "18463", 
                "selfLink": "/apis/stable.example.com/v1/namespaces/default/cloudyugas/my-cloudyuga-objecti1", 
                "uid": "e75328bc-c070-11e7-957a-c24bb4328857"
            }, 
            "spec": {
                "image": "nginx", 
                "name": "cloudyuga"
            }
        }
    ], 
    "kind": "CloudyugaList", 
    "metadata": {
        "continue": "", 
        "resourceVersion": "18701", 
        "selfLink": "/apis/stable.example.com/v1/namespaces/default/cloudyugas"
    }
}
```
## Delete a Custom Resource Definition.

Delete CRD instance.
```
$ kubectl delete cloudyuga --all
```

Delete the  CRD.
```
$ kubectl delete crd cloudyugas.stable.example.com
customresourcedefinition "cloudyugas.stable.example.com" deleted
```

### References
- https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/
