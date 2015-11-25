**NOTE: This only works with a docker registry v1!!!**

# Objective

Find tags in a Docker Registry that reference a given image ID.

# Prerequisites

You need to have the [`jq`](http://stedolan.github.io/jq/) binary in your `PATH`. On Ubuntu simply run `sudo apt-get install jq`.

#Usage

    docker-find-image-users.sh IMAGE_ID [REGISTRY_HOST_WITH_PORT [REPO [REPO ...]]]]

This program searches the given Docker registry in either all
repos or the ones that are given that to find the tags that
reference the given `IMAGE_ID`.

If no registry host is given `www.YOUR_DEFAULT_REGISTRY_HOST.com` is used.

By default informational output is output to `stderr`. If you don't
want to see it, simply append `2>/dev/null` to your call and only the
tags that reference the given `IMAGE_ID` will be printed.

**NOTE: Currently this program only works with Docker Registry API v1.**

Source: https://github.com/kwk/docker-find-image-users
