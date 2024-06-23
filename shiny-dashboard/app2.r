## Boilerplate for a shiny app


body <- dashboardBody(
  tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "helvetica",  serif, Times, "Times New Roman";
        font-weight: bold;
        font-size: 24px;
      }
	  /* Change the background-color to hexcode #000000 */
      .skin-blue .main-header .logo {
                background-color: #000000; 
      }
	  /* Change the hovered over color to gray */
      .skin-blue .main-header .logo:hover {
                background-color: gray; 
      }
      .skin-blue .main-header .navbar {
                background-color: #999999;
      } 
      .content-wrapper, .right-side {
         background-color: #252525;
      }
      '))),
          fluidRow(box(selectInput("stock", "Stock name", choices = c("AAPL", "DIS")))),
          fluidRow(valueBoxOutput("name", width = 2), 
                   valueBoxOutput("open", width = 2), 
                   valueBoxOutput("close", width = 2), 
                   valueBoxOutput("high", width = 2), 
                   valueBoxOutput("low", width = 2), 
                   valueBoxOutput("vol", width = 2)),
          fluidRow(box("This stock is in your portfolio", width = 2, status = "success"),
                   valueBoxOutput("open_pct", width = 2), 
                   valueBoxOutput("close_pct", width = 2), 
                   valueBoxOutput("high_pct", width = 2), 
                   valueBoxOutput("low_pct", width = 2), 
                   valueBoxOutput("vol_pct", width = 2)),
          fluidRow(box(plotlyOutput("line")), 
                   box(radioButtons("feature", "Features", 
                       choiceNames = c("Open", "Close", "High", "Low", "Volume"),
                       choiceValues = c("open", "close", "high", "low", "volume")) ) )
          )

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {
  output$name <- renderValueBox(valueBox("Stock name", get_name(input$stock), color = "black"))
  output$open <- renderValueBox(valueBox("Open price", most_recent(input$stock, "open"), color = "black"))
  output$close <- renderValueBox(valueBox("Close price", most_recent(input$stock, "close"), color = "black"))
  output$high <- renderValueBox(valueBox("High", most_recent(input$stock, "high"), color = "black"))
  output$low <- renderValueBox(valueBox("Low", most_recent(input$stock, "low"), color = "black"))
  output$vol <- renderValueBox(valueBox("Volume", most_recent(input$stock, "volume"), color = "black"))
  output$open_pct <- renderValueBox(valueBox("Change", paste0(most_recent_pct(input$stock, "open"),"%"), color = box_color(most_recent_pct(input$stock, "open"))))
  output$close_pct <- renderValueBox(valueBox("Change", paste0(most_recent_pct(input$stock, "close"),"%"), color = box_color(most_recent_pct(input$stock, "close"))))
  output$high_pct <- renderValueBox(valueBox("Change", paste0(most_recent_pct(input$stock, "high"),"%"), color = box_color(most_recent_pct(input$stock, "high"))))
  output$low_pct <- renderValueBox(valueBox("Change", paste0(most_recent_pct(input$stock, "low"),"%"), color = box_color(most_recent_pct(input$stock, "low"))))
  output$vol_pct <- renderValueBox(valueBox("Change", paste0(most_recent_pct(input$stock, "volume"),"%"), color = box_color(most_recent_pct(input$stock, "volume"))))
  output$line <- renderPlotly(plot_line(input$stock, input$feature))
}

shinyApp(ui, server)