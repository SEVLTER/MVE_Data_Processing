# KM Hall
# 2022
#
# Downloads raw MVE files from SEV Field Station Google Drive folders
#
# User must register the googledrive R package with their gmail account
# before using the googledrive R library to download data. 
# 
#
# NOTE: This is an example script. It does not include the actual
# GDrive links. If you believe you should have access to the links
# contact Jenn Rudgers.
#
# THIS PROGRAM SHOULD NOT BE UNDER GIT CONTROL. There is an example
# script that can be published online that does not contain the GDrive
# links that we are trying to keep private.





library(googledrive)
library(curl)
library(tidyverse)
library(filesstrings)


# this is the folder where the files are initially downloaded to - it becomes the working directory
download_folder <- "/Users/kris/Documents/SEV/Projects/MVE_Reporting/raw_data/"


setwd(download_folder)




# Download  files from GoogleDrive ----------------------------------


# download met data:
paste("Downloading and Saving MVE_Blue")
drive_download("GDRIVE_LINK_TO_MVE_BLUE_HERE",
               overwrite = TRUE)

paste("Downloading and Saving MVE_Black")
drive_download("GDRIVE_LINK_TO_MVE_BLACK_HERE",
               overwrite = TRUE)

paste("Downloading and Saving MVE_Creosote")
drive_download("GDRIVE_LINK_TO_MVE_CREOSOTE_HERE",
               overwrite = TRUE)

