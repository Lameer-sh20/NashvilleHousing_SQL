# Nashville Housing Data Cleaning 

The Nashville Housing dataset, contains records of properties and lands sales in Nashville, the capital city of the U.S. state of Tennessee.

I used SSMS to transform and clean the data, a yet to come step is to visualize data using Tableau.  

## Dataset
The dataset was taken from [GitHub](https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx) initially found in Kaggle. The dataset has 19 columns and 56,477 rows.


## Dataset Cleaning
The cleaning process involved the following steps:
- Standardize SaleDate column format.
- Populate the missing data in PropertyAddress column.
- Breaking out PropertyAddress column into individual columns (Address, City).
- Breaking out OwnerAddress into individual columns (Address, City, State).
- Replace (Y, N) in SoldAsVacant column into (Yes, No).
- Remove duplicates records.
- Delete unused columns.




