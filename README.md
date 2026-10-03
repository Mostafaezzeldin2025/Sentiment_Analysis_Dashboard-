# Text Mining & Sentiment Analysis Dashboard

An interactive R Shiny application built to perform sentiment breakdown, keyword frequency analysis, and word cloud generation from custom text or uploaded documents. I created this project to work with unstructured text data, implement NLP lexicons in R, and build interactive Shiny controls.

## Live Demo

You can try the live interactive dashboard hosted on shinyapps.io here:  
*(Paste your shinyapps.io link here once deployed)*

## What the App Does

The dashboard processes input text through three core modules:

1. **Sentiment Breakdown**: Analyzes the emotional tone of the text (NRC Lexicon) across categories like joy, sadness, anger, trust, and fear, alongside an overall positive/negative evaluation.
2. **Word Cloud Visualizer**: Displays a dynamic word cloud of non-stopword terms, with a custom slider to filter out low-frequency words.
3. **Top Keywords**: Plots a bar chart of the most frequent terms (Top 5 to Top 25) with options to export the cleaned summary table as a CSV file.

## Tech Stack & Packages

- **R** & **Shiny** for application logic and reactive interface.
- **bslib** for dashboard layout and styled theme cards.
- **tidytext** & **syuzhet** for text tokenization, stop-word removal, and sentiment analysis.
- **wordcloud2** & **ggplot2** for text visualizations and frequency charts.

## Running the App Locally

If you want to run this application on your local machine:

1. Clone this repository:
   ```bash
   git clone [https://github.com/Mostafaezzeldin2025/text-sentiment-shiny-dashboard.git](https://github.com/Mostafaezzeldin2025/text-sentiment-shiny-dashboard.git)
      Open ui.R or server.R in RStudio.
Ensure required packages are installed:
install.packages(c("shiny", "tidyverse", "tidytext", "wordcloud2", "syuzhet", "bslib", "rsconnect"))
Click Run App in RStudio.
