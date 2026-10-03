library(shiny)
library(tidyverse)
library(tidytext)
library(wordcloud2)
library(syuzhet)

server <- function(input, output, session) {
  
  # استخراج النص
  getText <- eventReactive(input$analyzeBtn, {
    if (input$inputType == "text") {
      req(input$userText)
      return(input$userText)
    } else {
      req(input$file1)
      text <- readLines(input$file1$datapath, warn = FALSE)
      return(paste(text, collapse = " "))
    }
  }, ignoreNULL = FALSE)
  
  # تنظيف البيانات
  getCleanData <- reactive({
    raw_text <- getText()
    req(nchar(raw_text) > 0)
    
    df <- tibble(text = raw_text) %>%
      unnest_tokens(word, text) %>%
      anti_join(stop_words, by = "word") %>%
      filter(!str_detect(word, "^[0-9]+$"))
    
    req(nrow(df) > 0)
    return(df)
  })
  
  output$totalWords <- renderText({
    df <- getCleanData()
    nrow(df)
  })
  
  output$uniqueWords <- renderText({
    df <- getCleanData()
    n_distinct(df$word)
  })
  
  output$overallSentiment <- renderText({
    raw_text <- getText()
    sent_score <- get_sentiment(raw_text, method = "syuzhet")
    
    if (sent_score > 0) {
      "Positive 😊"
    } else if (sent_score < 0) {
      "Negative 🙁"
    } else {
      "Neutral 😐"
    }
  })
  
  output$sentimentPlot <- renderPlot({
    raw_text <- getText()
    sentiments <- get_nrc_sentiment(raw_text)
    sentiment_scores <- data.frame(Sentiment = colnames(sentiments), Score = colSums(sentiments))
    
    ggplot(sentiment_scores, aes(x = reorder(Sentiment, Score), y = Score, fill = Sentiment)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      labs(title = "Detailed Emotional Breakdown (NRC Lexicon)", x = "Emotion / Sentiment", y = "Score") +
      theme_minimal(base_size = 14)
  })
  
  # 2. سحابة الكلمات مع التأكد من وجود كلمات بعد الفلترة
  output$wordcloudPlot <- renderWordcloud2({
    df <- getCleanData() %>%
      count(word, sort = TRUE) %>%
      filter(n >= input$minFreq)
    
    validate(
      need(nrow(df) > 0, "No words match the selected minimum frequency filter. Try lowering 'Min Word Frequency'.")
    )
    
    wordcloud2(df, size = 0.6, color = "random-dark")
  })
  
  # 3. أعلى الكلمات
  output$topWordsPlot <- renderPlot({
    df <- getCleanData() %>%
      count(word, sort = TRUE) %>%
      slice_max(n, n = input$topN, with_ties = FALSE)
    
    validate(
      need(nrow(df) > 0, "No data available to display top keywords.")
    )
    
    ggplot(df, aes(x = reorder(word, n), y = n)) +
      geom_col(fill = "#2c3e50") +
      coord_flip() +
      labs(title = paste("Top", min(input$topN, nrow(df)), "Most Frequent Words"), x = "Word", y = "Frequency") +
      theme_minimal(base_size = 14)
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("text_sentiment_stats_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      df <- getCleanData() %>%
        count(word, sort = TRUE)
      write.csv(df, file, row.names = FALSE)
    }
  )
}