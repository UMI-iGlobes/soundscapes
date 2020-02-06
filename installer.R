# Title     : installer.R
# Objective : installs all necessary packages for sound processing. Needed for HPC computing/creating a dockerfile.
# Created by: cflow
# Created on: 2/6/2020

install.packages(c("signal","tuneR","seewave"))
install.packages(c("soundecology"))
install.packages(c("rpanel","rgl"))