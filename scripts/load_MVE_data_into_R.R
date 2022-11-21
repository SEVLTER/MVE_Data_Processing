# KM Hall
# 2022
# 
# Function that is used to import MVE data into R. This file will be sources by the
# scripts that process MVE Blue, Black, and Creosote.

path_to_data_folder <- "raw_data/"


# function to read .dat files into R after downloading from GDrive
read_mve_in <- function(file_name) {
  
  # there are 4 header rows in the files. The 2nd row contains the variable names
  header <- names(read_csv(paste0(path_to_data_folder, file_name),
                           skip = 1,
                           n_max = 0))
  
  # read file into R using correct header name
  mve <- read_csv(paste0(path_to_data_folder, file_name),
                  skip = 4,
                  col_names = header)
  
  return(mve)
}




