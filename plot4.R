#Dates and Times Made Easy with lubridate
#http://www.jstatsoft.org/article/view/v040i03/v40i03.pdf
library(lubridate)

# DataFile: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# The first row in the data file contains these variable names:
# Date
# Time
# Global_active_power
# Global_reactive_power
# Voltage
# Global_intensity
# Sub_metering_1
# Sub_metering_2
# Sub_metering_3

# The file semi-colon delimted.
# missing values are denoted with ?'s
# read.table() function reads a file into data frame in table format. 
# The file can be comma delimited or tab or any other delimiter specified 
# by parameter "sep=". If the parameter "header=" is "TRUE", then the 
# first row will be treated as the row names. 

# create my own data type (using lubridate to parse the un-friendly date format in the dataset)
setClass('myDate')
setAs("character","myDate", function(from) dmy(from)) # This seemed easiest to me.
                                                      # I banged my head for a couple hours
                                                      # trying to get the date to work without <NA>'s                                              
  
# make sure to download and unzip the datafile into the current directory.
# This is pretty large dataset, but not really that large.  
# I read, "Specifying [the colClasses option]instead of using the default can make
# 'read.table' run MUCH faster, often twice as fast." Thus, ....
# reference: http://www.biostat.jhsph.edu/~rpeng/docs/R-large-tables.html
allData <- read.table("household_power_consumption.txt", 
                     header=TRUE, 
                     sep=";", 
                     na.strings = "?", 
                     colClasses = c("myDate", 
                                    "character", 
                                    "numeric",
                                    "numeric",
                                    "numeric",
                                    "numeric",
                                    "numeric",
                                    "numeric",
                                    "numeric")
                     
)

#We will only target dates in the range of 2007-02-01 to 2007-02-02.
targetData <- subset(allData, allData$Date > "2007-01-31" & allData$Date <= "2007-02-02")
 

# Create a plot that contains day of week on x-axis
datetime <- parse_date_time(paste(as.character(targetData$Date), targetData$Time, sep=" "), orders="ymd hms")


# create a datetime value by concatenating the date and time using 
#the lubridate method.
datetime <- parse_date_time(paste(as.character(targetData$Date), 
                                  targetData$Time, sep=" "), 
                            orders="ymd hms")


png("plot4.png", width=480, height=480)

#set up the plot window for 4 charts 2 (rows) 2 (columns)
par(mfrow=c(2,2))

# add plot 1
plot(datetime, targetData$Global_active_power, 
     type="l", 
     xlab="",
     ylab="Global Active Power (kilowatts)")


# add plot 2
plot(datetime, targetData$Voltage, 
     type="l", 
     xlab="datetime", 
     ylab="Voltage")


# add plot 3
plot(datetime, targetData$Sub_metering_1, 
     type="l", 
     ylab="Energy Sub Metering", 
     xlab="")

lines(datetime, targetData$Sub_metering_2, type="l", col="red")
lines(datetime, targetData$Sub_metering_3, type="l", col="blue")

legend("topright", c("Sub_metering_1", 
                     "Sub_metering_2", 
                     "Sub_metering_3"), 
       lty=1, 
       lwd=2.5,
       bty="n",
       col=c("black", "red", "blue"))

# add plot 4
plot(datetime, targetData$Global_reactive_power, 
     type="l", 
     xlab="datetime", 
     ylab="Global_reactive_power")

graphics.off() 

