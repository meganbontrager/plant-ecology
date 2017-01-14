## PLANT ECOLOGY (BIOL406): Data management and manipulation

# in the following excercises, we'll recreate some of the figures from:
  # Cameron EK, Cahill JF Jr, Bayne EM (2014) Root Foraging Influences Plant Growth Responses 
  # to Earthworm Foraging. PLoS ONE 9(9): e108873. doi:10.1371/journal.pone.0108873

# useful keyboard shortcuts:
  # shift+command/ctrl+C -> make a line a comment
  # shift+command/ctrl+M -> make a pipe
  # command/ctrl+enter -> runs highlighted code or current line
  # shift+command/ctrl+R -> create section
  # ctrl/command+alt/option+R -> run entire script

# I wrote these exercises on a mac, so please alert me if you're having trouble translating any of the instructions on a PC.



# 1. TIDYING EXERCISE AND PROJECT SETUP -----------------------------------

# make an Rproject for this course.

# open RStudio, file -> new project -> new directory -> empty project

# choose the directory that you'd like your project to be in, and give your project a name. this will create a folder with your project file inside it.

# an Rproject is basically an organizer for a given project. when you open a project, you'll have easy access to the files associated with that project. put all the files I've given you, including this script (save first if you've edited it), into the folder associated with your Rproject.  

# a few global options to adjust: 
# preferences -> general -> uncheck "restore Rdata at startup"
# preferences -> general -> save workspces to .Rdata -> "never"
# preferences -> code -> check "soft wrap source files"

# RStudio panes and tabs:
# source
# console
# plots
# files
# packages
# help
# environment

# you'll start by tidying data in Excel, then I'll show you how to import the data into R. 


# SKILL CHECK - do you know how to...
# - create a new Rproject?
# - examine data in Excel?
# - save data in Excel for importing into R?



# 2. LOADING AND INSTALLING LIBRARIES AND DATA ----------------------------

# if you haven't installed tidyverse package previously, install it first.



# a package is a set of programs and commands. anyone can develop and contribute packages for R. anytime you want to try out a new package, you'll need to install it first with the install.packages() command. you only need to install once, but each time you want to use the package, you'll need to load it with the library() command.

# now, load your data
# start with your .csv file (from Excel, "Save as", you can only save one sheet per file)



# one of the most basic commands in R is assigning objects values using the <- symbol. it works like this: newname <- an_existing_object_or_datafile_or_value. now newname is equivalent to whatever was on the right side of the arrow. this basic structure can be combined with other commands, for example: meanvalue <- mean(mytable$mycolumn).

# what are these?
# $
# c()
# NA

# quick examples:
# $ is a tool for reffering to columns in a dataframe



# c() is a way of assigning multiple items to a name



# NA is the default symbol for a missing value. you can perform numeric operations on a numeric column that contains NAs, whereas if it contained other text that would prevent R from recognizing it as a numeric column. the same applies to factors.



# back to the data you loaded. you can use the summary() command to see if your data falls into expected ranges. factors will have the levels listed, and the number of observations of each level. columns containing numeric values will have minimum, maximum, etc.



# data anomalies can be addressed by returning to the .csv file in excel (don't forget to reload it into R after modifying!) or (once you're more proficient in R) data problems should be corrected in your code. note that you should NOT remove true outliers from your data. this is just an opportunity to correct typos etc.


# SKILL CHECK - do you know how to...
# - install and load libraries?
# - import data into an R object?
# - use summary() to view the data?



# 3. CAMERON ET AL. FIGURE 2 ----------------------------------------------

# let's recreate figure 2, and examine how roots occupied different void types over time.

# for now, so that we're all on the same page, we'll load the tidy data that I've given you.



# check out this data frame. does it look as expected?



# what does the plot we want to make look like? consult cameron et al.
# http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0108873

# plot type = line
# x-axis = day
# y-axis = proportion occupied by roots
# grouping = voidtype and species

# first, we should create separate data frames for the 2 species.
# we can do this with the filter() function



# the above says: take rootvoids, and filter it to keep only rows with "ACHMIL" in the species column. place the output into a new object called am_rootvoids.

# what is %>% ?
# %>% is a pipe. it takes the previous object, and feeds it into the next command.

# take a look at this new data frame



# now do the same for Campanula rotundifolia



# now, we want to plot the proportion of each voidtype on each day that are colonized by roots
# one way of doing this is to make a table calculating these means (don't worry about the error bars for now)



# does this table look okay?



# is it the expected size?



# now make a plot



# now generate a plot for the Achillea data



# does this table look okay?



# is it the expected size?



# now make a plot



# you can save your plot with the export option near the plot tab.

# extra challenges for figure 2 (these are advanced, but if you're bored with the main exercises you can give them a try):
# 1. create a multipanel plot from the dataframe that contains both species (use google!)
# 2. create a plot from your full data frame, without separately calculating averages (hint: stat = summary)
# 3. add error bars to your plots (hint: stat_summary())
# 4. extend the lines to begin at 0,0 as in the paper's plots (I couldn't find a quick way to do this in the ggplot command, so I found a work-around. let me know what you come up with!)


# SKILL CHECK - do you know how to...
# - filter() a dataframe based on the value of a single column?
# - calculate mean values for different groups using group_by() and summarize()?
# - generate a line plot with ggplot?

  

# 4. CAMERON ET AL. FIGURE 3 ----------------------------------------------

# what does the plot we want to make look like?

# plot type = bar
# x-axis = type of void
# y-axis = proportion of cells with roots dying
# grouping = species (could also be considered an x-axis variable)

# load the data



# check it out



# if we want the bars to be in the same order as in the paper:



# if we want the full names of species included



# make the plot
# this time, both plant species are on a single plot


  
# SKILL CHECK - do you know how to...
# - make a bar plot with ggplot?
# - add error bars to your plot?
# - make multipanel plots?
  


# 5. CAMERON ET AL. FIGURE 4 ----------------------------------------------

# now, on your own, recreate Cameron et al. figure 4. 
# plant biomass data is in "roots-tidy/plant-biomass.csv"
# to prepare the original data for this exercise, I had to reshape it. I'll show you how if there's time.
# it's okay if your plot is slightly different in style or format from the plot in the paper, but keep
# the same groups and y-axis

# plot type = bar
# x-axis = species and biomass type
# y-axis = biomass in grams
# grouping = worms (could also be considered x-axis )



# 6. MAKE YOUR OWN FIGURE  ----------------------------------------------

# using any of the 3 data frames from Cameron et al., think of another thing you'd like to visualize.
# make a plot! 
# be sure to include properly labeled axes.
# if you're having trouble coming up with an idea, you can also re-plot the data from any of the above plots using a different plot type. If you do this, explain why your plot type may be a better choice for visualizing the data.

# plot type = 
# x-axis = 
# y-axis = 
# grouping = 


