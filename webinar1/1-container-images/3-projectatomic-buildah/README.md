## Projectatomic-Buildah
Buildah is a CLI tool developed by  `Projectatomic` for efficiently and quickly building Open Container Initiative (OCI) compliant images. Buildah can create an image, either from a working container or a Dockerfile. `Buildah` can perform image operation like build, list, push, tag. `Buildah`


### Installation.

Following instructions are for Ubuntu 16.04. If you are using different OS then please follow the [installation notes](https://github.com/projectatomic/buildah/blob/master/install.md)

- Install the required dependencies.
```
  apt-get -y install software-properties-common
  add-apt-repository -y ppa:alexlarsson/flatpak
  add-apt-repository -y ppa:gophers/archive
  apt-add-repository -y ppa:projectatomic/ppa
  apt-get -y -qq update
  apt-get -y install bats btrfs-tools git libapparmor-dev libdevmapper-dev libglib2.0-dev libgpgme11-dev libostree-dev libseccomp-dev libselinux1-dev skopeo-containers go-md2man
  apt-get -y install golang-1.8
```

- Install the runc and Buildah.
```
  mkdir ~/buildah
  cd ~/buildah
  export GOPATH=`pwd`
  git clone https://github.com/projectatomic/buildah ./src/github.com/projectatomic/buildah
  cd ./src/github.com/projectatomic/buildah
  PATH=/usr/lib/go-1.8/bin:$PATH make runc all TAGS="apparmor seccomp"
  cp buildah/src/github.com/opencontainers/runc/runc /usr/bin/.
  apt install buildah
```

- Configure the `/etc/containers/registries.conf`.
```
$ vi /etc/containers/registries.conf

# This is a system-wide configuration file used to
# keep track of registries for various container backends.
# It adheres to TOML format and does not support recursive
# lists of registries.

# The default location for this configuration file is /etc/containers/registries.conf.

# The only valid categories are: 'registries.search', 'registries.insecure',
# and 'registries.block'.

[registries.search]
registries = ['docker.io', 'registry.fedoraproject.org', 'quay.io', 'registry.access.redhat.com', 'registry.centos.org']

# If you need to access insecure registries, add the registry's fully-qualified name.
# An insecure registry is one that does not have a valid SSL certificate or only does HTTP.
[registries.insecure]
registries = []


# If you need to block pull access from a registry, uncomment the section below
# and add the registries fully-qualified name.
#
# Docker only
[registries.block]
registries = []
```


