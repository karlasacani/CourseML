rm(list = ls()) 
Db <- read.csv("./dataraw/rca_data_2012_2022-06-29.csv")

Db$CellIDFac <- as.factor(Db$CellID)
str(Db$CellIDFac)

require(tidyverse)
Db <- Db %>% select(CellIDFac, Date, SAL_avg)

aux1 <- list()

aux1[[1]] <- Db[Db$CellIDFac==levels(Db$CellIDFac)[1],c(1)]
for (i in 1:length(levels(Db$CellIDFac))){
    aux1[[i]] <- Db[Db$CellIDFac==levels(Db$CellIDFac)[i],c(3)]
}

aux2<-do.call(cbind.data.frame,aux1)
colnames(aux2)<-levels(Db$CellIDFac)

aux3 <- seq.Date(from = as.Date("2012-01-01"), to = as.Date("2013-01-01"), by = "1 day")
require(lubridate)
aux4 <- data.frame(Year = year(aux3), Month = month(aux3), Day = day(aux3))

data_prepared <- cbind(aux4,aux2)

saveRDS(data_prepared, file = "data_prepared.rds")

# Professor script ----
rm(list = ls()) 
# Drca <- read.csv("./dataraw/rca_data_2012_2022-06-29.csv")
# ls(Drca)
# 
# # load and reduce size
# require(tidyverse)
# Drca <- Drca %>% select(Date, CellID, SAL_avg) %>% 
#     mutate(Date = as.Date(Date), Month = as.integer(format(Date, "%m")),
#            Year = as.integer(format(Date, "%Y"))) %>% 
#     filter(Year == 2012) %>% 
#     group_by(CellID, Month) %>% 
#     summarise(SAL_avg = mean(SAL_avg))
# summary(Drca)
# saveRDS(Drca, file = "./dataderived/Drca.RDS")

Drca <- readRDS("./dataderived/Drca.RDS")

CELLS <- unique(Drca$CellID)
set.seed(123)
cells <- sample(CELLS, 100)

drca <- Drca %>% 
    filter(is.element(CellID, cells))
