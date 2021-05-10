
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Key doge
#'
#' @param data,params,size key stuff
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
draw_key_doge <- function(data, params, size) {

  im <- png::readPNG(data$image_filename)

  aspect <- dim(im)[1]/dim(im)[2]

  grid::rasterGrob(
    image  = im,
    width  = ggplot2::unit(data$size / size         , 'snpc'),
    height = ggplot2::unit(data$size / size * aspect, 'snpc')
  )
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Draw doge
#'
#' @param mapping,data,stat,position,...,na.rm,show.legend,inherit.aes see
#'        documentation for \code{ggplot2::geom_point()}
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
geom_doge <- function(mapping     = NULL,
                      data        = NULL,
                      stat        = "identity",
                      position    = "identity",
                      ...,
                      na.rm       = FALSE,
                      show.legend = NA,
                      inherit.aes = TRUE) {
  layer(
    data        = data,
    mapping     = mapping,
    stat        = stat,
    geom        = GeomDoge,
    position    = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params      = list(
      na.rm    = na.rm,
      ...
    )
  )
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' GeomDoge
#'
#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
#' @import ggplot2
#' @import grid
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GeomDoge <- ggplot2::ggproto(
  "GeomDoge", ggplot2::Geom,
  required_aes = c("x", "y"),
  non_missing_aes = c("size"),
  default_aes = ggplot2::aes(
    shape  = 19,
    colour = "black",
    size   = 1.5,
    fill   = NA,
    alpha  = NA,
    stroke = 0.5,
    image_filename  = system.file("doge.png", package = "dogeR", mustWork = TRUE),
    scale = 5
  ),

  draw_panel = function(data, panel_params, coord, na.rm = FALSE) {

    coords <- coord$transform(data, panel_params)

    im <- png::readPNG(coords$image_filename)
    aspect <- dim(im)[1]/dim(im)[2]

    grid::rasterGrob(
      image  = im,
      x      = coords$x,
      y      = coords$y,
      width  = ggplot2::unit(coords$size * coords$scale         , 'pt'),
      height = ggplot2::unit(coords$size * coords$scale * aspect, 'pt')
    )

  },

  draw_key = draw_key_doge
)
