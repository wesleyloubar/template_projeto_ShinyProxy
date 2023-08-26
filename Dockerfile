FROM openanalytics/r-ver:4.1.3

LABEL maintainer="Wesley L Barbosa <wesleyloubar@hotmail.com>"

# Bibliotecas/pacotes úteis para configuração do aplicativo
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

RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get -y install unzip
RUN apt-get -y update


RUN apt-get -y upgrade
RUN apt-get install apt-utils
RUN apt-get install -y wget 
# Baixa aplicação exemplo do Github
RUN wget "https://github.com/wesleyloubar/TrabalhoFinalComputacaoEmNuvem/raw/main/euler.zip"

# Descompacta e copia o conteudo para a pasta da aplicação
RUN unzip euler.zip -d /root/euler

#RUN cp app /root/app

# Bibliotecas básicas para o Shiny 
RUN R -q -e "install.packages(c('shiny', 'rmarkdown'))"

# Bibliotecas necessárias para execução do aplicativo
RUN R -q -e "install.packages('shinyalert')"

RUN  R -q -e "install.packages('shinydashboard')"

RUN  R -q -e "install.packages('plotly')"

RUN  R -q -e "install.packages('shinyjs')"

# Cria pasta para a aplicação
#RUN mkdir /root/app

#RUN apt-get -y install unzip
#RUN apt-get install -y wget 
# Baixa aplicação exemplo do Github
#RUN wget "https://github.com/wesleyloubar/TrabalhoFinalComputacaoEmNuvem/raw/main/app.zip"

# Descompacta e copia o conteudo para a pasta da aplicação
#RUN unzip app.zip -d app

#COPY app /root/app

# COPY Rprofile.site /usr/local/lib/R/etc/

EXPOSE 3838

CMD ["R", "-q", "-e", "shiny::runApp('/root/app')"]
