# Title     : file_processor.R
# Objective : Read WAV files from harddrive and compute features for analysis.
# Created by: Biosphere
# Created on: 1/24/2020

#install sound processing packages if not already present
#install.packages(c("signal","tuneR","seewave"))
#install.packages(c("soundecology"))
#install.packages(c("rpanel","rgl"))
library(tuneR)
library(seewave)
library(soundecology)
##creates class corresponding to a sound file from data library
Soundfile <- function(site=NA,date=NA,sound=NA)
{

        me <- list(
                site = site,
                date = date,
                sound = sound
       )

        ## Set the name for the class
        class(me) <- append(class(me),"Soundfile")
        return(me)
}
##provide path to data_library below:
data_library_path <- "D:\\data_library"
##get all wav file names
file.names <-list.files(data_library_path,recursive=TRUE, pattern = "wav$")
##initalize vector to store Soundfile objects
sound_files <- rep(NA,length(file.names))
for (i in 1:length(file.names))
  {
    site = unlist(strsplit(file.names[i], "/"))[1]
    date = unlist(strsplit(file.names[i], "/"))[2]
    print(site)
    print(date)
    #sound = readWave(paste(data_library_path,file.names[i],sep='/'))
    #sound_files[i] <- Soundfile(site,date,sound)
}

