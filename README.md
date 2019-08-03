# dependency-check
Dependency-check custom Dockerfile

## Introduction

This is a refactor of the official Dockerfile to ensure the host user and the container user use the same UID, so that mounted volumes are owned by the host user.

To do so, we use a custom entrypoint that creates a new user at runtime matching the host user UID, and then we `gosu` to that user.

## Usage

To ensure the container user will have the same UID as the host user, we provide the host user UID to docker as environment variable.


```
docker run \
    --rm 
    --volume $(pwd):/src \
    --volume ~/.depcheck/data:/usr/share/dependency-check/data \
    --volume ~/.depcheck/report:/report \
    -e uid=$UID \
    donhector/depcheck \
    /usr/share/dependency-check/bin/dependency-check.sh \
        --scan /src \
        --format HTML \
        --project "MyProject" \
        --out /report \
        --log /report/scan.log
```
