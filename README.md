# Climate Snapshot: Temperature Comparison Dashboard

| | |
| :--- | :--- |
| **License** | [![License](https://img.shields.io/github/license/UBC-MDS/DSCI-532_Temp_Dashboard_R?label=License)](LICENSE) |
| **R** | [![R 4.0+](https://img.shields.io/badge/R-4.0+-blue.svg)](https://www.r-project.org/) |
| **Status** | ![Status](https://img.shields.io/badge/status-active-brightgreen) |

## Overview

**Climate Snapshot** is an interactive **Shiny dashboard** that allows users to explore temperature trends across countries and compare seasonal and monthly temperature patterns between two selected years.

Users can choose a country and define a **baseline year** and **target year** to observe how temperatures have changed over time. The dashboard presents this information through seasonal summaries, interactive monthly temperature plots, and a downloadable data table.

This tool provides a simple and intuitive way to examine how temperature patterns vary across time, offering a quick glimpse into potential climate change signals.

**Deployed Dashboard URL:** https://019ce069-9700-e9a4-0799-ee403874cef8.share.connect.posit.cloud/

---

# Table of Contents

- [Overview](#overview)
- [For Users](#for-users)
  - [Features](#features)
- [For Contributors](#for-contributors)
  - [Project Structure](#project-structure)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Contributors](#contributors)
- [License](#license)

---

# For Users

The **Climate Snapshot dashboard** allows users to quickly explore and compare temperature patterns across countries.

## Features

- **Country selection** – Explore temperature data for different countries in the dataset  
- **Year comparison** – Compare temperature patterns between a baseline and target year  
- **Seasonal summary table** – View average seasonal temperatures and their changes  
- **Interactive monthly plot** – Visualize monthly temperature differences across the year  
- **Data table with export** – Inspect the monthly comparison table and download it as CSV  


---

# For Contributors

## Project Structure

The main application logic is located in the `src/` directory.

```text
├── data/                   # Data storage
│   ├── raw/                # Original temperature dataset
│   └── processed/          # Cleaned and aggregated datasets used by the app
├── src/                    # Shiny application source code
│   ├── app.R               # Main application file containing server logic
│   ├── ui.R                # User interface components and layout
│   ├── utils.R             # Helper functions and pre-aggregated data objects
│   ├── data_processor.R    # Script for cleaning and preparing the dataset
│   └── manifest.json       # Deployment configuration for the Shiny app
└── README.md               # Project documentation and usage instructions
```

## Installation

Ensure you have **R** and required packages installed.

Clone the repository:

```bash
git clone https://github.com/UBC-MDS/DSCI-532_Temp_Dashboard_R.git
cd DSCI-532_Temp_Dashboard_R
```

Install packages: 

```r
install.packages(c("shiny","bslib","dplyr","tidyr","ggplot2","plotly"))
```

## Running the App

Run the app locally: 

```bash
shiny::runApp("src")
```

## Contributors

Shi Fan Jin

## License
This project is licensed under the MIT License. See the [MIT License](./LICENSE) file for details.