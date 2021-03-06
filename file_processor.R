# Title     : file_processor.R
# Objective : Read WAV files from harddrive and compute features for analysis.
# Created by: Colton Flowers (UMI/iGlobes)
# Created on: 1/24/2020
CHECKMARK<-50
TIME_INTERVAL<- 5
##time interval to calculate indices in minutes. WARNING: if the duration of a file is not divisible by TIME_INTERVAL, the last interval of the file will not be calculated.
WRITE_TO_FILE_PATH<-paste("/media/colton/My Passport/jake_lockdown","_ti=",TIME_INTERVAL,".csv",sep="")
WRITE_TO_ERROR_FILE_PATH<-paste("/media/colton/My Passport/jake_lockdown_data_errors.txt","_ti=",TIME_INTERVAL,".csv",sep="")
DATA_LIBRARY_PATH<- "/media/colton/My Passport/jake_lockdown_data"
LOG_FILE<-"/media/colton/My Passport/data_library/log_file.txt"
source("utils.R")
#install sound processing packages if not already present
#install.packages(c("signal","tuneR","seewave"))
#install.packages(c("soundecology"))
#install.packages(c("rpanel","rgl"))
##provide path to data_library below:
##get all wav file names
file.paths <-list.files(DATA_LIBRARY_PATH,recursive=TRUE, pattern = "wav$")
print(file.paths)
file.names<-sapply(file.paths,function(path) {return(tail(unlist(strsplit(path, "/")),n=1))},USE.NAMES=FALSE)
file.namedata <- songmeter(file.names)
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
print("Running...")
total_recordings <- 0
error_cases <- data.frame(Site=character(),
                          Date=character(),
                          Time=character()
)
length_dic= {}
for (i in 1:length(file.paths)){
  start_time <- Sys.time()
  ###tryCatch used so that preprocessing continues even if an error/warning is thrown at a single(possibly several) iterations.
  { tryCatch({
    year <- file.namedata[i,"year"]
    month <- file.namedata[i,"month"]
    day <- file.namedata[i,"day"]
    hour <- file.namedata[i,"hour"]
    min <- file.namedata[i,"min"]
    sec <- file.namedata[i,"sec"]
    site <- unlist(strsplit(file.paths[i], "/"))[1]
    date <- paste(year,month,day,sep="/")
    file_path<- paste(DATA_LIBRARY_PATH,file.paths[i],sep="/")
    hdr <- readWave(file_path,header=TRUE)
    #print(file_path)
    sr <- hdr$sample.rate
    #print(paste('sr: ',sr))
    samples<-hdr$samples
    #print(paste('samples: ',samples))
    duration <- samples/sr
    #print(paste('duration ',duration))
    n_recordings <- duration%/%(TIME_INTERVAL*60)

    #if (n_recordings < TIME_INTERVAL) next
    for (j in 0:(n_recordings-1)){
      total_recordings<- total_recordings +1
      print(total_recordings)
      start_min_in_file<-j*TIME_INTERVAL
      end_min_in_file<-(j+1)*TIME_INTERVAL
      overall_start_hour<- hour + ((min + start_min_in_file) %/% 60)
      overall_start_min <- (min + start_min_in_file) %% 60
      time <- paste(overall_start_hour,overall_start_min,sec,sep=":")
      sink("/media/colton/My Passport/data_library/sink.txt",type="output")
      indices <- alpha_indices(file_path,start_min_in_file,end_min_in_file)
      sink()
      #print(indices)
      #print(indices)
      #indices<-rep(0,10)
      index_data[total_recordings,] <- c(site,date,time,indices)
       }
    if (i %% CHECKMARK == 0) {
    ##checkmarks the preprocessing by flushing already-processed data to a csv file.
      write.csv(index_data, file = WRITE_TO_FILE_PATH, row.names=FALSE)
      print(paste("CHECKMARKED @ ",i,"/",length(file.paths)))
    }
    },error=function(e){
      message("Caught an error at iteration: ",i," site:",site," date:",date," time:",time)
      print(e)
      write_to_log_file(paste(e," @ iteration",i),logger_level="ERR")
      error_cases[total_recordings,] <- c(site,date,time)

    },warning = function(w){
      message('Caught a warning at iteration: ',i," site:",site," date:",date," time:",time)
      print(w)
      write_to_log_file(paste(w," @ iteration",i), logger_level = "WARN")
      error_cases[total_recordings,] <- c(site,date,time)
    })

}
end_time = Sys.time()
print(i)
print(start_time-end_time)
}
print("Writing to CSV...")
write.csv(index_data, file = WRITE_TO_FILE_PATH,row.names=FALSE)
write.csv(error_cases,file= WRITE_TO_ERROR_FILE_PATH,row.names=FALSE)
print("Done!")