FROM trestletech/plumber@sha256:3a7c6486fa5efe16a017c01593d058a5349f2f074ddeddb8abf2c1a34138d809
  
# install R packages required 
# (change it depending on the packages you need)
RUN R -e "install.packages('here', repos='http://cran.rstudio.com/')"

COPY data /data
COPY api.R /api.R

CMD ["/api.R"]
