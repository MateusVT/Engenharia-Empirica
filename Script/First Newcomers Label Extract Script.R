library(RJSONIO)
library(RCurl)
library(jsonlite)
library(httr)
library(stringi)
library(chron) 
library(xlsx)
library(readxl)
# library(RCulr)
# library(XML)
library(filesstrings)
require(reshape2)
# require(XLConnect)

#Diretório para saída .xlsx
# setwd("D:/Dropbox/Faculdade/Engenharia Empírica/Saída")
setwd("C:/Users/Mateu/Dropbox/Engenharia Empírica/Saída")

#Planilha de entrada

# repositories <- read_excel("D:/Dropbox/Faculdade/Engenharia Empírica/Entrada/Processed Laplace projectstoextract (Fronchetti) FirstOcurrency - Full - Copia(CONCATENADO)  - clear.xlsx") # Just the first sheet
repositories <- read_excel("C:/Users/Mateu/Dropbox/Engenharia Empírica/Entrada/Processed Laplace projectstoextract (Fronchetti) FirstOcurrency - Full - Copia(CONCATENADO)  - clear small.xlsx") # Just the first sheet


## Connecting using oauth_app ##

# myapi = oauth_app("github","93551f3810a3b43c1a70", secret="757f8e2617940908651a23e80705e5eac735dc31") #My Credentials
# myapi = oauth_app("github","fa6c0d9b6b607c839d59", secret="cd30d422fbeaa59f3e73d632d0ffb3fe2dd68e9f") #Credentials Wiese
myapi = oauth_app("github","c08b4079861faf053146", secret="8800ec35a11848dd9ee2bc74239f1bf7fe211505") #Credentials Laplace
github_token = oauth2.0_token(oauth_endpoints("github"),myapi)
gtoken <- config(token = github_token)

## Getting the first ocurrency of a label for newcomers in the projects ##


vetName = repositories$name
vetURL = repositories$url
vetLanguage = repositories$language
vetNameToUse = repositories$nametouse
vetLabel = repositories$concatenado
newVect = NULL


  i = 1
  j = 1
  while(i <= length(repositories$name)){ #Percorre todos os repositories da planilha
    
    Name = vetName[i]
    URL = vetURL[i]
    Language = vetLanguage[i]
    NameToUse = vetNameToUse[i]
    fullNewComerLabel = vetLabel[i]
    vetFullNewComerLabel = unlist(strsplit(as.character(fullNewComerLabel), ";"))
    vetDatesFullNewComerLabel = NULL
    
    for(k in 1:length(vetFullNewComerLabel)){  
      
      # if(vetFullNewComerLabel[k]!="-" && vetFullNewComerLabel[k] !="X"){
      
      link = str_replace_all(paste0("https://api.github.com/search/issues?page=1&per_page=100&q=is:issue+label:%22",vetFullNewComerLabel[k],"%22+sort:created-asc+repo:",Name,"")," ", "%20")
      print(link)
      
    

      # fileConn<-file("D:/Dropbox/Faculdade/TCC 1/Scripts/First Newcomers Label Extract Script/output.txt")
      # writeLines(c(link), fileConn)
      # close(fileConn)

      request = GET(link,gtoken)
      json_file = content(request, as="parsed", encoding="UTF-8")
     
      oldest_Label = jsonlite::fromJSON(jsonlite::toJSON(json_file$items[1]))
      
      
      
      vet_data_oldest_label = unlist(strsplit(as.character(oldest_Label$created_at), "T"))
      # data_oldest_label = fromJSON(toJSON(vet_data_oldest_label[1]))
      
      
      if (j == 1) {
        FirstDates = fromJSON(toJSON(vet_data_oldest_label[1]))
      } else {

        if(is.null(vet_data_oldest_label[1])){
          FirstDates = rbind(FirstDates,"0000-00-00")
        }else{
          FirstDates = rbind(FirstDates, fromJSON(toJSON(vet_data_oldest_label[1])))
        }
       
      }
      
      data_oldest_label = vet_data_oldest_label[1]

      
      
      if(is.null(data_oldest_label)){
        data_oldest_label = paste0("0000-00-00")
        # vetDatesFullNewComerLabelAsDate = paste0("ERROR")
      }
      
      if(!data_oldest_label == "0000-00-00"){
        
        vetDatesFullNewComerLabel <- c(vetDatesFullNewComerLabel, data_oldest_label)
        vetDatesFullNewComerLabelAsDate <- as.Date(vetDatesFullNewComerLabel)
        
      }
      
      # if(length(vetDatesFullNewComerLabel)>1){
      
    }
       if(is.null(vetDatesFullNewComerLabelAsDate[1])){
         print(vetDatesFullNewComerLabelAsDate[1])
         oldestDate = paste0("ERROR")
       }else{
         oldestDate = sort(vetDatesFullNewComerLabelAsDate)[1]
       }
      
       
        print(oldestDate)
        # print(oldestDate)
        # print(FirstDates)
        # oldestDate <- c(oldestDate)
        # resultados = oldestDate
        # resultados <- append(resultados, oldestDate)
        
        newVect = rbind(newVect, oldestDate)
        
        # vetDatesFullNewComerLabelAsDate <- NULL
        
      # }
      
      
      
    # }
    # }
    
    i = i + 1
    j = j + 1
    
      
  }
 
  
  teste <- rbind(as.character(newVect))
  # teste = rbind(as.character(as.Date(newVect,origin='1970-01-01')))
  # teste2 = as.data.frame(do.call(rbind, teste))
  
  combined = cbind(vetName,vetLabel,newVect)
  # combined = cbind(vetName,vetLabel,FirstDates)
  
  rownames(combined) <- c()
  colnames(combined) <- c("Projeto", "Label", "Primeira Ocorrência")
 
  write.xlsx(data.frame(combined), file = paste("Primeira Ocorrência.xlsx",sep="") , row.names = FALSE)
  # write.xlsx(data.frame(combined), file = paste(Language," - ", NameToUse,".xlsx",sep="") , row.names = FALSE)
#------------------------------------------------




