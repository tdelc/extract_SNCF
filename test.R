# install.packages(c("RSelenium","Rcpp","doBy","rje","sampling","googlesheets","RCurl","tibble"))
# 
# devtools::install_github("ropensci/RSelenium")
# 
# devtools::install_version("binman", version = "0.1.0", repos = "https://cran.uni-muenster.de/")
# devtools::install_version("wdman", version = "0.2.2", repos = "https://cran.uni-muenster.de/")
# devtools::install_version("RSelenium", version = "1.7.1", repos = "https://cran.uni-muenster.de/")

require(RSelenium)
require(Rcpp)
require(doBy)
require(rje)
require(googlesheets)
require(RCurl)
require(tibble)

# setwd("C:/Users/Thomas.Delclite/Documents/SNCF")
setwd("C:/Users/Thomas.Delclite/Documents/GitHub/extract_SNCF")

load('tableau_recherche')

###
# Liens avec Google Drive
###

token <- gs_auth()
saveRDS(token,file='google_token')

# token <- readRDS('google_token')
# try(gs_auth(token),silent=TRUE)

###
# Boucle
###

source('functonSNCF.R')

boucleSNCF(100)


