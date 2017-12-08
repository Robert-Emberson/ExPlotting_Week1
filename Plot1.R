library(lubridate)
library(dplyr)

# Step 1 - download files
destfile<-paste0(getwd(),"/","Elec_consump.zip")
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile)
unzip("Elec_consump.zip")

# Read table
data <- read.table("household_power_consumption.txt", sep = ";", header = T)

# Step 2 - select only the dates of interest
data$Date <- dmy(data$Date)
sel_dat <- filter(data, between(data$Date, dmy("01/02/2007"), dmy("02/02/2007")))
sel_dat <- mutate(sel_dat, dtime = ymd_hms(paste(sel_dat$Date, sel_dat$Time)))

#Step 3 - Change columns to numeric
cols <- c(3:9); sel_dat[,cols] <- sapply(sel_dat[,cols], function(x) as.numeric(as.character(x)))

#Step 4 - Plotting
par(mfrow = c(1,1), mar = c(5,4,2,4))
hist(sel_dat$Global_active_power, col = "red", xlab ="Global Active Power (kilowatts)", main = "Global Active Power")

#Step 5 - Save file
dev.copy(png, file = "Plot1.png")
dev.off()