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
par(mfrow = c(2,2), mar = c(5,4,2,4))
plot(sel_dat$dtime, sel_dat$Global_active_power, type = "n", ylab = "Global Active Power (kilowatts)", xlab = "")
lines(sel_dat$dtime, sel_dat$Global_active_power, col = "black", lwd = 1)

plot(sel_dat$dtime, sel_dat$Voltage, type = "n", ylab = "Voltage", xlab = "datetime")
lines(sel_dat$dtime, sel_dat$Voltage, col = "black", lwd = 1)

plot(sel_dat$dtime, sel_dat$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(sel_dat$dtime, sel_dat$Sub_metering_1, col = "black", lwd = 1)
lines(sel_dat$dtime, sel_dat$Sub_metering_2, col = "red", lwd = 1)
lines(sel_dat$dtime, sel_dat$Sub_metering_3, col = "blue", lwd = 1)
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lwd = 1, bty = "n")

plot(sel_dat$dtime, sel_dat$Global_reactive_power, type = "n", ylab = "Global_reactive_power", xlab = "datetime")
lines(sel_dat$dtime, sel_dat$Global_reactive_power, col = "black", lwd = 1)

#Step 5 - Save file
dev.copy(png, file = "Plot4.png")
dev.off()