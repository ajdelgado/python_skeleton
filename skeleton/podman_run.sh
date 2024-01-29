#!/bin/sh
podman run --mount type=bind,src=config/,target=/config -t --rm --name __project_codename__ __project_codename__
