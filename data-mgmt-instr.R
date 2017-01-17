## PLANT ECOLOGY (BIOL406): Data management and manipulation

## INSTRUCTOR NOTES

# 0:00
# - introduce lab, pass out stickies (slide 1), try to mix up experienced and unexperienced students
# - mention the slides will be posted online
# - talk through slide 2
# 0:10
# - get Rstudio going, get files to everyone, get projects started (slide 3, demo the process) [STICKY CHECK]
# - talk through tidy data slide (slide 4-5), then get them to open up excel file (slide 6) [STICKY CHECK]
# 0:20
# - have them discuss changes for ~5 min
# 0:25
# - open up excel file on screen and make adjustments to the excel file as they suggest them.
## ANSWERS:
## - delete extra rows at top
## - delete title
## - fix species names to be consistent
## - worms: yes -> present
## - remove spaces from column names
## - move metadata to different file and improve
## - change na to NA
## - change missing data to NA
## - change note to NA
## - remove wrong units note from data field, create note column.
## - 32.o7 -> 32.07
# show how to save as a csv into project folder
# show how to import into R 
# this is another way to check your data for errors
# for now, just watch, in a minute you'll practice these commands yourself
mydata <- read.csv("roots-messy.csv")
# introduce summary(), head(), dim()
head(mydata)
summary(mydata)
dim(mydata)
# great, so, now you should know how to:
# - create a new Rproject
# - examine data in Excel
# - save data in Excel for importing into R
# - I've demoed looking at data in R, and now you'll get to do it yourself
# 2:30 begin live coding, get everyone to open data-mgmt-student.R [STICKY CHECK]
# go over the basics below
# remind them: R is a language, it's very hard at first, and it's normal to feel very overwhelmed if you're not used to coding. but you;ll get it eventually, it's worth it, and we're all here to help
# install/load emoji package to impress the kids
# library(devtools)
# install_github("dill/emoGG")
library(emoGG)
## END INSTRUCTOR NOTES


# in the following excercises, we'll recreate some of the figures from:
  # Cameron EK, Cahill JF Jr, Bayne EM (2014) Root Foraging Influences Plant Growth Responses 
  # to Earthworm Foraging. PLoS ONE 9(9): e108873. doi:10.1371/journal.pone.0108873

# I wrote these exercises on a mac, so please alert me if you're having trouble translating any of the instructions on a PC.

# RStudio panes and tabs:
# source, script
# console
# plots
# files
# packages (go over later)
# help
# environment

# useful keyboard shortcuts:
  # shift+command/ctrl+C -> make a line a comment
  # shift+command/ctrl+M -> make a pipe
  # command/ctrl+enter -> runs highlighted code or current line
  # shift+command/ctrl+R -> create section
  # ctrl/command+alt/option+R -> run entire script

# a few settings to adjust (if there's time, while everyone catches up): 
# preferences -> general -> uncheck "restore Rdata at startup"
# preferences -> general -> save workspces to .Rdata -> "never"
# preferences -> code -> check "soft wrap source files"



# 1. TIDYING EXERCISE -----------------------------------------------------

# see lecture slides

# SKILL CHECK - do you know how to...
# - create a new Rproject?
# - examine and tidy data in Excel?
# - save data in Excel for importing into R?



# 2. LOADING AND INSTALLING LIBRARIES AND DATA ----------------------------

# if you haven't installed tidyverse package previously, install it first.

# install.packages("tidyverse")
library(tidyverse)

# a package is a set of programs and commands. anyone can develop and contribute packages for R. anytime you want to try out a new package, you'll need to install it first with the install.packages() command. you only need to install once, but each time you want to use the package, you'll need to load it with the library() command.

# one of the most basic commands in R is assigning objects values using the <- symbol. it works like this: newname <- an_existing_object_or_datafile_or_value. now newname is equivalent to whatever was on the right side of the arrow. this basic structure can be combined with other commands, for example: meanvalue <- mean(mytable$mycolumn).

# for now, so that we're all on the same page, we'll load some tidy data that I've given you.

rootvoids <- read.csv("roots-tidy/root-void-occurrence.csv")

# let's practice head(), dim(), summary(), and str()

head(rootvoids)

dim(rootvoids)

summary(rootvoids) 

# note that some columns are integers (numeric), and some are factors (categorical variables). factors will have the levels listed, and the number of observations of each level. columns containing numeric values will have minimum, maximum, etc.

str(rootvoids)

# some important symbols:

# c() is a way of assigning multiple items to a name

numbers <- c(1,2,3,4,5)
numbers

names <- c("Amy","Megan","Rachel")
names

# $ is a tool for referring to columns in a dataframe

summary(rootvoids$voidtype)
mean(rootvoids$burrow)

# NA is the default symbol for a missing value. you can perform numeric operations on a numeric column that contains NAs, whereas if it contained other text that would prevent R from recognizing it as a numeric column. the same applies to factors.

# SKILL CHECK - do you know how to...
# - install and load libraries?
# - import data into an R object?
# - use summary() to view the data?



# 3. CAMERON ET AL. FIGURE 2 ----------------------------------------------

# let's recreate figure 2, and examine how roots occupied different void types over time.

# what does the plot we want to make look like? consult cameron et al.
# http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0108873

# plot type = line
# x-axis = Time(days) = day
# y-axis = proportion of cells occupied by roots = calculate from root
# grouping = voidtype and species

# first, we should create separate data frames for the 2 species.
# we can do this with the filter() function.
# the species code for Achillea millefolium is ACHMIL.

am_rootvoids <- rootvoids %>% 
  filter(species == "ACHMIL")

# the above says: take rootvoids, and filter it to keep only rows with "ACHMIL" in the species column. place the output into a new object called am_rootvoids.

# what is %>% ?
# %>% is a pipe. it takes the previous object, and feeds it into the next command.

# take a look at this new data frame

summary(am_rootvoids) 

# now do the same for Campanula rotundifolia (species code = CAMROT)

cr_rootvoids <- rootvoids %>% 
  filter(species == "CAMROT")

summary(cr_rootvoids)

# now, we want to plot theproportion of each voidtype on each day that are colonized by roots
# one way of doing this is to make a table calculating these proportions (don't worry about the error bars for now). 
# since root colonization is recorded as 1, and no roots is recorded as 0, the proportion of cells containing roots can be calculated as the average of these 1s and 0s.

cr_rootvoids_prop <- cr_rootvoids %>% 
  group_by(voidtype,day) %>% 
  summarize(prop_root = mean(root))

# the above takes the dataframe "cr_rootvoids", groups the rows by voidtype and day, and then creates a new column called "prop_root" which is equal to the mean of the column "root" in the original data frame (these means are calculated separately for each of the groups created above). the output of these steps is placed into a new dataframe called "cr_rootvoids_prop".
# note that the summarize() function drops columns that are not in either the group_by() command or the summarize() command.

# what size do you expect this table to be?
dim(cr_rootvoids_prop)

# does this table look okay?
cr_rootvoids_prop

# basic ggplot syntax

ggplot(dataframe, aes(x = your_x, y = your_y, color = group1, fill = group2)) +
  geom______() +
  labs()

# dataframe = the data to use in this plot
# aes = aesthetics, it supplies each part of the plot with variables
# x = assign your x variable (horizontal axis)
# y = assign your y variable
# color = one way to group variables, this works for lines, points, and shapes with outlines
# fill = another way to group variables, this works with shapes that have an interior to fill
# geom_____  = a layer to plot, this describes the type of plot you're making, i.e. bar plot, box plot, etc.
# labs = you can adjust your axis/legend labels here

# now let's build our plot

ggplot(cr_rootvoids_prop,aes(x = day, y = prop_root, color = voidtype)) +
  geom_point() +
  geom_path() +
  labs(x = "Time (days)", y = "Proportion of voids colonized", color = "Void type")

# now generate a plot for the Achillea data

am_rootvoids_prop <- am_rootvoids %>% 
  group_by(voidtype,day) %>% 
  summarize(prop_root = mean(root))

# does this table look okay?

head(am_rootvoids_prop)

# is it the expected size?

dim(am_rootvoids_prop)

# now make a plot

ggplot(am_rootvoids_means,aes(x = day, y = prop_root, color = voidtype)) +
  geom_point() +
  geom_path() +
  labs(x = "Time (days)", y = "Proportion of voids colonized", color = "Void type") 

# you can save your plot with the export option near the plot tab.


# extra challenges for figure 2 (these are advanced, but if you're bored with the main exercises you can give them a try):
# 1. create a multipanel plot from the dataframe that contains both species (use google!)
# 2. create a plot from your full data frame, without separately calculating averages (hint: stat = summary)
# 3. add error bars to your plots (hint: stat_summary())
# 4. extend the lines to begin at 0,0 as in the paper's plots (I couldn't find a quick way to do this in the ggplot command, so I found a work-around. let me know what you come up with!)


## INSTRUCTOR ONLY
# one possible solution:

# add full species names
rootvoids$species <- factor(rootvoids$species, labels = c("Achillea millefolium", "Campanula rotundifolia"))

# make a new mini-data frame with one row per group
origins <- rootvoids %>% 
  group_by(voidtype,species) %>% 
  sample_n(1)

# assign each row a 0 in the day and root columns
origins$day<-c(0,0,0,0,0,0)
origins$root<-c(0,0,0,0,0,0)

head(origins)

# bind these origin rows to the rootvoids frame
rootvoids_origins <- bind_rows(rootvoids, origins)

# this summary table is just to facilitate adding emojis
rootvoids_means <- rootvoids %>% 
  group_by(voidtype,day,species) %>% 
  summarize(prop_root = mean(root))

ggplot(data = rootvoids_origins, aes(x = day, y = root, color = voidtype)) +
  geom_point(stat = "summary", fun.y = "mean") +
  # add_emoji(emoji = "1f41b") +
  geom_path(stat = "summary", fun.y = "mean") +
  stat_summary(fun.data = "mean_cl_normal", width = 5, geom = "errorbar") +
  xlim(0,105) + 
  expand_limits(y=0) +
  facet_grid(. ~ species) +
  theme(strip.text = element_text(face = "italic")) +
  scale_color_discrete(name = "Void type") +
  # geom_emoji(emoji = "1f41b", data = rootvoids_means, aes(x = day, y = prop_root)) +
  labs(x = "Time (days)", y = "Proportion of voids colonized", color = "Void type") 
  
# note that the error bars on their plot are smaller because these are just based on a normal distribution
## END INSTRUCTOR ONLY

# SKILL CHECK - do you know how to...
# - filter() a dataframe based on the value of a single column?
# - calculate mean values for different groups using group_by() and summarize()?
# - generate a line plot with ggplot?



# 4. CAMERON ET AL. FIGURE 3 ----------------------------------------------

# what does the plot we want to make look like?

# check it out
summary(rootdeath)

# plot type = bar
# x-axis = type of void (voidtype)
# y-axis = proportion of cells with roots dying (calculate from column dead)
# grouping = species (this could also be considered an x-axis variable)

# load the data
rootdeath <- read.csv("roots-tidy/root-death.csv")

# some optional lines:
# if we want the bars to be in the same order as in the paper:
rootdeath$voidtype = factor(rootdeath$voidtype,levels(rootdeath$voidtype)[c(3,2,1)])

# if we want the full names of species included
rootdeath$species <- factor(rootdeath$species, labels = c("Achillea millefolium", "Campanula rotundifolia"))

# make the plot
# this time, both plant species are on a single plot
# we can separate by species in a few ways. 
# option 1: use fill

ggplot(data = rootdeath, aes(x = voidtype, y = dead, fill = species)) +
  geom_bar(stat = "summary", fun.data = "mean_se", position = "dodge") +
  geom_errorbar(stat = "summary", fun.data = "mean_se", position = position_dodge(width = 0.9), width = 0.2) +
  labs(x = "Plant species and void type", y = "Proportion of cells with roots dying", fill = "Plant species")

# this plot uses a few new features of ggplot
# first, within the geom_bar command, we'll use stat = "summary". this means that the function supplied by fun.data will be applied to each group. this is basically a way of performing the same summarize step that we performed earlier, but instead of creating a separate dataframe, these calculations are performed within the plotting code.
# second, we'll use geom_errorbar to add errorbars to our plot

# since the authors performed their analyses separately for each species, it's preferable to have the two species side-by-side
# option 2: use facet_grid()
  
ggplot(data = rootdeath, aes(x = voidtype, y = dead)) +
  geom_bar(stat = "summary", fun.data = "mean_se", position = "dodge") +
  geom_errorbar(stat = "summary", fun.data = "mean_se", position = position_dodge(width = 0.9), width = 0.2) +
  labs(x = "Plant species and void type", y = "Proportion of cells with roots dying") +
  theme(strip.text = element_text(face = "italic")) +
  facet_grid(. ~ species) 

# here we've used a new ggplot feature:
# facet_grid splits the data up by factors

# if you want the 2 species to be different colors, as in the paper, you can keep the fill command, then add:
  # scale_fill_discrete(guide = FALSE)
# to remove the legend, which is redundant with the grid labels

  
# SKILL CHECK - do you know how to...
# - make a bar plot with ggplot?
# - add error bars to your plot?
# - make multipanel plots?
  


# 5. CAMERON ET AL. FIGURE 4 ----------------------------------------------

# now, on your own, recreate Cameron et al. figure 4. 
# plant biomass data is in "roots-tidy/plant-biomass.csv"
# to prepare the original data for this exercise, I had to reshape it. I'll show you how if there's time.
# it's okay if your plot is slightly different in style or format from the plot in the paper, but keep the same groups and y-axis.
# annotate your code with plenty of comments.

## INSTRUCTOR ONLY
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
plants$biomass_type <- factor(plants$biomass_type, labels = c("root", "shoot"))

# and write the table out as a .csv
# write.csv(plants,"roots-tidy/plant-biomass.csv", row.names = FALSE)

## END INSTRUCTOR ONLY

plants <- read.csv("roots-tidy/plant-biomass.csv")

summary(plants)

# plot type = bar
# x-axis = species and biomass_type 
# y-axis = biomass in grams = biomass
# grouping = worms (could also be considered x-axis )

# there are several ways to generate a similar plot

plants$species <- factor(plants$species, labels = c("Achillea millefolium", "Campanula rotundifolia"))

# option 1: use facet_grid() for species

ggplot(data = plants, aes(x = biomass_type, y = biomass, fill = worms)) +
  geom_bar(stat = "summary", fun.data = "mean_se", position = "dodge") +
  geom_errorbar(stat = "summary", fun.data = "mean_se", position = position_dodge(width = 0.9), width = 0.2) +
  labs(x = "Plant species and biomass type", y = "Biomass (g)", fill = "Worms") +
  theme(strip.text = element_text(face = "italic")) +
  facet_grid(. ~ species)
  
# option 2: concatenate species and biomass type
# hint: to concatenate the contents of two columns:
plants$sp_mass<- paste(plants$species, plants$biomass_type, sep = " ")

plants$sp_mass_wrap <-str_wrap(plants$sp_mass,width = 6)

ggplot(data = plants, aes(x = sp_mass_wrap, y = biomass, fill = worms)) +
  geom_bar(stat = "summary", fun.data = "mean_se", position = "dodge") +
  geom_errorbar(stat = "summary", fun.data = "mean_se", position = position_dodge(width = 0.9), width = 0.2) +
  labs(x = "Plant species and biomass type", y = "Biomass (g)", fill = "Earthworms") 



# 6. MAKE YOUR OWN FIGURE  ----------------------------------------------

# using any of the 3 data frames from Cameron et al., think of another thing you'd like to visualize.
# make a plot! 
# be sure to include properly labeled axes.
# annotate your code with plenty of comments.
# if you're having trouble coming up with an idea, you can also re-plot the data from any of the above plots using a different plot type. If you do this, explain why your chosen plot type is a good choice for visualizing the data.

# plot type = 
# x-axis = 
# y-axis = 
# grouping = 



# EXTRA -------------------------------------------------------------------

# Methods text from Cameron et al.

# We digitized the locations of roots, burrows, and cracks in the soil in images obtained at four time steps (01 September 2010, 29 September 2010, 03 November 2010, 08 December 2010) in ArcGIS (v 10, Esri). Images from each pot (18 mm × 222 mm) were divided into 6 mm ×6 mm grid cells, with 111 cells per pot. We then  determined occurrence of roots, burrows, and cracks within each cell at each time step.
# Mixed effects logistic regression was used to examine root occurrence over time within grid cells containing burrows and cracks for each species separately. These models included void type (burrow, crack, or none), date, and the interaction of void type and date as fixed effects. The first date was not included in the analysis as planting had occurred just prior to imaging and there were no roots present at the depth of the mini-rhizotron tube. Pot identity and grid cell were used as random effects to account for correlations among grid cells within pots and within grid cells over time. We also performed post-hoc pairwise comparisons, with a Bonferroni correction for multiple testing, to examine root occurrence in cracks versus burrows at each time step. We focused our analysis on comparison of cracks versus burrows because detectability of roots is expected to be similar within these void types. In contrast, detectability might differ in the soil matrix versus in voids (cracks and burrows), as roots in voids are likely easier to see.
# A similar mixed effects logistic regression analysis was used to examine differences in root mortality within grid cells containing burrows, cracks, and soil. We included a random effect to account for pot identity and a fixed effect to control for the date of initial colonization of cells by roots. In this analysis, we examined only grid cells with roots present during the experiment. Roots were considered to have died when they were no longer visible in the cell at subsequent time steps. Analyses were also performed using a random effect for tube identity (there were five pots along each tube), but they produced similar results and thus are not shown.
# To assess effects of earthworms on root and shoot biomass, we used mixed effects linear regression with earthworm presence as a fixed effect and tube identity as a random effect. Species were analyzed separately. We also examined earthworm effects on biomass allocation to shoots versus roots using mixed effects linear regression with shoot biomass as the dependent variable and root biomass, earthworms, and the interaction between root biomass and earthworms as fixed effects. Tube identity was included as a random effect in this analysis as well. Normality was assessed by inspection of residuals and data were log transformed if non-normal. All analyses were conducted in Stata (v 12, StataCorp).