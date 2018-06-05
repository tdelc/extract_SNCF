saveData <- function(name,data) {
  table <- gs_title(name)
  if (class(table) == "try-error") {
    table <- gs_new(name)
  }
  gs_add_row(table, ws = 1, input = data)
  # gs_edit_cells(table, ws = 1, input = data)
}

loadData <- function(name) {
  liste <- gs_ls()
  id_sheet <- as.character(liste[liste$sheet_title == name,][1,'sheet_key'])
  table <- gs_key(id_sheet)
  gs_read_csv(table)
}

fichier_sncf <- "prix-sncf6"
fieldsTable <- c("timestamp","id_trajet","id_resultat","jourD","heureD","heureA","duree","transport","id_type_voyageur","id_carte_voyageur","villeD","villeA"," prix_noflex","prix_noflex_label"," prix_semiflex","prix_semiflex_label"," prix_flex","prix_flex_label","prix_upsell","prix_upsell_label")

tableau_prix <- try(loadData(fichier_sncf), silent = TRUE)
if (class(tableau_prix) == "try-error") {
  cat("Probleme connexion load google sheet 2")
  tableau_prix <-
    data.frame(matrix(ncol = length(fieldsTable), nrow = 0))
  colnames(tableau_prix) <- fieldsTable
  table_google <- gs_new(fichier_sncf)
  gs_edit_cells(table_google, ws = 1, input = tableau_prix)
}

###
# Fonctions web
###

detect_captcha <- function(){
  if (grepl("Nos systèmes ont détecté un trafic exceptionnel sur votre réseau informatique",remDr$getPageSource()) == 1){
    print("Problème captcha")
    Sys.sleep(60*10)
    reboot_remDr()
    print(1)
  }
  print(0)
}

recup_web <- function(webElem,using,value,type="text"){
  if (class(webElem) == "remoteDriver"){
    temp <- webElem$findElements(using,value)
  }else{
    temp <- webElem$findChildElements(using,value)
  }
  if (length(temp)==0){
    NA
  }else{
    if (type=="text"){
      temp[[1]]$getElementText()[[1]]
    }else{
      temp[[1]]$getElementAttribute(type)[[1]]
    }
  }
}

# eCap <- list(phantomjs.binary.path = "phantomjs.exe")
reboot_remDr <- function(){
  try(remDr$close(),silent = TRUE)
  remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4444, browserName = "chrome")
  # remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)
  Sys.sleep(5)
  try(remDr$open(),silent = TRUE)
  Sys.sleep(5)
  remDr <<- remDr
}

reboot_remDr()


boucleSNCF <- function(nb_requete){ 
	k_requete <- 1
	while (k_requete < nb_requete){
	  
	  print(k_requete)
	  print(round(k_requete/nb_requete,0))
	  k_requete <- k_requete+1
	  
	  if (runif(1)<0.05) reboot_remDr()
	  
	  # Sys.sleep(10)
	  
	  # Choix d'un trajet au hasard parmi ceux potentiellement dispo
	  # Tout est libre jusqu'au 4/09/2018

	  diff_date <- as.Date(as.character(tableau_recherche$jourD),format="%d/%m/%Y") - as.Date(Sys.time())
	  
	  sub <- tableau_recherche[diff_date<92,"id_recherche"]
	  id_recherche <- sample(sub,1)
	  
	  url <- "https://be.oui.sncf/fr/"
	  remDr$navigate(url)
	  
	  # test si blocage avec captcha
	  
	  # if (remDr$getCurrentUrl()[[1]] != "https://be.oui.sncf/fr/"){
	  #   Sys.sleep(60*10)
	  #   reboot_remDr()
	  # }
	  if(detect_captcha() == 1) next

		try(remDr$findElement("xpath","//div[@class='vsc__lightbox__container']/button[@aria-label='close']")$clickElement(),silent=TRUE)
		
		try(villeD <- remDr$findElement("id","vsb-origin-train"),silent=TRUE)
		try(villeD$clearElement(),silent=TRUE)
		try(villeD$clickElement(),silent=TRUE)
		try(villeD$sendKeysToElement(list(tableau_recherche$villeD[id_recherche])),silent=TRUE)
		try(villeD$sendKeysToActiveElement(list(tableau_recherche$villeD[id_recherche])),silent=TRUE)
		Sys.sleep(1)
		
		try(villeA <- remDr$findElement("id","vsb-destination-train"),silent=TRUE)
		try(villeA$clearElement(),silent=TRUE)
		try(villeA$clickElement(),silent=TRUE)
		try(villeA$sendKeysToElement(list(tableau_recherche$villeA[id_recherche])),silent=TRUE)
		try(villeA$sendKeysToActiveElement(list(tableau_recherche$villeA[id_recherche])),silent=TRUE)
		Sys.sleep(1)
		
		try(jourD <- remDr$findElement("id","vsb-departure-date-train"),silent=TRUE)
		try(jourD$clearElement(),silent=TRUE)
		try(jourD$clickElement(),silent=TRUE)
		try(jourD$sendKeysToActiveElement(list(tableau_recherche$jourD[id_recherche])),silent=TRUE)
		Sys.sleep(1)
		
		try(heureD <- remDr$findElement("id","vsb-departure-time-train"),silent=TRUE)
		try(heureD$clearElement(),silent=TRUE)
		try(heureD$clickElement(),silent=TRUE)
		try(heureD$sendKeysToActiveElement(list(tableau_recherche$heureD[id_recherche])),silent=TRUE)
		Sys.sleep(1)
		
		try(heureD <- remDr$findElement(using = 'xpath', paste("//*/option[@value = '",tableau_recherche$heureD[id_recherche],"']",sep="")),silent=TRUE)
		try(heureD$clickElement(),silent=TRUE)
		Sys.sleep(1)
		
		try(type_voyageur <- remDr$findElement(using = 'xpath', paste("//*/option[@value = '",tableau_recherche$id_type_voyageur[id_recherche],"']",sep="")),silent=TRUE)
		try(type_voyageur$clickElement(),silent=TRUE)
		Sys.sleep(1)
		
		try(carte_voyageur <- remDr$findElement(using = 'xpath', "//input[@id = 'PASSENGER_1_CARD']"),silent=TRUE)
		try(carte_voyageur$clickElement(),silent=TRUE)
		if (tableau_recherche$id_carte_voyageur[id_recherche]){
		  if (tableau_recherche$id_type_voyageur[id_recherche] == "SENIOR"){
			try(carte_voyageur <- remDr$findElement(using = 'xpath', "//li[@id = 'PASSENGER_1_CARD--option-2']"),silent=TRUE)
		  }else{ 
			try(carte_voyageur <- remDr$findElement(using = 'xpath', "//li[@id = 'PASSENGER_1_CARD--option-1']"),silent=TRUE)
		  }
		}else{
		  try(carte_voyageur <- remDr$findElement(using = 'xpath', "//li[@id = 'PASSENGER_1_CARD--option-0']"),silent=TRUE)
		}
		try(carte_voyageur$clickElement(),silent=TRUE)
		Sys.sleep(1)
		
		try(valid <- remDr$findElement("id","vsb-booking-train-submit"),silent=TRUE)
		try(valid$clickElement(),silent=TRUE)

		
	  Sys.sleep(10)
	  
	  # Vérifier si on a bien lancer la recherche
	  if(detect_captcha() == 1) next
	  
	  if (remDr$getCurrentUrl()[[1]] != "https://be.oui.sncf/fr/"){
	  
		#On va prendre le résultat ainsi que ceux des deux jours d'après
		for (k in 1:3){
		
		  liste_resultat <- remDr$findElements("xpath","//div[@class='main-row proposalRow__inner']")
		  
		  if (length(liste_resultat)>0){
		  
  			for (id_resultat in 1:length(liste_resultat)){
  			  resultat <- liste_resultat[[id_resultat]]
  			  
  			  villeD <- recup_web(resultat,"class","departure-station")
  			  villeA <- recup_web(resultat,"class","arrival-station")
  			  heureD <- recup_web(resultat,"class","departure-time")
  			  heureA <- recup_web(resultat,"class","arrival-time")
  			  duree <- recup_web(resultat,"class","duration")
  			  transport <- recup_web(resultat,"class","transporter-label")
  			  
  			
  			  prix_noflex <- recup_web(resultat,"xpath",".//div[contains(@class,'NOFLEX')]//price")
  			  prix_semiflex <- recup_web(resultat,"xpath",".//div[contains(@class,'SEMIFLEX')]//price")
  			  prix_flex <- recup_web(resultat,"xpath",".//div[contains(@class,' FLEX')]//price")
  			  prix_upsell <- recup_web(resultat,"xpath",".//div[contains(@class,'UPSELL')]//price")
  			  
  			  prix_noflex_label <- recup_web(resultat,"xpath",".//div[contains(@class,'NOFLEX')]//div[@class='price-btn__label']")
  			  prix_semiflex_label <- recup_web(resultat,"xpath",".//div[contains(@class,'SEMIFLEX')]//div[@class='price-btn__label']")
  			  prix_flex_label <- recup_web(resultat,"xpath",".//div[contains(@class,' FLEX')]//div[@class='price-btn__label']")
  			  prix_upsell_label <- recup_web(resultat,"xpath",".//div[contains(@class,'UPSELL')]//div[@class='price-btn__label']")
  			  
  			  if (!is.na(recup_web(resultat,"class","reason"))){
  				raison <- recup_web(resultat,"class","reason")
  				prix_noflex <- raison
  				prix_semiflex <- raison
  				prix_flex <- raison
  				prix_upsell <- raison
  			  }
  			  
  			  tableau_prix[nrow(tableau_prix)+1,] <-  list(as.character(Sys.time()),id_recherche,id_resultat,as.character(tableau_recherche$jourD[id_recherche]),heureD,heureA,duree,transport,as.character(tableau_recherche$id_type_voyageur[id_recherche]),tableau_recherche$id_carte_voyageur[id_recherche],tableau_recherche$villeD[id_recherche],tableau_recherche$villeA[id_recherche],prix_noflex,prix_noflex_label,prix_semiflex,prix_semiflex_label,prix_flex,prix_flex_label,prix_upsell,prix_upsell_label)
  			}
  			
  	    if(nrow(tableau_prix) == length(liste_resultat)){
  	      table_google <- gs_title(fichier_sncf)
  	      gs_edit_cells(table_google, ws = 1, input = tableau_prix)
  	    }else{
  	      try(saveData(fichier_sncf,tableau_prix[(nrow(tableau_prix)-length(liste_resultat)+1):(nrow(tableau_prix)),]),silent=TRUE)
  	    }
  		    
  			  
  			try(write.csv2(tableau_prix,"tableau_prix.csv"),silent=TRUE)
		  }
		  
		  if (k < 3){
			try({
			  jour_j_m <- remDr$findElement("xpath","//li[preceding-sibling::li[contains(@class,'selected')]]")
			  jour_j_m$clickElement()
			},silent=TRUE)
			Sys.sleep(5)
		  }
		}
	  }  
	}
}
