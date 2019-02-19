#!/usr/bin/Rscript

library("vegan")

files <- list.files(path=".", pattern="*.tab", full.names=T, recursive=FALSE)
files

lapply(files, function(x) {
  df <- read.table(x,sep=" ",header=T)
  
  simpson.div <- diversity(df[, 3], index = "simpson")
  cat(toString(c(x,simpson.div)), file="Simpson.txt",append = TRUE, sep = "\n")
  
  invsimpson.div <- diversity(df[, 3], index = "invsimpson")
  cat(toString(c(x,invsimpson.div)), file="InvSimpson.txt",append = TRUE, sep = "\n")
  
  shannon.div <- diversity(df[, 3], index = "shannon")
  cat(toString(c(x,shannon.div)), file="ShanonDiv.txt",append = TRUE, sep = "\n")
  
  pielou.eve <- shannon.div/log(nrow(df))
  clonality <- 1 - pielou.eve
  cat(toString(c(x,clonality)), file="Pielou.txt",append = TRUE, sep = "\n") 
  
})


