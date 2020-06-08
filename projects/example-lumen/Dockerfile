FROM trestletech/plumber
  
# install R packages required 
# (change it depending on the packages you need)
RUN R -e "install.packages('httr', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('here', repos='http://cran.rstudio.com/')"

COPY api.R /api.R

CMD ["/api.R"]
