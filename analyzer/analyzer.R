analyzer <- function(filename){
  all <- 1000
  nodata <- 31366
  data <- read.csv(filename,header=FALSE,sep=",")
  colnames(data) <- c("number","user","lat","long","n160","n10","act","cand","prob","all_prob","avgd","sdd","time")
  cat("rows:",nrow(data),"\n")
  act_data <- subset(data,act!=nodata)
  cat("having act:",nrow(act_data),"\n")
  cat("act mean:",mean(act_data$act),"\n")
  cat("act sd:",sd(act_data$act),"\n")
  cat("act 1:",nrow(subset(data,act==1))/all*100,"\n")
  cat("act 10:",nrow(subset(data,act<=10))/all*100,"\n")
  n10_data <- subset(data,n10!=nodata)
  cat("having n10:",nrow(n10_data),"\n")
  cat("n10 1:",nrow(subset(data,n10==1))/all*100,"\n")
  cat("n10 10:",nrow(subset(data,n10<=10))/all*100,"\n")
  n160_data <- subset(data,n160!=nodata)
  cat("having n160:",nrow(n160_data),"\n")
  cat("n160 1:",nrow(subset(data,n160==1))/all*100,"\n")
  cat("n160 10:",nrow(subset(data,n160<=10))/all*100,"\n")
  cat("cand mean:",mean(data$cand),"\n")
  cat("cand sd:",sd(data$cand),"\n")
  cat("avgd 10 mean:",mean(data$avgd),"\n")
  cat("avgd 10 sd:",sd(data$avgd),"\n")
}


colnames(data)<-c("num","user","lat","long","n160","n10","act","cand","rain","valid","res","p","allp","avgd","sdd","time")


ranalyzer <- function(filename){
  all <- 1000
  nodata <- 101
  data <- read.csv(filename,header=FALSE,sep=",")
  colnames(data) <- c("number","user","lat","long","n160","n10","act","cand","rain","valid","res","p","all_p","avgd","sdd","time")
  cat("rows:",nrow(data),"\n")
  act_data <- subset(data,act!=nodata)
  cat("having act:",nrow(act_data),"\n")
  cat("act mean:",mean(act_data$act),"\n")
  cat("act sd:",sd(act_data$act),"\n")
  cat("act 1:",nrow(subset(data,act==1))/all*100,"\n")
  cat("act 10:",nrow(subset(data,act<=10))/all*100,"\n")
  n10_data <- subset(data,n10!=nodata)
  cat("having n10:",nrow(n10_data),"\n")
  cat("n10 1:",nrow(subset(data,n10==1))/all*100,"\n")
  cat("n10 10:",nrow(subset(data,n10<=10))/all*100,"\n")
  n160_data <- subset(data,n160!=nodata)
  cat("having n160:",nrow(n160_data),"\n")
  cat("n160 1:",nrow(subset(data,n160==1))/all*100,"\n")
  cat("n160 10:",nrow(subset(data,n160<=10))/all*100,"\n")
  cat("cand mean:",mean(data$cand),"\n")
  cat("cand sd:",sd(data$cand),"\n")
  cat("avgd 10 mean:",mean(data$avgd),"\n")
  cat("avgd 10 sd:",sd(data$avgd),"\n")
  cat("rain mean:",mean(data$rain),"\n")
  cat("time mean:",mean(data$time),"\n")
  cat("sorted size mean:",mean(data$res),"\n")
}

manalyzer <- function(filename){
  all <- 1000
  nodata <- 101
  data <- read.csv(filename,header=FALSE,sep=",")
  colnames(data) <- c("number","user","lat","long","n160","n10","act","cand","res","p","all_p","avgd","sdd")
  cat("rows:",nrow(data),"\n")
  act_data <- subset(data,act!=nodata)
  cat("having act:",nrow(act_data),"\n")
  cat("act mean:",mean(act_data$act),"\n")
  cat("act sd:",sd(act_data$act),"\n")
  cat("act 1:",nrow(subset(data,act==1))/all*100,"\n")
  cat("act 10:",nrow(subset(data,act<=10))/all*100,"\n")
  n10_data <- subset(data,n10!=nodata)
  cat("having n10:",nrow(n10_data),"\n")
  cat("n10 1:",nrow(subset(data,n10==1))/all*100,"\n")
  cat("n10 10:",nrow(subset(data,n10<=10))/all*100,"\n")
  n160_data <- subset(data,n160!=nodata)
  cat("having n160:",nrow(n160_data),"\n")
  cat("n160 1:",nrow(subset(data,n160==1))/all*100,"\n")
  cat("n160 10:",nrow(subset(data,n160<=10))/all*100,"\n")
  cat("cand mean:",mean(data$cand),"\n")
  cat("cand sd:",sd(data$cand),"\n")
  cat("avgd 10 mean:",mean(data$avgd),"\n")
  cat("avgd 10 sd:",sd(data$avgd),"\n")
  cat("sorted size mean:",mean(data$res),"\n")
}
