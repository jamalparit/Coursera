Preparation:


1. Download and Extract Datasets
2. setwd("D:/OneDrive/Public/Data Science/Coursera/Exploratory-Data-Analysis/Project 2")
3. Load  NEI and SCC data frames from the .rds files

```r
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```

## Questions

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

### Question 1

Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

### Answer

```r
aggTotals <- aggregate(Emissions ~ year,NEI, sum)
```

```r
png(filename='plot1.png')
barplot(
  (aggTotals$Emissions)/10^6,
  names.arg=aggTotals$year,
  xlab="Year",
  ylab="Emissions)",
  main="Total PM2.5 Emissions All Sources"
)
dev.off()
```
<img src="https://github.com/jamalparit/Coursera/blob/master/Exploratory-Data-Analysis/Project%202/plot1.png" alt="Exploratory Data Analysis Project 2 question 1" >

### Question 2

Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

### Answer
Aggregate total emissions from PM2.5 for Baltimore City, Maryland (fips="24510") from 1999 to 2008.


```r
baltimoreNEI <- NEI[NEI$fips=="24510",]
aggTotalsBaltimore <- aggregate(Emissions ~ year, baltimoreNEI,sum)
```

Now we use the base plotting system to make a plot of this data,


```r
png(filename='plot2.png')
barplot(
  aggTotalsBaltimore$Emissions,
  names.arg=aggTotalsBaltimore$year,
  xlab="Year",
  ylab="PM2.5 Emissions)",
  main="Total PM2.5 Emissions From All Baltimore City"
)
dev.off()
```
<img src="https://github.com/jamalparit/Coursera/blob/master/Exploratory-Data-Analysis/Project%202/plot2.png" alt="Exploratory Data Analysis Project 2 question 2" >

### Question 3
Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

### Answer


```r
library(ggplot2)
png(filename='plot3.png')

ggp <- ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission")) + 
  labs(title=expression("PM"[2.5]*" Emissions by Source Type in Baltimore City 1999-2008"))

print(ggp)
dev.off()
```
<img src="https://github.com/jamalparit/Coursera/blob/master/Exploratory-Data-Analysis/Project%202/plot3.png" alt="Exploratory Data Analysis Project 2 question 3" >

### Question 4
Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

### Answer

First subset coal combustion source factors NEI data.

```r
# Subset coal combustion related NEI data
combustionRelated <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coalRelated <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coalCombustion <- (combustionRelated & coalRelated)
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]
```

```r
library(ggplot2)
png(filename='plot4.png')

ggp <- ggplot(combustionNEI,aes(factor(year),Emissions/10^5)) +
  geom_bar(stat="identity",fill="#af8885",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions from 1999-2008 Across US"))

print(ggp)
dev.off()
```
<img src="https://github.com/jamalparit/Coursera/blob/master/Exploratory-Data-Analysis/Project%202/plot4.png" alt="Exploratory Data Analysis Project 2 question 4" >

### Question 5
How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

First subset the motor vehicles


```r
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]
```

```r
baltimoreVehiclesNEI <- vehiclesNEI[vehiclesNEI$fips==24510,]
```

```r
library(ggplot2)
png(filename='plot5.png')

ggp <- ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="#af8885",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions between 1999-2008 in Baltimore"))

print(ggp)
dev.off()
```
<img src="https://github.com/jamalparit/Coursera/blob/master/Exploratory-Data-Analysis/Project%202/plot5.png" alt="Exploratory Data Analysis Project 2 question 5" >

### Question 6
Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

### Answer

```r
vehiclesBaltimoreNEI <- vehiclesNEI[vehiclesNEI$fips == 24510,]
vehiclesBaltimoreNEI$city <- "Baltimore City"
vehiclesLANEI <- vehiclesNEI[vehiclesNEI$fips=="06037",]
vehiclesLANEI$city <- "Los Angeles County"
bothNEI <- rbind(vehiclesBaltimoreNEI,vehiclesLANEI)
```

```r
library(ggplot2)
png(filename='plot6.png')
 
ggp <- ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions between 1999-2008  in Baltimore & LA,"))

print(ggp)
dev.off()
```
<img src="https://github.com/jamalparit/Coursera/blob/master/Exploratory-Data-Analysis/Project%202/plot6.png" alt="Exploratory Data Analysis Project 2 question 6" >
