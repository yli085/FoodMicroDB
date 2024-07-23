getwd()
# "/Users/yahui/Documents/01work/09Liu_lab/02FoodMicroDB/0add_data/YLv4/newdata0717"
library(readxl)
library(tidyverse)
library(writexl)
library(dplyr)
library(RColorBrewer)

# fermented food or not ---------------------------------------
df <- read_excel('Food_info.xlsx')
sum(df[,6] == "Y") # 29
sum(df[,6] == "N") # 50
prop <- c(sum(df[,6] == "Y"), sum(df[,6] == "N"))
myPalette <- brewer.pal(2, "Set2")
pie(prop, labels = c("Fermented", "Non-fermented"), col=myPalette)

# Define the data
values <- c(sum(df[,6] == "Y"), sum(df[,6] == "N"))
labels <- c("Fermented \n 29", "Non-fermented \n 50")

# Create a function to position the labels inside the pie chart
label_pos <- function(values) {
  cumsum(values) - values / 2
}

# Calculate the positions for the labels
positions <- label_pos(values) / sum(values) * 360

# Create the pie chart
pie(values, labels = NA, main = "Fermented vs Non-fermented", col = c("tan2","dodgerblue"))

# Add labels inside the pie chart
text(x = 1.1 * cos(positions * pi / 180), 
     y = 1.1 * sin(positions * pi / 180), 
     labels = labels, 
     cex = 0.8, 
     col = "black")


# barplot by PTFI ---------------------------------------------------------
# first get stats and make a stat table
# order the L3 category by numbers, use excel to plot a draft
# then use R to plot nicely, use color to differentiate plant/animal/others

unique(df[[11]])
table(df[[11]])
table(df[[13]])
L3_tab <- as.data.frame(table(df[[13]]))
write_xlsx(L3_tab, "L3_stat.xlsx")

## start from the stat table
mycolors = brewer.pal(3, "Set2")

df <- read_excel('stat.xlsx', range = "A1:C14")
df$L3 <- ordered(df$L3, levels = unique(df$L3))
df$Category <- as_factor(c(rep("Plant food product", 7), rep("Animal food product", 5), "Others"))

ggplot(df, aes(x = L3, y = Number, fill = Category)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Number), vjust = -0.5) +
  scale_fill_manual(values = c("Plant food product" = mycolors[1], "Animal food product" = mycolors[2], "Others" = mycolors[3])) +
  labs(x = "Categories", y = "Number") +
  scale_y_continuous(limits=c(0,25))+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x=element_blank(),
        axis.text=element_text(color='black'),
        panel.grid.major.x=element_blank(),
        panel.grid.major.y=element_line())
# save in 7x5 inch.