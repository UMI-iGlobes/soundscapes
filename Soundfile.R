# Title     : Soundfile.R
# Objective : potential soundfile class; currently not used
# Created by: Biosphere
# Created on: 1/29/2020

Soundfile <- function(site=NA,date=NA,sound=NA)
{

        me <- list(
                site = site,
                date = date,
                sound = sound
       )

        ## Set the name for the class
        class(me) <- append(class(me),"Soundfile")
        return(me)
}