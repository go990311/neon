# Correlation

# Libraries ----

# Shiny
library(shiny)
library(bslib)

# Modeling
library(modeldata)
library(DataExplorer)

library(ggplot2)

# Widgets
library(plotly)

# Core
library(tidyverse)


# Load Datasets ----
utils::data("stackoverflow", "car_prices", "Sacramento", package = "modeldata")

data_list = list(
    "StackOverflow" = stackoverflow,
    "Car Prices"    = car_prices,
    "Sacramento Housing" = Sacramento
)

# 1.0 Define UI  ----
ui <- navbarPage(

    title = "Data Explorer",

    theme = bslib::bs_theme(version = 4, bootswatch = "minty"),

    tabPanel(
        title = "Explore",

        sidebarLayout(

            sidebarPanel(
                width = 3,
                h1("Explore a Dataset"),

                # Requires Reactive Programming Knowledge
                # - Taught in Shiny Dashboards (DS4B 102-R)
                shiny::selectInput(
                    inputId = "dataset_choice",
                    label   = "Data Connection",
                    choices = c("StackOverflow", "Car Prices", "Sacramento Housing")
                ),

                # Requires Boostrap Knowledge
                hr(),
                h3("Apps for web framework"),
                p("Correlation between variables"),
                p("Learn Shiny Today!") %>%
                    a(
                        href = 'https://yards.albert-rapp.de/shiny-applications.html',
                        target = "_blank",
                        class = "btn btn-lg btn-primary"
                    ) %>%
                    div(class = "text-center")


            ),

            mainPanel(
                h1("Correlation"),
                plotlyOutput("corrplot", height = 700)
            )
        )

    )


)

# 2.0 Define server  ----
server <- function(input, output) {

    # Reactive Programming ----

    rv <- reactiveValues()

    observe({

        rv$data_set <- data_list %>% pluck(input$dataset_choice)

    })

    output$corrplot <- renderPlotly({

        g <- DataExplorer::plot_correlation(rv$data_set)

        plotly::ggplotly(g)
    })

}

# Run Shiny app
shinyApp(ui = ui, server = server)
