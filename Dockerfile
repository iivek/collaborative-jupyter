FROM ubuntu:latest AS live

USER root

RUN apt-get update && apt-get -y upgrade \
    && apt-get install -y python3.8 \
    && apt-get install -y python3-pip

COPY . /opt/app

WORKDIR /opt/app
RUN pip3 install -r requirements/live.txt

CMD python3 app.py


FROM live AS develop

# build-time:
ENV NB_USER jovyan
ENV NB_UID 1000
ENV NB_WORKDIR /opt/app/notebooks
ENV CONFIG /home/$NB_USER/.jupyter/jupyter_notebook_config.py
ENV CONFIG_IPYTHON /home/$NB_USER/.ipython/profile_default/ipython_config.py
# run-time:
ENV NB_GROUP jovyan
ENV NB_GID 1000

USER root

COPY --from=live /opt/app .
RUN chmod +x /opt/app/setup_jovyan.sh

WORKDIR /opt/app

RUN pip3 install -r requirements/develop.txt

# Jupyter user and configuration
#
RUN useradd -m -s /bin/bash -u $NB_UID $NB_USER
RUN mkdir $NB_WORKDIR \
    && chown $NB_USER:$NB_GID $NB_WORKDIR

USER $NB_USER

RUN mkdir $HOME/.jupyter
RUN jupyter notebook --generate-config --allow-root && \
    ipython profile create
# --ip 0.0.0.0 --port 8888 --no-browser --allow-root
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> ${CONFIG} && \
    echo "c.NotebookApp.port = 8888" >> ${CONFIG} && \
    echo "c.NotebookApp.open_browser = False" >> ${CONFIG} && \
    echo "c.NotebookApp.allow_root = True" >> ${CONFIG}
RUN echo "c.InteractiveShellApp.exec_lines = ['%matplotlib inline']" >> ${CONFIG_IPYTHON}
#
##\Jupyter user and configuration

USER root

# By assigning a group with the same gid as docker host to Jovyan user, Jovyan gets the same level of access as the host
# to the mounted volume as docker host.
ENTRYPOINT ["/opt/app/setup_jovyan.sh"]
CMD ["jupyter notebook"]
