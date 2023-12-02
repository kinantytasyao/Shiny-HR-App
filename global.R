library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(tidyverse)
library(plotly)
library(scales)
library(glue)
library(caret)
library(randomForest)

data_attrition <- read_csv(file = 'data_input/data-attrition.csv')

cat_var <- data_attrition %>% 
  select(gender, education, 
         education_field, 
         work_life_balance,
         marital_status) %>% 
  colnames() %>% 
  str_replace_all(pattern = "_", replacement = " ") %>% 
  str_to_title()

num_var <- data_attrition %>% 
  select(age, distance_from_home, 
         total_working_years, 
         num_companies_worked) %>% 
  colnames() %>% 
  str_replace_all(pattern = "_", replacement = " ") %>% 
  str_to_title()

