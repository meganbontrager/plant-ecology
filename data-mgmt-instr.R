## Data management and manipulation

# Make an Rproject for this course.
# Put this script and the .csv data files into the associated folder.

# 1. load libraries and data

# if you haven't installed these packages previously, install them first.

library(dplyr)
library(tidyr)
library(ggplot2)

## instr only
roots<-read.csv("roots-messy-reshape.csv")
roots2<-roots %>% 
  gather("species","biomass", 2:3) 
head(roots2)
##

# now, load your data
# start with 



# 2. 


# 3. 


# 4. 


# EXTRA

library(devtools)
install_github("dill/emoGG")
library(emoGG)
emoji_search("worm")


ggplot(iris,aes(x=Petal.Length, y= Petal.Width)) +
  geom_emoji(emoji = "1f41b")

