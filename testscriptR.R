library(tidyverse)  # data manipulation
library(cluster)  # clustering algorithms
library(tidycensus)
library(fpc)
library(philentropy)
library(data.table)
library(readr)

#to be sure that the census data inquiry works, needs to be run only first time 
census_api_key('156fda6326a38745b31480cc7848c55e7f4fcf41', overwrite = FALSE, install = TRUE)

#ask input from the user 

myvar <- as.character(readline("Enter the county: "))
choicelist <- countyincome$NAME

#get data for population and income, so that we would have at least two variables 
countyincome <- get_acs(geography = "county", variables = c(medincome="B19013_001")) %>% select(-variable, -moe)
population <- get_acs(geography = "county", variables = c(pop= "B01003_001E")) %>% select(-variable, -moe)
age <- get_acs(geography = "county", variables = c(age = "B01002_001E")) %>% select(-variable, -moe)


#rename so that we wouldn't have same variables 
population <- population %>% rename(pop = estimate)
age <- age %>% rename(age = estimate)

data <- left_join(countyincome, population) %>%
  left_join(age)


#be sure there's no NA-s

data <- na.omit(data)

#create a second data variable to remove, so that the code would only deal with numeric variables 

data2 <- data %>% column_to_rownames(var="NAME") %>% select(-GEOID)

#calculate eucledian distance 

eucdata <- as.data.frame(distance(data2, method = "euclidean")) %>%
  rownames_to_column()

data <- bind_cols(data, eucdata) %>% column_to_rownames(var = "rowname")
#create a function to sort all the counties by which one is the closest to x



v1 <- as.data.frame(eucdata$rowname)
data <- bind_cols(v1, data) %>% rename(vname = 1)

write_rds(data, "sampledata.RDS")

close <- function(x, value, tol=NULL){
  if(!is.null(tol)){
    x[abs(x-10) <= tol]
  } else {
    x[order(abs(x-10))]
  }
}

find_close_county(data, myvar)


find_close_county()
#use the "close" function to get the end result "countylist"

countylist <- as.data.frame(close(data[ ,myvar], value=0, tol=NULL)) %>% rename(!!myvar := 1)
countylist <- countylist %>% left_join(data) %>% select(1:5) %>% rename(euclidean_distance = 1) 

#try with small first 

# small <- head(t, 100)
# small2 <- head(t2, 100)
# 
# eucsmall <- as.data.frame(distance(small2, method = "euclidean")) %>%
#   rownames_to_column()
# 
# small <- bind_cols(small, eucsmall) %>% column_to_rownames(var = "rowname")

#test whether the algorith gives correct results 
# 
# countylist25 <- as.data.frame(close(small[ ,myvar], value=0, tol=NULL)) %>% rename(!!myvar := 1)
# countylist <- as.data.frame(close(small$v25, value=0, tol=NULL)) %>% rename(!!myvar := 1)
# countylist <- countylist %>% left_join(small) %>% select(1:5)

#test whether they're the same
#anti_join(countylist25, countylist) %>% nrow()

###next steps: look into shiny, fix code, make it to functions 



