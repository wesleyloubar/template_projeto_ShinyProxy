FROM openanalytics/r-ver:4.1.3

LABEL maintainer="Wesley L Barbosa <wesleyloubar@hotmail.com>"

# Pacotes do sistema 
RUN apt-get update && apt-get install --no-install-recommends -y \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

# Pacotes para a instalação e construção das bibliotecas R
RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

# Biblioteca Shiny
RUN R -q -e "install.packages(c('shiny', 'rmarkdown'))"

# Bibliotecas R necessárias para rodar o aplicativo
RUN R -q -e "install.packages('Rmpfr')"
RUN R -q -e "install.packages('shinyalert')"
RUN R -q -e "install.packages('shinydashboard')"
RUN R -q -e "install.packages('shinyjs')"
RUN R -q -e "install.packages('plotly')"
RUN R -q -e "install.packages('bslib', dependencies = TRUE)"
RUN R -q -e "install.packages('dplyr')"
RUN R -q -e "install.packages('ggplot2')"
RUN R -q -e "install.packages('ggExtra')"


# Copia o aplicativo para a imagem
RUN mkdir /root/euler
COPY euler /root/euler

COPY Rprofile.site /usr/local/lib/R/etc/

EXPOSE 3838

CMD ["R", "-q", "-e", "shiny::runApp('/root/euler')"]
