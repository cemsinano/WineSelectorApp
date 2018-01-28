
#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


#wineData <-read.csv("https%3A%2F%2Fwww.kaggle.com%2Fzynicide%2Fwine-reviews%2Fdownloads%2Fwinemag-data-130k-v2.csv")

#wineData <-read.csv("https://www.kaggle.com/zynicide/wine-reviews/downloads/winemag-data-130k-v2.csv")





wineData <- wineData %>% select(title, points, price, description, taster_name,variety, country)

wineData <- wineData %>% mutate(code  = countrycode(country, 'country.name', 'iso3c'))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                sort(unique(wineData$country)),
                selected = c("Turkey", "Israel"),
                multiple = TRUE)
  })  
  
  
    filtered <- reactive({
    #   if (is.null(input$countryInput)){
    #       if(is.null(input$varietyInput)){
    #         if(is.null(input$tasterInput)){
    #           wineData %>%
    #           filter(price >= input$priceInput[1],
    #                  price <= input$priceInput[2],
    #                  points  >= input$pointsInput[1],
    #                  points <= input$pointsInput[2]
    #                  )
    #         }
    #         else{
    #           filter(price >= input$priceInput[1],
    #                price <= input$priceInput[2],
    #                points  >= input$pointsInput[1],
    #                points <= input$pointsInput[2],
    #                taster_name %in% input$tasterInput
    #         )
    #         }
    #       }
    #       else
    #       {
    #         filter(price >= input$priceInput[1],
    #                price <= input$priceInput[2],
    #                variety %in% input$varietyInput,
    #                points  >= input$pointsInput[1],
    #                points <= input$pointsInput[2],
    #                taster_name %in% input$tasterInput
    #         )
    #       }
    #   } 
    #   
    #   else if(is.null(input$tasterInput)){
    #     if(is.null(input$varietyInput)){
    #       wineData %>%
    #         filter(price >= input$priceInput[1],
    #              price <= input$priceInput[2],
    #              country %in% input$countryInput,
    #              points  >= input$pointsInput[1],
    #              points <= input$pointsInput[2]
    #       )
    #     }
    #     else{
    #       wineData %>%
    #         filter(price <= input$priceInput[2],
    #       country %in% input$countryInput,
    #       variety %in% input$varietyInput,
    #       points  >= input$pointsInput[1],
    #       points <= input$pointsInput[2]
    # )
    #     }
    #   }
    #   else if(is.null(input$varietyInput)){
    #     wineData %>%
    #       filter(price >= input$priceInput[1],
    #              price <= input$priceInput[2],
    #              country %in% input$countryInput,
    #              points  >= input$pointsInput[1],
    #              points <= input$pointsInput[2],
    #              taster_name %in% input$tasterInput
    #       )
    #   }
    #  else{
      wineData %>%
        filter(price >= input$priceInput[1],
               price <= input$priceInput[2],
               country %in% input$countryInput,
               variety %in% input$varietyInput,
               points  >= input$pointsInput[1],
               points <= input$pointsInput[2]
              # ,taster_name %in% input$tasterInput
        )
   #   }
    })
  
    output$coolplot <- renderPlotly({
      if (is.null(filtered())) {
       return()
      }
    d <- data.frame(p=c(0:25,32:127))
    p <-   ggplot(filtered(), aes(price,points,
                                  color = country,
                                  shape = variety,
                                  name = title)) +
        geom_point(show.legend=F) +
        scale_shape_discrete(solid=F)+
      theme_bw()
    ggplotly(p)
    
    })
    
    output$Secondplot <- renderPlotly({
      if (is.null(filtered())) {
        return()
      }
      p <-   ggplot(filtered(), aes(x = country)) +
        geom_bar(aes(fill = variety), show.legend=F) +
        theme_bw()
      ggplotly(p)
      
      
    })
    
    

    output$results <- DT::renderDataTable({
      DT::datatable(filtered(), option = list(scrollX = TRUE, pageLength = 3))
      
      })
    #renderTable({
    #  filtered()
    #})
    
    output$MapPlot <- renderPlotly({
      if (is.null(filtered())) {
        return()
      }
      # light grey boundaries
      l <- list(color = toRGB("grey"), width = 0.5)
      
      # specify map projection/options
      g <- list(
        showframe = T,
        showcoastlines = T,
        projection = list(type = 'Mercator')
      )
      
      p <- plot_geo(filtered()) %>%
        add_trace(
          z = ~price, color = ~price, colors = 'Blues',
          text = ~country, locations = ~code, marker = list(line = l)
        ) %>%
        colorbar(title = 'Average Price') %>%
        layout(
          title = 'Wine Map',
          geo = g
        )
      
      p
      
    })
    
    
  })
  
