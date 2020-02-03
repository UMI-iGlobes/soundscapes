# Title     : utils.R
# Objective : helper funtions; alpha indexer: calculates alpha indices for a given wav file and saves them to an array.;write_to_log: write error handling information to a log.
# Created by: Colton Flowers (UMI/iGlobes
# Created on: 1/27/2020
library(tuneR)
library(seewave)
library(soundecology)
alpha_indices <- function(x) {
  ##computes alpha_indices for a given filename corresponding to a wav_file and then returns these indices in a vector.
  x <- readWave(x)
  x <- mono(x,which='left')
  ms <- meanspec(x,plot=FALSE)
  ba <- bioacoustic_index(x,min_freq=500,max_freq=12000) #bioacoustic index;left channel:asseses relative avian abundance, area under curve between 2000 and 8000
  print("bioacoustic index calculated")
  amp <- M(x) #amplitude index
  print("amplitude index calculated")
  te <- th(env(x,plot=FALSE)) #temporal entropy index:shannon evenness of amplitude envelope
  print("temporal entropy calculated")
  se <- sh(ms) #spectral entropy index:shannon evenness of frequency spectrum
  print("spectral entropy calculated")
  ae <- H(x)#acoustic entropy index
  print("acoustic entropy calculated")
  ad <- acoustic_diversity(x)#acoustic diversity:left channel
  print("acoustic diversity calculated")
  aeve <- acoustic_evenness(x)#acoustic evenness;left channel:
  print("acoustic evenness calculated")
  ac <- ACI(x)#acoustic complexity index:gives more importance to sounds that are modulated in amplitude
  print("acoustic complexity calculated")
  nr <- nrow(fpeaks(ms,amp=c(0.04,0.04),plot=FALSE))#number of frequency peaks: estimate of diversity of sound
  print("number of frequency peaks calculated")
  ndsi <- NDSI(soundscapespec(x,plot=FALSE))#normalized difference soundscape index:estimates level of anthropogenic disturbance
  print("ndsi calculated")
  return(c(ba,amp,te,se,ae,ad,aeve,ac,nr,ndsi))
}
##take start time to calculate running time for alpha index collection on one sound
#print("Calculating indices...")
#start_time <- Sys.time()
#print(alpha_indices(test_sound))
#end_time = Sys.time()
#print("Done")
#print(end_time - start_time)
write_to_log_file <- function(message_to_be_written,logger_level=NA) {
  entry<-paste("Logger Level: ",logger_level," Message: ",message_to_be_written," Date: ",Sys.Date()," Time: ",Sys.time())
  write(entry,LOG_FILE,append= TRUE)
}
