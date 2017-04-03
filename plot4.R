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

#plot3: weekday view of household power consumption by sub meters
par(mfcol = c(2,2), mar = c(4, 4, 2, 1))

with(hh_feb, {
    plot(newDateTime, Global_active_power, type="l", ylab = "Global Active Power",xlab="")
    plot(newDateTime, Sub_metering_1, type="n",ylab = "Energy sub metering",xlab="")
    points(newDateTime, Sub_metering_1, type="l")
    points(newDateTime, Sub_metering_2, type="l", col="red")
    points(newDateTime, Sub_metering_3, type="l",  col="blue")})
    
    #manually adjust position of the legend box
    info<-legend("topright", lty="solid", plot=FALSE, pt.cex = 1, cex = .85, col=c("black","red","blue"), legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
    
    leftx <- info$rect$left - 25000
    rightx <- (info$rect$left + info$rect$w) * 4
    topy <- info$rect$top
    bottomy <- info$rect$top - info$rect$h
    
    legend(x = c(leftx, rightx), y = c(topy, bottomy), bty="n",lty="solid", pt.cex = 1, cex = .85,
           col = c("black","red","blue"),
           legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
    
    with(hh_feb, {
    plot(newDateTime, Voltage, type="l", ylab = "Voltage", xlab="datetime")
    plot(newDateTime, Global_reactive_power, type = "l",xlab="datetime")
    })

dev.off() ## Don't forget to close the PNG device!
