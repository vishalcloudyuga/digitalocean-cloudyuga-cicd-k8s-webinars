## Dockerfiles
Docker builds the container images automatically by reading the instructions from a `Dockerfile`. A `Dockerfile` is a text file that consist of all the commands required to assemble a container image. Using `docker build` command we can create an automated build that executes several command-line instructions provided in `Dockerfile`. The `docker build` command builds an image from a `Dockerfile` and a `context`. The `context` is the set of files required to create a environment and run applications in container image.

## Demo

- Fork the `RSVP` repository which consist of sample Application and Dockerfile to build the image.
```
$ git clone https://github.com/cloudyuga/rsvpapp.git
```

- Get into the forked repo and list the files.
```
$ cd rsvpapp
$ ls
docker-compose.yml  Dockerfile  __init__.py  LICENSE  README.md  requirements.txt  rsvp.py  static  templates  tests
```

- Lets take a look at `Dockerfile`
```
$ cat Dockerfile

FROM teamcloudyuga/python:alpine
COPY . /usr/src/app
WORKDIR /usr/src/app
ENV LINK http://www.meetup.com/cloudyuga/
ENV TEXT1 CloudYuga
ENV TEXT2 Garage RSVP!
ENV LOGO https://raw.githubusercontent.com/cloudyuga/rsvpapp/master/static/cloudyuga.png
ENV COMPANY CloudYuga Technology Pvt. Ltd.
RUN pip3 install -r requirements.txt
CMD python rsvp.py
```
Dockerfile consist of the set of instructions required to build the image.

- Lets Build the Image.
```
$ docker build -t teamcloudyuga/rsvpapp:demo .

docker build -t teamcloudyuga/rsvpapp:demo .
Sending build context to Docker daemon  466.4kB
Step 1/10 : FROM teamcloudyuga/python:alpine
alpine: Pulling from teamcloudyuga/python
c0cb142e4345: Pull complete 
bc4d09b6c77b: Pull complete 
606abda6711f: Pull complete 
809f49334738: Pull complete 
Digest: sha256:5ffa34a66d3e81d4de2103282fbbfd3ab52a4a8ea76d03271bfad38b67ecbdba
Status: Downloaded newer image for teamcloudyuga/python:alpine
 ---> b0c552b8cf64
Step 2/10 : COPY . /usr/src/app
 ---> 181d08e3ba78
Step 3/10 : WORKDIR /usr/src/app
 ---> Running in 5ad0301c57ce
Removing intermediate container 5ad0301c57ce
 ---> 3dd799c7e9fe
Step 4/10 : ENV LINK http://www.meetup.com/cloudyuga/
 ---> Running in 7b0f094fbfe3
Removing intermediate container 7b0f094fbfe3
 ---> 29b13271020f
Step 5/10 : ENV TEXT1 CloudYuga
 ---> Running in aa38834a4950
Removing intermediate container aa38834a4950
 ---> 14c17181bdfc
Step 6/10 : ENV TEXT2 Garage RSVP!
 ---> Running in adfbbcaaf8d5
Removing intermediate container adfbbcaaf8d5
 ---> 89ba1ac108ed
.
.
.
.
.
.

Step 10/10 : CMD python rsvp.py
 ---> Running in 02533895ba9a
Removing intermediate container 02533895ba9a
 ---> 964e1dbf0f79
Successfully built 964e1dbf0f79
Successfully tagged teamcloudyuga/rsvpapp:demo
```

- List the Docker images.
```
$ docker image ls

REPOSITORY              TAG                 IMAGE ID            CREATED              SIZE
teamcloudyuga/rsvpapp   demo                964e1dbf0f79        About a minute ago   108MB
```
