#5) How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

#Scatter plot of total motor vehicle emissions by year in Baltimore with trend curve
#plot shows that emissions are strictly decreasing over time

#subset data for motor vehicles in Baltimore City 
baltimore_vehicle <- subset(joined_data, fips == "24510" & type == "ON-ROAD", drop = FALSE)
#group data by year to sum Emissions per year to check totals are correct
baltimore_onroad_totals <- baltimore_vehicle %>%
    group_by(year) %>%
    summarise(total_Emissions = sum(Emissions, na.rm = TRUE))
#check dataframe
print(baltimore_onroad_totals)

#open file decide
png(filename = "plot5.png", width = 480, height = 480)
#create plot to show total emissions per year in Baltimore city with trend curve to aid in visual comparison
ggplot(baltimore_onroad_totals, aes(x = as.numeric(year), y = total_Emissions)) +
    geom_point(color = "yellow", size = 5) +
    geom_smooth(method = "loess", color = "gold") + #trend curve to aid in visual comparison
    labs( title = "Total Motor Vehicle Emissions in Baltimore City", 
          x = "Year", 
          y = "PM2.5 Emissions")+ 
    theme_light()
#close file device
dev.off()
    
