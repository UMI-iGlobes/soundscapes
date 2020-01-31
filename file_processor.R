# Title     : file_processor.R
# Objective : Read WAV files from harddrive and compute features for analysis.
# Created by: Biosphere
# Created on: 1/24/2020
CHECKMARK<-50
WRITE_TO_FILE_PATH<-"D:\\data_library\\index_data.csv"
DATA_LIBRARY_PATH<- "D:\\data_library"
source("utils.R")
#install sound processing packages if not already present
#install.packages(c("signal","tuneR","seewave"))
#install.packages(c("soundecology"))
#install.packages(c("rpanel","rgl"))
library(tuneR)
library(seewave)
library(soundecology)
##provide path to data_library below:

##get all wav file names
file.paths <-list.files(DATA_LIBRARY_PATH,recursive=TRUE, pattern = "wav$")
file.names<-sapply(file.paths,function(path) {return(unlist(strsplit(path, "/"))[3])},USE.NAMES=FALSE)
file.namedata = songmeter(file.names)
#print(file.namedata)
##initalize data.frame to store indices.
index_data <- data.frame(Site=character(),
                 Date<-as.Date(character(),format="%Y/%m/%d"),
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
  { tryCatch({
    year <- file.namedata[i,"year"]
    month <- file.namedata[i,"month"]
    day <- file.namedata[i,"day"]
    hour <- file.namedata[i,"hour"]
    min <- file.namedata[i,"min"]
    sec <- file.namedata[i,"sec"]

    site <- unlist(strsplit(file.paths[i], "/"))[1]
    date <- paste(year,month,day,sep="/")
    time <- paste(hour,min,sec,sep=":")

    indices <- alpha_indices(file.paths[i])
    index_data[i,] <- c(site,date,time,indices)
    if (i %% 50 == 0) {
    write.csv(index_data, file = WRITE_TO_FILE_PATH, row.names=FALSE)
    print(paste("CHECKMARKED @ ",i,"/",length(file.paths)))
    }
    }
    , error=function(e){
      message("Caught an error at iteration: ",i," site:",site," date:",date," time:",time)
      print(e)
      write_to_log_file(e,logger_Level="ERR")
    }
    , warning = function(w){
      message('Caught a warning at iteration: ',i," site:",site," date:",date," time:",time)
      print(w)
      write_to_log_file(w, logger_level = "WARN")
    }
)
}
write.csv(index_data, file = WRITE_TO_FILE_PATH, row.names=FALSE)
