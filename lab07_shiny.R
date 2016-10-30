# Courtesy by Dr. Mujeeb Basit

# List of packages for session
.packages <- c("shiny", "dplyr", "data.table", "ggplot2", "sqldf")
# Install CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if (length(.packages[!.inst]) > 0)
  install.packages(.packages[!.inst])
# Load packages into session
lapply(.packages, require, character.only = TRUE)


shinyApp(
  ui = fluidPage(
    titlePanel("Dimaonds Lab"),
    sidebarLayout(
      sidebarPanel(
        textInput("title", "Plot title:",
                  value = "x v y"),
        selectInput(
          "clarity",
          "1. Select clarity to graph:",
          choices = c("All", "I1",  "SI2",  "SI1",  "VS2",  "VS1",  "VVS2", "VVS1", "IF"),
          selected = "disp"
        ),
        sliderInput("carat", 
                    "2. Select carat range:", 
                    value = c(1, 2),
                    min = min(diamonds$carat), 
                    max = max(diamonds$carat),
                    step = 0.1
        ),
        selectizeInput(
          "Cut",
          "3. Select the cut values you want to graph",
          choices = diamonds$cut,
          multiple = TRUE
        )
      ),
      
      mainPanel(h3(textOutput("Diamonds")),
                plotOutput("diamPlot"))
    )
  ),
  
  server = function(input, output, session) {
    # Whenever a field is filled, aggregate all form data
    loadDiamonds <- reactive({
      data(diamonds)
      
      query = paste("SELECT * FROM diamonds WHERE (carat >= ", input$carat[1], 
                    ") AND (carat <= ", input$carat[2], ") ", sep="")
      
      if(input$clarity != "All") {
        query = paste(query, " AND (clarity = '", input$clarity, "')", sep="")
      }
      
      print(query)
      
      diasamp = sqldf(query)
      #diasamp = diamonds[sample(1:length(diamonds$price), 10000),]
      #diasamp = diamonds
      
      diasamp
    })
    
    output$diamPlot <- renderPlot(
      ggplot(loadDiamonds(), aes(
        x = cut, y = price, color = cut
      )) +
        geom_violin() +
        geom_boxplot(width = 0.3, outlier.size = 0)
    )
  }
)