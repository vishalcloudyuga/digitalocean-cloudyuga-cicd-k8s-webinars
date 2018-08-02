## Projectatomic-Buildah
Buildah is a CLI tool developed by  `Projectatomic` for efficiently and quickly building Open Container Initiative (OCI) compliant images. Buildah can create an image, either from a working container or a Dockerfile. `Buildah` can perform image operation like build, list, push, tag. `Buildah`


### Installation.

Following instructions are for Ubuntu. If you are using different OS then please follow the [installation notes](https://github.com/projectatomic/buildah/blob/master/install.md)

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

- Install the Buildah.
```
  mkdir ~/buildah
  cd ~/buildah
  export GOPATH=`pwd`
  git clone https://github.com/projectatomic/buildah ./src/github.com/projectatomic/buildah
  cd ./src/github.com/projectatomic/buildah
  PATH=/usr/lib/go-1.8/bin:$PATH make runc all TAGS="apparmor seccomp"
  sudo make install install.runc
  buildah --help
```

### Build the Image.

- Clone the repository.
```
$ git clone https://github.com/cloudyuga/rsvpapp.git
```

- List the contents.
```
$ ls
docker-compose.yml  Dockerfile  __init__.py  LICENSE  README.md  requirements.txt  rsvp.py  static  templates  tests
```

- 
