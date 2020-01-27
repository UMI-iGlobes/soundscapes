# Title     : utils.R
# Objective : helper funtions; alpha indexer: calculates alpha indices for a given wav file and saves them to an array.
# Created by: Biosphere
# Created on: 1/27/2020
test_sound <- "D:\\data_library\\Jake\\18_07_18\\S4A07341_20180718_184801.wav"
indices <- function(x) {
  x <- readWave(x)
  return(c(bioacoustic_index(x,min_freq=500,max_freq=12000)$left_area, #bioacoustic index,left channel
           M(x), #amplitude index
           th(env(x,plot=FALSE)), #temporal entropy index
           sh(meanspec(x,plot=FALSE)), #spectral entropy index
           H(x),#spectral entropy index
           acoustic_diversity(x)$adi_left#accoustic diversity,left channel
  ))
}
##take start time to calculate running time for alpha index collection on one sound
start_time <- Sys.time()
print(indices(test_sound))
end_time = Sys.time()
print(end_time - start_time)