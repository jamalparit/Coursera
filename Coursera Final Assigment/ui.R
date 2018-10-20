suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
shinyUI(navbarPage("Data Science Capstone: Final Project",
                   tabPanel("Predict the Next Word",
                            # Sidebar
                              sidebarLayout(
                              sidebarPanel(
                                helpText("Enter a partially complete sentence to begin the next word prediction"),
                                textInput("inputString", "Enter a partial sentence here",value = ""),
                                br(),
                                br(),
                                br(),
                                HTML("<strong>Author: Ismail Bin Che Ani</strong>"),
                                br(),
                                HTML("<strong>Date: 20.10.2018</strong>"),
                                br()
                                ),
                              mainPanel(
                                  h2("Predicted Next Word"),
                                  verbatimTextOutput("prediction"),
                                  strong("Sentence Input:"),
                                  tags$style(type='text/css', '#text1 {background-color: rgba(255,255,0,0.40); color: blue;}'), 
                                  textOutput('text1'),
                                  br(),
                                  strong("Note:"),
                                  tags$style(type='text/css', '#text2 {background-color: rgba(255,255,0,0.40); color: black;}'),
                                  textOutput('text2')
                              )
                              )
                             
                  )
                  ,
                  img(src = "./headers.png"),
                  tabPanel("About",
                           mainPanel(
                             includeMarkdown("about.md")
                           )
                  )
                  ,
                   tabPanel("Assigmnent Instruction",
                            mainPanel(
                              includeMarkdown("assignment.md")
                            )
                   )
)
)