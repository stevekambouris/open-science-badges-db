# open-science-badges-db
_A snapshot of the Open Science Badges group library hosted on Zotero_

This repository contains time-stamped snapshots of the [Open Science Badges Zotero group library](https://www.zotero.org/groups/2146879/open_science_badges).

# Release 2024-08-09 (v1.0)

This release contains an export of the Open Science Badges Zotero library for 2024-08-09, along with a cleaned version of this dataset, and summary figures and a table. The contents of this repository are described below.

## Raw data

- `data\Open_Science_Badges_2020-02-21.csv`
- `data\Open_Science_Badges_2024-04-04.csv`
- `data\Open_Science_Badges_2024-07-17.csv`
- `data\Open_Science_Badges_2024-08-09.csv`

These four CSV files are direct exports of the Open Science Badges Zotero library from the Zotero desktop client for Windows. These files provide snapshots of the library contents on four dates: 2020-02-21, 2024-04-04, 2024-07-17, and 2024-08-09.

- `data\WoS_subject_categories_for_journals.xlsx`

This Excel spreadsheet contains the Web of Science Collection Subject Category for each journal title included in the dataset. This data was manually compiled from Web of Science [_Master Journal List_](https://mjl.clarivate.com/home) and entered onto the worksheet `WoS_Categories_raw`.

## Cleaned data

- `data\osb_lib_with_study_id_2020-02-21.csv`
- `data\osb_lib_with_study_id_2024-04-04.csv`
- `data\osb_lib_with_study_id_2024-07-17.csv`
- `data\osb_lib_with_study_id_2024-08-09.csv`

These CSV files are cleaned, formatted versions of the exported Zotero CSVs, with additional fields added. (The details of the data cleaning and formatting are provided in the code scripts summarised in the next section.)

- `data\osb_lib_journals_wos_subj_cats.csv`

This CSV file is a cleaned version of the Web of Science Subject Category data for each journal title in the dataset.

## Code

Note that all code files are written in [R](https://www.r-project.org/) (the [Quarto](https://quarto.org/) document provided contains R code chunks). These files were originally run with R 4.3.3, RStudio 2024.04.2+764, and Quarto 1.4.555 in a 64-bit Windows environment. The R packages required to run these scripts are noted in the `library()` statements at the top of each file.

- `code\update_zotero_lib_2024-04-04.R`
- `code\update_zotero_lib_2024-07-17.R`
- `code\update_zotero_lib_2024-08-09.R`

These R scripts import the Zotero export CSV for the data indicated in the filename, and append the new articles to the existing formatted dataset to create the formatted CSV files (`osb_lib_with_study_id_2024-04-04.csv`, etc.). Note there is no script to create the file `osb_lib_with_study_id_2020-02-21.csv`; this is because [this is the final file from the previous snapshot of the library, available on OSF](https://osf.io/q46r5).

- `code\clean_journal_wos_subject_categories.R`

This R script creates `data\osb_lib_journals_wos_subj_cats.csv` from the Excel spreadsheet `data\WoS_subject_categories_for_journals.xlsx`.

- `code\osb_lib_summary.qmd`

This Quarto document creates a HTML summary of the contents of the dataset `osb_lib_with_study_id_2024-08-09.csv` and generates the contents of the folder `results` (described next section).

## Results

- `results\osb_lib_summary.html`

This is the HTML output of the Quarto document `osb_lib_summary.qmd`.

- `results\osb_lib_summary_fig_byjnl.png`
- `results\osb_lib_summary_fig_byyear.png`
- `results\osb_lib_summary_fig_combos.png`

These images are figures summarising (respectively) article counts by journal, article counts by publication year, and the percentages of articles having each combination of Open Science Badges.

- `results\osb_lib_summary_tbl_wos_subj_cats.csv`

This CSV is a summary of the number of journal titles which fall into each Web of Science Subject Category found.
