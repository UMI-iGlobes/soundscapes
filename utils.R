# Title     : utils.R
# Objective : helper funtions; alpha indexer: calculates alpha indices for a given wav file and saves them to an array.
# Created by: Biosphere
# Created on: 1/27/2020
test_sound <- "D:\\data_library\\Jake\\18_07_18\\S4A07341_20180718_184801.wav"
alpha_indices <- function(x) {
  ##computes alpha_indices for a given filename corresponding to a wav_file and then returns these indices in a vector.
  x <- readWave(x)
  ms <- meanspec(x,plot=FALSE)
  return(c(bioacoustic_index(x,min_freq=500,max_freq=12000)$left_area, #bioacoustic index;left channel:asseses relative avian abundance, area under curve between 2000 and 8000
           M(x), #amplitude index
           th(env(x,plot=FALSE)), #temporal entropy index:shannon evenness of amplitude envelope
           sh(ms), #spectral entropy index:shannon evenness of frequency spectrum
           H(x),#acoustic entropy index
           acoustic_diversity(x)$adi_left,#acoustic diversity:left channel
           acoustic_evenness(x)$aei_left,#acoustic evenness;left channel:
           ACI(x),#acoustic complexity index:gives more importance to sounds that are modulated in amplitude
           nrow(fpeaks(ms,amp=c(0.04,0.04),plot=FALSE)),#number of frequency peaks: estimate of diversity of sound
           NDSI(soundscapespec(x,plot=FALSE))#normalized difference soundscape index:estimates level of anthropogenic disturbance
  ))
}
##take start time to calculate running time for alpha index collection on one sound
#print("Calculating indices...")
#start_time <- Sys.time()
#print(alpha_indices(test_sound))
#end_time = Sys.time()
#print("Done")
#print(end_time - start_time)