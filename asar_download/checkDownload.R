#!/usr/bin/Rscript
args <- commandArgs(trailingOnly = TRUE)
print(args)
webkey<-args[1]
proj.ID<-args[2]
library(data.table)
library(stringr)
library(plyr)
library(biomformat)
mdt<-read.csv(file = paste0(proj.ID,'.meta.csv'))
lines<-c()
fsubIDs<-c()
seedIDs<-c()
koIDs<-c()

i<-1
for(mid in mdt$MG.RAST.ID){
  fn<-paste0(mid,'.fsub')
  if(!file.exists(fn)){
    lines[i]<-paste0('sbatch getMGRAST.fsub.sh ',webkey,' ',mid)
    fsubIDs[length(fsubIDs)+1]<-mid
    i<-i+1
  }else{
  s<-tryCatch(paste(fread(paste0('tail -n 1 ',fn)),collapse = ' '))
  if (inherits(s, "try-error")) {
    lines[i]<-paste0('sbatch getMGRAST.fsub.sh ',webkey,' ',mid)
    fsubIDs[length(fsubIDs)+1]<-mid
    i<-i+1
  }else if(!grepl('Download complete',s)){
    lines[i]<-paste0('sbatch getMGRAST.fsub.sh ',webkey,' ',mid)
    fsubIDs[length(fsubIDs)+1]<-mid
    i<-i+1
  }
  }
  # s<-tryCatch(paste(fread(paste0('tail -n 1 ',mid,'.fseed')),collapse = ' '))
  # if (inherits(s, "try-error")) {
  #   lines[i]<-paste0('sbatch getMGRAST.fseed.sh ',webkey,' ',mid)
  #   i<-i+1
  # }else if(!grepl('Download complete',s)){
  #   lines[i]<-paste0('sbatch getMGRAST.fseed.sh ',webkey,' ',mid)
  #   i<-i+1
  # }
  fn<-paste0(mid,'.seed')
  if(!file.exists(fn)){
    lines[i]<-paste0('sbatch getMGRAST.seed.sh ',webkey,' ',mid)
    seedIDs[length(seedIDs)+1]<-mid
    i<-i+1
  }else{
  s<-tryCatch(paste(fread(paste0('tail -n 1 ',fn)),collapse = ' '))
  if (inherits(s, "try-error")) {
    lines[i]<-paste0('sbatch getMGRAST.seed.sh ',webkey,' ',mid)
    seedIDs[length(seedIDs)+1]<-mid
    i<-i+1
  }else if(!grepl('Download complete',s)){
    lines[i]<-paste0('sbatch getMGRAST.seed.sh ',webkey,' ',mid)
    seedIDs[length(seedIDs)+1]<-mid
    i<-i+1
  }
  }
  fn<-paste0(mid,'.ko')
  if(!file.exists(fn)){
    lines[i]<-paste0('sbatch getMGRAST.ko.sh ',webkey,' ',mid)
    koIDs[length(koIDs)+1]<-mid
    i<-i+1
  }else{
  s<-tryCatch(paste(fread(paste0('tail -n 1 ',fn)),collapse = ' '))
  if (inherits(s, "try-error")) {
    lines[i]<-paste0('sbatch getMGRAST.ko.sh ',webkey,' ',mid)
    koIDs[length(koIDs)+1]<-mid
    i<-i+1
  }else if(!grepl('Download complete',s)){
    lines[i]<-paste0('sbatch getMGRAST.ko.sh ',webkey,' ',mid)
    koIDs[length(koIDs)+1]<-mid
    i<-i+1
  }
  }
}
if(length(lines)>0){
  fname<-paste0('resubmit',format(Sys.time(), "%Y.%m.%d.%H.%M.%S"),'.sh')
  writeLines(c('#!/bin/bash',lines),fname)
  system(paste0('chmod a+x ',fname))
  fname<-paste0('resubmit',format(Sys.time(), "%Y.%m.%d.%H.%M.%S"),'.loop.sh')
  fsubLines<-c()
  seedLines<-c()
  koLines<-c()
  if(length(fsubIDs)>0){
    fsubLines<-paste('sbatch getMGRAST.loop.fsub.sh',webkey,paste(fsubIDs,collapse = ' '))
  }
  if(length(seedIDs)>0){
    seedLines<-paste('sbatch getMGRAST.loop.seed.sh',webkey,paste(seedIDs,collapse = ' '))
  }
  if(length(koIDs)>0){
    koLines<-paste('sbatch getMGRAST.loop.ko.sh',webkey,paste(koIDs,collapse = ' '))
  }
  
  cat('The download is incomplete. Run ',fname,'\n')
  flines<-c(fsubLines,seedLines,koLines)
  writeLines(c('#!/bin/bash',flines),fname)
  system(paste0('chmod a+x ',fname))
}else{
  cat('The download is complete. Preparing Rdata file\n\tBe patient it could take several minutes.\n')
  source('createPathView.R')
}
