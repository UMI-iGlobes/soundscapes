# Title     : file_processor.R
# Objective : Read WAV files from harddrive and compute features for analysis.
# Created by: Biosphere
# Created on: 1/24/2020

source("utils.R")
#install sound processing packages if not already present
#install.packages(c("signal","tuneR","seewave"))
#install.packages(c("soundecology"))
#install.packages(c("rpanel","rgl"))
library(tuneR)
library(seewave)
library(soundecology)
##provide path to data_library below:
data_library_path <- "D:\\data_library"
##get all wav file names
file.paths <-list.files(data_library_path,recursive=TRUE, pattern = "wav$")
file.names<-sapply(file.paths,function(path) {return(unlist(strsplit(path, "/"))[3])},USE.NAMES=FALSE)
file.namedata = songmeter(file.names)
#print(file.namedata)
##initalize data.frame to store indices.
index_data <- data.frame(Site=character(),
                 Date<-as.Date(character(),format="%y/%m/%d"),
                 Time<-character(),
                 bioacoustic<-double(),
                 amplitude<-double(),
                 temporal_entropy<-double(),
                 spectral_entropy<-double(),
                 acoustic_entropy<-double(),
                 acoustic_diversity<-double(),
                 acoustic_evenness<-double(),
                 acoustic_complexity<-double(),
                 nrows<-double(),
                 ndsi<-double(),
                 stringsAsFactors=FALSE)
for (i in 1:length(file.paths))
  { year <- file.namedata[i,"year"]
    month <- file.namedata[i,"month"]
    day <- file.namedata[i,"day"]
    hour <- file.namedata[i,"hour"]
    min <- file.namedata[i,"min"]
    sec <- file.namedata[i,"sec"]

    site <- unlist(strsplit(file.paths[i], "/"))[1]
    date <- paste(day,month,year,sep="-")
    time <- paste(hour,min,sec,sep=":")

    #indices <- alpha_indices(file.paths[i])
    indices <- rep(1,10)
    index_data[i,] <- c(site,date,time,indices)
    #sound = readWave(paste(data_library_path,file.names[i],sep='/'))
    #sound_files[i] <- Soundfile(site,date,sound)
}
