library(sp)
library(raster)
library(rgdal)
library(gdalUtils)
lat = 27
lon=86
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
srtm_path = 'data/srtm/'
output_path = 'output/srtm/'
dir.create(srtm_path, showWarnings = FALSE)
dir.create(output_path, showWarnings = FALSE)

rs <- raster(nrows = 24, ncols = 72, xmn = -180, xmx = 180, 
             ymn = -60, ymx = 60)
rowTile <- rowFromY(rs, lat)
colTile <- colFromX(rs, lon)
if (rowTile < 10) {
  rowTile <- paste("0", rowTile, sep = "")
}
if (colTile < 10) {
  colTile <- paste("0", colTile, sep = "")
}

file_path <- paste(srtm_path, "srtm_", colTile, "_", rowTile, ".tif" ,sep = "")

if (!file.exists(file_path)){
  getData('SRTM', lon=lon, lat=lat, path='data/srtm/')
}

srtm_img <- raster(file_path)
plot(srtm_img)
hist(srtm_img, main="Distribution of elevation values", col= "purple", maxpixels=22000000)
image(srtm_img, zlim=c(8000, 9000))
elev_countur_file = paste(tempfile(), "elev_contur.shp", sep="")
elev_contour <- gdal_contour(src_filename=file_path, dst_filename = elev_countur_file,
                               a="Elevation",i=1000,output_Vector=TRUE)
spplot(elev_contour["Elevation"],contour=TRUE)