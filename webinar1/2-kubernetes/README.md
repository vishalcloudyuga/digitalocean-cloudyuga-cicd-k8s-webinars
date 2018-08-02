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
