
# Usage -------------------------------------------------------------------
# generate Project_Time_metadata
# check whether city in location matches that in sample metadata
# check whether food in food_info matches that in sample metadata and project metadata
# check on host vs food(food part).

# sum：128 projects, 79 foods, 113 studies

getwd()
# "/Users/yahui/Documents/work/newdata/"
library(readxl)
library(tidyverse)
library(writexl)
library(dplyr)

# check numbers of projects and papers ------------------------------------
# check unique projects in project metadata and sample metadata, and if they match.
# main table
df <- read_excel('Project_metadata.xlsx')
unique(df[[2]]) %>% length() # 128
projects <- unique(df[[2]]) 

df_sample <- read_excel('Sample_metadata.xlsx')
unique(df_sample[[3]]) %>% length() # 128

# count unique papers
unique(df$Publication_Title) %>% length # 113

# generate sub-project metadata folder ------------------------------------
# select time-series projects from the main table
df <- read_excel("Project_metadata.xlsx")
df_time <- df %>% 
  dplyr::filter(grepl("Time", Analysis_Type, ignore.case = F)) %>% 
  select(1:16)
write_xlsx(df_time, "Project_Time_metadata.xlsx")


# location check ---------------------------------------------------
# compare to sample metadata
loc <- read_excel("location.xlsx")
sample <- read_excel("Sample_metadata.xlsx")
unique(sample$geo_loc_name) %>% length # 135
unique(loc$City) %>% length # 134
setdiff(unique(sample$geo_loc_name), unique(loc$City)) # "NA"
setdiff(unique(loc$City),unique(sample$geo_loc_name)) # character(0)

# check food info ---------------------------------
# compared to the sample metadata and project metadata
food <- read_excel("Food_info.xlsx")
sample <- read_excel("Sample_metadata.xlsx")
project <- read_excel("Project_metadata.xlsx")

proj_food <- project["Food"]
proj_food2 <- proj_food %>% separate_rows(Food, sep="\\|\\|")
samp_food <- sample["Food"]

# food table vs project table
unique(food$Food) %>% length # 79
setdiff(unique(food$Food), unique(samp_food$Food)) # character(0)
setdiff(unique(samp_food$Food),unique(food$Food)) # "NA"

#  project table vs sample table
unique(proj_food2$Food) %>% length # 79
unique(samp_food$Food) %>% length # 80
setdiff(unique(samp_food$Food), unique(proj_food2$Food)) # "NA"
setdiff(unique(proj_food2$Food),unique(samp_food$Food)) # character(0)


# hosts check for food and food part -------------------------------------------------
# to check if the numbers of hosts for food and food part are the same

df <- read_excel('Sample_metadata.xlsx')
df2 <- df %>% unite(Host2, c("Food", "Food_part"))
host1 <- as.data.frame(unique(df$Host)) # 125
host2 <- as.data.frame(unique(df2$Host2)) # 104, but one is NA-NA, so 103.
