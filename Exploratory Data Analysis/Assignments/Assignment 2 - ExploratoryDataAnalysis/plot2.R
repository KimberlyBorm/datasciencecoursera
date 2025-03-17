#2) Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
#from 1999 to 2008? Use the base plotting system to make a plot answering this question.

#Scatter plot for total emission by year of Baltimore City Emissions
#plot shows that emissions decrease overall despite and increase from 2002 to 2005

#open file device
png(filename = "plot2.png", width = 480, height = 480)
#subset data for Baltimore City only
baltimore <- subset(NEI, fips == "24510", drop = FALSE)
#check data subset correctly 
head(baltimore)
# sum emission per year
totals <- with(baltimore, tapply(Emissions, year, sum))
#check dataframe before using
print(totals)
#create lablels for x-axis
years <- as.numeric(names(totals))
#create trend line for data
trend <- lm(totals ~ years)
#initiate plot using base R code and surpress auto x-axis labeling
plot(years, totals, 
     main = "Baltimore City, Maryland Total Emmisions",
     xaxt = "n",
     xlab = "Year",
     ylab = "Total PM2.5",
     col = "red",
     pch = 19,
     ylim = c(1500, 3500)
     
)
#add labels for years to x-axis
axis(1, at = years, label = years)  
#add trend line to show decrease overall despite increase from 2002 to 2005
abline(trend, col = "blue")
#close file device
dev.off()
