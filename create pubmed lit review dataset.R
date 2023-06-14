#######################################
# Create Lit Review List from PubMed Pull
#
# Katherine Schaughency
# 13 June 2023
#######################################

#------------------------------------#
# load R package

library(tidyverse)

#------------------------------------#
# read exported file from pubmed

pubmed <- read.csv("/Users/katherineschaughency/Desktop/Desktop/Work Related/exportlist.csv", header=F)

# preview data
View(pubmed)
dim(pubmed)

#------------------------------------#
# pull out relevant rows to create a dataset for title review
# rename variables to relevant title
# preview data

# english only journal
pubmed.eng <- pubmed  %>% filter(str_detect(V1, paste0("^","%G eng"))) %>% rename(eng = V1) 
dim(pubmed.eng)
head(pubmed.eng)

# publication year
pubmed.year <- pubmed %>% filter(str_detect(V1, paste0("^","%D"))) %>% rename(year = V1)
dim(pubmed.year)
head(pubmed.year)

# publication journal
pubmed.journal <- pubmed %>% filter(str_detect(V1, paste0("^","%B"))) %>% rename(journal = V1)
dim(pubmed.journal)
head(pubmed.journal)

# PMID
pubmed.pmid <- pubmed %>% filter(str_detect(V1, paste0("^","%M"))) %>% rename(pmid = V1)
dim(pubmed.pmid)
head(pubmed.pmid)

# first author
pubmed.author <- pubmed %>% filter(str_detect(V1, paste0("^","%A"))) %>% rename(author = V1)
dim(pubmed.author)
head(pubmed.author)

# title
pubmed.title <- pubmed %>% filter(str_detect(V1, paste0("^","%T"))) %>% rename(title = V1)
dim(pubmed.title)
head(pubmed.title)

# URL
pubmed.url <- pubmed %>% filter(str_detect(V1, paste0("^","%U"))) %>% rename(url = V1)
dim(pubmed.url)
head(pubmed.url)


#------------------------------------#
# combine key variables into one dataset for title review
# deduplicate entries

title.review <- cbind(pubmed.year, pubmed.journal, pubmed.pmid, pubmed.title) %>% filter(!duplicated(join.4))

# preview data
View(head(title.review))
dim(title.review)


#------------------------------------#
# export the unique list for review

write.csv(x = title.review, 
          file = "/Users/katherineschaughency/Desktop/Desktop/Work Related/title review list.csv",
          row.names = F)


