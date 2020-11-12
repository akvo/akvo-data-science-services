FROM trestletech/plumber@sha256:3a7c6486fa5efe16a017c01593d058a5349f2f074ddeddb8abf2c1a34138d809
  
# install R packages required 
# (change it depending on the packages you need)
RUN R -e "\
install.packages('httr', repos='http://cran.rstudio.com/'); \ 
install.packages('here', repos='http://cran.rstudio.com/'); \ 
install.packages('readr', repos='http://cran.rstudio.com/'); \
install.packages('jsonlite', repos='http://cran.rstudio.com/'); \
install.packages('dplyr', repos='http://cran.rstudio.com/'); \
install.packages('tidyr', repos='http://cran.rstudio.com/'); \
install.packages('reshape2', repos='http://cran.rstudio.com/');"

COPY api.R /api.R

CMD ["/api.R"]
