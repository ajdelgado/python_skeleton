#!/bin/sh
podman run --mount type=bind,src=config/,target=/config -t --rm --name discovery-mastodon-servers discovery-mastodon-servers
