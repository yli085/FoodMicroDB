## shell code
# work directory
cd /Users/yahui/Documents/01work/09Liu_lab/02FoodMicroDB/0add_data/YLv4/newdata0717
# the archaea file names
less ../YLv4_amplicon/16S/local/Abundance/arc.project.txt

## R code
# Install and load necessary libraries
library(readxl)
library(data.table)
library(tidyverse)
library(writexl)

# Update project metadata -------------------------------------------------
# Read the Excel file
metadata <- read_excel("Project_metadata.xlsx")

# 将“Bacteria||Archaea” 转回“Bacteria” （手动也可）
# 首先把之前的"Bacteria||Archaea"转回“Bacteria”
# 注意R中“|”字符需要用\\
metadata <- metadata %>%
  mutate(Kingdom = str_replace(Kingdom, "Bacteria\\|\\|Archaea", "Bacteria"))

# Load the Project Accession IDs
accessions <- read.table("../YLv4_amplicon/16S/local/Abundance/arc.project.txt", header = FALSE)
setnames(accessions, "Project_Accession") 

# Filter and replace the Kingdom values based on Project_Accession matches
# two scenarios: Bacteria --> Bacteria||Archaea; Bacteria||Fungi--> Bacteria||Archaea||Fungi
metadata2 <- metadata %>%
  mutate(Kingdom = if_else(Project_Accession %in% accessions$Project_Accession & Kingdom == "Bacteria",
                           str_replace(Kingdom, "Bacteria", "Bacteria||Archaea"),
                           Kingdom)) %>% 
  mutate(Kingdom = if_else(Project_Accession %in% accessions$Project_Accession & Kingdom == "Bacteria||Fungi", str_replace(Kingdom, "Bacteria", "Bacteria||Archaea"),
                           Kingdom))
# check
xx <- metadata2["Kingdom"] 
xx2 <- xx[xx$Kingdom == "Bacteria||Archaea",] # 33
xx3 <- xx[xx$Kingdom == "Bacteria||Archaea||Fungi",] #3

# Save the modified metadata into a new Excel file
write_xlsx(metadata2, "Project_metadata2.xlsx")

# Update sample_metadata ---------------------------------------------------------

# same, except the project ID column name changes to "BioProject"
# Read the Excel file
metadata <- read_excel("Sample_metadata.xlsx")

# 首先把之前的"Bacteria||Archaea"转回“Bacteria”, 同时将Tomato里那个Archaea也改成Bacteria
# 注意R中“|”字符需要用\\
metadata <- metadata %>%
  mutate(Kingdom = str_replace(Kingdom, "Bacteria\\|\\|Archaea", "Bacteria")) %>% 
  mutate(Kingdom = str_replace(Kingdom, "Archaea", "Bacteria"))

# Load the Project Accession IDs
accessions <- read.table("../YLv4_amplicon/16S/local/Abundance/arc.project.txt", header = FALSE)
setnames(accessions, "Project_Accession") 

# Filter and replace the Kingdom values based on BioProject/Project_Accession matches
# only one scenario here: change Bacteria to Bacteria||Archaea.
metadata2 <- metadata %>%
  mutate(Kingdom = if_else(BioProject %in% accessions$Project_Accession & Kingdom == "Bacteria",
                           str_replace(Kingdom, "Bacteria", "Bacteria||Archaea"),
                           Kingdom))
# check
xx <- metadata2["Kingdom"] 
xx2 <- xx[xx$Kingdom == "Bacteria||Archaea",] 

# Save the modified metadata back to a new Excel file
write_xlsx(metadata2, "Sample_metadata2.xlsx")

