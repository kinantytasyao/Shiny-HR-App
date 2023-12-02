function(input, output) {
  output$quantity <- renderValueBox({
    
    valueBox(value = data_attrition %>% 
               filter(attrition == "Yes", department == input$department) %>% 
               nrow(), 
             subtitle = "Who left the company", 
             color = "purple",
             icon = icon("user-minus"))
    
  })
  
  
  
  
  output$rate <- renderValueBox({
    
    temp <- data_attrition %>% 
      filter(department == input$department) %>% 
      count(attrition) %>% 
      mutate(percent = n/sum(n)) %>% 
      filter(attrition == "Yes") %>% 
      pull(percent) %>% 
      scales::percent()
    
    valueBox(
      value = temp,
      subtitle = "Turnover Rate",
      color = "purple",
      icon = icon("percentage"))
    
  })
  
  output$tenure <- renderValueBox({
    
    temp <- data_attrition %>% 
      filter(attrition == "Yes", department == input$department) %>% 
      pull(years_at_company) %>% 
      mean() %>% 
      round(2)
    
    
    valueBox(
      value = temp,
      subtitle = "Average Years Tenure",
      color = "purple",
      icon = icon("clock"))
    
  })
  
  output$jobsat <- renderValueBox({
    
    value_job_satisfaction <- data_attrition %>% 
      filter(attrition == "Yes", department == input$department) %>% 
      pull(job_satisfaction) %>% 
      mean() %>% 
      round(2)
    
    valueBox(
      value = value_job_satisfaction, 
      subtitle = "Avg Job Satisfaction",
      icon = icon("smile"),
      color = "green", width = 3
    )
    
  })
  
  output$envsat <- renderValueBox({
    
    
    value_env_satisfaction <- data_attrition %>% 
      filter(attrition == "Yes", department == input$department) %>% 
      pull(environment_satisfaction) %>% 
      mean() %>% 
      round(2)
    
    valueBox(
      value = value_env_satisfaction, 
      subtitle = "Avg Environment Satisfaction",
      icon = icon("user-friends"),
      color = "green", width = 3
    )
    
  })
  
  output$income <- renderValueBox({
    
    
    
    avg_income <- data_attrition %>% 
      filter(attrition == "Yes", department == input$department) %>% 
      pull(monthly_income) %>% 
      mean() %>% 
      round(2) %>% 
      dollar()
    
    valueBox(
      value = avg_income, 
      subtitle = "Avg monthly income",
      icon = icon("comment-dollar"),
      color = "green", width = 3
    )
    
  })
  
  datcat <- reactive({
    
    temp <- input$perscat %>% str_replace_all(" ", replacement = "_") %>% str_to_lower()
    
    filter_column <- sym(temp)
    
    data_attrition %>% 
      filter(attrition == "Yes") %>% 
      count(!! filter_column) %>% 
      mutate(
        prop = n/sum(n),
        label = paste("Proportion: ", percent(prop))
      ) %>% 
      ungroup() %>% 
      
      mutate_if(is.character, ~str_replace_all(string = ., pattern = "_", replacement = " ") %>% str_to_title())
    
    
    
  })
  
  output$personalNum <- renderPlotly({
    
    # create visualization
    
    temp <- input$persnum %>% str_replace_all(" ", replacement = "_") %>% str_to_lower()
    
    title_num <- temp %>%
      str_replace_all(pattern = "_", replacement = " ") %>%
      str_to_title()
    
    p <- ggplot(data_attrition, aes_string(temp)) +
      geom_density(aes(fill = attrition), alpha = 0.6, col = "white") +
      scale_fill_manual(values = c("purple", "springgreen4")) +
      labs(
        title = title_num,
        y = 'Percentage',
        x = NULL,
        fill = "Attrition"
      ) +
      theme_bw() +
      theme(legend.position = "none")
    
    ggplotly(p) %>% 
      config(displayModeBar = FALSE)
    
  })
  
  
  output$personalCat <- renderPlotly({
    
    temp <- input$perscat %>% str_replace_all(" ", replacement = "_") %>% str_to_lower()
    
    filter_column <- sym(temp)
    
    
    
    p <- ggplot(datcat(), aes(x = reorder(!! filter_column, -prop), y = prop, text = label)) +
      geom_col(aes(fill = prop), show.legend = FALSE, alpha = 0.7) +
      scale_fill_gradient(low = "gray", high = "springgreen4") +
      labs(
        title = input$perscat,
        x = NULL,
        y = 'Percentage',
        fill = "Attrition"
      ) +
      theme_bw() +
      theme(legend.position = "none")
    
    
    ggplotly(p, tooltip = "text") %>% 
      config(displayModeBar = FALSE)
    
  })
  
  output$corbased <- renderPlotly({
    
    
    # aggregation
    data_agg <- data_attrition %>% 
      filter(job_role == input$jobrole) %>% 
      group_by(job_involvement, environment_satisfaction) %>% 
      summarise(n = n()) %>% 
      ungroup() %>% 
      complete(job_involvement, environment_satisfaction) %>% 
      mutate(n = replace_na(n, 0)) %>% 
      mutate(label = glue("Total Employees: {n}
                                    Job Involvement Level: {job_involvement}
                                    Environment Satisfaction: {environment_satisfaction}"))
    
    ggplotly(
      ggplot(data_agg, aes(x = job_involvement, y = environment_satisfaction, text = label)) +
        geom_tile(aes(fill = n), alpha = 0.6, col = "white") +
        scale_y_continuous(expand = expand_scale(mult = c(0, 0))) +
        scale_x_continuous(expand = expand_scale(mult = c(0, 0))) +
        labs(
          title = "Number of employee by job involvement and satisfaction levels",
          subtitle = "from laboratory technician samples",
          caption = "Source: IBM Watson",
          x = "Job Involvement",
          y = "Environment Satisfaction",
          fill = NULL
        ) +
        theme_bw() +
        scale_fill_gradient(low = "white", high = "springgreen4") +
        theme(legend.position = "none")
      , tooltip = "text") %>% 
      config(displayModeBar = FALSE)
    
  })
  
  output$relation <- renderPlotly({
    
    
    # aggregation
    data_agg <- data_attrition %>% 
      filter(job_role == input$jobrole) %>% 
      group_by(years_at_company, attrition) %>% 
      summarise(
        stock_option_level = median(stock_option_level),
        monthly_income = median(monthly_income)
      ) %>% 
      ungroup()
    
    # prepare visualization data
    data_viz <- data_agg %>% 
      mutate(attrition = attrition %>%
               str_to_title() %>% 
               factor(levels = c("Yes", "No"))
      ) %>% 
      rename(Attrition = attrition) %>% 
      mutate(label = glue("{years_at_company} Years at Company 
                                    Monthly Income: {dollar(monthly_income)}
                                    Stock Option Level: {stock_option_level}"))
    
    
    # visualize
    plot <- ggplot(data_viz, aes(x = years_at_company, y = monthly_income, text = label)) +
      geom_point(aes(size = stock_option_level), alpha = 0.85, colour = "springgreen4") +
      geom_smooth(method = "loess", se = FALSE, colour = "purple") +
      facet_wrap(facets = vars(Attrition), labeller = "label_both") +
      scale_y_continuous(labels = dollar_format(scale = 1e-3, suffix = "K")) +
      labs(
        title = "The relation of years at the company and monthly income",
        subtitle = "using median value from laboratory technician samples",
        x = NULL,
        y = NULL,
        size = "Stock Option Level"
      ) +
      theme_minimal() +
      theme(legend.position = "top")
    
    ggplotly(plot, tooltip = "text") %>% 
      config(displayModeBar = FALSE) 
    
  })

  name <- eventReactive(input$action, input$NAME)
  
  test_data <- eventReactive(input$action,{
    
    data_input <- data.frame(AGE = input$AGE,
                             DAILY_RATE = input$DAILY_RATE,
                             DISTANCE_FROM_HOME = input$DISTANCE_FROM_HOME,
                             EDUCATION = input$EDUCATION,
                             ENVIRONMENT_SATISFACTION = input$ENVIRONMENT_SATISFACTION,
                             GENDER = input$GENDER,
                             HOURLY_RATE = input$HOURLY_RATE,
                             JOB_INVOLVEMENT = input$JOB_INVOLVEMENT,
                             JOB_LEVEL = input$JOB_LEVEL,
                             JOB_SATISFACTION = input$JOB_SATISFACTION,
                             MARITAL_STATUS = input$MARITAL_STATUS,
                             MONTHLY_INCOME = input$MONTHLY_INCOME,
                             MONTHLY_RATE = input$MONTHLY_RATE,
                             NUM_COMPANIES_WORKED = input$NUM_COMPANIES_WORKED,
                             PERCENT_SALARY_HIKE = input$PERCENT_SALARY_HIKE,
                             PERFORMANCE_RATING = input$PERFORMANCE_RATING,
                             RELATIONSHIP_SATISFACTION = input$RELATIONSHIP_SATISFACTION,
                             STANDARD_HOURS = input$STANDARD_HOURS,
                             STOCK_OPTION_LEVEL = input$STOCK_OPTION_LEVEL,
                             TOTAL_WORKING_YEARS = input$TOTAL_WORKING_YEARS,
                             TRAINING_TIMES_LAST_YEAR = input$TRAINING_TIMES_LAST_YEAR,
                             WORK_LIFE_BALANCE = input$WORK_LIFE_BALANCE,
                             YEARS_AT_COMPANY = input$YEARS_AT_COMPANY,
                             YEARS_IN_CURRENT_ROLE = input$YEARS_IN_CURRENT_ROLE,
                             YEARS_SINCE_LAST_PROMOTION = input$YEARS_SINCE_LAST_PROMOTION,
                             YEARS_WITH_CURR_MANAGER = input$YEARS_WITH_CURR_MANAGER)
    
    data_predict <- data_input %>% mutate_at(colnames(data_input), as.numeric)
    
    
  })
    
   
  prediction <- eventReactive(input$action,{
    
    rf_model <- readRDS("data_input/randomforest.RDS")
    
    pred <- predict(rf_model, test_data(), type = "prob")
    
    pred[,2]
    
  })
  
  output$text_result <- renderText({
    prediksi <- as.numeric(prediction() > 0.5) %>% as.factor()
    
    decode <- function(x){
      case_when(x == "1" ~ paste0("likely to leave the company with probability of ", round(prediction()*100,1),"%."),
                x == "0" ~ "likely to stay in the company."
      )}
    
    
    paste0(name(), " is ", decode(prediksi))
  })
  
  output$gauge <- renderPlotly({
    fig <- plot_ly(
      domain = list(x = c(0, 1), y = c(0, 1)),
      value = prediction()*100,
      number = list(suffix = "%"),
      type = "indicator",
      mode = "gauge+number",
      gauge = list(
        axis = list(range = list(NULL, 100),
                    tickwidth = 1,
                    tickcolor = "black"),
        bar = list(color = "#582f0e"),
        bgcolor = "white",
        borderwidth = 2,
        bordercolor = "gray",
        steps = list(
          list(range = c(0, 50), color = "#dbfeb8"),
          list(range = c(50, 100), color = "#fbc3bc")),
      threshold = list(
        line = list(color = "gray", width = 4),
        thickness = 0.75,
        value = 50)))
    
    fig <- fig %>%
      layout(
        margin = list(l=15,r=25),
        paper_bgcolor = "#fefae0",
        font = list(color = "#582f0e", family = "Arial"),
        title= list(text = "Employee turnover probability:", x = 0.49, y = 0.4, size = 15))
    
    fig
  })
  
  
}