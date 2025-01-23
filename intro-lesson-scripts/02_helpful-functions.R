# Epidemia Training
# Session 1: Introduction to R
# Presenters: Justin Millar and Amir Siraj
# Date: 23 Jan 2025
# 
# Part 2: More useful R functions
 
 # Section 2: Using "if" conditions ---------------

# Using "if" statements
x <- 10

if (x > 5) {
  print("x is greater than 5")
}

# Expanding the if statement with "else"
x <- 3

if (x > 5) {
  print("x is greater than 5")
} else {
  print("x is not greater than 5")
}

# Combining multiple if-else statements
x <- 7

if (x > 10) {
  print("x is greater than 10")
} else if (x > 5) {
  print("x is greater than 5 but less than or equal to 10")
} else {
  print("x is 5 or less")
}

# Nested if-else statements with multiple conditions
x <- 15
y <- 20

if (x > 10) {
  if (y > 15) {
    print("x is greater than 10 and y is greater than 15")
  } else {
    print("x is greater than 10 but y is not greater than 15")
  }
} else {
  print("x is 10 or less")
}

# Vectorized if-else statements with the "ifelse" function
# Syntax: ifelse(test, yes, no)
x <- c(2, 7, 5, 10)

result <- ifelse(x > 5, "Greater than 5", "5 or less")
print(result)

# Section 3: More helpful functions -------------------

# Concatenating strings and printing messages

# The paste function
str1 <- "Hello"
str2 <- "World"
result <- paste(str1, str2)
print(result)

# Using a different separator
result <- paste("A", "B", "C", sep = "-")
print(result)

# Collapsing a vector into a single string
words <- c("apple", "banana", "cherry")
result <- paste(words, collapse = ", ")
print(result)
length(words)
length(result)

# The paste0 function
str1 <- "Hello"
str2 <- "World"
result <- paste0(str1, str2)
print(result)

result <- paste0("A", "B", "C")
print(result)
# Output: "ABC"

# Printing messages in the console with the message() function
message("This is an informational message.")

# Combining print() and message() functions
name <- "John"
age <- 30
message(paste("Name:", name, "Age:", age))

prefix <- "ID_"
id <- 1234
message(paste0("Generated ID: ", prefix, id))

# Saving and loading R objects
x <- 1:10
y <- letters[1:10]
save(x, y, file = "output/data.RData")

load("output/data.RData")
print(x)
print(y)

# Using the saveRDS() function to save R objects
# This allows us to load in an object that we create
z <- matrix(1:9, nrow = 3)
saveRDS(z, file = "output/matrix.RDS")

my_matrix <- readRDS("output/matrix.RDS")
print(my_matrix)

# Loading CSV files
data <- read.csv("path/to/yourfile.csv")
print(head(data))

library(readr)   # Part of the tidyverse package
data <- read_csv("path/to/yourfile.csv")
print(head(data))

# Loading Excel files
library(readxl)
data <- read_excel(path, sheet = 1)

library(readxl)
data <- read_excel("path/to/yourfile.xlsx", sheet = "Sheet1")
print(head(data))

# Running a full script with source()
source("path/to/your_script.R")

# Section 4: Combining steps using "pipes" ---------------
library(tidyverse)

data <- mtcars   # Another built-in dataset
head(data)

# Multiple steps in using intermediate objects
filtered_data <- filter(data, cyl == 6)
selected_data <- select(filtered_data, mpg, hp)
summarized_data <- summarize(selected_data, mean_mpg = mean(mpg), mean_hp = mean(hp))

print(summarized_data)

# Using tidyverse pipes
data %>%
  filter(cyl == 6) %>%
  select(mpg, hp) %>%
  summarize(mean_mpg = mean(mpg), mean_hp = mean(hp)) %>%
  print()

# Using a custom function within a pipe
custom_function <- function(df) {
  df %>%
    filter(gear == 4) %>%
    select(mpg, wt)
}

data %>%
  custom_function() %>%
  head()

# Passing inputs to specific arguments with the dot operator "."
data %>%
  filter(cyl == 4) %>%
  select(mpg, wt) %>%
  {
    n <- nrow(.)
    mean_wt <- mean(.$wt)
    data.frame(n = n, mean_wt = mean_wt)
  }

# Nested pipelines
data1 <- mtcars %>%
  filter(cyl == 6) %>%
  select(mpg, hp)

data2 <- mtcars %>%
  filter(cyl == 4) %>%
  select(mpg, wt)

combined_data <- bind_rows(data1, data2)
print(combined_data)

# Quick examples using "native" pipes
mtcars |>
  filter(cyl == 6) |>
  select(mpg, hp) |>
  summarize(mean_mpg = mean(mpg), mean_hp = mean(hp)) |>
  print()

custom_function <- function(df) {
  df |>
    filter(gear == 4) |>
    select(mpg, wt)
}

mtcars |>
  custom_function() |>
  head()

# No "dot" operator in the native pipe
mtcars |>
  (\(df) filter(df, cyl == 4))() |>
  (\(df) select(df, mpg, wt))() |>
  (\(df) {
    n <- nrow(df)
    mean_wt <- mean(df$wt)
    data.frame(n = n, mean_wt = mean_wt)
  })()