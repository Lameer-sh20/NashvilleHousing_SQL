/* Cleaning Data in SQL Queries */

select * from nashvillehousing
---------------------------------------------------------------------------------------------------
-- Standardize Date Format, datetime to date
select saledate, convert(date,saledate) from NashvilleHousing

alter table nashvillehousing
add UpdatedSaleDate date

update NashvilleHousing
set UpdatedSaleDate = convert(date,saledate)



---------------------------------------------------------------------------------------------------
-- Populate the missing data in PropertyAddress, parcelid = property address
select * 
from NashvilleHousing 
where PropertyAddress is null

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from NashvilleHousing as a
	join NashvilleHousing as b
on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from NashvilleHousing as a
	join NashvilleHousing as b
on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid



---------------------------------------------------------------------------------------------------
-- Breaking out PropertyAddress into individual columns (Address, City)
select PropertyAddress from NashvilleHousing 

select PropertyAddress,
	substring (PropertyAddress,0,PATINDEX('%,%', PropertyAddress)) as Address,
	substring (PropertyAddress,PATINDEX('%,%', PropertyAddress)+1,len(PropertyAddress)) as City
from NashvilleHousing 

alter table nashvillehousing
add PropertySplitAddress varchar(255)

update NashvilleHousing
set PropertySplitAddress = substring (PropertyAddress,0,PATINDEX('%,%', PropertyAddress))

select PropertySplitAddress from NashvilleHousing 


alter table nashvillehousing
add PropertySplitCity varchar(255)

update NashvilleHousing
set PropertySplitCity = substring (PropertyAddress,PATINDEX('%,%', PropertyAddress)+1,len(PropertyAddress))

select PropertySplitAddress from NashvilleHousing 


---------------------------------------------------------------------------------------------------
-- Breaking out OwnerAddress into individual columns (Address, City, State)
select owneraddress 
from NashvilleHousing 

select owneraddress,
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) as Address,
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) as City,
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) as State
from NashvilleHousing 

alter table nashvillehousing
add OwnerSplitAddress varchar(255), OwnerSplitCity varchar(255), OwnerSplitState varchar(255)

update NashvilleHousing
set 
OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select owneraddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState  
from NashvilleHousing 


---------------------------------------------------------------------------------------------------
-- Replace (Y, N) in SoldAsVacant column into (Yes, No)
select distinct(soldasvacant) from NashvilleHousing 

select soldasvacant, replace(soldasvacant,'Y','Yes'), replace(soldasvacant,'N','No')
from NashvilleHousing 
where soldasvacant = 'Y' or soldasvacant ='N'

update NashvilleHousing
set soldasvacant = case 
						when soldasvacant = 'Y' then 'Yes'
						when soldasvacant = 'N' then 'No'
						else soldasvacant
					end



---------------------------------------------------------------------------------------------------
-- Remove duplicates records
with cte as (
select parcelid, propertyaddress, saledate, saleprice, legalreference, ownername,
row_number() over (
					partition by parcelid, propertyaddress, saledate, saleprice, legalreference, ownername
					order by uniqueid 
					) row_num
					from NashvilleHousing
					)
delete
from cte 
where row_num > 1



---------------------------------------------------------------------------------------------------
-- Delete unused columns
select * from NashvilleHousing

alter table NashvilleHousing
drop column propertyaddress, owneraddress,saledate





