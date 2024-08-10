# The handwriterAppDemo R package performs writership analysis of handwritten
# documents. Copyright (C) 2024 Iowa State University of Science and Technology
# on behalf of its Center for Statistics and Applications in Forensic Evidence
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.

library(bslib)
library(dplyr)
library(handwriter)
library(magick)
library(magrittr)
library(shiny)
library(shinycssloaders)
library(shinyjs)
library(stringr)
library(tidyr)

source("current_image.R")
source("demo_known.R")
source("demo_preview.R")
source("demo_qd.R")
source("inner.R")
source("server_utils.R")
source("ui_utils.R")


options(shiny.maxRequestSize = 30*1024^2)
shiny::addResourcePath("www", "www")

ui <- shiny::shinyUI(
  shiny::fluidPage(title = "handwriter",
                   shinyjs::useShinyjs(),
                   tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
                   # shiny::includeCSS(system.file("extdata", "styles.css", package = "handwriterAppDemo")),
                   shiny::tags$head(
                     shiny::tags$link(
                       href = "https://fonts.googleapis.com/css?family=Montserrat:400,500,700,900|Ubuntu:400,500,700",
                       rel = "stylesheet",
                       type = "text/css"
                     ),
                   ),
                   shiny::tags$div(id="app-container",
                                   shiny::fluidRow(
                                     shiny::column(width = 4, shiny::tags$a(target = "_blank", href="https://forensicstats.org", shiny::tags$img(src = "www/CSAFE_Tools_handwriter_cropped.png", height="100px"))),
                                     shiny::column(width = 4, shiny::br()),
                                     shiny::column(width = 4, shiny::tags$a(target = "_blank", href="https://forensicstats.org", shiny::tags$img(src = "www/handwriter_graphic.png", height="100px"), class="right-float")),
                                   ),
                                   shiny::tags$div(id="main-content",
                                                   shiny::navbarPage(
                                                     shiny::tags$script(shiny::HTML("var header = $('.navbar > .container-fluid'); header.append('<div style=\"float:right\"><a href=\"https://forensicstats.org\"><img src=\"www/CSAFE-Tools_Stacked_white_cropped.png\" alt=\"alt\" style=\"float:right;width:117px;height:50px;padding-right:5px;\"> </a></div>'); console.log(header)")),
                                                     shiny::tabPanel(
                                                       "Home",
                                                       innerUI('inner1'),
                                                     ),
                                                     shiny::tabPanel( 
                                                       "About",
                                                       shiny::includeHTML("www/about.html")
                                                     ),
                                                     shiny::tabPanel(
                                                       "Contact",
                                                       shiny::includeHTML("www/contact.html")
                                                     )
                                                   ))),
                   # Footer
                   shiny::tags$div(id="global-footer",
                                   shiny::fluidRow(
                                     shiny::column(width = 4, shiny::tags$img(src="www/csafe_tools_blue_h.png", alt="Logo", height = "40px")),
                                     shiny::column(width = 4, shiny::tags$p("195 Durham Center, 613 Morrill Road, Ames, Iowa, 50011")),
                                     shiny::column(width = 4, shiny::tags$p("(C) 2023 | All Rights Reserved", class="right-float"))
                                   )
                   )
  )  
)

# SERVER ------------------------------------------------------------------
server <- function(input, output, session) {
  innerServer('inner1')
}

shiny::shinyApp(ui = ui, server = server)
