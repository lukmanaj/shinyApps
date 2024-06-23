library(shiny)
library(shinydashboard)

header <- dashboardHeader(
  title = "Portfolio dashboard for Sally",
  titleWidth = 300,
  dropdownMenu(type = "notifications",
       notificationItem("Sell alert", status = "danger"),
       notificationItem("Buy alert", status = "success"))
)

sidebar <- dashboardSidebar(
  width = 300,
  sidebarMenu(
    id = "pages",
    menuItem("Historical trends",
             tabName = "historical"),
    menuItem("Profits and Losses (PnLs)", 
             tabName = "profit", 
             icon = icon("money-bill-alt"),
             badgeLabel = "+2.3%", badgeColor = "green")
  )
)

body <- dashboardBody(tabItems(
  tabItem(tabName = "historical",
          fluidRow(box(selectInput("stock", "Select stock symbol", 
                                   choices=c("AAPL", "DIS"))),
                   box("Stock name", 
                       title="Stock name title", 
                       width = 6, 
                       status = "info", solidHeader = TRUE)),
          fluidRow(infoBox("Open", "value", width = 2, color = "black"), 
                   infoBox("High", "value", width = 2, color = "black"),
                   infoBox("Low", "value", width = 2, color = "black"),
                   infoBox("Close", "value", width = 2, color = "black"),
                   infoBox("Volume", "value", width = 4, color = "navy")),
          # Change the color of each valueBox
          fluidRow(valueBox("Open (%)", "0%", width = 2, color="yellow"), 
                   valueBox("High (%)", "+1%", width = 2, color="green"),
                   valueBox("Low (%)", "-4%", width = 2, color="red"),
                   valueBox("Close (%)", "-2%", width = 2, color="red"),
                   valueBox("Volume (%)", "+30%", width = 2, color="green")),
          fluidRow(box("Candlestick chart", width = 12, height = 350)),
          fluidRow(box("Volume chart", width = 12, height = 200))),
  tabItem(tabName = "profit",
          fluidRow(box("valueBox", "Account balance", width = 3),
                   box("valueBox",  "Value at Risk (Var)", width = 3),
                   box("valueBox", "Returns", width = 3),
                   box("valueBox", "Profit-to-loss ratio", width = 3)),
          fluidRow(box("PnL chart", width = 12, height = 400)))
)
)

ui <- dashboardPage(header, sidebar, body)
server <- function(input, output){}
shinyApp(ui, server)