FROM trestletech/plumber
  
# install R packages required 
# (change it depending on the packages you need)
RUN R -e "install.packages('httr', repos='http://cran.rstudio.com/')"

COPY auth.R /auth.R

CMD ["/auth.R"]