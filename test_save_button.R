library(rhandsontable)
library(shiny)

# setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # set your working directory

fname <- paste0('./input/cache/diamond/edited') # R object data frame stored as ASCII text
values <- list() 
setHot <- function(x) values[["hot"]] <<- x 

ui <- fluidPage(
  rHandsontableOutput("hot"),
  br(),
  actionButton("saveBtn", "Save changes")
)

server <- function(input, output, session) {
  
  observeEvent( 
    input$saveBtn, # update csv file each time the button is pressed
    {if (!is.null(values[["hot"]])) { # if there's a table input
      # write.csv(values[["hot"]], fname) # overwrite the temporary database file
      write.csv(x = values[["hot"]], file = paste0(fname, ".csv"), row.names = FALSE) # overwrite the csv
    }
  })
  
  output$hot <- renderRHandsontable({ 
    if (!is.null(input$hot)) { # if there is an rhot user input...
      DF <- hot_to_r(input$hot) # convert rhandsontable data to R object and store in data frame
      setHot(DF) # set the rhandsontable values
      
    } else {
      DF <- readRDS(paste0('./input/cache/diamond/J_Ideal.RDS'))
      setHot(DF) # set the rhandsontable values
    }
    
    rhandsontable(DF) %>% # actual rhandsontable object
      hot_table(highlightCol = TRUE, highlightRow = TRUE) 
  }
  )
  
}

shinyApp(ui = ui, server = server)