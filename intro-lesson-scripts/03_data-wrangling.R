# Epidemia Training
# Session 1: Introduction to R
# Presenters: Justin Millar and Amir Siraj
# Date: 23 Jan 2025
# 
# Part 3: Data manipulation and reshaping

# Section 5: Data manipulation with dplyr and tidyr ---------------
library(tidyverse)

# Read in our training data
case_data <- read_csv("data/training_case_data_long.csv")

# Inspecting our data
head(case_data)
str(case_data)
summary(case_data)

# Subsetting a dataframe with the tidyverse
# Select just one column (region)
select(case_data, region)
# Select multiple columns
select(case_data, woreda, data_type, count)

# Select all but one column
select(case_data, -region)
# Removing multiple columns
select(case_data, -period, -region)

# Filter rows based on a specific values
filter(case_data, region == "Oromia")
filter(case_data, region == "Oromia", data_type == "presumed")

# Combining multiple conditions within filter()
# region is Easter AND data type is presumed 
filter(case_data, region == "Oromia" & data_type == "presumed")

# region is Oromia OR data type is presumed 
filter(case_data, region == "Oromia" | data_type == "presumed")

# region is Afar OR Oromia, AND count is over 1,000
filter(case_data, region == "Afar" | region == "Oromia", count > 1000)

# Using the "match" operator/function (%in%) to combine conditions
filter(case_data, data_type %in% c("presumed", "confirmed"))

# Keep rows from a group of selected woredas
study_woredas <- c("Adama Town", "Liban Jawi", "Mieso", "Wondo")
filter(case_data, woreda %in% study_woredas)

# Using the NOT operator (!) to filter everything expect a specific value
# Keep all rows where region is NOT Addis Ababa
filter(case_data, region != "Addis Ababa")

# ----
#' Challenge:
#' * Create a table for all confirmed malaria cases in Amhara and Harari regions 
#' in 2020.
#' 
#' * Create a table for all presumed malaria cases NOT in Amhara and Harari 
#' regions in 2020.
#' 
#' * Create a table for all presumed and confirmed cases that are over 500.
#' 
#' * Create a table for all data that are NOT presumed and that are over 500.
# ----

# Working with dates using the "lubridate" package
library(lubridate)

# Vector of workshop days
workshop_days <- c("2023-09-04", "2023-09-05", "2023-09-06", "2023-09-07","2023-09-08")
class(workshop_days)

# Convert to a Date class
workshop_days <- ymd(workshop_days)
class(workshop_days)

# Extracting elements of a date
year(workshop_days)
month(workshop_days)
month(workshop_days, label = TRUE)

# Using lubridate functions inside filter
filter(case_data, year(period) == 2020)
filter(case_data, between(period, ymd("2019-01-01"), ymd("2019-06-30")))

# ----
#' Challenge:
#' * What were the reported total cases (presumed and confirmed) in Bambasi 
#'   woreda each month during 2018?
#' 
#' * How many cases (presumed and confirmed) were reported in April 2020 in 
#'   Gudetu Kondole woreda?
#' 
#' * What were the monthly confirmed cases in Bambasi during the peak 
#'   transmission season (~September-December) each year?
# ----

# Creating new columns with mutate()
mutate(case_data, month = month(period))

# Create multiple columns at once
mutate(case_data,
  month_num = month(period),
  month_name = month(period, label = TRUE))

# Good practice to create new objects!
case_data_dates <- mutate(case_data,
    month_num = month(period),
    month_name = month(period, label = TRUE))

# ----
#' Challenge:
#' * Can you add a new variable (column) to the dataset that gives the quarter 
#'   of the year?
#' 
#' * Can you add a new variable (column) to the dataset that gives just the 
#'   last 2 digits of the year? i.e. 2021 becomes 21
# ----

# Bringing steps together with pipes
case_data_oromia_confirmed <- filter(case_data, region == "Oromia", data_type == "confirmed")
case_data_oromia_woreda_months <- select(case_data_oromia_confirmed, woreda, period, count)
case_data_oromia_woreda_months

case_data %>% 
  filter(region == "Oromia", data_type == "confirmed") %>% 
  select(woreda, period, count)

# Save into a new object
oromia_confirmed_cases <- case_data %>% 
  filter(region == "Oromia", data_type == "confirmed") %>% 
  select(woreda, period, count)

# ----
#' Challenge:
#' Using pipes, create a table contain the confirmed cases in January 2019 for 
#' each woreda in Oromia region. 
#' The table should only have two columns (woreda and count)
# ----

# Grouping and summarizing data
oromia_presumed <- case_data %>% 
  filter(data_type == "presumed", region == "Oromia")
sum(oromia_presumed$count, na.rm = T)

# Summarizing for ALL regions
case_data %>% 
  filter(data_type == "presumed") %>% 
  group_by(region) %>% 
  summarise(mean_presumed = mean(count, na.rm = TRUE))

# Multiple summaries
case_data %>% 
  filter(data_type == "presumed") %>% 
  group_by(region, woreda, year) %>% 
  summarise(mean_presumed_per_month = mean(count, na.rm = TRUE), 
            total_presumed_per_month = sum(count, na.rm = TRUE))

# Using the arrange function to organize
case_data %>% 
  filter(data_type == "presumed", 
         year(period) == 2019) %>% 
  group_by(woreda, period) %>% 
  summarise(total_presumed_per_month = sum(count)) %>% 
  arrange(total_presumed_per_month)

case_data %>% 
  filter(data_type == "presumed", 
         year(period) == 2019) %>% 
  group_by(woreda, period) %>% 
  summarise(total_presumed_per_month = sum(count)) %>% 
  arrange(desc(total_presumed_per_month))

# ----
#' Challenge:
#' * What were the total number of confirmed cases in each region in 2019?
#' 
#' * What were the total number of cases (presumed and confirmed) in each month 
#'   for all regions for each year?
#' 
#' * What were the total number of cases (presumed and confirmed) in the peak 
#'   (September - December) and the low (January - April) transmission seasons 
#'   for each woreda in Somali region during 2020?
# ----

# Pivoting a dataframe using the tidyverse
case_data %>% 
  filter(woreda == "Awabel", period == ymd("2020-01-01"))

case_data %>% 
  filter(woreda == "Awabel", period == ymd("2020-01-01")) %>% 
  pivot_wider(names_from = data_type, values_from = count)

# Pivoting "wide" versus "long"
wide_data <- case_data %>% 
  filter(woreda == "Awabel", period == ymd("2020-01-01")) %>% 
  pivot_wider(names_from = data_type, values_from = count)


wide_data %>% 
  pivot_longer(
    names_to = "data_type", values_to = "count", 
    cols = c(confirmed, presumed))

# ----
#' Challenge:
#' * Create a table that contains the total number of confirmed cases each year 
#'   for each region, then pivot wider to make it so the rows are the year and 
#'   there is a column for each region.
#' 
#' * Can you make this table longer again, where we now have 3 columns
#'   (year, region and count)
#' 
#' * Create a table that contains the total number of confirmed cases for each 
#'   woreda and each year in Somali region, now pivot wider to make each woreda 
#'   its own column where year is now the row - start by writing out the steps 
#'   1 by 1 as above
# ----

# Section 6: Joining data with dplyr ---------------
# Simple example
df1 <- tibble(
  id = c(1, 2, 3, 4),
  name = c("Alice", "Bob", "Charlie", "David")
)
print(df1)

df2 <- tibble(
  id = c(1, 2, 4, 5),
  score = c(85, 90, 88, 92)
)
print(df2)

# Combine with left_join
joined_df <- left_join(df1, df2, by = "id")
print(joined_df)

# Dealing with mismatched column names
df3 <- tibble(
  student_id = c(1, 2, 4, 5),
  grade = c("A", "B", "B+", "A-")
)

joined_df2 <- left_join(df1, df3, by = c("id" = "student_id"))
print(joined_df2)

# Examples using training data
confirmed_cases_annual <- read_csv("data/training_case_data_long.csv")
population_annual <- read_csv("data/training_population_data_long.csv")

confirmed_cases_annual
population_annual

annual_incidence <- confirmed_cases_annual %>%
  filter( year == 2020) %>%
  group_by (region, zone, woreda, year) %>%
  summarise(annual_cases = sum(count, na.rm=TRUE)) %>%
  left_join(population_annual, by = c("region" = "region",
                                      "zone" = "zone",
                                      "woreda" = "woreda",
                                      "year" = "year")) %>%
  mutate(api = annual_cases/ population * 1000) %>%
  arrange(desc(api))

# ----
#' Final Challenges:
#' 1. For each region, calculate the total number of cases confirmed by RDT each
#'    year and present as a wide dataframe, where each column is a year and each
#'    row is a region and finally, order the dataframe such that the region with
#'    the most cases in 2020 is at the top.
#' 
#' 2. For each woreda in Oromia region, calculate the proportion of total cases 
#'    in 2020 that were confirmed (confirmed cases / confirmed cases + presumed).
# ----
