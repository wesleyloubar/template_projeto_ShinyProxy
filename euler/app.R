################################# APP Modelo ################################## 
# source('ui/loginpage.R')

ui <- shinydashboard::dashboardPage(
  skin = 'black',
                                     # Dashboard header
                                     shinydashboard::dashboardHeader(title = "PSI5120"),
                                     shinydashboard::dashboardSidebar(
                                       br(),
                                       shiny::fluidPage(
                                         htmlOutput('boasvindas_output')
                                         
                                         ,br(),
                                         uiOutput('loginSM', align = 'center'),
                                         br(),
                                         # h3("Operador", align = 'center'),
                                         htmlOutput('operador_display'),
                                         br(), hr()),br(),
                                         uiOutput("sidebarpanel")
                                       
                                       # source('ui/sidebar_menu.R')
                                     ),


                                     ####    BODY    ####
                                     shinydashboard::dashboardBody(
                                      
                                       uiOutput("body")
                                       # ,shinydashboard::box(
                                       #   width = 11,
                                         ,shiny::fluidRow(
                                        
                                             
                                             uiOutput('logo_SM'),
                                             uiOutput('logo_laraia'),
                                             uiOutput('logos_rodape')
                                             #align = 'center'
                                           # )
                                         # ),
                                         ,shiny::h4(
                                           shiny::HTML('&copy'),
                                           htmlOutput('rodape_equipe'), align = 'center')
                                         )
                                      
                                       ))




###### SERVER #####
# Define server logic required to draw a histogram
server <- function(input, output, session){ 
  library(shinyalert)
  library(shinydashboard)
  library(shinyjs)
  library(shiny)
  library(plotly)
  library(bslib)
  library(dplyr)
  library(ggplot2)
  library(ggExtra)
  # library(reshape2) # to load tips data
  # library(tidyverse)
  # library(tidymodels) # for the fit() function
  
  

  # df <- readRDS('df.rds')
  df = read.csv('https://raw.githubusercontent.com/jcheng5/simplepenguins.R/main/penguins.csv')
  df <- df[complete.cases(df),]
  df_num <- df %>% select(where(is.numeric), -Year)
  
  subsetted <- reactive({
    req(input$species)
    df %>% filter(Species %in% input$species)
  })
  
  output$scatter <- renderPlot({
    p <- ggplot(subsetted(), aes(!!input$xvar, !!input$yvar)) + list(
      theme(legend.position = "bottom"),
      if (input$by_species) aes(color = Species),
      geom_point(),
      if (input$smooth) geom_smooth()
    )
    
    if (input$show_margins) {
      margin_type <- if (input$by_species) "density" else "histogram"
      p <- ggExtra::ggMarginal(p, type = margin_type, margins = "both",
                               size = 8, groupColour = input$by_species, groupFill = input$by_species)
    }
    
    p
  }, res = 100)

  # operador_id <<- '419BMlwDrTdlAZHySU2f'
  # source('data/funcoes_estudos.R')
  # source('data/funcoes_estudos.R', local = T, encoding = 'UTF8')[1]
  # source('ui/uidashboardPage.R', local = T, encoding = 'UTF8')[1]
  # source('data/funcoes_wesley.R', local = T, encoding = 'UTF8')[1]
  # source('functions/funcoes_usuarios.R', local = T, encoding = 'UTF8')[[1]]
  
  # Main login screen ####
  loginpage <-
    div(
      id = "loginpage",
      style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;
                 background-image: linear-gradient(to bottom, #003b52, #016473, #017687, #00879c, #02aac4,
                              #00879c, #017687, #016473, #003b52);",
      wellPanel(
        tags$h2("LOG IN", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
        textInput(
          "userName",
          placeholder = "email",
          label = tagList(icon("user"), "Email")
        ),
        passwordInput(
          "passwd",
          placeholder = "senha",
          label = tagList(icon("unlock-alt"), "Senha")
        ),
        br(),
        div(
          style = "text-align: center;",
          actionButton(
            "login",
            "Entrar",
            style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;")
          
          ,HTML('
               <h3 dir="auto" tabindex="-1">Logins</h3>
<h4 dir="auto" style="text-align: left;" tabindex="-1"><a id="user-content-emails-usuario1-usuario2-usuario3--usuario10-" class="anchor" href="https://github.com/wesleyloubar/TrabalhoFinalComputacaoEmNuvem/blob/main/template_projeto_ShinyProxy/README.md#emails-usuario1-usuario2-usuario3--usuario10-" aria-hidden="true"></a><strong>Emails</strong>: usuario1, usuario2, usuario3, ..., usuario10</h4>
<h4 dir="auto" style="text-align: left;" tabindex="-1"><a id="user-content-senha-123456" class="anchor" href="https://github.com/wesleyloubar/TrabalhoFinalComputacaoEmNuvem/blob/main/template_projeto_ShinyProxy/README.md#senha-123456" aria-hidden="true"></a><strong>Senha</strong>: 123456</h4>
<p>&nbsp;</p>
                ')
          
          # ,shinyjs::hidden(div(
          #   id = "nomatch"
          #   ,tags$p(
          #     "Oops! Email e/ou senha incorretos!",
          #     style = "color: red; font-weight: 600;
          #                                   padding-top: 5px;font-size:16px;",
          #     class = "text-center")
          # )
          )
        )
      )
    
  
  
  body_ui <-  shiny::fluidRow(
   
    shinydashboard::box(width = 12, 
                        status = "success",
                        title = HTML('Gráfico Carros'),
                        sidebarPanel(
                          selectInput('xcol','X Variable', names(mtcars)),
                          selectInput('ycol','Y Variable', names(mtcars)),
                          selected = names(mtcars)[[2]]),
                        mainPanel(
                          plotlyOutput('plot')
                        ),
                        collapsible = TRUE,
                        solidHeader = TRUE,
                        br())
    ,shinydashboard::box(solidHeader = TRUE,
                        width = 12, 
                        status = "success",
                        title = HTML('Gráfico Espécies'),
          shiny::sidebarLayout(
          shiny::sidebarPanel(width = 3,
        varSelectInput("xvar", "X variable", df_num, selected = "Bill Length (mm)"),
        varSelectInput("yvar", "Y variable", df_num, selected = "Bill Depth (mm)"),
        checkboxGroupInput(
          "species", "Filter by species",
          choices = unique(df$Species), 
          selected = unique(df$Species)
        ),
        hr(), # Add a horizontal rule
        checkboxInput("by_species", "Show species", TRUE),
        checkboxInput("show_margins", "Show marginal plots", TRUE),
        checkboxInput("smooth", "Add smoother")
      ),
      mainPanel(plotOutput("scatter", height = 500))
    )
    )
  )
  
  # data(tips)
  atualizar_plot <- function(){
   
    mtcars = mtcars[complete.cases(mtcars),]
    x1 = mtcars[,input$xcol]
    y1 = mtcars[,input$ycol]
    z = mtcars[,input$xcol]
    w = predict(lm(mtcars[,input$ycol] ~ mtcars[,input$xcol]))
    
    df = data.frame(x_df = x1, y_df = y1, z = z, w = w)
    
    # saveRDS(df, 'deletar.rds')
    
    
    
    output$plot <- renderPlotly(
      plot_ly(df, x = ~x_df,  y = ~y_df,  type = 'scatter',  mode = 'markers', name = 'Dados') %>% 
        add_trace(x = ~x_df, y = ~w,
                  name = 'Linha de regressão', mode = 'lines', alpha = 1) %>%
        layout(title = paste0(input$xcol, ' x ', input$ycol), 
           xaxis = list(title = input$xcol), 
            yaxis = list(title = input$ycol))
      
    )
  }
  
  observeEvent(input$xcol, {
    # Sys.sleep(5)
    atualizar_plot()
  })
  
  observeEvent(input$ycol, {
    atualizar_plot()
  })
 
  
  
  
  login <- FALSE
  USER <- reactiveValues(login = login)
  output$body <- renderUI({
    if (USER$login == TRUE) { body_ui } else {  loginpage  }
  })
  


  observe({
    if (USER$login == TRUE) {
      # updateTabItems(session, inputId = 'menu', selected = 'inicio')
      # output$rodape_equipe <- renderText(paste0(year(Sys.Date()), ' By LaraiaTech Dev. Team'))
      output$boasvindas_output <- renderText((paste0('
                                                 <h3 style="text-align: center;">Bem vindo(a)!</h3>
<h3 style="text-align: center;">Usu&aacute;rio:</h3>
<h3 style="text-align: center;">',input$userName,'</h3>')))
      
    }else{
      if (!is.null(input$login)) {
        if (input$login > 0) {
          
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          
          email <- Username
          senha <- Password

            # df = validar_login(email, senha, session)
            
          usuarios <- data.frame(email = c('usuario1','usuario2','usuario3',
                                           'usuario4','usuario5','usuario6',
                                           'usuario7','usuario8','usuario9',
                                           'usuario10'                                           ),
                                 senha = c('123456','123456',"123456",
                                           '123456','123456',"123456",
                                           '123456','123456',"123456",
                                           '123456'))
          
          # email <- 'email1@gmail.com'
          # senha <- '123456'
            if(email %in% usuarios$email){
              
              df = usuarios[which(usuarios$email == email),]
              
              if(senha == df$senha[1]){
                USER$login = TRUE
              }else{
                shinyjs::delay(
                  3000,
                  shinyjs::toggle(
                    id = "nomatch",
                    anim = TRUE,
                    time = 1,
                    animType = "fade"
                  ))
                shinyalert("Oops!", "Senha incorreta!!!",
                           type = "error")
              }
              
            } else{
              shinyalert("Oops!", "Este usuário não está cadastrado na base de dados", 
                         type = "error")
            }
            # }else{
            #   shinyalert("Oops!", "Este usuário não está cadastrado na base de dados",
            #              type = "error")
            # }
          
        }}
    }
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
