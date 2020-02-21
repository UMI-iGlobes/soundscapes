# Title     : Single File Processor
# Objective : Process a single file
# Created by: Colton Flowers (UMI/iGlobes)
# Created on: 2/5/2020
source("utils.R")
TIME_INTERVAL=5
<<<<<<< HEAD
direc <-list.files("./",recursive=TRUE, pattern = "wav$")
#print(direc)
path <- direc
#print(path)
if (file.exists("output/out.csv")){
  index_data <- read.csv("output/out.csv", header = TRUE, sep = ",",stringsAsFactors=FALSE)
=======
#args = commandArgs(trailingOnly=TRUE)
args <- c("/home/colton/Music/S4A07275_20190418_111236.wav","out.csv")
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.csv"
}
path=args[1]
if (file.exists("out.csv")){
  index_data <- read.csv("out.csv", header = TRUE, sep = ";",stringsAsFactors=FALSE)
>>>>>>> d937ebb486c4766760ff97c9a350ee60913dbc1a
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
<<<<<<< HEAD
#print(ncol(index_data))
total_recordings <- nrow(index_data)
#print(total_recordings)
file.name <- tail(unlist(strsplit(path, "/")),n=1)
file.songmetername<- tail(unlist(strsplit(file.name,"_")))
len <- length(file.songmetername)
name <- paste(file.songmetername[len-2],file.songmetername[len-1],file.songmetername[len],sep="_")
sitelist <- file.songmetername[1:(len-3)]
site <- paste(sitelist[1],sitelist[2],sep="_")
print(site)
file.namedata <- songmeter(name)
=======
print(ncol(index_data))
total_recordings <- nrow(index_data)
print(total_recordings)
file.name <- tail(unlist(strsplit(path, "/")),n=1)
site <- tail(unlist(strsplit(path, "/")),n=3)[1]
print(site)
file.namedata <- songmeter(file.name)
>>>>>>> d937ebb486c4766760ff97c9a350ee60913dbc1a
year <- file.namedata[1,"year"]
month <- file.namedata[1,"month"]
day <- file.namedata[1,"day"]
hour <- file.namedata[1,"hour"]
min <- file.namedata[1,"min"]
sec <- file.namedata[1,"sec"]
date <- paste(year,month,day,sep="/")
print(date)
hdr <- readWave(path,header=TRUE)
print(path)
sr <- hdr$sample.rate
print(paste('sr: ',sr))
samples<-hdr$samples
print(paste('samples: ',samples))
duration <- samples/sr
print(paste('duration ',duration))
n_recordings <- duration%/%(TIME_INTERVAL*60)
print(paste('n_recordings: ',n_recordings))
if (duration > TIME_INTERVAL) {
  for (j in 0:(n_recordings-1)){
    total_recordings<- total_recordings +1
    print(total_recordings)
    start_min_in_file<-j*TIME_INTERVAL
    end_min_in_file<-(j+1)*TIME_INTERVAL
    overall_start_hour<- hour + ((min + start_min_in_file) %/% 60)
    overall_start_min <- (min + start_min_in_file) %% 60
    time <- paste(overall_start_hour,overall_start_min,sec,sep=":")
    sink("sink.txt",type="output")
    indices <- alpha_indices(path,start_min_in_file,end_min_in_file)
    sink()
    print(indices)
    #print(indices)
    #indices<-rep(0,10)
    print(date)
    index_data[total_recordings,] <- c(site,date,time,indices)

  }
}
print("Done!")
<<<<<<< HEAD
write.csv(index_data, file = "output/out.csv",row.names=FALSE)
=======
write.csv(index_data, file = args[2],row.names=FALSE)
>>>>>>> d937ebb486c4766760ff97c9a350ee60913dbc1a
