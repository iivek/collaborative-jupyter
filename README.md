## Collaboration-friendly project skeleton sporting Jupyter

A project skeleton with multistage Dockerfile, resulting in:
* a lightweight container suitable for deployment
* a development container with Jupyter.


### Instructions
Git clone and cd to project root.

#### Jupyter container
To build the container image, run

`docker build --target develop -t develop .`

To run Jupyter from the container and make all changes to the notebooks persist in `$PWD/notebooks` on Docker host, execute

`export NB_GID=$(id -g) && docker run -p 8888:8888 -v $PWD/notebooks:/opt/app/notebooks  -e NB_GID=$NB_GID -it develop`

#### Minimal container
Build and run the container image:

`docker build --target live -t live .`
`docker run live`
