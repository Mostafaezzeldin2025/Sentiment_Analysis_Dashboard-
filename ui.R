library(shiny)
library(bslib)
library(wordcloud2)

ui <- fluidPage(
  theme = bs_theme(bootswatch = "flatly", primary = "#2c3e50"),
  
  # سكريبت لضمان إعادة رسم Word Cloud عند تغيير التبويب
  tags$head(
    tags$script(HTML("
      $(document).on('shiny:bound', function(event) {
        $('a[data-toggle=\"tab\"]').on('shown.bs.tab', function (e) {
          $(window).trigger('resize');
        });
      });
    "))
  ),
  
  titlePanel("Text Mining & Sentiment Analysis Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      h4("Input & Controls"),
      
      radioButtons("inputType", "Input Method:",
                   choices = c("Direct Text Input" = "text", 
                               "Upload Text File (.txt)" = "file")),
      
      conditionalPanel(
        condition = "input.inputType == 'text'",
        textAreaInput("userText", "Enter Text Here:", 
                      value = "Data science is amazing and R Shiny makes building dashboards easy and enjoyable! However, debugging can sometimes be challenging and frustrating.",
                      rows = 5)
      ),
      
      conditionalPanel(
        condition = "input.inputType == 'file'",
        fileInput("file1", "Choose .txt File", accept = c("text/plain", ".txt"))
      ),
      
      actionButton("analyzeBtn", "Analyze Text", class = "btn-primary w-100"),
      
      hr(),
      h5("Custom Filters"),
      
      sliderInput("topN", "Top Keywords Count:", min = 5, max = 25, value = 10),
      sliderInput("minFreq", "Min Word Frequency (Cloud):", min = 1, max = 5, value = 1),
      
      hr(),
      downloadButton("downloadData", "Download Word Stats (CSV)", class = "btn-outline-secondary w-100")
    ),
    
    mainPanel(
      width = 9,
      
      fluidRow(
        column(4, wellPanel(style = "text-align:center; background:#f8f9fa;", 
                            h6("Total Words"), h3(textOutput("totalWords")))),
        column(4, wellPanel(style = "text-align:center; background:#f8f9fa;", 
                            h6("Unique Words"), h3(textOutput("uniqueWords")))),
        column(4, wellPanel(style = "text-align:center; background:#f8f9fa;", 
                            h6("Overall Sentiment"), h3(textOutput("overallSentiment"))))
      ),
      
      br(),
      
      tabsetPanel(
        id = "main_tabs",
        tabPanel("Sentiment Breakdown", 
                 br(),
                 plotOutput("sentimentPlot", height = "400px")),
        tabPanel("Word Cloud", 
                 br(),
                 wordcloud2Output("wordcloudPlot", width = "100%", height = "400px")),
        tabPanel("Top Keywords", 
                 br(),
                 plotOutput("topWordsPlot", height = "400px"))
      )
    )
  )
)