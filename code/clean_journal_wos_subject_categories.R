# clean_journal_wos_subject_categories.R ---------------------------------------
#
# This script imports and cleans the manually-compiled Excel spreadsheet
# containing the Web of Science subject categories assigned to each journal
# title listed in the Open Science badges database.



# Load required libraries ------------------------------------------------------
library(tidyverse)
library(here)
library(readxl)


# Import the manually-compiled spreadsheet -------------------------------------
wos_cats_raw <- read_xlsx(path = here("data",
                                      "WoS_subject_categories_for_journals.xlsx"),
                          sheet = "WoS_Categories_raw")


# Clean the data ---------------------------------------------------------------
#
# - Remove the journals which never offered badges:
#   - Addiction
#   - Journal of Counseling Psychology
#   - Journal of Sleep Research
#   - Canadian Journal of Behavioural Science
wos_cats_clean <- wos_cats_raw |> 
  filter(! `Journal Name` %in% c("Addiction",
                                 "Journal of Counseling Psychology",
                                 "Journal of Sleep Research",
                                 "Canadian Journal of Behavioural Science")) |> 
  select(`Journal Name`:`WoS Core Collection Category`) |> 
  rename("journal_name" = "Journal Name",
         "journal_abbrev" = "Journal abbrev. (sheet name)",
         "publisher" = "Publisher",
         "note" = "Note",
         "issn" = "ISSN",
         "wos_subj_cat" = "WoS Core Collection Category") |> 
  separate_wider_delim(cols = wos_subj_cat,
                       delim = "|",
                       cols_remove = FALSE,
                       names_sep = "_",
                       too_few = "align_start") |> 
  rename("wos_subj_cat_all" = "wos_subj_cat_wos_subj_cat") |> 
  arrange(journal_name)



# Export the data --------------------------------------------------------------
write_rds(wos_cats_clean,
          here("data", "osb_lib_journals_wos_subj_cats.rds"))

write_excel_csv(wos_cats_clean,
                here("data", "osb_lib_journals_wos_subj_cats.csv"),
                na = "",
                quote = "all",
                eol = "\r\n")
