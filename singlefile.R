# Title     : Single File Processor
# Objective : Process a single file
# Created by: Colton Flowers (UMI/iGlobes)
# Created on: 2/5/2020
source("utils.R")
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.csv"
}
path=args[1]
if (file.exists("out.csv")){
  index_data <- read.csv(index_data, header = TRUE, sep = ";",stringsAsFactors=FALSE)
} else {
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
}
total_recordings <- nrow(index_data)
file_name <- tail(unlist(strsplit(path, "/")),n=1)
site <- tail(unlist(strsplit(path, "/")),n=2)
file.namedata <- songmeter(file.name)
year <- file.namedata[i,"year"]
month <- file.namedata[i,"month"]
day <- file.namedata[i,"day"]
hour <- file.namedata[i,"hour"]
min <- file.namedata[i,"min"]
sec <- file.namedata[i,"sec"]
date <- paste(year,month,day,sep="/")
hdr <- readWave(file_path,header=TRUE)
#print(file_path)
sr <- hdr$sample.rate
#print(paste('sr: ',sr))
samples<-hdr$samples
#print(paste('samples: ',samples))
duration <- samples/sr
#print(paste('duration ',duration))
n_recordings <- duration%/%(TIME_INTERVAL*60)
if (n_recordings < TIME_INTERVAL) {
  for (j in 0:(n_recordings-1)){
    total_recordings<- total_recordings +1
    print(total_recordings)
    start_min_in_file<-j*TIME_INTERVAL
    end_min_in_file<-(j+1)*TIME_INTERVAL
    overall_start_hour<- hour + ((min + start_min_in_file) %/% 60)
    overall_start_min <- (min + start_min_in_file) %% 60
    time <- paste(overall_start_hour,overall_start_min,sec,sep=":")
    sink("sink.txt",type="output")
    indices <- alpha_indices(file_path,start_min_in_file,end_min_in_file)
    sink()
    #print(indices)
    #print(indices)
    #indices<-rep(0,10)
    index_data[total_recordings,] <- c(site,date,time,indices)
  }
}