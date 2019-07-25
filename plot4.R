library(dplyr)

#Load the data
if (!file.exists("household_power_consumption.txt")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                destfile = "household_power_consumption.txt")
}
df <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), na.strings = "?")

#Take subset
ids <- grepl('^1/2/2007|^2/2/2007', x = df$Date)
df <- subset(x = df, subset = ids, select = names(df), drop = TRUE)

#Convert to date and time
n <- names(df)
tbl <- tbl_df(df) %>%
  mutate(DateTime = paste(Date, Time)) %>%
  select(DateTime, n[3:length(n)])
tbl$DateTime <- strptime(tbl$DateTime, format = "%e/%m/%Y %H:%M:%S")

#Plot4
png(filename = "plot4.png")

par(mfrow = c(2,2))

with(tbl, plot(DateTime, Global_active_power,
               ylab = "Global Active Power",
               xlab = "",
               type = "n"))
with(tbl, lines(DateTime, Global_active_power))

with(tbl, plot(DateTime, Voltage,
               ylab = "Voltage",
               xlab = "datetime",
               type = "n"))
with(tbl, lines(DateTime, Voltage))

with(tbl, plot(DateTime, Sub_metering_1,
               ylab = "Energy sub metering",
               xlab = "",
               type = "n"))
with(tbl, lines(DateTime, Sub_metering_1))
with(tbl, lines(DateTime, Sub_metering_2,
                col = "red"))
with(tbl, lines(DateTime, Sub_metering_3,
                col = "blue"))
legend(x = "topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = c("solid", "solid", "solid"),
       bty = "n")

with(tbl, plot(DateTime, Global_reactive_power,
               ylab = "Global_reactive_power",
               xlab = "datetime",
               type = "n"))
with(tbl, lines(DateTime, Global_reactive_power))

dev.off()
