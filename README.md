---
title: "Wholesale Market Supply Curve"
output: github_document
---

##Introduction
This document presents a guide for R beginners on how to build a supply curve that one might expect to see in the wholesale energy market. This supply curve is purely hypothetical, but can be used as a general model for energy professionals. 

To run the code, you will need `dplyr` and `ggplot2`. The csv file is already provided using sample data. 

##1: Load the data in RStudio

```{r}
#--- load packages ---
library(dplyr)
library(ggplot2)

#---- load data, create data frame, and view ---
df <- read.csv('supplycurve.csv')
data <- tbl_df(df)
data %>% View()
```

##2: Check data structures and groupings
At the very least, you should have data on fuel type (`Fuel`), cumulative capacity (`CumCap`), and bid price (`Price`). Prices should be sorted from least to greatest, and the cumulative capacity should correspond to the prices. 

Here, my `Group` column is identical to my `Fuel` column. So I will sort by `Group` to see how many unique fuel types I have to work with. It's also important to understand what data structure the columns are. Using `str(data)`, notice my `CumCap` and `Price` columns are numeric. If not, convert them using the first two optional lines of code below. Use the last optional line of code to get rid of NA values.
```{r}
data %>% 
  select(Group) %>%
  unique()

str(data)

#optional
as.numeric(data$Price)
as.numeric(data$CumCap)
data <- data[!(is.na(data$Group)),]
```

##3: Create fuel categories
If your `Fuel` column is already characters, great. If they are indexed as numbers as they are in my .csv file, then you need to convert them. 

```{r}
# --- convert groups into categories --- 
data$Group[data$Group == 2] <- 'Wind'
data$Group[data$Group == 3] <- 'Oil'
data$Group[data$Group == 5] <- 'Natural Gas'
data$Group[data$Group == 10] <- 'Hydro'
data$Group[data$Group == 11] <- 'Biomass'
data$Group[data$Group == 15] <- 'Solar'
data$Group[data$Group == 20] <- 'Nuclear'
```

##4: Plot using ggplot2
Here, I sorted by supply stack by fuel. I also changed the X and Y axis labels. If you see data points with extreme prices, you can clip it using the optional code below. 

```{r}
supply_curve <- ggplot(data, aes(x = CumCap, y = Price, shape = Group, color = Group))
supply_curve + geom_point(size = 5, shape = 20) +labs(x = "Capacity (MW)", y = "Price ($/MWh)")

#optional: clip extreme values and max price at $200/MWh
data <- subset(data, data$Price < 200)


```

##5: Rinse and repeat
