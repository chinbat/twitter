library("maps")
library("mapdata")
require(ggplot2)
library(ggsubplot)
japan.map <- map("worldHires","Japan", plot = FALSE, fill = FALSE)
require(lattice)
require(latticeExtra)
temp = read.csv("R/chofu.csv",sep=",")
//temp$prop <- temp$cnt / temp$all
japan.info <- temp
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
pl <- cloud(cnt ~ long + lat, japan.info, panel.3d.cloud = function(...) {
                                                          panel.3dmap(...)
                                                          panel.3dscatter(...)
                                                        }, col = "blue2",  type = "h", scales = list(draw = FALSE), zoom = 1.1,
            xlim = japan.map$range[1:2], ylim = japan.map$range[3:4],
            xlab = NULL, ylab = NULL, zlab = NULL, aspect = c(diff(japan.map$range[3:4])/diff(japan.map$range[1:2]),
                                                              0.3), panel.aspect = 0.75, lwd = 2, screen = list(
                                                                                                                x = -60), par.settings = list(axis.line = list(col = "transparent"),
                                                                                                                                              box.3d = list(col = "transparent", alpha = 0)))
print(pl)