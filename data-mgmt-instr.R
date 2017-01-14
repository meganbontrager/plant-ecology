## PLANT ECOLOGY (BIOL406): Data management and manipulation

# in the following excercises, we'll recreate some of the figures from:
# Cameron EK, Cahill JF Jr, Bayne EM (2014) Root Foraging Influences Plant Growth Responses 
# to Earthworm Foraging. PLoS ONE 9(9): e108873. doi:10.1371/journal.pone.0108873

# keyboard shortcuts
# shift+command+C -> make a line a comment
# shift+command+M -> make a pipe
# shift+enter -> runs highlighted code


# 1. TIDYING EXERCISE -----------------------------------------------------

# make an Rproject for this course.
# you'll start by tidying in Excel, then I'll show you how to import the data into R. 
# put this script and the data files I've given you into the associated folder.

## instructor notes
# once they have looked at their data a bit, show them how to import into R 
# and use summary to see if values are in the expected ranges (see next section)

# KEY to data fixes 
# root-void-occurence
# - grid id 6o -> 60
# - ACHMILL -> ACHMIL
# - 11030 -> 1103
# - correct uninformative notes
# - root = 11 -> root = 1
# - worms ?? -> worms NA
# 
# plant-biomass
# - separate metadata from data
# - remove extra header
# - remove notes that are in value boxes
# - standardize NAs

# root-death
# - dead -> 1
# - names correction
## end



# 2. LOADING AND INSTALLING LIBRARIES AND DATA ----------------------------

# if you haven't installed tidyverse packages previously, install it first.

install.packages("tidyverse")
library(tidyverse)

## instructor only

library(devtools)
# install_github("dill/emoGG")
library(emoGG)

##end

# now, load your data
# start with your .csv file (from Excel, "Save as", you can only save one sheet per file)

mydata <- read.csv("[insert your file name].csv")

# you can use the summary() command to see if your data falls into expected ranges
# factors will have the levels listed, and the number of observations of each level
# columns containing numeric values will have minimum, maximum, etc. listed

summary(mydata)

# anomalies can be addressed by returning to the .csv file in excel (don't forget to reload it into R after modifying!)
# or (once you're more proficient in R) data problems will be corrected in your code.

# for now, so that we're all on the same page, we'll load the tidy data that I've given you.

rootvoids <- read.csv("roots-tidy/root-void-occurrence.csv")

# check out these data frames. do they look as expected?

summary(rootvoids)



# 3. CAMERON ET AL. FIGURE 2 ----------------------------------------------

# let's recreate figure 2, and examine how roots occupied different void types over time.

# what does the plot we want to make look like?

# plot type = line
# x-axis = day
# y-axis = proportion occupied by roots
# grouping = voidtype and species

# first, we should create separate data frames for the 2 species.
# we can do this with the filter() function

am_rootvoids <- rootvoids %>% 
  filter(species == "ACHMIL")

summary(am_rootvoids)

cr_rootvoids <- rootvoids %>% 
  filter(species == "CAMROT")

summary(cr_rootvoids)

# now, we want to plot the proportion of each voidtype on each day that are colonized by roots
# one way of doing this is to make a table calculating these means (don't worry about the error bars for now)

cr_rootvoids_means <- cr_rootvoids %>% 
  group_by(voidtype,day) %>% 
  summarize(prop_root = mean(root))

# does this table look okay?

head(cr_rootvoids_means)

# is it the expected size?

dim(cr_rootvoids_means)

# now make a plot

ggplot(cr_rootvoids_means,aes(x = day, y = prop_root, color = voidtype)) +
  geom_point() +
  geom_path() +
  labs(title = "Campanula rotundifolia root colonization of voids", x = "Time (days)", y = "Proportion of voids colonized") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_discrete(name = "Void type")

# now generate a plot for the Achillea data

am_rootvoids_means <- am_rootvoids %>% 
  group_by(voidtype,day) %>% 
  summarize(prop_root = mean(root))

# does this table look okay?

head(am_rootvoids_means)

# is it the expected size?

dim(am_rootvoids_means)

# now make a plot

ggplot(am_rootvoids_means,aes(x = day, y = prop_root, color = voidtype)) +
  geom_point() +
  geom_path() +
  labs(title = "Achillea millefolium root colonization of voids", x = "Time (days)", y = "Proportion of voids colonized") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_discrete(name = "Void type")

# you can save your plot with the export option near the plot tab.

# NOT REQUIRED
# extra challenges for figure 2 (these are advanced, but if you're bored with the main exercises you can give them a try):
# 1. create a multipanel plot from the dataframe that contains both species
# 2. create a plot from your full data frame, without separately calculating averages
# 3. add error bars to your plots
# 4. extend the lines to begin at 0,0 as in the paper's plots

## instr only

# one possible solution

rootvoids$species <- factor(rootvoids$species, labels = c("Achillea millefolium", "Campanula rotundifolia"))

origins <- rootvoids %>% 
  group_by(voidtype,species) %>% 
  sample_n(1)

origins$day<-c(0,0,0,0,0,0)
origins$root<-c(0,0,0,0,0,0)

head(origins)

rootvoids_origins <- bind_rows(rootvoids, origins)

# this summary table is just to facilitate adding emojis

rootvoids_means <- rootvoids %>% 
  group_by(voidtype,day,species) %>% 
  summarize(prop_root = mean(root))

ggplot(data = rootvoids_origins, aes(x = day, y = root, color = voidtype)) +
  geom_point(stat = "summary", fun.y = "mean") +
  add_emoji(emoji = "1f41b") +
  geom_path(stat = "summary", fun.y = "mean") +
  stat_summary(fun.data = "mean_cl_normal", width = 5, geom = "errorbar") +
  xlim(0,105) + 
  expand_limits(y=0) +
  facet_grid(. ~ species, labeller = ) +
  scale_color_discrete(name = "Void type") +
  labs(title = "Root colonization of voids", x = "Time (days)", y = "Proportion of voids colonized") +
  theme(plot.title = element_text(hjust = 0.5), strip.text = element_text(face = "italic")) +
  # geom_emoji(emoji = "1f41b", data = rootvoids_means, aes(x = day, y = prop_root)) 

# note that the error bars on their plot are smaller because these are just based on a normal distribution

## end



# 4. CAMERON ET AL. FIGURE 3 ----------------------------------------------

# what does the plot we want to make look like?

# plot type = bar
# x-axis = type of void
# y-axis = proportion of cells with roots dying
# grouping = species (could also be considered an x-axis variable)

# load the data
rootdeath <- read.csv("roots-tidy/root-death.csv")

# check it out
summary(rootdeath)

# if we want the bars to be in the same order as in the paper:
rootdeath$voidtype = factor(rootdeath$voidtype,levels(rootdeath$voidtype)[c(3,2,1)])

# if we want the full names of species included
rootdeath$species <- factor(rootdeath$species, labels = c("Achillea millefolium", "Campanula rotundifolia"))

# make the plot
# this time, both plant species are on a single plot

ggplot(data = rootdeath, aes(x = voidtype, y = dead, fill = species)) +
  geom_bar(stat = "summary", fun.data = "mean_se", position = "dodge") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", position = position_dodge(width = 0.9), width = 0.2) +
  labs(title = "Root death", x = "Plant species and void type", y = "Proportion of cells with roots dying") +
  theme(plot.title = element_text(hjust = 0.5), strip.text = element_text(face = "italic")) +
  # scale_fill_discrete(guide = FALSE) +
  scale_fill_discrete(name = "Plant species") +
  # facet_grid(. ~ species)


# 5. CAMERON ET AL. FIGURE 4 ----------------------------------------------

# now, on your own, recreate Cameron et al. figure 4. 
# plant biomass data is in "roots-tidy/plant-biomass.csv"
# to prepare the original data for this exercise, I had to reshape it. I'll show you how if there's time.
# it's okay if your plot is slightly different in style or format from the plot in the paper, but keep
# the same groups and y-axis

## instr only
# plant-biomass reshape
  
plants_wide <- read.csv("roots-tidy/plant-biomass-wide.csv")
  
head(plants_wide)

# note that root and shoot biomass are in separate columns. but on our graph we want to have them side-
# by-side on the same axis, so we want to put them in the same column, and add an additional column 
# that indicates whether each row contains root or shoot data

# to make our dataframe narrower and taller, we'll use gather()
# we'll get rid of initial leaf length in this frame, or else it would be duplicated

plants <- plants_wide %>% 
  select(-initialleaflength) %>% 
  gather("biomass_type","biomass",5:6)

# make biomass_type a factor
plants$biomass_type <- as.factor(plants$biomass_type)
summary(plants)

# let's make those names better
plants$biomass_type <- factor(plants$biomass_type, labels = c("Root", "Shoot"))

# and write the table out as a .csv
write.csv(plants,"roots-tidy/plant-biomass.csv", row.names = FALSE)

## end

# plot type = bar
# x-axis = species and biomass type
# y-axis = biomass in grams
# grouping = worms (could also be considered x-axis )

plants <- read.csv("roots-tidy/plant-biomass.csv")

summary(plants)

# there are several ways to generate a similar plot

plants$species <- factor(plants$species, labels = c("Achillea millefolium", "Campanula rotundifolia"))

# option 1: use facet_grid for species

ggplot(data = plants, aes(x = biomass_type, y = biomass, fill = worms)) +
  geom_bar(stat = "summary", fun.data = "mean_se", position = "dodge") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", position = position_dodge(width = 0.9), width = 0.2) +
  labs(title = "Biomass with and without earthworms", x = "Plant species and biomass type", y = "Biomass (g)") +
  theme(plot.title = element_text(hjust = 0.5), strip.text = element_text(face = "italic")) +
  scale_fill_discrete(name = "Earthworms") +
  facet_grid(. ~ species)
  
# option 2: concatenate species and biomass type

labs <- c(expression(paste(italic('Achillea millefolium')," \n root", sep = " ")),
                    expression(paste(italic("Achillea millefolium")," \n shoot", sep = " ")),
                    expression(paste(italic("Campanula rotundifolia")," \n root", sep = " ")),
                    expression(paste("italic('Campanula rotundifolia') \n shoot", sep = " ")))


plants$sp_mass<- paste(plants$species, plants$biomass_type, sep = " ")

ggplot(data = plants, aes(x = sp_mass, y = biomass, fill = worms)) +
  geom_bar(stat = "summary", fun.data = "mean_se", position = "dodge") +
  stat_summary(fun.data = "mean_se", geom = "errorbar", position = position_dodge(width = 0.9), width = 0.2) +
  labs(title = "Biomass with and without earthworms", x = "Plant species and biomass type", y = "Biomass (g)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels = labs) +
  scale_fill_discrete(name = "Earthworms")


# 6. MAKE YOUR OWN FIGURE  ----------------------------------------------

# using any of the 3 data frames from Cameron et al., think of another thing you'd like to visualize
# make a plot! 
# be sure to include properly labeled axes
# if you're having trouble coming up with an idea, you can also re-plot the data from any of the above 
# plots using a different plot type. If you do this, explain why your plot type may be a better choice 
# for visualizing the data.

# plot type = 
# x-axis = 
# y-axis = 
# grouping = 



# EXTRA -------------------------------------------------------------------

# Methods text from Cameron et al.

# We digitized the locations of roots, burrows, and cracks in the soil in images obtained at four time steps 
# (01 September 2010, 29 September 2010, 03 November 2010, 08 December 2010) in ArcGIS (v 10, Esri). Images 
# from each pot (18 mm × 222 mm) were divided into 6 mm ×6 mm grid cells, with 111 cells per pot. We then 
# determined occurrence of roots, burrows, and cracks within each cell at each time step.
# 
# Mixed effects logistic regression was used to examine root occurrence over time within grid cells 
# containing burrows and cracks for each species separately. These models included void type (burrow, crack, 
# or none), date, and the interaction of void type and date as fixed effects. The first date was not included 
# in the analysis as planting had occurred just prior to imaging and there were no roots present at the depth 
# of the mini-rhizotron tube. Pot identity and grid cell were used as random effects to account for 
# correlations among grid cells within pots and within grid cells over time. We also performed post-hoc 
# pairwise comparisons, with a Bonferroni correction for multiple testing, to examine root occurrence in 
# cracks versus burrows at each time step. We focused our analysis on comparison of cracks versus burrows 
# because detectability of roots is expected to be similar within these void types. In contrast, 
# detectability might differ in the soil matrix versus in voids (cracks and burrows), as roots in voids are 
# likely easier to see.
# 
# A similar mixed effects logistic regression analysis was used to examine differences in root mortality 
# within grid cells containing burrows, cracks, and soil. We included a random effect to account for pot 
# identity and a fixed effect to control for the date of initial colonization of cells by roots. In this 
# analysis, we examined only grid cells with roots present during the experiment. Roots were considered to 
# have died when they were no longer visible in the cell at subsequent time steps. Analyses were also 
# performed using a random effect for tube identity (there were five pots along each tube), but they produced 
# similar results and thus are not shown.
# 
# To assess effects of earthworms on root and shoot biomass, we used mixed effects linear regression with 
# earthworm presence as a fixed effect and tube identity as a random effect. Species were analyzed separately. 
# We also examined earthworm effects on biomass allocation to shoots versus roots using mixed effects linear 
# regression with shoot biomass as the dependent variable and root biomass, earthworms, and the interaction 
# between root biomass and earthworms as fixed effects. Tube identity was included as a random effect in this 
# analysis as well. Normality was assessed by inspection of residuals and data were log transformed if non-
# normal. All analyses were conducted in Stata (v 12, StataCorp).