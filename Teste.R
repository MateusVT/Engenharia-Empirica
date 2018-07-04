library(tidyverse)
library(lubridate)
library(nycflights13)




# setwd("C:/Users/Mateu/Dropbox/Engenharia Empírica")

repositories <- read.csv("D:/Dropbox/Faculdade/Engenharia Empírica/R PORRA.csv") # Just the first sheet
vetorRep = as.vector(t(repositories))

# seq(as.Date(vetorRep),by=1, len=7) 
teste = format(as.Date(vetorRep), "%U")
print(teste)
# strftime(repositories, format = "%V")
