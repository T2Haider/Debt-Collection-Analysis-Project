📊 Debt Collection Analysis Project
A comprehensive SQL + Python-based project analyzing debt collection performance, uncovering trends in payment behaviors, and providing actionable insights to improve recovery strategies. This project is ideal for data science learners, analysts, and anyone interested in real-world financial data analysis.

🚀 Project Objectives
Extract debt collection data from a SQL database

Clean and transform the data using Python (pandas)

Perform exploratory data analysis (EDA)

Visualize key metrics and behavioral trends

Generate insights to optimize collection strategies

🧰 Tech Stack
Python – for data cleaning, analysis, and visualization

MySQL – for data extraction and querying

pandas – for data manipulation

matplotlib & seaborn – for data visualization

Jupyter Notebook – for interactive development

MySQL Workbench – for executing SQL queries

📁 Project Structure
bash
Copy
Edit
Debt-Collection-Analysis-Project/
│
├── database/
│   └── debt_collection.sql             # SQL schema or mock data (if applicable)
│
├── notebooks/
│   └── Debt_Collection_Analysis.ipynb  # Main analysis notebook
│
├── queries/
│   └── collection_queries.sql          # SQL scripts for data extraction
│
├── visualizations/
│   └── [charts].png                    # Generated plots and graphs
│
├── requirements.txt                    # List of Python libraries used
└── README.md                           # Project overview and documentation
📊 Dataset Overview
The dataset includes the following fields:

Debtor ID

Loan Amount

Amount Paid

Remaining Balance

Status (Paid, In Progress, Default)

Date of First Contact

Contact Attempts

Region

Collection Agent Assigned

Note: This is simulated or anonymized data for educational use only.

🔍 Analysis Highlights
Status distribution of debts (paid vs default vs in progress)

Agent-wise recovery performance

Region-wise debt behavior and trends

Correlation between contact attempts and recovery success

Loan size vs default likelihood

Monthly trends in collections and payment behavior

📈 Visualizations
The following visualizations are included:

Pie chart: Debt status distribution

Bar chart: Agent performance

Line chart: Monthly collection trends

Heatmap: Regional recovery rates

Histogram: Loan size vs default frequency

Visuals are saved in the /visualizations directory.
