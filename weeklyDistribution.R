library(tidyverse)
library(lubridate)
library(nycflights13)




# setwd("C:/Users/Mateu/Dropbox/Engenharia Empírica")

repositories <- read.csv("D:/Dropbox/Faculdade/Engenharia Empírica/R PORRA.csv") # Just the first sheet
vetorRep = as.vector(t(repositories))

# seq(as.Date(vetorRep),by=1, len=7) 
weeklyID = format(as.Date(vetorRep), "%U")
byYear = format(as.Date(vetorRep), "%Y")

for (year in 2010:2015){
  print(paste("The year is", year))
}


print(teste)
# strftime(repositories, format = "%V")
