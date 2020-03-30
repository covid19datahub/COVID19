#' Animated Mapping
#'
#' Visualize data across the space and time dimensions by animated mapping.
#'
#' @param x \code{data.frame} containing the columns \code{lat} (latitude), \code{lng} (longitude) and \code{date} (time). See \code{\link{world}}, \code{\link{diamond}}, \code{\link{italy}} and \code{\link{switzerland}}.
#' @param map map data. The string choices include \code{'world'}, \code{'italy'}, \code{'switzerland'} and more (type \code{help(package='maps')} to see the package index). See \code{\link[maps]{map}} for details.
#' @param value the value column.
#' @param label the label column.
#' @param filename file name to create on disk. Use .gif for animations, .png for static images.
#' @param width,height plot size.
#' @param title the title. Dynamic label variables are available from \code{\link[gganimate]{transition_states}}.
#' @param text.size the text size.
#' @param caption the caption. Dynamic label variables are available from \code{\link[gganimate]{transition_states}}.
#' @param caption.size the caption size.
#' @param colour the text colour.
#' @param fill the fill colour.
#' @param background the background color.
#' @param point.alpha the point opacity.
#' @param point.size a numeric vector of length 2 that specifies the minimum and maximum size of the plotting symbol.
#' @param point.colour a character vector of length 2 that specifies the colours corresponding to the lowest and highest values.
#' @param legend.title the legend title. Dynamic label variables are available from \code{\link[gganimate]{transition_states}}.
#' @param legend.background the legend background.
#' @param legend.position the legend position, \code{c(0,0)} corresponds to bottom-left, \code{c(1,1)} to top-right.
#' @param legend.barheight the height of the colourbar.
#' @param legend.barwidth the width of the colourbar.
#' @param fps the framerate of the animation in frames/sec.
#' @param nframes the number of frames to render. Default two frames per date.
#' @param end_pause number of times to repeat the last frame in the animation.
#' @param ... additional arguments passed to \code{\link[gganimate]{animate}}
#'
#' @return The return value of the \code{\link[gganimate]{animate}} function.
#'
#' @examples
#' \dontrun{
#'
#' # download data
#' it <- italy()
#'
#' # add column
#' it$label <- factor(it$confirmed)
#'
#' # map
#' geomap(it,
#'   map = "italy",
#'   value = "confirmed",
#'   label = "label",
#'   title = "COVID-19: {closest_state}",
#'   caption  = "Data source: ...",
#'   legend.title = "Total cases")
#' }
#'
#' @import ggplot2
#'
#' @export
#'
geomap <- function(
  x,
  map               = "world",
  value             = "confirmed",
  label             = "",

  filename          = "",
  width             = 720,
  height            = 560,

  title             = "COVID-19: {closest_state}",
  text.size         = 24,

  caption           = "",
  caption.size      = 12,

  colour            = "#bdbdbd",
  fill              = "#2a2a28",
  background        = "#000f1a",

  point.alpha       = 0.95,
  point.size        = c(1,24),
  point.colour      = c("#ffaa00", "#a20f0e"),

  legend.title      = "",
  legend.background = "transparent",
  legend.position   = c(0,0),
  legend.barheight  = 8,
  legend.barwidth   = 1,

  fps               = 10,
  nframes           = NULL,
  end_pause         = 30,

  ...)
{

  if(map=='switzerland'){

    switz <- rgdal::readOGR(dsn = system.file("extdata", "shp", "ch", package = "COVID19"), layer="ch", verbose = FALSE)
    switz <- sp::spTransform(switz, sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

    borders <- geom_polygon(data = fortify(switz), aes_(~long, ~lat, group = ~group),
                            fill = fill, colour = colour, inherit.aes = FALSE)

  } else {

    borders <- borders(map, colour = colour, fill = fill)

  }

  g <-
    ggplot(data = x) +
    borders +
    ggthemes::theme_map(base_size = text.size) +
    theme(plot.background = element_rect(fill = background),
          plot.caption = element_text(size = caption.size),
          text = element_text(colour = colour),
          legend.position = legend.position,
          legend.background = element_rect(fill = legend.background),
          legend.box.background = element_rect(fill = legend.background, colour = legend.background),
          legend.key = element_rect(fill = legend.background))

  g <- g +
    geom_point(alpha = point.alpha, mapping = aes_string(x = "lng", y = "lat", size = value, color = value)) +
    scale_size_continuous(range = point.size) +
    scale_color_continuous(low = point.colour[1], high = point.colour[2]) +
    guides(size = "none", color = guide_colourbar(barheight = legend.barheight, barwidth = legend.barwidth)) +
    labs(color = legend.title, title = title, caption = paste(caption, "Created with the R package COVID19", sep = "\n"))

  g <- g +
    gganimate::transition_states(date) +
    gganimate::enter_fade() +
    gganimate::exit_fade()

  if(label!=""){
    g <- g +
      geom_text(aes_string(label = label, x = "lng", y = "lat", size = value), colour = colour)
  }

  if(is.null(nframes))
    nframes <- end_pause + (2*length(unique(x$date)))

  g <- gganimate::animate(
    g,
    width     = width,
    height    = height,
    nframes   = nframes,
    end_pause = end_pause,
    fps       = fps, ...)

  if(filename!=""){
    gganimate::anim_save(filename = filename, animation = g)
  }

  return(g)

}

