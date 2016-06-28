#--- load libraries ---
library(dplyr)
library(ggplot2)

#--- read and view data ---
df <- read.csv('supplycurve.csv')
data <- tbl_df(df)
data %>% View()

#--- check data structures and groupings
data %>% 
  select(Group) %>%
  unique()

str(data)

#optional
as.numeric(data$Price)
as.numeric(data$CumCap)
data <- data[!(is.na(data$Group)),]

# --- convert groups into categories --- 
data$Group[data$Group == 2] <- 'Wind'
data$Group[data$Group == 3] <- 'Oil'
data$Group[data$Group == 5] <- 'Natural Gas'
data$Group[data$Group == 10] <- 'Hydro'
data$Group[data$Group == 11] <- 'Biomass'
data$Group[data$Group == 15] <- 'Solar'
data$Group[data$Group == 20] <- 'Nuclear'

#--- plot in ggplot ---
supply_curve <- ggplot(data, aes(x = CumCap, y = Price, shape = Group, color = Group))
supply_curve + geom_point(size = 5, shape = 20) +labs(x = "Capacity (MW)", y = "Price ($/MWh)")

#--- OPTIONAL: plot in Base R ---
scatter.smooth(data$CumCap, data$Price)

#--- OPTIONAL: remove extremes --- 
data <- subset(data, data$Price < 250)
data <- subset(data, data$Price >= 0)
