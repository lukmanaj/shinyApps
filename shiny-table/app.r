library(tidyverse)
library(gapminder)
library(DT)
library(shiny)

# CSS for styling
my_css <- "
#download_data {
  /* Change the background color of the download button
     to orange. */
  background: orange;

  /* Change the text size to 20 pixels. */
  font-size: 20px;
}

#table {
  /* Change the text color of the table to red. */
  color: red;
}
"

ui <- fluidPage(
  h1("Gapminder"),
  # Add the CSS that we wrote to the Shiny app
  tags$style(my_css),
  tabsetPanel(
    tabPanel(
      title = "Inputs",
      sliderInput(inputId = "life", label = "Life expectancy",
                  min = 0, max = 120,
                  value = c(30, 50)),
      selectInput("continent", "Continent",
                  choices = c("All", levels(gapminder$continent))),
      downloadButton("download_data")
    ),
    tabPanel(
      title = "Plot",
      plotOutput("plot")
    ),
    tabPanel(
      title = "Table",
      DT::dataTableOutput("table")
    )
  )
)

server <- function(input, output) {
  filtered_data <- reactive({
    data <- gapminder |>
      filter(lifeExp >= input$life[1], lifeExp <= input$life[2])
    
    if (input$continent != "All") {
      data <- data |>
        filter(continent == input$continent)
    }
    
    data
  })
  
  output$table <- DT::renderDataTable({
    data <- filtered_data()
    data
  })

  output$download_data <- downloadHandler(
    filename = "gapminder_data.csv",
    content = function(file) {
      data <- filtered_data()
      write_csv(data, file)
    }
  )

  output$plot <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(gdpPercap, lifeExp)) +
      geom_point() +
      scale_x_log10()
  })
}

shinyApp(ui, server)
