# Epidemia Training
# Session 1: Introduction to R
# Presenters: Justin Millar and Amir Siraj
# Date: 23 Jan 2025
# 
# Part 1: Intro R and RStudio

## Section 0: Getting Started --------------
# Installing packages
install.packages(c("dplyr","knitr","lubridate","parallel","readr","readxl",
                  "tidyr","tinytex","tools","tidyverse","janitor","writexl",
                  "sf","ISOweek"))

## Section 1: Introduction to R and Rstudio and basic functions ---------------
# Setting up a project in RStudio
# https://path-global-health.github.io/epidemiar-intro-training/base-r-intro.html

# Remember to set up a data and output folder, and copy over raw data files

# Exploring R, finding help, debugging and writing comments
20 * 10.5
sqrt(25)
?sqrt

# Be careful about common typos and errors:
sqrt(a)
sqrt("a")
SQRT(25)
sqrt(25))

# Create an object/variable
area_of_circle <- pi * 4 ^2

# Data types - Numerics
my_first_variable <- 20
my_first_variable

b <- 2/10
malaria_prevalence_2020 <- 2/10

# Overwrite a variable
test_variable <- 15
test_variable

test_variable <- 20
test_variable

# Character "strings"
my_first_string  <- "avocado"
my_first_string

my_first_string  * my_first_variable

# Checking data types with the class() function
class(my_first_string)
class(my_first_variable)

# Vectors -- Multiple vaules in a single object
v1 <- c(1,2,3,4,5)
v2 <- c(0.1,0.15,0.2,0.4,0.5)
v3 <- c("red","blue","green","orange","black")

# Subsetting a vector
v1[3]   # Note the difference between [ ] and ( )

# ----
#' Challenge
#' Question 1: What happens if you try to find an element that doesn’t exist? 
#' (e.g. the 0th or 6th element of v1 - how do you type this and 
#' what is the output?)
# ----

# Summarizing a vector
mean(v1)
sd(v1) 
var(v1)
min(v1)
max(v1)
sum(v1)
sum(v1[c(1,4)])
length(v1)
plot(v1)
plot(v2,v1)

# ----
# Challenge
#' Question 2: What happens if you try to use these operations on v3 rather 
#' than v1?
#' 
#' Question 3: Try v1* v2 - What has the operator * done to your vectors? 
#' Is that what you expected?
# ----

# Using the rep() function
v4 <- rep(0, 14)
v4[1] <- 10
v4

# ----
#' Challenge:
#' Question 4:What do you think the following will do:
#' v4[2:14] <- c(11:23) Try to guess before you try it!
# ----

# Dataframes (tabular/spreadsheets style data)
?CO2               # Built-in dataset in R
data("CO2")        # Details about dataset
head(CO2)          # View subsetion of data
head(CO2, n = 20)
dim(CO2)           # View number of rows and columns

# ----
#' Challenge:
#' Q5: What are the column names of this dataset?
# ----

# Subsetting dataframes
CO2[3,2]       # using [row number, column number]
CO2[6,]        # Extract a full row
CO2[,3]        # Extract a full column
CO2$Treatment  # Alternative methods for extracting a column (by name)

# Creating an object from a subsetted dataframe
CO2_op2 <- CO2[,2:3]
head(CO2_op2)

# Summarizing a dataframe
str(CO2)
summary(CO2)

# Summarizing single columns
table(CO2$Treatment) 
mean(CO2$uptake)

# Using logical functions and combining steps
which(CO2$Type == "Quebec") 
CO2$conc[which(CO2$Type == "Quebec")]
mean(CO2$uptake[which(CO2$Type == "Quebec")])

# Similar process using the "tidyverse"
# you may need to run: install.packages("tidyverse")
op1 = dplyr::filter(CO2, Type == "Quebec")   # the filter function
mean(op1$uptake)

op2 = dplyr::filter(CO2, Type == "Quebec", Treatment == "chilled")
mean(op2$uptake)

# ----
#' Challenges:
#' Q6a: What is the value in the 14th row and 5th column?
#' Q6b: What are the values in the 1st to 7th rows of the 4th column
#' Q6c: How many of the samples are from Quebec?
#' 
#' Q7: What is the range and median of the uptake column?
#' 
#' Can you now fill in this table - we want the **MEDIAN** uptake value for 
#' each treatment-type combination:
# ----

# Using R Packages
install.packages("janitor")
library(janitor)
janitor::

# Reading in data (with the tidyverse package)
library(tidyverse)
dat <- read_csv("data/training_case_data_wide.csv")  # Make sure the file is in a folder called "data"!
head(dat)

# Subsetting a real dataset: 
# How many confirmed malaria cases there were in Ababo woreda in 2021?
op1 = filter(dat, woreda == "Ababo", year == 2021)
op1
sum(op1$confirmed)

# ----
#' Question 9: What happens if we repeat this for presumed cases in Ababo in 2021?
# ----

# Small example of summing values with NA's
test_vector <- c(1, 5, 8, 3, NA, 6)
sum(test_vector)
sum(test_vector, na.rm = TRUE)

# Now try to calculate the total presumed cases in Ababo in 2021

# ----
#' Final Challenges:
#' 1. What was the total number of cases (presumed and confirmed) in Hudet woreda in 2020?
#' 2. Were there more presumed or confirmed cases of malaria in Awra woreda in 2020?
#' 3.  In 2021, were there more confirmed malaria cases in Hulet Ej Enese or Takusa?
# ----


