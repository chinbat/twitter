library("maps")
library("mapdata")
require(ggplot2)
library(ggsubplot)
japan.map <- map("worldHires","Japan", plot = FALSE, fill = FALSE)
require(lattice)
require(latticeExtra)
curry <- read.csv("R/trans_curry.txt",header=FALSE,sep=",")
colnames(curry) <- c("lat","long","p")
japan.info <- curry
panel.3dmap <- function(..., rot.mat, distance, xlim,
                        ylim, zlim, xlim.scaled, ylim.scaled, zlim.scaled) {
  scaled.val <- function(x, original, scaled) {
    scaled[1] + (x - original[1]) * diff(scaled)/diff(original)
  }
  m <- ltransform3dto3d(rbind(scaled.val(japan.map$x,
                                         xlim, xlim.scaled), scaled.val(japan.map$y, ylim,
                                                                        ylim.scaled), zlim.scaled[1]), rot.mat, distance)
  panel.lines(m[1, ], m[2, ], col = "grey40")
}
pl <- cloud(p ~ long + lat, japan.info, panel.3d.cloud = function(...) {
                                                          panel.3dmap(...)
                                                          panel.3dscatter(...)
                                                        }, col = "blue2",  type = "h", scales = list(draw = FALSE), zoom = 1.1,
            xlim = japan.map$range[1:2], ylim = japan.map$range[3:4],
            xlab = NULL, ylab = NULL, zlab = NULL, aspect = c(diff(japan.map$range[3:4])/diff(japan.map$range[1:2]),
                                                              0.3), panel.aspect = 0.75, lwd = 2, screen = list(
                                                                                                                x = -60), par.settings = list(axis.line = list(col = "transparent"),
                                                                                                                                              box.3d = list(col = "transparent", alpha = 0)))
print(pl)