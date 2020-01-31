[![Build Status](https://travis-ci.com/jgkawell/sawyer_dev.svg?branch=master)](https://travis-ci.com/jgkawell/sawyer_dev)

# sawyer-dev
A helper repository for setting up a development environment for Sawyer.


## Docker

This is a simple ROS development container running Ubuntu 16.04, ROS Kinetic Desktop, and has the needed tools from Rethink Robotics loaded for Sawyer development and initialized for simulation. There are two different tags: `simple` has OMPL and MoveIt! installed normally; `custom` has OMPL and MoveIt! installed from source and tweaked for custom cost functions. More info can be found [here](https://github.com/jgkawell/ompl-dev).

The image for this lives on Docker Hub as [jgkawell/sawyer](https://hub.docker.com/repository/docker/jgkawell/sawyer).


### Setup

As long as your network is fast, I would suggest pulling this image from Docker Hub instead of building locally from the Dockerfile. I also suggest using the launch script I've written to automate this process (pulling image, setting up xauth and xhost, etc.). This launch script is in another helper repository so we need to pull that first:

```
git clone https://github.com/jgkawell/docker-scripts.git
bash ./docker-scripts/tools/launch.sh {user} {repository} {tag} {host}
```

Make sure to use the user, repository, tag, and host that you would like. For example, using the image built with the Dockerfile in this repository on a Linux computer running Intel graphics would look like this:

```
bash ./docker-scripts/tools/launch.sh jgkawell sawyer base intel
```

If you're running a Linux host then check [the documentation](https://github.com/jgkawell/docker-scripts/wiki) for how to set up hardware acceleration which is needed for these images. It will work with either Nvidia or Intel graphics.

Then, in another terminal, start a shell on the box:

```
docker exec -it {container_name} bash
```

Be sure to replace `{container_name}` with the name of the container you built which depends on the host you're using:

- `windows` or `intel` = `sawyer-{tag}`
- `nvidia` = `sawyer-{tag}-nvidia`

You can relaunch the container using the launch script at any point in the future.


## Local

This will simply install the Intera SDK and Sawyer packages locally on your machine and set them up for local simulation. The only real prerequisite is that you are running Ubuntu 16.04 with ROS Kinetic installed.

Optionally you can run this with OMPL installed from source for custom cost functions. Checkout [this repository](https://github.com/jgkawell/ompl-dev) for information on setting this up.

### Setup

Simply run the install script and it should get everything set up for you:

```
sudo bash local/sawyer-install.sh
```


## Usage

For an overview on using the Sawyer tools. Head over to [this page](https://github.com/jgkawell/docker-scripts/blob/master/docs/simulated-sawyer.md) in the documentation.
