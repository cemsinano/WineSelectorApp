

shinyUI(dashboardPage(
  dashboardHeader(title = "Wine Selector App"),
  dashboardSidebar(
    
   sidebarMenu(
      menuItem("Home", tabName = "tabItem1", icon = icon("th")),
      menuItem("About", tabName = "tabItem2", icon = icon("th"))
    ),
  #  selectInput("tasterInput", "Taster Name",
  #             choices = unique(as.character(wineData$taster_name)),
  #              selected = c("Mike DeSimone","Lauren Buzzeo"),
  #              multiple = TRUE),

    sliderInput("priceInput", "Price Range",
                min = 0, max = 1000, 
                value = c(10, 60),
                step = 1,
                pre = "$"
    ),
    uiOutput("countryOutput"),
    sliderInput("pointsInput", "Point Range",
                min = 0, max = 100, 
                value = c(0, 100),
                step = 1,
                pre = ""
    ),
    selectInput("varietyInput", "Variety",
                choices = unique(as.character(wineData$variety)),
                selected = c("Syrah","White Blend"),
                multiple = TRUE)
  
  ),
  
  dashboardBody(
    # Boxes need to be put in a row (or column)
    tabItems(
      
      tabItem(tabName = "tabItem1",
            fluidRow(
              box(title = "Scores vs Price",
                  width = 350,
                  collapsible = TRUE,
                  plotlyOutput("coolplot")),
              
              
              box(title = "Country vs Variety",
                  width = 350,
                  collapsible = TRUE,
                  plotlyOutput("Secondplot"))
            ,   
           
              box(
                title = "Results",
                width = 350,
                collapsible = TRUE,
                #tableOutput("results")
                DT::dataTableOutput("results")
              ),
              box(
              width = 350,
              title = "World Map",
              collapsible = TRUE,
             plotlyOutput("MapPlot")
              )
             )
    
  ),
  
  tabItem(tabName = "tabItem2",
                   includeMarkdown("./about.md"),
                   hr()
  )
    )
))
)





