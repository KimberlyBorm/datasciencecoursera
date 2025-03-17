srt#String split to give columns names from the list "cnames"
cnames <- strsplit(cnames, "|", fixed = TRUE)
#make syntactically valid names
names(pm0) <- make.names(cnames[[1]][wcol])
head(pm0)
#pm2.5 readings only
x0 <- pm0$Sample.Value
str(x0)
#percent of missing reading in hte data 
mean(is.na(x0))

#do it all again with 2012 data
names(pm1) <- make.names(cnames[[1]][wcol])
dim(pm1)
x1 <- pm1$Sample.Value
mean(is.na(x1))

#step 1 - answer our question if pm2.5 has decreased
summary(x0)
summary(x1) # min is negative but pm2.5 is not a neg value
boxplot(x0, x1)
boxplot(log10(x0), log10(x1))

#should not have megative values - need to explore this more
negative <- x1< 0
sum(negative, na.rm = TRUE)
mean(negative, na.rm = TRUE) # 2% of values re negative - not a lot
#look if it happens at a partular time of year
#seperate dates
dates <- pm1$Date
str(dates)
#fix format to date
dates <- as.Date(as.character(dates), "%Y%m%d")
hist(dates[negative], "month") #occor in winter onths with spike in May
# 2% of data is not too concerning and occor when polution tends to be low. probably a measurment error

#step 2 - look at the change in just one monitor
str(site0)
both <- intersect(site0, site1)
both
#see how many reading we have from eqach monitor in both sets of data
cnt0 <- subset(pm0, State.Code == 36 & county.site %in% both)
cnt1 <- subset(pm1, State.Code == 36 & county.site %in% both)
#split cnt0 into several data frames according to county.site 
sapply(split(cnt0, cnt0$county.site), nrow)
sapply(split(cnt1, cnt1$county.site), nrow)
#picked one monitor
pm0sub <- subset(cnt0, County.Code == 63 & Site.ID == 2008)
pm1sub <- subset(cnt1, County.Code == 63 & Site.ID == 2008)
#compare years 
x0sub <- pm0sub$Sample.Value
x1sub <- pm1sub$Sample.Value
dates0 <- as.Date(as.character(pm0sub$Date),"%Y%m%d")
dates1 <- as.Date(as.character(pm1sub$Date),"%Y%m%d")
#plot
par(mfrow = c(1,2), mar = c(4,4,2,1))
plot(dates0, x0sub, pch = 20)
abline(h = median(x0sub, na.rm = TRUE), lwd = 2)
plot(dates1, x1sub, pch = 20)
abline(h = median(x1sub, na.rm = TRUE), lwd = 2)
#change ylim so scales on both graphs match
rng <- range(x0sub,x1sub,na.rm=TRUE)

#step 3, compare state by state averages
mn0 <- with(pm0, tapply(Sample.Value, State.Code, mean, na.rm = TRUE))
str(mn0) 
mn1 <- with(pm1, tapply(Sample.Value, State.Code, mean, na.rm = TRUE))
str(mn1)
summary(mn0)
summary(mn1)
d0 <- data.frame(state = names(mn0), mean = mn0)
d1 <- data.frame(state = names(mn1), mean = mn1)
mrg <- merge(d0, d1, by = "state")
#plot points
with(mrg, plot(rep(1, 52), mrg[, 2], xlim = c(.5, 2.5)))
with(mrg, points(rep(2, 52), mrg[, 3]))
segments(rep(1, 52), mrg[, 2], rep(2, 52), mrg[, 3])
#find states with higher means in 2012 than 2009
mrg[mrg$mean.x < mrg$mean.y, ]
skip()
