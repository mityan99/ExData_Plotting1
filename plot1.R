library(dplyr)

#get data
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, "hhpowerconsumption.zip")
unzip(zipfile="hhpowerconsumption.zip")

hh = read.delim("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", stringsAsFactors=FALSE)

newDateTime = strptime(paste(hh$Date, hh$Time), "%d/%m/%Y %H:%M:%S")

hh2 = cbind(hh, newDateTime)

#subset data by date: 2007-02-01 and 2007-02-02
hh_feb = filter(hh2, between(newDateTime, as.POSIXct("2007-02-01"), as.POSIXct("2007-02-02 23:59:59")))

str(hh_feb)
summary(hh_feb)

#width of 480 pixels and a height of 480 pixels
png("plot1.png", 480, 480)
#plot1: frequency of Global Active Power
hist(hh_feb$Global_active_power, col="red", main="Global Active Power",xlab = "Global Active Power (kilowatts)")

dev.off() ## Don't forget to close the PNG device!
