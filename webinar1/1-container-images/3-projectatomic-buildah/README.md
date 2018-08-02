



### Installation.

Following instructions are for Ubuntu. If you are on other OS than it then please follow the [installation notes](https://github.com/projectatomic/buildah/blob/master/install.md)
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
