# -------------------------------------------------------------
# INITIAL PROJECT SETUP ---------------------------------------
# -------------------------------------------------------------
# This initial setup will ensure that you have all required
# R packages installed for use with the ScyllaCharacterization
# package. If you are running this in an environment where 
# there is no access to the Internet please see the "offline
# setup guide". TODO: Provide Link!
# -------------------------------------------------------------
# -------------------------------------------------------------
install.packages("renv")

projectFolder <- "E:/ScyllaCharacterization"
setwd(projectFolder)

# Download the lock file:
download.file("https://raw.githubusercontent.com/ohdsi-studies/ScyllaCharacterization/renv.lock", "renv.lock")

# If you plan to run this in offline mode, uncomment this line
# Sys.setenv("RENV_PATHS_CACHE" = getwd())

# Build the local library:
renv::init()

# When not in RStudio, you'll need to restart R now
library(ScyllaCharacterization)

# -------------------------------------------------------------
# END Initial Project Setup
# -------------------------------------------------------------