library(scales)
library(ggplot2)
library(dplyr)
library(patchwork)
compare <- function(id, variables, data_updated, data_reference){
  #' @id id of the geographical unit
  #' @variables variables to compare
  #' @data_updated updated data
  #' @data_reference benchmark data
  #' 
  #' @return One plot and table for each variable
  #' 

  tables <- list()
  plots <- list()
  
  data_updated <- data_updated[which(data_updated$id == id),]
  data_reference <- data_reference[which(data_reference$id == id),]
  
  merged <- merge(
    data_updated[, c("id", "date", variables)], 
                  data_reference[, c("id", "date", variables)], 
                  by = c("id", "date"), 
                  all = TRUE, 
                  suffixes = c("_updated", "_reference")
                  )
    
  for (variable in variables) {
    variable_updated <- paste0(variable, "_updated")
    variable_reference <- paste0(variable, "_reference")
    table <- merged[, c("date", variable_updated, variable_reference)]
    table$difference <- table[[variable_updated]] - table[[variable_reference]]
    tables[[variable]] <- table
    
    melted <- table[,1:3]
    colnames(melted) <- c("DATE", "Updated", "Reference")
    melted <- pivot_longer(melted, cols = c("Updated", "Reference"), names_to = "NAME", values_to = "VALUE")
    
    fig1 <- ggplot(melted, aes(x = DATE, y = VALUE, color = NAME)) +
      geom_point(size = 0.25, na.rm = TRUE) +
      geom_line(linewidth = 0.25, na.rm = TRUE) +
      scale_y_continuous(labels = comma) +
      labs(title = variable, x = "Date", y = "Count", color = "Dataset") +
      theme_minimal() +
      theme(panel.background = element_rect(fill = "white", color = NA),
            plot.background = element_rect(fill = "white", color = NA), 
            legend.position = "bottom")
    
    natable <- table[,1:3]
    colnames(natable) <- c("DATE", "Updated", "Reference")
    natable$NADIFF <- is.na(natable[["Updated"]]) - is.na(natable[["Reference"]])
    fig2 <- ggplot(natable, aes(x = DATE, y = NADIFF)) +
      geom_point(size = 0.25, na.rm = TRUE) +
      labs(title = variable, x = "Date", y = "Count", color = "Dataset") +
      theme_minimal() +
      ylim(c(-1, 1)) +
      theme(panel.background = element_rect(fill = "white", color = NA),
            plot.background = element_rect(fill = "white", color = NA), 
            legend.position = "bottom")

    combined_plot <- fig1 / fig2 + plot_layout(ncol = 1, heights = c(2, 1))
    
    plots[[variable]] <- combined_plot
  }
  
  return(list(
    "tables" = tables, "plots" = plots
  ))
}

# Parameters
iso <- "CHE"
id <- "ef51ecaa"
root <- "test"
variables <- c(
  "confirmed", 
  "deaths", 
  "recovered", 
  "tests", 
  "vaccines",
  "people_vaccinated", 
  "people_fully_vaccinated", 
  "hosp", 
  "icu"
)

data_reference <- read.csv(sprintf("https://storage.covid19datahub.io/country/%s.csv",iso))
data_updated <- covid19(iso, 1)
result <- compare(id, variables, data_updated, data_reference)

# SAVE
folder <- paste0(root, '/fig/', id)

if (!dir.exists(folder)) {
  dir.create(folder)
}


# Save all comparison plots
for (variables in names(result[["plots"]])) {
  ggsave(
    filename = paste0(folder, "/comparison_plot_", col, ".png"),
    plot = result[["comparison_plots"]][[col]],
    width = 12, height = 6, dpi = 300
  )
}
