FROM rocker/shiny:3.6.3

# Install linux dependencies
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libssl-dev

RUN Rscript -e "install.packages('remotes')"

WORKDIR /srv/shiny-server/shiny-santa

COPY DESCRIPTION /srv/shiny-server/shiny-santa/DESCRIPTION

RUN Rscript -e "remotes::install_deps()"

COPY . /srv/shiny-server/shiny-santa

RUN chmod -R 777 /srv/shiny-server/shiny-santa
