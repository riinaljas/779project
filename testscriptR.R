library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) #
library(tidycensus)
library(fpc)
library(philentropy)
library(data.table)

#to be sure that the census data inquiry works 
#census_api_key('156fda6326a38745b31480cc7848c55e7f4fcf41', overwrite = FALSE, install = TRUE)

#get data for population and income, so that we would have at least two variables 
countyincome <- get_acs(geography = "county", variables = c(medincome="B19013_001"))
population <- get_acs(geography = "county", variables = c(pop= "B00001_001E")) 

population <- population %>% rename(pop = estimate) %>% select(-variable)

countyincome <- left_join(countyincome1, population)

#select only the variables we're interested in 
countyincome <- countyincome %>%
  select(-variable, -moe)

#continue with test variable

t <- countyincome %>% remove_rownames() %>% column_to_rownames(var="NAME") %>% select(-GEOID)

#be sure there's no NA-s
t <- na.omit(t)

#calculate the euclidean distance 
euc <- distance(t, method = "euclidean")

#create a function to sort all the counties by which one is the closest to x

close <- function(x, value, tol=NULL){
  if(!is.null(tol)){
    x[abs(x-10) <= tol]
  } else {
    x[order(abs(x-10))]
  }
}


# have rownames as names so we know which places we're talking about 
euc2 <- euc[1] %>% rownames_to_column()
y <- as.data.frame(close(euc2$v1, value=12603.618, tol=NULL)) 
y <- y %>% 
  rename(v1 = `close(euc2$v1, value = 12603.618, tol = NULL)` )

y = y %>% left_join(euc2)


###next steps: look into shiny, fix code, make it to functions 


