library(scales)
library(ggplot2)
library(dplyr)

compare_data <- function(current, past, cols_compare, level = 1, region = NA) {
  comparison_results <- list()
  plots_diff <- list()
  plots_comp <- list()
  
  # Filter data based on level and region
  if (level == 1) {
    # National level
    current <- current %>% filter(administrative_area_level == 1)
    past <- past %>% filter(administrative_area_level == 1)
  } else if (level == 2) {
    # Regional level
    current <- current %>% filter(administrative_area_level == 2)
    past <- past %>% filter(administrative_area_level == 2)
    
    if (!is.na(region)) {
      current <- current %>% filter(administrative_area_level_2 == region)
      past <- past %>% filter(administrative_area_level_2 == region)
    }
  } else if (level == 3) {
    # Provincial level
    current <- current %>% filter(administrative_area_level == 3)
    past <- past %>% filter(administrative_area_level == 3)
    
    if (!is.na(region)) {
      current <- current %>% filter(administrative_area_level_3 == region)
      past <- past %>% filter(administrative_area_level_3 == region)
    }
  }
  
  for (col in cols_compare) {
    merged <- merge(current[, c("id", "date", col)], 
                    past[, c("id", "date", col)], 
                    by = c("id", "date"), 
                    all = TRUE, 
                    suffixes = c("_current", "_past"))
    
    # Calculate the difference
    merged$difference <- merged[[paste0(col, "_current")]] - merged[[paste0(col, "_past")]]
    
    comparison_results[[col]] <- merged
    
    # Plot the comparison
    plot_comp <- ggplot(merged, aes(x = date)) +
      geom_point(aes(y = .data[[paste0(col, "_current")]], color = "Current"), size = 2, na.rm = TRUE) +
      geom_point(aes(y = .data[[paste0(col, "_past")]], color = "Past"), size = 2, na.rm = TRUE) +
      geom_line(aes(y = .data[[paste0(col, "_current")]], color = "Current"), size = 1, na.rm = TRUE) + 
      geom_line(aes(y = .data[[paste0(col, "_past")]], color = "Past"), size = 1, alpha = 0.3, na.rm = TRUE) +
      scale_y_continuous(labels = comma) +
      labs(title = paste("Comparison of", col, "for level", level, 
                         if (!is.na(region)) paste("region:", region) else ""), 
           x = "Date",
           y = col,
           color = "Dataset") +
      theme_minimal() +
      theme(panel.background = element_rect(fill = "white", color = NA),
            plot.background = element_rect(fill = "white", color = NA), 
            legend.position = "bottom")
    
    plots_comp[[col]] <- plot_comp
    
    # Plot the differences over time
    plot_diff <- ggplot(merged, aes(x = date)) +
      geom_line(aes(y = c(NA, diff(.data[[paste0(col, "_current")]])), color = "Current"), size = 2, na.rm = TRUE) +
      geom_line(aes(y = c(NA, diff(.data[[paste0(col, "_past")]])), color = "Past"), size = 1, na.rm = TRUE) +
      scale_y_continuous(labels = comma) +
      labs(
        title = paste("Daily differences for", col, "in level", level, 
                      if (!is.na(region)) paste("region:", region) else ""),
        x = "Date",
        y = paste("Difference in", col),
        color = "Dataset"
      ) +
      theme_minimal() +
      theme(panel.background = element_rect(fill = "white", color = NA),
            plot.background = element_rect(fill = "white", color = NA), 
            legend.position = "bottom")
    
    plots_diff[[col]] <- plot_diff
  }
  return(list(
    comparison_results = comparison_results,
    difference_plots = plots_diff,
    comparison_plots = plots_comp
  ))
}


columns <- c("confirmed", "deaths", "recovered", "tests", "vaccines",
  "people_vaccinated", "people_fully_vaccinated", "hosp", "icu")

# past_data <- read.csv("https://storage.covid19datahub.io/country/CHE.csv")
# current <- covid19("CHE", 2)
# result <- compare_data(current, past_data, columns, 2, "Basel-Stadt")

# SAVE
folder <- "...."

if (!dir.exists(folder)) {
  dir.create(folder)
}

for (col in names(result[["difference_plots"]])) {
  ggsave(
    filename = paste0(folder, "/difference_plot_", col, ".png"),
    plot = result[["difference_plots"]][[col]],
    width = 8, height = 6, dpi = 300
  )
}

# Save all comparison plots
for (col in names(result[["comparison_plots"]])) {
  ggsave(
    filename = paste0(folder, "/comparison_plot_", col, ".png"),
    plot = result[["comparison_plots"]][[col]],
    width = 8, height = 6, dpi = 300
  )
}