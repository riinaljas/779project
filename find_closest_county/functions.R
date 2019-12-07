

#write script to the program fucntion 
find_close_county <- function(y) {countyincome <- get_acs(geography = "county", variables = c(medincome="B19013_001")) %>% select(-variable, -moe)
population <- get_acs(geography = "county", variables = c(pop= "B00001_001E")) %>% select(-variable)

population <- population %>% rename(pop = estimate)

data <- left_join(countyincome, population) 

#be sure there's no NA-s

data <- na.omit(data)

#create a second data variable to remove, so that the code would only deal with numeric variables 

data2 <- data %>% column_to_rownames(var="NAME") %>% select(-GEOID)

#calculate eucledian distance 

eucdata <- as.data.frame(distance(data2, method = "euclidean")) %>%
  rownames_to_column()

data <- bind_cols(data, eucdata) %>% column_to_rownames(var = "rowname")
#create a function to sort all the counties by which one is the closest to x

close <- function(x, value, tol=NULL){
  if(!is.null(tol)){
    x[abs(x-10) <= tol]
  } else {
    x[order(abs(x-10))]
  }
}
countylist <- as.data.frame(close(data[ ,myvar], value=0, tol=NULL)) %>% rename(!!myvar := 1)
countylist <- countylist %>% left_join(data) %>% select(1:5) %>% rename(euclidean_distance = 1)
View(countylist)
  
}


