## Project skeleton sporting Jupyter

A project skeleton with multistage Docker build, resulting in:
* a lightweight container suitable for deployment
* a development container with Jupyter.


### Instructions
Git clone and cd to project root.

#### Jupyter container

To run Jupyter from the container and make all changes to the notebooks persist in `$PWD/notebooks` on Docker host, execute

`export NB_GID=($id -g) && docker-compose up develop`

#### Minimal container
Build and run the container image:

`docker-compose up develop`
