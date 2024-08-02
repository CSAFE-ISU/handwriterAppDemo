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

innerUI <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::sidebarLayout(shiny::tags$div(id=ns("my-sidebar"),
                                         shiny::sidebarPanel(width=3,
                                                             shiny::fluidPage(
                                                               
                                                               # Welcome UI ----
                                                               shiny::conditionalPanel(condition="input.screen == 'Welcome'",
                                                                                       ns = shiny::NS(id),
                                                                                       shiny::div(id = "autonomous",
                                                                                                  format_sidebar(title = "GET STARTED",
                                                                                                                 help_text = "See handwriter in action with example handwriting samples."),
                                                                                                  shiny::fluidRow(shiny::column(width = 3, shiny::actionButton(ns("demo_button"), "Demo")))
                                                                                       ),
                                                               ),
                                                               
                                                               # Demo UI ----
                                                               shiny::conditionalPanel(condition="input.screen == 'Demo Preview'",
                                                                                       ns = shiny::NS(id),
                                                                                       shiny::div(id = "autonomous",
                                                                                                  shiny::includeHTML("www/demo_preview.html"),
                                                                                                  shiny::fluidRow(shiny::column(width = 3, shiny::actionButton(ns("demo_preview_back_button"), "Back")), 
                                                                                                                  shiny::column(width = 9, align = "right", shiny::actionButton(ns("demo_preview_next_button"), "Next")))
                                                                                       ),
                                                               ),
                                                               
                                                               # Demo Known UI ----
                                                               shiny::conditionalPanel(condition="input.screen == 'Demo Known'",
                                                                                       ns = shiny::NS(id),
                                                                                       shiny::div(id = "autonomous",
                                                                                                  format_sidebar(title = "KNOWN WRITING",
                                                                                                                 help_text = "Estimate writer profiles from the known writing samples and fit a statistical model to the writer profiles.",
                                                                                                                 module = demoKnownSidebarUI(ns("demo_known")),
                                                                                                                 break_after_module = TRUE),
                                                                                                  shiny::fluidRow(shiny::column(width = 3, shiny::actionButton(ns("demo_known_back_button"), "Back")), 
                                                                                                                  shiny::column(width = 9, align = "right", shiny::actionButton(ns("demo_known_next_button"), "Next")))
                                                                                       ),
                                                               ),
                                                               
                                                               # Demo QD UI ----
                                                               shiny::conditionalPanel(condition="input.screen == 'Demo QD'",
                                                                                       ns = shiny::NS(id),
                                                                                       shiny::div(id = "autonomous",
                                                                                                  format_sidebar(title = "QUESTIONED DOCUMENTS",
                                                                                                                 help_text = "Estimate writer profiles from the questioned documents. Use the statistical model to estimate the posterior probabilities that each POI wrote a questioned document.",
                                                                                                                 module = demoQDSidebarUI(ns("demo_qd")),
                                                                                                                 break_after_module = TRUE),
                                                                                                  shiny::fluidRow(shiny::column(width = 3, shiny::actionButton(ns("demo_qd_back_button"), "Back")),
                                                                                                                  shiny::column(width = 9, align = "right", shiny::actionButton(ns("demo_qd_next_button"), "Finish")))
                                                                                       ),
                                                               ),
                        
                                                             ))),
                         shiny::mainPanel(
                           shiny::tabsetPanel(id=ns("screen"),
                                              type = "hidden",
                                              
                                              # Welcome Display ----
                                              shiny::tabPanel(id = ns("Welcome"),
                                                              title = "Welcome",
                                                              shiny::h3("WELCOME TO HANDWRITER!"),
                                                              shiny::p("Handwriter is designed to assist forensic examiners by analyzing handwritten 
                                                documents against a closed set of potential writers. It determines the probability 
                                                that each writer wrote the document. Whether you are a forensic document examiner, 
                                                legal professional, academic, or simply curious about how statistics are applied to 
                                                handwriting, handwriter provides an automated way to evaluate handwriting samples."),
                                                              shiny::br(),
                                              ),
                                              
                                              # Demo Display ----
                                              shiny::tabPanel(id = ns("Demo Preview"),
                                                              title = "Demo Preview",
                                                              shinycssloaders::withSpinner(demoPreviewBodyUI(ns('demo_preview')))
                                              ),
                                              
                                              # Demo Known Display ----
                                              shiny::tabPanel(id = ns("Demo Known"),
                                                              title = "Demo Known",
                                                              shinycssloaders::withSpinner(demoKnownBodyUI(ns('demo_known')))
                                              ),
                                              
                                              # Demo QD Display ----
                                              shiny::tabPanel(id = ns("Demo QD"),
                                                              title = "Demo QD",
                                                              shinycssloaders::withSpinner(demoQDBodyUI(ns('demo_qd')))
                                              ),
                           )
                         )
    )
  )
}


innerServer <- function(id){
  shiny::moduleServer(
    id,
    function(input, output, session){
      # NEXT BUTTONS ----
      # disable next buttons at start
      shinyjs::disable("demo_known_next_button")
      
      # enable next buttons
      shiny::observe({
        # model needs to be loaded
        shiny::req(global$model)
        shinyjs::enable("demo_known_next_button")
      })
      
      # demo next buttons
      shiny::observeEvent(input$demo_button, {shiny::updateTabsetPanel(session, "screen", selected = "Demo Preview")})
      shiny::observeEvent(input$demo_preview_next_button, {shiny::updateTabsetPanel(session, "screen", selected = "Demo Known")})
      shiny::observeEvent(input$demo_known_next_button, {shiny::updateTabsetPanel(session, "screen", selected = "Demo QD")})
      shiny::observeEvent(input$demo_qd_next_button, {shiny::updateTabsetPanel(session, "screen", selected = "Welcome")})
      
      # demo back buttons
      shiny::observeEvent(input$demo_preview_back_button, {shiny::updateTabsetPanel(session, "screen", selected = "Welcome")})
      shiny::observeEvent(input$demo_known_back_button, {shiny::updateTabsetPanel(session, "screen", selected = "Demo Preview")})
      shiny::observeEvent(input$demo_qd_back_button, {shiny::updateTabsetPanel(session, "screen", selected = "Demo Known")})
      
      # STORAGE ----
      global <- shiny::reactiveValues(
        analysis = NULL,
        known_names = NULL,
        known_paths = NULL,
        main_dir = NULL,
        model = NULL,
        qd_names = NULL,
        qd_paths = NULL
      )
      
      # Reset storage
      shiny::observeEvent(input$demo_button, {
        # reset_app(global)
        # delete_demo_dir()
      })
      
      # Reset storage and empty temp > demo directory
      shiny::observeEvent(input$demo_qd_next_button, {
        # reset_app(global)
        # delete_demo_dir()
      })
      
      # DEMO PREVIEW ----
      demoPreviewServer('demo_preview', global)
      
      # DEMO KNOWN ----
      demoKnownServer('demo_known', global)
      
      # DEMO QD ----
      demoQDServer('demo_qd', global)
      
    }
  )
}