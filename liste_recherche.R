library(sampling)
library(doBy)

setwd("C:/Users/benoit/Documents/SNCF")

###
# Définir les recherches
###

# trajet

# tableau_trajet <- data.frame(villeD=NA,villeA=NA)[0,]
# 
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Paris","Lille")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Lille","Paris")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Paris","Amsterdam")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Amsterdam","Paris")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Paris","Londres")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Londres","Paris")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Paris","Lyon")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Lyon","Paris")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Paris","Marseille")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Marseille","Paris")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Lyon","Marseille")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Marseille","Lyon")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Lille","Lyon")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Lyon","Lille")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Paris","Bordeaux")
# tableau_trajet[nrow(tableau_trajet)+1,] <-  list("Bordeaux","Paris")
# 
# vecteur_trajet <- c(1:nrow(tableau_trajet))
# 
# tableau_heures <- c(7,13,17)
# 
# tableau_type_voy <- c("ADULT","JOUNG","SENIOR")
# 
# tableau_carte_voy <- c(TRUE,FALSE)
# 
# tableau_jours <- format(seq.Date(as.Date("2018/9/4"),as.Date("2018/12/2"),by='day'),"%d/%m/%Y")
# 
# univers_recherche <- expand.grid(vecteur_trajet,tableau_jours,tableau_heures,tableau_type_voy,tableau_carte_voy)
# 
# colnames(univers_recherche) <- c("id_trajet","jourD","heureD","id_type_voyageur","id_carte_voyageur")
# univers_recherche$villeD <- tableau_trajet[univers_recherche$id_trajet,'villeD']
# univers_recherche$villeA <- tableau_trajet[univers_recherche$id_trajet,'villeA']
# 
# strate <- summaryBy(villeA~villeD+villeA+id_type_voyageur+id_carte_voyageur,data=univers_recherche,FUN=length)
# 
# strate$taille <- 10
# strate[strate$id_type_voyageur == "ADULT" & strate$id_carte_voyageur,'taille'] <- 0
# strate[strate$id_type_voyageur == "ADULT" & !strate$id_carte_voyageur,'taille'] <- 15
# strate[strate$id_type_voyageur == "JOUNG",'taille'] <- 5
# strate[strate$id_type_voyageur == "SENIOR",'taille'] <- 5
# strate$prob <- strate$taille / strate$villeA.length
# 
# univers_recherche$prob <- 0
# for (i in 1:nrow(univers_recherche)){
#   univers_recherche[i,'prob'] <- strate[strate$villeD == univers_recherche[i,'villeD'] & strate$villeA == univers_recherche[i,'villeA'] & strate$id_type_voyageur == univers_recherche[i,'id_type_voyageur'] & strate$id_carte_voyageur == univers_recherche[i,'id_carte_voyageur'],'prob']
# }
# 
# summaryBy(prob~villeD+villeA+id_type_voyageur+id_carte_voyageur,data=univers_recherche,FUN=mean)
# summaryBy(prob~id_type_voyageur+id_carte_voyageur,data=univers_recherche,FUN=mean)
# 
# set.seed(110287)
# list_echantillon <- sample(1:nrow(univers_recherche),800,prob=univers_recherche$prob) 
# 
# tableau_recherche <- univers_recherche[list_echantillon,]
# 
# summaryBy(villeA~villeD+villeA,data=tableau_recherche,FUN=length)
# summaryBy(villeA~id_type_voyageur+id_carte_voyageur,data=tableau_recherche,FUN=length)
# summaryBy(villeA~id_type_voyageur,data=tableau_recherche,FUN=length)
# summaryBy(villeA~jourD,data=tableau_recherche,FUN=length)
# 
# tableau_recherche$id_recherche <- 1:nrow(tableau_recherche)
# 
# write.csv2(tableau_recherche,file='tableau_recherche.csv')
# save(tableau_recherche,file='tableau_recherche')
