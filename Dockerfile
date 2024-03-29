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
  libssl-dev \
  libpq-dev

RUN Rscript -e "install.packages('remotes')"

WORKDIR /app

COPY ./shiny-santa/DESCRIPTION /app/DESCRIPTION

RUN Rscript -e "remotes::install_deps()"
RUN Rscript -e "install.packages('shinymanager', repos='https://mran.microsoft.com/snapshot/2020-08-31')"

COPY ./shiny-santa /app

RUN chmod -R 777 /app

ENV PORT=3838
EXPOSE $PORT

RUN useradd shiny-user
USER shiny-user

CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = as.numeric(Sys.getenv('PORT')))"]
