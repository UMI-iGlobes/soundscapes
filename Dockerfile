FROM rocker/r-ver:3.6.2

RUN mkdir -p /data
RUN mkdir -p /output

COPY file.sh file.sh
COPY singlefile.R singlefile.R
COPY utils.R utils.R
COPY installer.R installer.R

RUN Rscript installer.R
ENTRYPOINT ["/file.sh"]

