# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# this app uses Kim (2014)
# to plot a confusion matrix
# created by: Amy Finnegan
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




# setup =======================================================================

library(dplyr)
library(magrittr)
library(shiny)
library(shinydashboard)
  
# app =========================================================================


ui <- navbarPage(
  title=HTML("<a href=\"http://www.designsandmethods.com/book/\" target=_blank>
             Global Health Research</a>"),
  
  # title=HTML("<img src=logo.png style=width:42px;height:42px;border:0;align:right;>
  #            <a href=\"http://www.designsandmethods.com/book/\" target="_blank">
  #            Global Health Research</a>"),
  
  id="nav",
  #theme="http://bootswatch.com/spacelab/bootstrap.css",
  #inverse=TRUE,
  windowTitle="Shiny GHR",
  collapsible=TRUE,
  
  tabPanel(
    title="Confusion Matrix",
    dashboardPage(
      #header=dashboardHeader(title=tags$a(href='http://www.designsandmethods.com/',
      #tags$img(src='logo.png'))),
      header=dashboardHeader(disable=TRUE),
      sidebar=dashboardSidebar(disable = TRUE),
      body=dashboardBody(
  
         fluidPage( 
           
           # control the border, text size and alignment of each cell
           tags$head(
             tags$style(HTML("
                             table, th, td {
                             #border: 1px solid black;
                             padding: 15px;
                             text-align: center;
                             font-size: 12px;
                             }

                              .vertical_Text {
                              -webkit-transform: rotate(-90deg);
                              }
      
                              .special {
                                border: 1px solid black
                              }
                             "))),
           
           # center align the input boxes
           tags$style(type='text/css', '#a {text-align: center; height: 40px}'),
           tags$style(type='text/css', '#d {text-align: center; height: 40px}'),
               
           
           fluidRow(column(12, align="left",
                           
                           h4("This Shiny app displays a confusion matrix.
                              Change the True Positives and True Negatives to 
                              see how the accuracy of a judgement can affect all calculations.")
                           )),
           
           fluidRow(
             
             tags$div(
               HTML(
                 "<table>

                <tr>
                <td></td>
                <td></td>
                <th colspan=2>GOLD STANDARD: Clinician Rating</th>
                <td></td>
                <td></td>
                <td></td>
                </tr>
                 
                 <tr>
                 <th></th>
                 <th></th>
                 <th class=special>Depression Dx</th> 
                 <th class=special>No Depression Dx</th>
                 <th class=special>Total</th>
                 </tr>
                 
                 <tr>
                 <th rowspan=2 class=vertical_Text>TEST: BDI-II Score</br>(cutoff > 15)</th>
                 <td class=special><span style=font-weight:bold>Pos</span></td>
                 
                 <td bgcolor=#209AC9 class=special><font color=white><span style=font-weight:bold>a</br>true positive</span>
                 <div class=form-group shiny-input-container>
                 <input id=a type=number class=form-control value=79 min=0 max=182/></div>
                 </td>
                 
                 <td class=special bgcolor=#EF9906><font color=white><span style=font-weight:bold>b</br>false positive</span>
                 <pre id=b class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special></br></br>a + b</br>
                 <pre id=ab class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special><span style=font-weight:bold>Positive Predictive Value</br>(PPV)</span></br>a/(a+b)
                 <pre id=PPV class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special><span style=font-weight:bold>False Discovery Rate</br>(FDR)</span></br>1-PPV
                 <pre id=FDR class=shiny-text-output></pre>
                 </td>
                 </tr>
                 
                 <tr>
                 <td class=special><span style=font-weight:bold>Neg</span></td>
                 
                 <td class=special bgcolor=#EF9906><font color=white><span style=font-weight:bold>c</br>false negative</span>
                 <pre id=c class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special bgcolor=#209AC9><font color=white><span style=font-weight:bold>d</br>true negative</span>
                 <div class=form-group shiny-input-container>
                 <input id=d type=number class=form-control value=353 min=0 max=380/>
                 </div></td>
                 
                 <td class=special></br></br>c + d</br>
                 <pre id=cd class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special><span style=font-weight:bold>Negative Predictive Value</br>(NPV)</span></br>d/(c+d)
                 <pre id=NPV class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special><span style=font-weight:bold>False Omission Rate</br>(FOR)</span></br>1-NPV
                 <pre id=FOR class=shiny-text-output></pre>
                 </td>
                 </tr>
                 
                 <tr>
                 <td></td>
                 <td class=special><span style=font-weight:bold>Total</span></td>
                 
                 <td class=special>a + c
                 <pre id=ac class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special>b + d
                 <pre id=bd class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special>a+b+c+d
                 <pre id=abcd class=shiny-text-output></pre>
                 </td>
                 
                 <td></td>
                 <td></td>
                 </tr>
                 
                 <tr>
                 <td></td>
                 <td></td>
                 <td class=special><span style=font-weight:bold>Sensitivity</br>True Positive Rate</br>(TPR)</span></br>a/(a+c)
                 <pre id=TPR class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special><span style=font-weight:bold>Specificity</br>True Negative Rate</br>(TNR)</span></br>d/(b+d)
                 <pre id=TNR class=shiny-text-output></pre>
                 </td>
                 
                 <td></td>
                 
                 <td><span style=font-weight:bold></br></br>Prevalence</span></br>(a+c)/(a+b+c+d)
                 <pre id=prevalence class=shiny-text-output></pre>
                 </td>
                 
                 <td><span style=font-weight:bold></br>Pos Likelihood Ratio</br>(LR+)</span></br>TPR/FPR
                 <pre id=PLR class=shiny-text-output></pre>
                 </td>
                 </tr>
                 
                 <tr>
                 <td></td>
                 <td></td>

                 <td class=special><span style=font-weight:bold>False Negative Rate</br>(FNR)</span></br>1-sensitivity
                 <pre id=FNR class=shiny-text-output></pre>
                 </td>
                 
                 <td class=special><span style=font-weight:bold>False Positive Rate</br>(FPR)</span></br>1-specificity
                 <pre id=FPR class=shiny-text-output></pre>
                 </td>
                 
                 <td></td>
                 
                 <td><span style=font-weight:bold></br>Accuracy</span></br>(a+d)/(a+b+c+d)
                 <pre id=accuracy class=shiny-text-output></pre>
                 </td>
                 
                 <td><span style=font-weight:bold>Neg Likelihood Ratio</br>(LR-)</span></br>FNR/TNR
                 <pre id=NLR class=shiny-text-output></pre>
                 </td>
                 
                 </tr>
                 
                 
                 </table>"))
             
               )
    

                
              
      )))),
  
  tabPanel(
    title="About",
    dashboardPage(
      header=dashboardHeader(disable=TRUE),
      sidebar=dashboardSidebar(disable = TRUE),
      body=dashboardBody(
        fluidPage(
          
          # about text
          fluidRow(column(12, align="left",
                          
                          # credits
                          img(src='logo.png', align = "left"),
                          
                          withTags({
                            
                            div(class="header",
                                
                                p("This app was created by ",
                                  
                                  a("Amy Finnegan",
                                    href="https://sites.google.com/site/amyfinnegan/home", target="_blank"),
                                  
                                  "and Eric Green for the online textbook" ,
                                  
                                  a("Global Health Research: Designs and Methods.",
                                    href="http://www.designsandmethods.com/book/", target="_blank"),
                                  
                                  "It is based on the following article:"),
                                
                                
                                
                                p("Kim, et al. (",
                                  
                                  a("2014",
                                    href="http://jiasociety.org/index.php/jias/article/view/18965/3868",
                                    target="_blank"),
                                  
                                  "). Prevalence of Depression and Validation of the Beck Depression 
                                  Inventory-Ii and the Children’s Depression Inventory-Short Amongst 
                                  Hiv-Positive Adolescents in Malawi.” Journal of the International AIDS Society 17 (1).")
                                
                                
                                )
                          })
                          
          ))))))
  )

    

  
  
  server <- function(input, output) {
    
    
    c <- reactive({
      
      x <- 380-input$d
      
      return(x)
      
    })
    
    b <- reactive({
      
      x <- 182-input$a
      
      return(x)
      
    })

    # column 1
    output$c <- renderText({ c() })
    output$ac <- renderText({ input$a + c() })
    output$TPR <- renderText({ round(input$a/(input$a+c()), 2) })
    output$FNR <- renderText({ round(1-(input$a/(input$a+c())), 2) })
    
    # column 2
    output$b <- renderText({ b() })
    output$bd <- renderText({ b() + input$d })
    output$TNR <- renderText({ round(input$d/(b()+input$d), 2) })
    output$FPR <- renderText({ round(1-(input$d/(b()+input$d)), 2) })
    
    # column 3
    output$ab <- renderText({ input$a + b() })
    output$cd <- renderText({ c() + input$d })
    output$abcd <- renderText({ input$a + b() + c() + input$d })
    
    # # column 4
    output$PPV <- renderText({ round(input$a/(input$a+b()), 2)  })
    output$NPV <- renderText({  round(input$d/(c()+input$d), 2) })
     
    output$prevalence <- renderText({ round((input$a+c())/(input$a+b()+c()+input$d), 2)  })
    output$accuracy <- renderText({ round((input$a+input$d)/(input$a+b()+c()+input$d), 2)  })
     
    # column 5
    output$FDR <- renderText({ 1-round(input$a/(input$a+b()), 2) })
    output$FOR <- renderText({ 1-round(input$d/(c()+input$d), 2) })
     
    output$PLR <- renderText({  round((input$a/(input$a+c()))/(1-(input$d/(b()+input$d))), 2) })
    output$NLR <- renderText({  round(round(1-(input$a/(input$a+c())), 2)/round(input$d/(b()+input$d), 2), 2) })
    
    
  }
  
  shinyApp(ui, server)



