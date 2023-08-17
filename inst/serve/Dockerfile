#
# Dockerfile to run shiny shiny-server
#
# Using rocker/shiny-verse image because there is a lot of useful stuff already
# loaded.  NOTE: this is a heavyweight solution, but we only need to run this
# in one location, it's not designed for maximal portability.  To do that, we
# could use rocker/shiny and explicitly list minimal required R packages.
# 

# get shiny server and R from the rocker project
FROM rocker/shiny-verse:4.3.1

# system libraries
RUN apt-get update && apt-get install -y libxml2-dev less

ADD . /srv/resilient-games
WORKDIR /srv/resilient-games

# copy files into the image
COPY ./inst/serve/shiny-server.conf /etc/shiny-server/shiny-server.conf

RUN installGithub.r TheResilientCollective/Resilient-readsdr@constant-modifier

# NOTE: this has to run in the resilient-games directory (needs ./DESCRIPTION)
RUN install2.r --error remotes
RUN Rscript -e "remotes::install_deps()"


RUN R -e "install.packages('/srv/resilient-games', repos=NULL, type='source')"
RUN mkdir /srv/resilient-games/output
RUN chown shiny:shiny /srv/resilient-games/output

# run app
CMD ["/usr/bin/shiny-server"]
