library("ggmap")
library("jsonlite")
library("rgdal")

map = get_map(location = "Cracow", zoom=14)


url <- "https://www.booking.com/markers_on_map?aid=376384;label=bdot-vU_NadVzzYtVqpv7J8OSPwS222988235661%3Apl%3Ata%3Ap1%3Ap21.093.000%3Aac%3Aap1t1%3Aneg%3Afi%3Atiaud-146342138710%3Akwd-334108349%3Alp9067405%3Ali%3Adec%3Adm;sid=43d2db1a72457db3388b7be1a0a4243d;aid=376384;dest_id=-510625;dest_type=city;sr_id=601f4adbf6b665dbcfe034f41cb6ac5f02ba1be0;ref=searchresults;limit=90;stype=1;lang=pl;ssm=1;ngp=1;room1=A;maps_opened=1;esf=1;nflt=;sr_countrycode=pl;sr_lat=50.0629997253418;sr_long=19.9370002746582;dba=1;dbc=1;srh=;somp=1;BBOX=19.91469224558068,50.04627839412086,19.964216552831658,50.073250963998476&_=1523628534936"
data <- fromJSON(url)

hotels <- data.frame(lat=data$b_hotels$b_latitude, lng=data$b_hotels$b_longitude, score=data$b_hotels$b_review_score)
names(hotels) <- c("lat", "lng", "score")

hotels$score <- as.numeric(levels(hotels$score))[hotels$score]
hotels$lat <- as.numeric(levels((hotels$lat)))[hotels$lat]
hotels$lng <- as.numeric(levels((hotels$lng)))[hotels$lng]

plotted <- ggmap(map)
hotels_cracow <- plotted + geom_point(data=hotels, aes(lng, lat, colour = score), size=5, alpha=0.5, show.legend=TRUE) + scale_colour_gradient(high = "orange")

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
dir.create("output", showWarnings = FALSE)
png(filename="output/hotels_cracow.png")
plot(hotels_cracow)
dev.off()