# Title     : Single File Processor
# Objective : Process a single file
# Created by: Colton Flowers (UMI/iGlobes)
# Created on: 2/5/2020
args = commandArgs(trailingOnly=TRUE)
#print(args[1])
source("utils.R")
list.files("data")
TIME_INTERVAL=5
#print(direc)
path <- args[1]
out <- args[2]
# test if there is at least one argument: if not, return an error
if (file.exists(out)){
  index_data <- read.csv(out, header = TRUE, sep = ";",stringsAsFactors=FALSE)

} else {
  index_data <- data.frame(Site=character(),
                 Date<-as.Date(character(),format="%Y/%m/%d"),
                 Time<-character(),
                 File<-character(),
                 Start_Time<-character(),
                 End_time<-character(),
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
#print(ncol(index_data))
total_recordings <- nrow(index_data)
#print(total_recordings)
file.name <- tail(unlist(strsplit(path, "/")),n=1)
file.songmetername<- tail(unlist(strsplit(file.name,"_")))
#print(file.songmetername)
len <- length(file.songmetername)
name <- paste(file.songmetername[len-2],file.songmetername[len-1],file.songmetername[len],sep="_")
print(name)
sitelist <- file.songmetername[1:(len-3)]
site <- paste(sitelist[1],sitelist[2],sep="_")
print(site)
file.namedata <- songmeter(name)
#print(ncol(index_data))
total_recordings <- nrow(index_data)
#print(total_recordings)
year <- file.namedata[1,"year"]
month <- file.namedata[1,"month"]
day <- file.namedata[1,"day"]
hour <- file.namedata[1,"hour"]
min <- file.namedata[1,"min"]
sec <- file.namedata[1,"sec"]
date <- paste(year,month,day,sep="/")
#print(date)
hdr <- readWave(path,header=TRUE)
#print(path)
sr <- hdr$sample.rate
#print(paste('sr: ',sr))
samples<-hdr$samples
#print(paste('samples: ',samples))
duration <- samples/sr
#print(paste('duration ',duration))
n_recordings <- duration%/%(TIME_INTERVAL*60)
#print(paste('n_recordings: ',n_recordings))
if (duration > TIME_INTERVAL) {
  for (j in 0:(n_recordings-1)){
    total_recordings<- total_recordings +1
    start_min_in_file<-j*TIME_INTERVAL
    end_min_in_file<-(j+1)*TIME_INTERVAL
    overall_start_hour<- hour + ((min + start_min_in_file) %/% 60)
    overall_start_min <- (min + start_min_in_file) %% 60
    time <- paste(overall_start_hour,overall_start_min,sec,sep=":")
    sink("sink.txt", type="output")
    indices <- alpha_indices(path,start_min_in_file,end_min_in_file)
    sink()
    print(indices)
    index_data[total_recordings,] <- c(site,date,time,file.name,start_min_in_file,end_min_in_file,indices)

  }
}
print("Done!")
write.csv(index_data, file = out,row.names=FALSE)