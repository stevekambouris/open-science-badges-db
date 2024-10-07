# update_zotero_lib_2024-08-09.R -----------------------------------------------
#
# This script formats the OSB library export from 9th August 2024 and adds the
# new articles (correctly formatted) to the existing 2024-07-17 data set.

# Load required libraries.
library(tidyverse)
library(here)



# Import the formatted original library ----------------------------------------
osb_lib1_fmt <- read_csv(here("data",
                              "osb_lib_with_study_id_2024-07-17.csv"))



# Import the updated library from the exported Zotero CSV ----------------------
osb_lib2_raw <- read_csv(file = here("data",
                                     "Open_Science_Badges_2024-08-09.csv"))



# Check for new articles -------------------------------------------------------
new_articles <- osb_lib2_raw |> 
  anti_join(osb_lib1_fmt, by = "Key")

old_articles <- osb_lib2_raw |> 
  semi_join(osb_lib1_fmt, by = "Key")

missing_article <- osb_lib1_fmt |> 
  anti_join(osb_lib2_raw, by = "Key")

# Check the titles, years of publication of the new articles
check_years <- new_articles |> 
  group_by(`Publication Year`) |> 
  count()

check_titles <- new_articles |> 
  group_by(`Publication Title`) |> 
  count()

# Confirm all the new articles have new DOIs
check_new_dois <- new_articles |> 
  semi_join(osb_lib1_fmt, by = "DOI")

# Check the maximum number of tags (in case more than 10)
check_tagcount <- osb_lib2_raw |> 
  mutate(tag_count = str_count(`Manual Tags`, ";") + 1)
table(check_tagcount$tag_count, useNA = "always")

check_tagcount2 <- check_tagcount |> 
  filter(tag_count > 10)



# Format the new articles, add article ID --------------------------------------
#
# Split up the manual tags.
# Create a flag variable for articles with an Open Data badge.
# Create a flag variable for articles with an Open Materials badge.
# Create a flag variable for articles with a Pre-registered or
# Pre-registered+Analysis Plan badge.
# Create a flag variable for articles with an Erratum tag.
# Rename some journal titles for consistency and to prevent accidental
# "splitting" of articles by journal.
#
# Order the dataset by the value of the Key variable, then assign a study id
# based on the format "a000000", using the row number as the unique counter.
# The previous library ended with article 5233, so start numbering from 5234.


osb_new_fmt <- new_articles %>%
  separate(col = `Manual Tags`,
           into = c("manual_tags1", "manual_tags2",
                    "manual_tags3", "manual_tags4",
                    "manual_tags5", "manual_tags6",
                    "manual_tags7", "manual_tags8",
                    "manual_tags9", "manual_tags10")) %>% 
  mutate(OpenDataBadge = case_when(
    manual_tags1 == "OSBadgeOpenData" ~ TRUE,
    manual_tags2 == "OSBadgeOpenData" ~ TRUE,
    manual_tags3 == "OSBadgeOpenData" ~ TRUE,
    manual_tags4 == "OSBadgeOpenData" ~ TRUE,
    manual_tags5 == "OSBadgeOpenData" ~ TRUE,
    manual_tags6 == "OSBadgeOpenData" ~ TRUE,
    manual_tags7 == "OSBadgeOpenData" ~ TRUE,
    manual_tags8 == "OSBadgeOpenData" ~ TRUE,
    manual_tags9 == "OSBadgeOpenData" ~ TRUE,
    manual_tags10 == "OSBadgeOpenData" ~ TRUE,
    TRUE ~ FALSE
  )
  ) %>% 
  mutate(OpenMaterialsBadge = case_when(
    manual_tags1 == "OSBadgeOpenMaterials" ~ TRUE,
    manual_tags2 == "OSBadgeOpenMaterials" ~ TRUE,
    manual_tags3 == "OSBadgeOpenMaterials" ~ TRUE,
    manual_tags4 == "OSBadgeOpenMaterials" ~ TRUE,
    manual_tags5 == "OSBadgeOpenMaterials" ~ TRUE,
    manual_tags6 == "OSBadgeOpenMaterials" ~ TRUE,
    manual_tags7 == "OSBadgeOpenMaterials" ~ TRUE,
    manual_tags8 == "OSBadgeOpenMaterials" ~ TRUE,
    manual_tags9 == "OSBadgeOpenMaterials" ~ TRUE,
    manual_tags10 == "OSBadgeOpenMaterials" ~ TRUE,
    TRUE ~ FALSE
  )
  ) %>% 
  mutate(PreregisteredBadge = case_when(
    manual_tags1 == "OSBadgePreregistered" ~ TRUE,
    manual_tags2 == "OSBadgePreregistered" ~ TRUE,
    manual_tags3 == "OSBadgePreregistered" ~ TRUE,
    manual_tags4 == "OSBadgePreregistered" ~ TRUE,
    manual_tags5 == "OSBadgePreregistered" ~ TRUE,
    manual_tags6 == "OSBadgePreregistered" ~ TRUE,
    manual_tags7 == "OSBadgePreregistered" ~ TRUE,
    manual_tags8 == "OSBadgePreregistered" ~ TRUE,
    manual_tags9 == "OSBadgePreregistered" ~ TRUE,
    manual_tags10 == "OSBadgePreregistered" ~ TRUE,
    manual_tags1 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags2 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags3 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags4 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags5 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags6 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags7 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags8 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags9 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags10 == "OSBadgePreregisteredPlus" ~ TRUE,
    TRUE ~ FALSE
  )
  ) %>% 
  mutate(ErratumTag = case_when(
    manual_tags1 == "OSBadgeErratum" ~ TRUE,
    manual_tags2 == "OSBadgeErratum" ~ TRUE,
    manual_tags3 == "OSBadgeErratum" ~ TRUE,
    manual_tags4 == "OSBadgeErratum" ~ TRUE,
    manual_tags5 == "OSBadgeErratum" ~ TRUE,
    manual_tags6 == "OSBadgeErratum" ~ TRUE,
    manual_tags7 == "OSBadgeErratum" ~ TRUE,
    manual_tags8 == "OSBadgeErratum" ~ TRUE,
    manual_tags9 == "OSBadgeErratum" ~ TRUE,
    manual_tags10 == "OSBadgeErratum" ~ TRUE,
    TRUE ~ FALSE
  )
  ) %>% 
  mutate(`Publication Title` = recode(.x = `Publication Title`,
                                      `Canadian Journal of Experimental Psychology/Revue canadienne de psychologie expérimentale` = "Canadian Journal of Experimental Psychology",
                                      `Psychology of Popular Media Culture` = "Psychology of Popular Media"
  )
  ) %>% 
  mutate(effective_year = case_when(
    `Publication Year` < 2014 ~ 2014,
    TRUE ~ `Publication Year`
  )
  ) %>% 
  mutate(PROpenData = case_when(
    manual_tags1 == "OSBadgeOpenDataPR" ~ TRUE,
    manual_tags2 == "OSBadgeOpenDataPR" ~ TRUE,
    manual_tags3 == "OSBadgeOpenDataPR" ~ TRUE,
    manual_tags4 == "OSBadgeOpenDataPR" ~ TRUE,
    manual_tags5 == "OSBadgeOpenDataPR" ~ TRUE,
    manual_tags6 == "OSBadgeOpenDataPR" ~ TRUE,
    manual_tags7 == "OSBadgeOpenDataPR" ~ TRUE,
    manual_tags8 == "OSBadgeOpenDataPR" ~ TRUE,
    manual_tags9 == "OSBadgeOpenDataPR" ~ TRUE,
    manual_tags10 == "OSBadgeOpenDataPR" ~ TRUE,
    TRUE ~ FALSE
  )
  ) %>% 
  mutate(PRPreregistered = case_when(
    manual_tags1 == "OSBadgePreregisteredPR" ~ TRUE,
    manual_tags2 == "OSBadgePreregisteredPR" ~ TRUE,
    manual_tags3 == "OSBadgePreregisteredPR" ~ TRUE,
    manual_tags4 == "OSBadgePreregisteredPR" ~ TRUE,
    manual_tags5 == "OSBadgePreregisteredPR" ~ TRUE,
    manual_tags6 == "OSBadgePreregisteredPR" ~ TRUE,
    manual_tags7 == "OSBadgePreregisteredPR" ~ TRUE,
    manual_tags8 == "OSBadgePreregisteredPR" ~ TRUE,
    manual_tags9 == "OSBadgePreregisteredPR" ~ TRUE,
    manual_tags10 == "OSBadgePreregisteredPR" ~ TRUE,
    TRUE ~ FALSE
  )
  ) %>% 
  mutate(PROpenMaterials = case_when(
    manual_tags1 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    manual_tags2 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    manual_tags3 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    manual_tags4 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    manual_tags5 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    manual_tags6 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    manual_tags7 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    manual_tags8 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    manual_tags9 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    manual_tags10 == "OSBadgeOpenMaterialsPR" ~ TRUE,
    TRUE ~ FALSE
  )
  ) %>% 
  mutate(DEPreregistered = case_when(
    manual_tags1 == "OSBadgePreregisteredDE" ~ TRUE,
    manual_tags2 == "OSBadgePreregisteredDE" ~ TRUE,
    manual_tags3 == "OSBadgePreregisteredDE" ~ TRUE,
    manual_tags4 == "OSBadgePreregisteredDE" ~ TRUE,
    manual_tags5 == "OSBadgePreregisteredDE" ~ TRUE,
    manual_tags6 == "OSBadgePreregisteredDE" ~ TRUE,
    manual_tags7 == "OSBadgePreregisteredDE" ~ TRUE,
    manual_tags8 == "OSBadgePreregisteredDE" ~ TRUE,
    manual_tags9 == "OSBadgePreregisteredDE" ~ TRUE,
    manual_tags10 == "OSBadgePreregisteredDE" ~ TRUE,
    TRUE ~ FALSE
  )
  ) %>% 
  mutate(TCPreregistered = case_when(
    manual_tags1 == "OSBadgePreregisteredTC" ~ TRUE,
    manual_tags2 == "OSBadgePreregisteredTC" ~ TRUE,
    manual_tags3 == "OSBadgePreregisteredTC" ~ TRUE,
    manual_tags4 == "OSBadgePreregisteredTC" ~ TRUE,
    manual_tags5 == "OSBadgePreregisteredTC" ~ TRUE,
    manual_tags6 == "OSBadgePreregisteredTC" ~ TRUE,
    manual_tags7 == "OSBadgePreregisteredTC" ~ TRUE,
    manual_tags8 == "OSBadgePreregisteredTC" ~ TRUE,
    manual_tags9 == "OSBadgePreregisteredTC" ~ TRUE,
    manual_tags10 == "OSBadgePreregisteredTC" ~ TRUE,
    TRUE ~ FALSE
  )
  ) %>% 
  mutate(PreregisteredPlus = case_when(
    manual_tags1 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags2 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags3 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags4 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags5 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags6 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags7 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags8 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags9 == "OSBadgePreregisteredPlus" ~ TRUE,
    manual_tags10 == "OSBadgePreregisteredPlus" ~ TRUE,
    TRUE ~ FALSE
  )
  ) |> 
  arrange(Key) |> 
  tibble::rowid_to_column(var = "rowid") |> 
  mutate(rowid = rowid + 5233) |> 
  mutate(study_id = paste0("a", sprintf("%06d", rowid)))



# Append the new articles to the existing articles -----------------------------

all.equal(names(osb_new_fmt), names(osb_lib1_fmt))


# Remove article a002215 / Key "XXALX28J" / DOI 10.17705/1CAIS.04720, this
# should never have been added to the database
#
# Remove the following corrigenda/errata articles:
# a001652
# a001631
# a001335
# a001204
# a001120
# a000895
# a000890
# a000841
# a000623
# a000312
osb_lib_updated <- bind_rows(osb_lib1_fmt,
                             osb_new_fmt) |> 
  filter(! study_id %in% c("a002215",
                           "a001652",
                           "a001631",
                           "a001335",
                           "a001204",
                           "a001120",
                           "a000895",
                           "a000890",
                           "a000841",
                           "a000623",
                           "a000312",
                           "a000166")
  )

check_updated_dups_key <- osb_lib_updated |> 
  group_by(Key) |> 
  count() |> 
  filter(n > 1)

check_updated_dups_id <- osb_lib_updated |> 
  group_by(study_id) |> 
  count() |> 
  filter(n > 1)

check_updated_dups_doi <- osb_lib_updated |> 
  group_by(DOI) |> 
  count() |> 
  filter(n > 1)

check_updated_missing_doi <- osb_lib_updated |> 
  filter(is.na(DOI))

# Do additional checking
temp_check1 <- osb_lib_updated |> 
  filter(study_id == "a002215")





# Export the updated library ---------------------------------------------------

write_rds(osb_lib_updated,
          here("data", "osb_lib_with_study_id_2024-08-09.rds"))
write_excel_csv(osb_lib_updated,
                here("data", "osb_lib_with_study_id_2024-08-09.csv"),
                na = "",
                eol = "\r\n",
                quote = "all")
