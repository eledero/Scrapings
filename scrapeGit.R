library(RSelenium)
#Initialize RSelenium
####################################
#devtools::install_github("ropensci/RSelenium")
#Initialize RSelenium

print("Initializing Remote Drive...")
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "firefox")
remDr$open(silent = TRUE)

url <- "https://gitcoin.co/explorer?network=mainnet&idx_status=open&order_by=-web3_created"

print("Remote driver initialized. Browsing to the list of projects...")
remDr$navigate(url)
Sys.sleep(5)


print("List of projects ready. Pressing end to get all of the projects. Let's wait a couple of seconds for the full list to load... ")
body = remDr$findElement(using = 'css', value = "body")
body$sendKeysToElement(list(key = "end"))
#html body.interior.dashboard.g-font-muli div#dashboard-content.row.no-gutter div.col-12.col-lg-9.col-xl-10.body div#bounties.container-fluid div#dashboard-title div.row.mt-2.mb-2 div.col-12.offset-lg-1.col-lg-10.title-row div.col-12.col-md-4 span#filter.font-title

Sys.sleep(15)
elems = remDr$findElements(using = 'css', value = "a.row")
links = unlist(sapply(1:length(elems), function(x) elems[[x]]$getElementAttribute("href")))
links

print("Full list retrieved. Starting to scrape all projects on the list...")
getData <- function(x){
  
  remDr$navigate(links[x])
  Sys.sleep(1.5)
  
  title <- (remDr$findElement(using = 'css', value = "#title"))$getElementText()
  status <- (remDr$findElement(using = 'css', value = ".timeleft"))$getElementText()
  opened <- (remDr$findElement(using = 'css', value = ".bounty-info > div:nth-child(2) > span:nth-child(1)"))$getElementText()
  openedTime <- (remDr$findElement(using = 'css', value = "#web3_created"))$getElementText()
  
  experience <- (remDr$findElement(using = 'css', value = ".bounty-info > div:nth-child(4) > span:nth-child(1)"))$getElementText()
  experienceLevel <- (remDr$findElement(using = 'css', value = "#experience_level"))$getElementText()
  
  issue <- (remDr$findElement(using = 'css', value = ".bounty-info > div:nth-child(5) > span:nth-child(1)"))$getElementText()
  issueType <- (remDr$findElement(using = 'css', value = "#bounty_type"))$getElementText()
  
  project <- (remDr$findElement(using = 'css', value = "div:nth-child(6) > span:nth-child(1)"))$getElementText() 
  projectType <- (remDr$findElement(using = 'css', value = "#project_type"))$getElementText()
  
  time <- (remDr$findElement(using = 'css', value = ".bounty-info > div:nth-child(7) > span:nth-child(1)"))$getElementText()
  timeCommitment <- (remDr$findElement(using = 'css', value = "#project_length"))$getElementText()
  
  permission <- (remDr$findElement(using = 'css', value = ".bounty-info > div:nth-child(8) > span:nth-child(1)"))$getElementText()
  permission_type <- (remDr$findElement(using = 'css', value = "#permission_type"))$getElementText()
  
  description <- (remDr$findElement(using = 'css', value = "#issue_description"))$getElementText()
  
  print(paste0("Project # ", x, " processed."))


 defList = c(title, 
              status, 
              opened, 
              openedTime, 
              experience, 
              experienceLevel, 
              issue, 
              issueType, 
              project, 
              projectType, 
              time, 
              timeCommitment, 
              permission, 
              permission_type, 
              description)

defList = lapply(defList, function(x) ifelse(x == "", NA, x))

print(defList) 



  return(defList)  
}

a <- lapply(1:4, getData)
#a <- lapply(1:length(links), getData)
b <- data.frame(matrix(unlist(a), ncol = 15))
