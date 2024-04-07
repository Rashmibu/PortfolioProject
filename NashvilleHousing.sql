--Clearing Data
select * from NashvilleHousing

--Standardize Sale Date
Select saledate, CONVERT(Date,Saledate) as SalesDate
from NashvilleHousing

Alter table Nashvillehousing
Drop SaleDateConverted; Date;

Update NashvilleHousing
SET SaleDateConverted= CONVERT(Date,Saledate)
-----------------------------------------------------------------------------------------------------
--Populate Property Address
Select *
from NashvilleHousing
where PropertyAddress IS NULL
order by ParcelID

Select a.uniqueid,a.ParcelID,a.PropertyAddress,b.uniqueid,b.ParcelID,b.PropertyAddress
 from NashvilleHousing a JOIN NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null 

Update a
SET a.propertyaddress= ISNULL(a.propertyaddress,b.PropertyAddress)
from NashvilleHousing a JOIN NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null 

-----------------------------------------------------------------------------------------
--Breaking out Address into Individual Columns(Address,City,State)

Select Propertyaddress,
SUBSTRING(Propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from NashvilleHousing

Alter Table NashvilleHousing
Add PropAddress NVarchar(255);
Update NashvilleHousing
SET PropAddress=SUBSTRING(Propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertyCity NVarchar(255);
Update NashvilleHousing
SET PropertyCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

---------------------------------------------------------------------------------------------------------------------
--Changing Owner Address into Address,City and State
Select OwnerAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing

Alter Table NashvilleHousing
Add OwnAddress NVarchar(255);
Update NashvilleHousing
SET OwnAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerCity NVarchar(255);
Update NashvilleHousing
SET OwnerCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerState NVarchar(255);
Update NashvilleHousing
SET OwnerState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select * from NashvilleHousing

--------------------------------------------------------------------------------
--Change Y and N to YEs and NO respectively in 'SoldAsVacant field'
Select distinct(SoldAsVacant),Count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant

Select SoldAsVacant,
CASE 
	When SoldAsVacant='Y' Then 'Yes'
	When SoldAsVacant='N' Then 'No'
	Else SoldAsVacant
END
from NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant=CASE 
	When SoldAsVacant='Y' Then 'Yes'
	When SoldAsVacant='N' Then 'No'
	Else SoldAsVacant
END

--------------------------------------------------------------------------------------
--Remove Duplicates
With RowNumCTE AS(
Select * ,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelId,
	PropertyAddress,
	SaleDate,
	Saleprice,
	Legalreference
	ORDER BY
	UniqueID) row_num
from NashvilleHousing)

Select *
--DELETE 
from RowNumCTE
where row_num>1

--------------------------------------------------------------------------
--Delete UnUSed Columns

Select *
From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress,SaleDate








