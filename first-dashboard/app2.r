## Boilerplate code for a shiny dashboard 


num_listings <- function(range){
  # Filter listings appropriately
  filter(listings, price >= range[1], price <= range[2]) %>% nrow()
}
make_plots <- function(range, choice){
  filtered_listings <- filter(listings, price >= range[1], price <= range[2])
  # Set the correct if-else conditions
  if (choice == "Box plots"){
     filtered_listings %>%
      ggplot(aes(y = price, x = room_type)) + geom_boxplot() + theme_classic()
  }
  else if (choice == "Violin plots"){
    filtered_listings %>%
      ggplot(aes(y = price, x = room_type)) + geom_violin() + theme_classic()
}}







body <- dashboardBody(
  tabItems(
    tabItem(tabName = "charts",
            fluidRow(
              valueBoxOutput(outputId = "count"), valueBoxOutput(outputId = "prop"),valueBoxOutput(outputId = "med") ),
            fluidRow(
              tabBox(side = "left", id = "tabset", height = "500px",
                     tabPanel("Charts", 
                              # Place plotly object here
                              fluidRow(box(plotlyOutput("plots", height = 500, width = 600)) ) ), 
                     # Place dataTable object here
                     tabPanel("Data table", height = "500px", DT::DTOutput("table")) ), 
              box(side = "right", height = "200px", title = "Welcome to London!",),
              box(side = "right", height = "385px", title = "Controls",
                  sliderInput(inputId = "range", label = "Select price range:",
                              min = 0, max = 25000,value = c(0,2500)),
                  selectInput(inputId = "select", label = "Select group:", 
                              choices = c("Box plots", "Violin plots")) ) ) ),
    tabItem(tabName = "map",
            # Place leaflet object here
            fluidRow(box(title = "Map of listings in London", leaflet("map", height = 600, width = 700))) ) ) ) 

# Set the correct arguments for dashboardPage()
ui <- dashboardPage(header,sidebar,body) 

server <- function(input, output) {
  output$count <- renderValueBox(valueBox("Number of listings", num_listings(input$range), 
                                        icon = icon("house-user") ))
  output$prop <- renderValueBox(valueBox("Private rooms", paste0(num_private_rooms(input$range), "% of all listings"),
                                        icon = icon("eye"), color = "orange") )
  output$med <- renderValueBox(valueBox("Median price", paste0(median_price(input$range), "£"), 
                                        icon = icon("money-bill-alt"), color = "olive") )
  output$plots <- renderPlotly(make_plots(input$range, input$select))
  output$table <- renderDataTable(filter(listings, price >= input$range[1], price <= input$range[2]) %>% select(c(name, neighbourhood, room_type, price)), 
                                  options = list(lengthMenu = c(5, 30, 50)))
  output$map <- renderLeaflet(m_london)
}

shinyApp(ui, server)