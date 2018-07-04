library(RJSONIO)
library(jsonlite)
library(httr)
library(stringi)
library(stringr)
library(chron) 
library(xlsx)
library(readxl)
library(filesstrings)
require(reshape2)
library(Rcrawler)
require(XLConnect)



setwd("D:/Dropbox/Faculdade/Visualização de Dados/Base VD")
repositories <- read_excel("D:/Dropbox/Faculdade/Visualização de Dados/Base VD/Lista de Projetos (1).xlsx") # Just the first sheet

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
print(length(repositories$name))
while(i <= length(repositories$name)){ #Percorre todos os repositories da planilha
  
  Name = vetName[i]
  URL = vetURL[i]
  Language = vetLanguage[i]
  NameToUse = vetNameToUse[i]
  
  
  link = paste0("https://api.github.com/repos/",Name,"")
  mainPage = readLines(paste("https://github.com/",Name,"/",sep=""))
  issuesPage = readLines(paste("https://github.com/",Name,"/issues",sep="")) #Lê HTML
  pullsPage = readLines(paste("https://github.com/",Name,"/pulls",sep=""))
  
  print(link)
  
  request = GET(link,gtoken)
  
  json_file = content(request, as="parsed", encoding="UTF-8")
  
  fullname = jsonlite::fromJSON(jsonlite::toJSON(json_file$full_name))
  created_at = unlist(strsplit(as.character(jsonlite::fromJSON(jsonlite::toJSON(json_file$created_at))), "T"))[1]
  size = jsonlite::fromJSON(jsonlite::toJSON(json_file$size)) #Size Lines
  language = jsonlite::fromJSON(jsonlite::toJSON(json_file$language))
  stars_count = jsonlite::fromJSON(jsonlite::toJSON(json_file$stargazers_count))
  forks_count = jsonlite::fromJSON(jsonlite::toJSON(json_file$forks_count))
  issues_open_count = jsonlite::fromJSON(jsonlite::toJSON(json_file$open_issues_count))
  isses_open_count_git = gsub("Open","",gsub(" ", "", issuesPage[grep("btn-link",issuesPage)+2][1], fixed = TRUE))#Pega a qtd de issues Open pelo HTML
  issues_closed_count_git = gsub("Closed","",gsub(" ", "", issuesPage[grep("btn-link",issuesPage)+2][2], fixed = TRUE))
  subscribers_count = jsonlite::fromJSON(jsonlite::toJSON(json_file$subscribers_count))
  commits_count = gsub(" ", "", mainPage[grep("num text-emphasized",mainPage)+1][1], fixed = TRUE)
  branches_count = gsub(" ", "", mainPage[grep("num text-emphasized",mainPage)+1][2], fixed = TRUE)
  releases_count = gsub(" ", "", mainPage[grep("num text-emphasized",mainPage)+1][3], fixed = TRUE)
  contributors_count = gsub(" ", "", mainPage[grep("num text-emphasized",mainPage)+1][4], fixed = TRUE)
  pulls_open_count_git = gsub("Open","",gsub(" ", "", pullsPage[grep("btn-link",pullsPage)+2][1], fixed = TRUE))
  pulls_closed_count_git = gsub("Closed","",gsub(" ", "", pullsPage[grep("btn-link",pullsPage)+2][2], fixed = TRUE))

  cat("Name : ",fullname,"\n")
  cat("Created :", created_at,"\n")
  cat("Lines :" ,size,"\n")
  cat("Language :" ,language,"\n")
  cat("Stars :" ,stars_count,"\n")
  cat("Fork :" ,forks_count,"\n")
  # cat("Issues Open API :" ,open_issues_count,"\n")
  cat("Issues Open GiT :" ,isses_open_count_git,"\n")
  cat("Issues Closed GiT :" ,issues_closed_count_git,"\n")
  cat("Pulls Open GiT :" ,pulls_open_count_git,"\n")
  cat("Pulls Closed GiT :" ,pulls_closed_count_git,"\n")
  cat("Watches :" ,subscribers_count,"\n")
  cat("Commits :" ,commits_count,"\n")
  cat("Contributors :" ,contributors_count,"\n")
  cat("Branches :" ,branches_count,"\n")
  cat("Releases :" ,releases_count,"\n")

  i = i + 1
  
}

# combined = cbind(vetName,vetLanguage,FirstDates)
# rownames(combined) <- c()
# colnames(combined) <- c("Projeto", "Label", "Primeira Ocorrência")
# 
# write.xlsx(data.frame(combined), file = paste("Primeira Ocorrência.xlsx",sep="") , row.names = FALSE)


#-----------------------------------------------------------------------------------------------------------------------------




