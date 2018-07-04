library(RJSONIO)
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
require(XLConnect)

setwd("D:/Dropbox/Faculdade/TCC 1/Nova coleta")
repositories <- read_excel("D:/Dropbox/Faculdade/TCC 1/projectstoextract (Fronchetti).xlsx") # Just the first sheet


## Connecting using oauth_app ##

# myapi = oauth_app("github","93551f3810a3b43c1a70", secret="757f8e2617940908651a23e80705e5eac735dc31") #My Credentials
myapi = oauth_app("github","fa6c0d9b6b607c839d59", secret="cd30d422fbeaa59f3e73d632d0ffb3fe2dd68e9f") #Credentials Wiese
github_token = oauth2.0_token(oauth_endpoints("github"),myapi)
gtoken <- config(token = github_token)

## Getting all the labels of the projects ##

vetName = repositories$name
vetURL = repositories$url
vetLanguage = repositories$language
vetNameToUse = repositories$nametouse

  i = 1
  while(i <= length(repositories$name)){ #Percorre todos os repositories da planilha
    
    Name = vetName[i]
    URL = vetURL[i]
    Language = vetLanguage[i]
    NameToUse = vetNameToUse[i]
    
    
    thepage = readLines(paste("https://github.com/",Name,"/labels",sep=""))
    labels_count = extract_numbers(thepage[grep("js-labels-count",thepage)])
    number_of_pages = round(0.5+(as.numeric(labels_count[1])/100))
  
    j = 1
    while (j <= number_of_pages) {
    
      link = paste("https://api.github.com/repos/",Name,"/labels?page=",j,"&per_page=100",sep="")
      request = GET(link,gtoken)
      json_file = content(request, as="parsed", encoding="UTF-8")
      
      List_of_labels_names = jsonlite::fromJSON(jsonlite::toJSON(json_file))
      
      if (j == 1) {
        Labels = fromJSON(toJSON(List_of_labels_names$name))
      } else {
        Labels = rbind(Labels, fromJSON(toJSON(List_of_labels_names$name)))
      }
      
      write.xlsx(data.frame(Labels), file = paste(Language," - ", NameToUse,".xlsx",sep="") , row.names = FALSE)
      
      j = j+1
    }
    i = i + 1
  
}
#-----------------------------------------------------------------------------------------------------------------------------




