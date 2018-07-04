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
library(httr)
library(httpuv)
require(reshape2)
require(XLConnect)

#Diretório para saída .xlsx
setwd("C:/Users/Mateu/Dropbox/Engenharia Empírica/Saída")

#Planilha de entrada
repositories <- read_excel("C:/Users/Mateu/Dropbox/Engenharia Empírica/Entrada/projectstoextract Test - Cópia.xlsx") # Just the first sheet


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
vetLabel = repositories$newcomerslabel


  i = 1
  j = 1
  while(i <= length(repositories$name)){ #Percorre todos os repositories da planilha
    
    Name = vetName[i]
    URL = vetURL[i]
    Language = vetLanguage[i]
    NameToUse = vetNameToUse[i]
    NewComerLabel = vetLabel[i]
    issuesPage = readLines(paste("https://github.com/",Name,"/issues",sep=""))#Lê HTML
    issues_open_count_git = gsub("Open","",gsub(" ", "", issuesPage[grep("btn-link",issuesPage)+2][1], fixed = TRUE))#pega a qtd de issue open pelo HTML
    number_of_pages = round(0.5+(as.numeric(gsub(",","",issues_open_count_git))/100))#pega o numero de issue open e divide por 100 arredondando pra cima
    
    j = 1
    while (j <= number_of_pages) {
      # link = str_replace_all(paste0("https://api.github.com/search/issues?page=1&per_page=100&q=is:issue+label:%22",NewComerLabel,"%22+sort:created-asc+repo:",Name,"")," ", "%20")
      link = paste0("https://api.github.com/search/issues?page=",j,"&per_page=100&q=is:issue+is:open+repo:",Name,"")
      print(link)
      if(j%%9 == 0){
      print("entrei")
       
      # makeActiveBinding("refresh", function() { system("R"); q("yes") }, .GlobalEnv)
      # Sys.sleep(61)
      }

      request = GET(link, gtoken)
      if(j==1){
        json_file1 = content(request, as="parsed", encoding="UTF-8")
      }
      
      json_file = content(request, as="parsed", encoding="UTF-8")
     
      # oldest_Label = jsonlite::fromJSON(jsonlite::toJSON(json_file$items[1]))
       issue = jsonlite::fromJSON(jsonlite::toJSON(unlist(json_file$items[1])))
       j = j + 1
      
       # issue = json_file$items[1]
       # carac_issue = unlist(issue);
       # print(carac_issue[7])
      # print(issue[1])
      # print(json_file)
       # print(json_file$items[1])
    }
    i = i + 1
    link = paste0("https://api.github.com/search/issues?page=",j,"&per_page=100&q=is:issue+is:open+repo:",Name,"")
    print(link)
    request = GET(link, gtoken)
    json_file = content(request, as="parsed", encoding="UTF-8")
  }
  # rbind
  # combined = cbind(vetName,vetLabel,FirstDates)
  # rownames(combined) <- c()
  # colnames(combined) <- c("Projeto", "Label", "Primeira Ocorrência")
  # 
  # write.xlsx(data.frame(combined), file = paste("Primeira Ocorrência.xlsx",sep="") , row.names = FALSE)
#------------------------------------------------




