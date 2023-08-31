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
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Pacotes para a instalação e construção das bibliotecas R
RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

# Biblioteca Shiny
RUN R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"

# Bibliotecas R necessárias para rodar o aplicativo
#RUN R -e "my_packages = c('rmarkdown', 'Rmpfr','bslib','dplyr', 'ggplot2', 'ggExtra', 'shinyalert', 
#'shinydashboard', 'plotly', 'shinyjs') 
#install_if_missing = function(p) { if (p %in% rownames(installed.packages()) == FALSE) 
#{ i#nstall.packages(p, dependencies = TRUE) } else 
#{ cat(paste('Skipping already installed package:', p, '\n')) } } 
#sapply(my_packages, install_if_missing)"

RUN R -e "install.packages('rmarkdown', repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages('Rmpfr', repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages('bslib', repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages('dplyr', repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages('ggExtra', repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages('shinyalert', repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages('shinydashboard', repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages('plotly', repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages('shinyjs', repos='http://cran.rstudio.com/', dependencies = TRUE)"



# Copia o aplicativo para a imagem
RUN mkdir /root/euler
COPY euler /root/euler

COPY Rprofile.site /usr/local/lib/R/etc/

EXPOSE 3838

CMD ["R", "-q", "-e", "shiny::runApp('/root/euler')"]
