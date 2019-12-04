library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) #
library(tidycensus)
library(fpc)
library(philentropy)
library(data.table)

df <- USArrests
df <- na.omit(df)
df <- scale(df)
?scale

distance <- get_dist(tarr)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

census_api_key('156fda6326a38745b31480cc7848c55e7f4fcf41', overwrite = FALSE, install = TRUE)


countyincome1 <- get_acs(geography = "county", variables = c(medincome="B19013_001"))
countyincome2 <- get_acs(geography = "county", variables = c(pop= "B00001_001E")) 

countyincome2 <- countyincome2 %>% rename(pop = estimate) %>% select(-variable)

countyincome <- left_join(countyincome1, countyincome2)

countyincome <- countyincome %>%
  select(-variable, -moe)

t <- countyincome %>% remove_rownames() %>% column_to_rownames(var="NAME") %>% select(-GEOID)

t <- na.omit(t)


k2 <- kmeans(t, centers = 25, nstart = 6)

fviz_cluster(k2, data = t)

cluster.stats(d, )

distance(t, method = "euclidean")

euc <- distance(t, method = "euclidean")

euc <- as.data.frame(euc)


#ou can use data.table to do a binary search:
  
dt = data.table(euc) # you'll see why val is needed in a sec
setkey(dt, "euc")
dt[J(v16), roll = "nearest"]
dt[J(v16), .I, roll = "nearest", by = .EACHI]


rm(x)


close <- function(x, value, tol=NULL){
  if(!is.null(tol)){
    x[abs(x-10) <= tol]
  } else {
    x[order(abs(x-10))]
  }
}
euc2 <- euc[1] %>% rownames_to_column()
y <- as.data.frame(close(euc2$v1, value=12603.618, tol=NULL)) 
y <- y %>% 
  rename(v1 = `close(euc2$v1, value = 12603.618, tol = NULL)` )

y = y %>% left_join(euc2)


###next steps: look into shiny, fix code, make it to functions 


