setwd('C:\\Users\\aksha\\Documents\\MIS 6380')
library('dplyr')
library('imputeTS')
library('lubridate')
library('anytime')
library('dplyr')

vac<-read.csv('US_vacc_fil_csv.csv')
head(vac)

#selecting only numerical columns for imputation............I've left out the booster columns 
vac_num<-select(vac,c(3,4,5,6,7,8,9,10,11,12,13,14))
head(vac_num)
vac_rem<-select(vac,c(1,2,15,16))
                
head(vac_rem)



vac_proc<-na_interpolation(vac_num)
vac_final<-data.frame(vac_rem,vac_proc)
head(vac_final)


vote<-read.csv('voting.csv')
head(vote)

dem<-vote[vote$biden_win==1,]

dem$ï..state

democrat<-c( "Hawaii","Washington","Oregon","California","Nevada","Arizona","Colorado","New Mexico","Minnesota","Wisconsin",
              "Illinois","Michigan","Georgia","Maine","New Hampshire","Vermont","Massachusetts","Rhode Island","Connecticut","New York State",
              "Pennsylvania","Virginia","New Jersey","Delaware","Maryland","District of Columbia")

rep<-vote[vote$trump_win==1,]
rep$ï..state

republican<-c("Alaska","Idaho","Montana","Wyoming","Utah","North Dakota","South Dakota","Nebraska","Kansas","Oklahoma","Texas","Iowa","Missouri","Arkansas",
              "Louisiana" ,"Mississippi","Indiana","Kentucky","Tennessee","Alabama","Ohio",
              "West Virginia" , "Florida",  "North Carolina" ,"South Carolina")

head(vac_final)

vac_final$pi<-''

vac_final$pi[vac_final$location %in% democrat] <- 'democrat'
vac_final$pi[vac_final$location %in% republican] <- 'republican'

head(vac_final)

str(mdy(vac_final$date))

vac_final$date<- mdy(vac_final$date)


vac_final$date<-as.Date(vac_final$date, origin = "2021-01-12")
vac_boost<-vac_final[c(1,3,4)]

head(vac_boost)


vac_boost<-vac_boost[vac_boost$date > '2021/10/20' & vac_boost$date <= '2022/02/18' ,]

vac_boost<-na_interpolation(vac_boost[vac_boost$date > '2021/10/20' & vac_boost$date <= '2022/02/18' ,])
head(vac_boost)


head(vac)

booster<-vac %>% select(date,total_boosters, total_boosters_per_hundred)

head(booster)

booster$date<- mdy(booster$date)


booster$date<-as.Date(booster$date, origin = "2021/01/12")

boost_impute<-na_interpolation(booster[booster$date > '2021/10/20' & booster$date <= '2022/02/18' ,])

boost_impute

boost_na<-booster[booster$date < '2021/10/21',]

boost_final<-rbind(boost_na,boost_impute)

nrow(boost_final)
nrow(vac_final)

head(boost_final)

head(vac_final)

ind<-data.frame(row.names(boost_final))

colnames(ind) = 'ind'

boost_final = data.frame(boost_final,ind)

ind_vac<-data.frame(row.names(vac_final))
colnames(ind_vac) = 'ind'

vac_final = data.frame(vac_final,ind_vac)

df_merged<-merge(x = vac_final, y = boost_final, by = "ind", all = TRUE)

head(df_merged)

write.csv(vac_final,"C:\\Users\\aksha\\Documents\\MIS 6380\\vac_done.csv", row.names = FALSE)
write.csv(boost_final,"C:\\Users\\aksha\\Documents\\MIS 6380\\boost_done.csv", row.names = FALSE)
write.csv(df_merged,"C:\\Users\\aksha\\Documents\\MIS 6380\\df_merged1.csv", row.names = FALSE)

pop<-read.csv('pop.csv')

pop<-pop[c(5,6)]

head(pop)

