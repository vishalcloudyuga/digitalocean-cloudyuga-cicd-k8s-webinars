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

## Multi-Stage
Multi stage build is the new feature introduced in the Docker 17.05, Which is very useful for optimizing the Dockerfile. It is very challeging task to write down the efficient Dockerfile with the lesser Docker image size. Each instruction in the Dockerfile creates the layer to the Docker image. Generally before this feature one Dockerfile was used for development (which contained everything needed to build your application),and another [reduced/modified] Dockerfile was used for production, which only contained your application and dependencies which were needed to run that application. So you have to maintain multiple Dockerfiles

- Clone the git repository. 
```
$ git clone https://github.com/vishalcloudyuga/multistage.git
$ cd multistage
$ ls
Dockerfile  hello.c  README.md  SimpleDockerfile  start.sh
```

#### Without Multistage

- First Lets Build the image without multistage. For that take a look at `SimpleDockerfile`.
```
cat SimpleDockerfile 
FROM ubuntu AS buildstep
RUN apt-get update && apt-get install -y build-essential gcc
COPY hello.c /app/hello.c
COPY ./start.sh /app/start.sh
WORKDIR /app
RUN gcc -o hello hello.c && chmod +x hello
ENV INITSYSTEM=on
CMD ["bash", "/app/start.sh"]

```

- Build the Image.
```
$ docker build -t cloudyuga/simple:capp -f ./SimpleDockerfile .
```

- List the Images.
```
$ docker image ls
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
cloudyuga/simple        capp                88880d3279c7        8 seconds ago       329MB
```

- Run the docker container from the above created image.
```
$ docker container run cloudyuga/simple:capp
Hello From CLOUDYUGA
```

#### With Multistage

- Take a look at Dockerfile.
```
$ cat Dockerfile

# This is the base for our build step container
# which has all our build essentials
FROM ubuntu AS buildstep
RUN apt-get update && apt-get install -y build-essential gcc
COPY hello.c /app/hello.c
WORKDIR /app
RUN gcc -o hello hello.c && chmod +x hello

# This is our runtime container that will end up
# running on the device.
FROM ubuntu

# Uncomment the following if your binary requires additional dependencies
# RUN apt-get update && apt-get install -y \
# curl \
# && rm -rf /var/lib/apt/lists/*

# Defines our working directory in container
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app

# Copy our artifact into our deployable container context.
COPY --from=buildstep /app/hello ./hello

# Copy our start script into our deployable container context.
COPY ./start.sh ./start.sh

# Enable systemd init system in container
ENV INITSYSTEM=on

# server.js will run when container starts up on the device
CMD ["bash", "/usr/src/app/start.sh"]

```

- Build the image from above Dockerfile.
```
$ docker build -t cloudyuga/multistage:capp .
```

- List Docker image.
```
$ docker image ls
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
cloudyuga/multistage    capp                f19242572416        10 seconds ago      83.5MB
cloudyuga/simple        capp                88880d3279c7        2 minutes ago       329MB
```
You can see the reduced size of image.

- Run the docker container from the above created image.
```
$ docker container run cloudyuga/multistage:capp
Hello From CLOUDYUGA
```

