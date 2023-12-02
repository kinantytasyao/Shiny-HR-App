edu_input <- c("Bellow College" = "1",
               "College" = "2",
               "Bachelor" = "3",
               "Master" = "4",
               "Doctor" = "5")

gender_input <- c("Female" = 1,
                  "Male" = 2)

marital_input <- c("Single" = 3,
                   "Married" = 2,
                   "Divorced" = 1)

header <- dashboardHeader(
  title = "People Analytics"
)


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      text = "Overview", 
      tabName = "page1",
      badgeLabel = "Descriptive", 
      badgeColor = "teal",
      icon = icon("dashboard")
    ),
    menuItem(
      text = "Prediction Tool", 
      tabName = "page2",
      badgeLabel = "Predictive", 
      badgeColor = "fuchsia",
      icon = icon("gears")
    )
  )
)

body <- dashboardBody(
  tags$style(HTML("
                  .box.box-primary {
                  border-top-color: #605ca8;
                  }

                    .box.box-solid.box-primary>.box-header {
                    color:#ffffff;
                    background:#605ca8
                    }

                    .box.box-solid.box-primary{
                    border-bottom-color:#ffffff;
                    border-left-color:#ffffff;
                    border-right-color:#ffffff;
                    border-top-color:#fefae0;
                    background:#fefae0
                    }
                  
                  .btn-primary {
                  background-color: #605ca8;
                  border-color: #2e6da4;
                  }
                  
                  .irs--shiny .irs-bar {
                  border-top: 1px solid #605ca8;
                  border-bottom: 1px solid #605ca8;
                  background: #605ca8;
                  }
                  
                  .irs--shiny .irs-single {
                  background-color: #605ca8;
                  }
                  
                  .box-header.with-border {
                  text-align: center;
                  background:#fefae0
                  }
                  
                  .form-control {
                  text-align: center;
                  }
                  
                  pre.shiny-text-output {
                  text-align: center;
                  }
                  
                  .box-body {
                  background:#fefae0;
                  }
                  
                  code, kbd, pre, samp {
                  font-family: arial;
                  font-size: 18px;
                  font-weight: bold;
                  font-style:italic
                  }
                  
                  pre {
                  background-color: #FFFFFF;
                  }
                  
                  .main-footer {
                  background: #ecf0f5;
                  border-top: 1px #ecf0f;
                  }

                    ")),
  tabItems(
    tabItem(
      tabName = "page1",
      
      fluidRow(
        box(
          title = "Employee Turnover Dashboard",
          closable = TRUE, 
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          collapsible = TRUE,
          width = 12,
          p("Employee turnover, is the measurement of the number of employees who leaves
                               an company during a scpecified time period. This dashboard illustrates a sample 
                               number of employees who left the organization during the previous  2 years. 
                               Dashboard also provide the simulation feature to predict the probability of employee will
                               to resign.")
        )
      ),
      
      fluidRow(
        box(
          title = "Explore", 
          closable = TRUE, 
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          collapsible = TRUE,
          width = 2,
          
          p("Please take a look a descriptive statistics the employee who left the company to get insight into which indicator
                              affect the most"),
          
          selectInput(
            inputId = "department",
            label = "Which Department?",
            choices = unique(data_attrition$department)
          )
        ),
        box(
          title = "Info Card", 
          closable = TRUE, 
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          collapsible = TRUE,
          width = 10,
          
          
          
          valueBoxOutput(
            outputId = "quantity", 
            width = 4
          ),
          
          valueBoxOutput(
            outputId = "rate",
            width = 4
          ),
          
          valueBoxOutput(
            outputId = "tenure",
            width = 4
          ),
          
          valueBoxOutput(
            outputId = "jobsat", 
            width = 4
          ),
          
          valueBoxOutput(
            outputId = "envsat",
            width = 4
          ),
          
          valueBoxOutput(
            outputId = "income",
            width = 4
          )
        )
      ),
      
      fluidRow(
        
        box(
          title = "Employee Demographics", 
          closable = TRUE, 
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          collapsible = TRUE,
          width = 6,
          height = "600px",
          
          selectInput(inputId = "perscat", 
                      label = "Which aspect have the highest turnover rate?", 
                      choices = cat_var,
                      selected = "Education Field"),
          plotlyOutput("personalCat"),
          
          hr(),
          
          selectInput(inputId = "persnum", 
                      label = "Which information you wanna look?", 
                      choices = num_var,
                      selected = "Total Working Years"),
          plotlyOutput("personalNum") 
          
          
        ),
        
        box(
          title = "Work & Billing Status", 
          closable = TRUE, 
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          collapsible = TRUE,
          width = 6,
          height = "600px",
          
          selectInput(
            inputId = 'jobrole',
            label = "Did any difference likelihood from job role?",
            choices = unique(data_attrition$job_role),
            selected = "Laboratory Technician"
          ),
          
          plotlyOutput(
            outputId = "corbased"
          ),
          hr(),
          p("Monthly income for each years at the company doesn’t always explain why an employee leave the company;
                              sometimes, other factor does really matter, like investment opportunity in our case."),
          plotlyOutput(
            outputId = "relation"
          )
        )
      )
    ),
    # Second tab content
    tabItem(tabName = "page2",
            fluidRow(
              box(
                title = strong("Employee Turnover Prediction"),
                enable_label = TRUE,
                label_status = "danger",
                status = "primary", 
                solidHeader = FALSE,
                width = 12,
                p("The Employee Turnover Prediction Tool helps companies figure out if employees might leave soon.
                      It looks at things like how happy employees are with their jobs and how long they've been working here.
                      This helps companies plan better and create a great and happy workplace for everyone.
                      To use this prediction tool, you need to complete the provided 4 sections, namely the identity, survey, compensation, and time section.
                      Afterward, you can view the results by clicking the 'Check the Result!' button.")
              )
            ),
            fluidRow(
              box(title = "Please enter the employe name!",
                  enable_label = TRUE,
                  label_status = "danger",
                  status = "primary", 
                  solidHeader = TRUE,
                  width = 12,
                  
                  textInput("NAME",
                            label = " ",
                            value = "...")
              )
            ),
            fluidRow(
              box(title = "Please provide the employee's identity!",
                  solidHeader = TRUE,
                  enable_label = TRUE,
                  label_status = "danger",
                  status = "primary",
                  collapsible = TRUE,
                  collapsed = TRUE,
                  width = 6,align = "center",
                  height = "300px",
                  
                  numericInput("AGE",
                               label = "Age",
                               value = 25,min = 15,max = 80,),
                  selectInput("EDUCATION",
                              label = "Education Level",
                              choices = edu_input,
                              selected = "2"),
                  selectInput("GENDER",
                              label = "Gender",
                              choices = gender_input,
                              selected = 1),
                  selectInput("MARITAL_STATUS",
                              label = "Marital Status",
                              choices = marital_input,
                              selected = 3),
                  numericInput("DISTANCE_FROM_HOME", label = "Distance from Work to Home (km)", value = 10, min = 0,step = 0.5),
                  numericInput("NUM_COMPANIES_WORKED",
                               label = "Number of Companies Worked Before",
                               value = 1,min = 0),
                  selectInput("STOCK_OPTION_LEVEL",
                              label = "Stock Option Level",
                              c(0,1,2,3),selected = 2),
                  selectInput("JOB_LEVEL",
                              label = "Job Level",
                              c(1,2,3,4,5),selected = 2)
                  
              ),
              box(
                title = "Please complete this survey based on employee answers!",
                solidHeader = TRUE,
                enable_label = TRUE,
                label_status = "danger",
                status = "primary", 
                collapsible = TRUE,
                collapsed = TRUE,
                width = 6,
                p("These questions provide insights into various aspects of the work environment using a simple 5-point scale."),
                
                sliderInput(
                  inputId = "ENVIRONMENT_SATISFACTION",
                  label = "1. How satisfied are you with your current work environment?",
                  min = 1, max = 5, value = 1),
                sliderInput(
                  inputId = "JOB_INVOLVEMENT",
                  label = "2. How involved do you feel in your current job?",
                  min = 1, max = 5, value = 1),
                sliderInput(
                  inputId = "JOB_SATISFACTION",
                  label = "3. How satisfied are you with your current job?",
                  min = 1, max = 5, value = 1),
                sliderInput(
                  inputId = "PERFORMANCE_RATING",
                  label = "4. How would you rate your overall performance in your role?",
                  min = 1, max = 5, value = 1),
                sliderInput(
                  inputId = "WORK_LIFE_BALANCE",
                  label = "5. How satisfied are you with your work-life balance?",
                  min = 1, max = 5, value = 1),
                sliderInput(
                  inputId = "RELATIONSHIP_SATISFACTION",
                  label = "6. How satisfied are you with your work relationship?",
                  min = 1, max = 5, value = 1)
              )
            ),
            fluidRow(
              box(
                title = "Please provide the employee's compensation!",
                solidHeader = TRUE,
                enable_label = TRUE,
                label_status = "danger",
                status = "primary", 
                collapsible = TRUE,
                collapsed = TRUE,
                align = "center",
                width = 6,
                
                numericInput("MONTHLY_INCOME",
                             label = "Monthly Income",
                             value = 4919,min = 0),
                numericInput("PERCENT_SALARY_HIKE",
                             label = "Percentage Increse in Salary (%)",
                             value = 14,min = 0),
                numericInput("HOURLY_RATE",
                             label = "Hourly Rate",
                             value = 66,min = 0),
                numericInput("DAILY_RATE",
                             label = "Daily Rate",
                             value = 802,min = 0),
                numericInput("MONTHLY_RATE",
                             label = "Monthly Rate",
                             value = 14236,min = 0),
                numericInput("TRAINING_TIMES_LAST_YEAR",
                             label = "Traning Times Last Year",
                             value = 3,min = 0)
                
                
              ),
              box(
                title = "Please complete the additional infomation!",
                solidHeader = TRUE,
                enable_label = TRUE,
                label_status = "danger",
                status = "primary", 
                collapsible = TRUE,
                collapsed = TRUE,
                align = "center",
                width = 6,
                
                numericInput("STANDARD_HOURS",
                             label = "Standard Work Hours",
                             value = 80,min = 0),
                numericInput("TOTAL_WORKING_YEARS",
                             label = "Total Working Years",
                             value = 2,min = 0),
                numericInput("YEARS_AT_COMPANY",
                             label = "Years at Company",
                             value = 1,min = 0),
                numericInput("YEARS_IN_CURRENT_ROLE",
                             label = "Years in Current Role",
                             value = 1,min = 0),
                numericInput("YEARS_SINCE_LAST_PROMOTION",
                             label = "Years since Last Promotion",
                             value = 1,min = 0),
                numericInput("YEARS_WITH_CURR_MANAGER",
                             label = "Years with Current Manager",
                             value = 1,min = 0)
                
                
              )
            ),
            
            fluidRow(
              box(title = actionButton(inputId = "action", label = "Check the Result!"),
                  enable_label = TRUE,
                  label_status = "info",
                  status = "primary",
                  width = 12,
                  verbatimTextOutput("text_result"),
                  plotlyOutput("gauge"))
            )
            
            
    )
  )
)

footer <-  dashboardFooter(
  left = "Overview by Dwi Gustin Nurdialit &
  Prediction Tool by Kinanty Tasya Octaviane",
  right = "Copyright © 2023 algorit.ma"
)


dashboardPage(
  title = "Human Resource Dashboard",
  skin = "purple",
  header = header,
  body = body,
  sidebar = sidebar,
  footer = footer
)
