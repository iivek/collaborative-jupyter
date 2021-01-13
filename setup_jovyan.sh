#!/bin/bash

groupmod -g $NB_GID -o $NB_GROUP
usermod -a -G $NB_GROUP $NB_USER

su $NB_USER --command "$@"