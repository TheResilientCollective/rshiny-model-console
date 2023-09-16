
<!-- README.md is generated from README.Rmd. Please edit that file -->

# RShiney dashboards for Resilient Games

<!-- badges: start -->
<!-- badges: end -->

This package defines four interconnected shiny apps for running web
based Resilient Community Games. The applications are designed to enable
a subset of users (interpreters) to view, edit, and run a community
model while other users (players) view the status of model state and
timely “news” media curated by the interpreters.

## Installation

To install the development version:

``` r
# install.packages("devtools")
devtools::install_github("center4health/resilient-games")
```

## Shiny Apps

We define four applications for viewing or manipulating state of a
common model. Users are identified as either game interpreters, who have
read/write access to game data, or game players, who have read only
access. The intent is for the apps to be run together, operating with a
common model, whose state is contained in a single xml file. Here is a
quick rundown of the apps, more detailed descriptions below.

- `status`
  - a single non-interactive view which shows vital details for players
- `newsfeed`
  - a single non-interactive view of game updates and related media
- `player`
  - a combined view with the content of both *status* and *newsfeed*
- `controller`
  - an interactive view for game interpreters to control the game state

## Status Application

This passive application simply reflects the current state of the shared
model. It is a single view with cards containing simple statistics.
State is maintained by monitoring an RDS file and reading the contents
on change.

## Newsfeed Application

Another read only application which displays content designed by the
interpreters to enhance the game experience and convey extra
information. Content is again maintained by monitoring changes in an RDS
file.

## Player Application

A combined view containing status and newsfeed for situations where both
are to be displayed together (e.g., players are viewing the game on
single screen, or individual laptop).

## Control Application

This is the complex, interactive application which allows interpreters
to modify and advance game state, preview the results, and publish
changes for consumption by the other applications.

The control view is made up of the following functional tabs: - model -
upload model file - edit model parameters - advance model state - undo
or rollback? - visualize outputs - download: fetch full model file with
current state including - parameter changes - simulation state -
newsfeed editor - add and modify content - contains a panel which shows
preview of newsfeed as seen by players - publish (this writes current
content to the RDS file) - status view - show current version based on
state in model editor - indicate whether the state has been published or
not - button to publish (write to shared RDS file)

## Docker and proxy

We use ShinyProxy to provide an authentication layer and serve the apps
within a docker network. This is for deployment and deployment testing
only. For shiny development, just run locally in R, or use RStudio,
which has it’s own single-page browser. Here we describe the docker
infrastructure from the ground up:

- `resilient-apps` is a docker image defined by `./Dockerfile`
  containing the shiny apps exposed on port 3838
- `resilient-proxy` is a docker image defined by
  `inst/serve/proxy/Dockerfile` and `inst/serve/proxy/application.yml`
  which
  - runs the proxy server
  - handles authentication and access permissions
  - serves the shiny apps by spinning up containers from
    `resilient-apps`, one container per app
- `./compose.yml` creates a network and spins up the resilient proxy
  container
  - the user in the proxy container needs access to /var/run/docker.sock
    for creating images
  - this is set from the DOCKERGRP env variable, which can be set on the
    command line

### 
###  Service Deployment:  
#### CI and Github actions
 containers for resilientucsd/resilient-games-proxy and resilientucsd/resilient-games-app
 are created using github actions.
If you are running on a non-main branch, edit .github/workflows/resilient*.yml and add the branch.


#### Configuring and Running
* copy the example.env to rshiny.env
  * this is fixed on the compose file, for now.
* edit PROXY in env, and set passwords, 
    * if OSX, then set `SHINYPROXY_DOCKER_PROXY=http://host.docker.internal:2375`
    * if other, then set `SHINYPROXY_DOCKER_PROXY=unix:///var/run/docker.sock`
           see https://gist.github.com/styblope/dc55e0ad2a9848f2cc3307d4819d819f`
      * (localhost from a container is localhost)
      * you need to set DOCKERGRP= (some number)
          * `getent group docker | cut -d: -f3`
      * valume needs to be mapped into the container as a volume 
  ```yaml
  volumes:
      - /var/run/docker.sock:/var/run/docker.sock
  ``` 

### command to run just the rshiny
`docker compose --env-file rshiny.env -f rshiny_compose_deploy.yaml up`

Command to run (tested on ubuntu):
`sudo DOCKERGRP=$(getent group docker | cut -d: -f3) docker compose --env-file rshiny.env  -f inst/serve/compose.yml up`

### Development mode on osx

To run this on a mac some changes have to be made: - add
`url: http://host.docker.internal:2375` under `proxy.docker` in
application.yml - build the proxy image - NOTE: this is pre-built at
rishig32/resilient-proxy-osx - will have to be rebuilt for any changes
to the proxy application.yml -
`sudo docker build . -t rishig32/resilient-proxy-osx` in that dir after
adding the url - run with
`sudo docker compose -f inst/serve/compose.yml -f inst/serve/compose-osx.yml up` -
NOTE: `DOCKERGRP` not required, but will raise a warning
