library(shiny)
library(tidyverse)
library(shinydashboard)

soccer <- read_csv("soccer.csv")

red_plot <- ggplot(soccer, aes(x = redCards, y = country)) +
  geom_bar(stat = "identity", fill = "grey40") +
  xlab("Total number of red cards") +
  ylab("Country") +
  theme_minimal()

red_plot <- ggplot(soccer, aes(x = yellowCards, y = country)) +
  geom_bar(stat = "identity", fill = "grey40") +
  xlab("Total number of yellow cards") +
  ylab("Country") +
  theme_minimal()

goals_plot <- ggplot(soccer, aes(x = goals, y = country)) +
  geom_bar(stat = "identity", fill = "grey40") +
  xlab("Total number of goalss") +
  ylab("Country") +
  theme_minimal()

daytime_fn <- function(match){
  filter(soccer, match_no == match) %>%
    mutate(datetime = paste(date, hour)) %>%
    pull(datetime)
}


venue_fn <- function(match){
  filter(soccer, match_no == match) %>%
    pull(venue)
}


grp_fn <- function(match){
  filter(soccer, match_no == match) %>%
    pull(group)
}


team1_fn <- function(match){
  filter(soccer, match_no == match) %>%
    pull(`1`)
}

team2_fn <-  function(match){
  filter(soccer, match_no == match) %>%
    pull(`2`)
}

score1_fn <-  function(match){
  filter(soccer, match_no == match) %>%
    pull(`1_goals`)
}

score2_fn <- function(match){
  filter(soccer, match_no == match) %>%
    pull(`1_goals`)
}




body <- dashboardBody(tabItems(
  tabItem(tabName = "matchtab", 
  fluidRow(selectInput("match", "Match number", choices = 1:nrow(soccer)),
           infoBoxOutput("daytime"), infoBoxOutput("venue"), infoBoxOutput("grp")),
  fluidRow(valueBoxOutput("team1", width = 3), valueBoxOutput("score1", width = 3), 
           valueBoxOutput("team2", width = 3), valueBoxOutput("score2", width = 3)),
  fluidRow(plotOutput("histogram"))),
  tabItem(tabName = "statstab", 
          tabBox(tabPanel("Goals", plotOutput("goals", height = "700px")),
                 tabPanel("Yellow cards", plotOutput("yellow", height = "700px")),
                 tabPanel("Red cards", plotOutput("red"))))
))

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {
  # Fill in outputs in first to third rows of the first page
  output$daytime <- renderInfoBox(infoBox("Day and time", 
                                          daytime_fn(input$match), 
                                          icon = icon("calendar"), 
                                          color = "green"))
  output$venue <- renderInfoBox(infoBox("Venue", 
                                        venue_fn(input$match), 
                                        icon = icon("map"), 
                                        color = "green"))
  output$grp <- renderInfoBox(infoBox("Group", 
                                      grp_fn(input$match), 
                                      color = "green"))
  output$team1 <- renderValueBox(valueBox("Team 1", team1_fn(input$match), color = "blue"))
  output$score1 <- renderValueBox(valueBox("# of goals", score1_fn(input$match), color = "blue"))
  output$team2 <- renderValueBox(valueBox("Team 2", team2_fn(input$match), color = "red")) 
  output$score2 <- renderValueBox(valueBox("# of goals", score2_fn(input$match), color = "red"))
  output$histogram <- renderPlot(plot_histogram(input$match))
  # Fill in outputs in the second page
  output$goals <- renderPlot(goals_plot)
  output$yellow <- renderPlot(yellow_plot)
  output$red <- renderPlot(red_plot)
}

# Put the UI and server together
shinyApp(ui,server)