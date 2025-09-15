# Hipages Data Project

This repository contains SQL, exploratory analysis, and visualization files for the Hipages data task.

## Contents

- **SQL_Task.sql**  
  SQL queries used for data extraction, cleaning, and transformation.

- **EDA.ipynb**  
  Jupyter Notebook containing exploratory data analysis (EDA).  
  *(Note: Earlier versions will be merged into this single notebook.)*

- **Hipages_Final.twbx**  
  Tableau packaged workbook with dashboards and visualizations.

## Usage

1. **SQL**  
   Open `SQL_Task.sql` in any SQL editor (BigQuery, MySQL, or similar). Run queries step-by-step to reproduce the data preparation.

2. **EDA Notebook**  
   - Requires Python 3.  
   - Install dependencies:  
     ```bash
     pip install pandas numpy matplotlib seaborn jupyter
     ```  
   - Launch notebook:  
     ```bash
     jupyter notebook EDA.ipynb
     ```

3. **Tableau**  
   - Open `Hipages_Final.twbx` in Tableau Desktop.  
   - Contains interactive charts/dashboards built on top of the processed dataset.

## Notes
- The `.twbr` file is a temporary Tableau backup and not required.
- Excel file (`jobs.xlsx`) contains supporting raw data for analysis.

---

Author: **choobs**  
