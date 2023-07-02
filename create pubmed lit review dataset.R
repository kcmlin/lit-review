#######################################
# Create a literature review list from a PubMed pull
#
# Katherine Schaughency
# created: 13 June 2023
# updated: 2 July 2023 
#######################################

#------------------------------------#
# load R package

library(tidyverse)

#------------------------------------#
# set working directory

setwd("/Users/katherineschaughency/Documents/GitHub/lit-review/")

#------------------------------------#
# read exported file from pubmed
# create an unique id for each new article

pubmed <- read.csv("exportlist.csv", header=F) %>% 
            mutate(seq.id = 1:n()) %>% 
            mutate(new.article = case_when(str_detect(V1, paste0("^","%0 ")) ~ "X")) %>% 
            mutate(new.article.id = case_when(new.article=="X" ~ paste0(new.article, seq.id))) %>% 
            fill(new.article.id) %>% 
            select(-seq.id,-new.article)
  

# preview data
View(pubmed)
dim(pubmed)

#------------------------------------#
# pull out relevant rows to create a dataset for title review
# rename variables to relevant title
# preview data


# publication year
pubmed.year <- pubmed %>% filter(str_detect(V1, paste0("^","%D"))) %>% 
                    rename(year = V1)
dim(pubmed.year)
head(pubmed.year)

# publication journal
pubmed.journal <- pubmed %>% filter(str_detect(V1, paste0("^","%B"))) %>% 
                    rename(journal = V1)
dim(pubmed.journal)
head(pubmed.journal)

# PMID
pubmed.pmid <- pubmed %>% filter(str_detect(V1, paste0("^","%M"))) %>% 
                    rename(pmid = V1)
dim(pubmed.pmid)
head(pubmed.pmid)

# first author
pubmed.author <- pubmed %>% filter(str_detect(V1, paste0("^","%A"))) %>% 
                    rename(author = V1) %>% 
                    group_by(new.article.id) %>% 
                    slice(1) %>% 
                    ungroup() 
dim(pubmed.author)
head(pubmed.author)

# title
pubmed.title <- pubmed %>% filter(str_detect(V1, paste0("^","%T"))) %>% 
                    rename(title = V1)
dim(pubmed.title)
head(pubmed.title)

# URL
pubmed.url <- pubmed %>% filter(str_detect(V1, paste0("^","%U"))) %>% 
                    rename(url = V1)
dim(pubmed.url)
head(pubmed.url)

# abstract
pubmed.abstract <- pubmed %>% filter(str_detect(V1, paste0("^","%X"))) %>% 
                    rename(abstract = V1)
dim(pubmed.abstract)
head(pubmed.abstract)


#------------------------------------#
# combine key variables into one dataset for title and abstract reviews

join.1 <- left_join(x = pubmed.year %>% select(new.article.id, year), 
                    y = pubmed.journal, 
                    by = "new.article.id")
join.2 <- left_join(x = join.1,
                    y = pubmed.pmid,
                    by = "new.article.id")
join.3 <- left_join(x = join.2,
                    y = pubmed.author,
                    by = "new.article.id")
join.4 <- left_join(x = join.3,
                    y = pubmed.title,
                    by = "new.article.id")
join.5 <- left_join(x = join.4,
                    y = pubmed.abstract,
                    by = "new.article.id")
join.6 <- left_join(x = join.5,
                    y = pubmed.url,
                    by = "new.article.id")

review <- join.6

# preview data
View(head(review))
dim(review)


#------------------------------------#
# export the unique list for review

write.csv(x = review, 
          file = "title and abstract review list.csv",
          row.names = F)


