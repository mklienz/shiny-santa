FROM rocker/r-ver:3.6.3

# Install linux dependencies
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  gdebi-core \
  pandoc \
  pandoc-citeproc \
  libcurl4-gnutls-dev \
  libcairo2-dev \
  libxt-dev \
  xtail \
  wget \
  libssl-dev

RUN Rscript -e "install.packages('remotes')"

WORKDIR /app

COPY DESCRIPTION /app/DESCRIPTION

RUN Rscript -e "remotes::install_deps()"

COPY . /app

RUN chmod -R 777 /app

EXPOSE 3838

RUN useradd shiny-user
USER shiny-user

CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]
