SELECT * 
FROM Portfolio.dbo.NashvilleHousing;



-- Standardize Sale Date

ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate date;

SELECT SaleDate 
FROM Portfolio.dbo.NashvilleHousing;



-- Populate Property Address Data

SELECT * FROM Portfolio.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL;



-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress 
FROM Portfolio.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +2, LEN(PropertyAddress)) AS City
FROM Portfolio.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +2, LEN(PropertyAddress));


SELECT OwnerAddress
FROM Portfolio.dbo.NashvilleHousing;

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM Portfolio.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1);




--  Change Y and N to Yes and No

SELECT distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM Portfolio.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant
,	CASE When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
		END
FROM Portfolio.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
		END



-- Remove Duplicates

With RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) row_num

FROM Portfolio.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1




-- Delete Unused Columns

SELECT *
FROM Portfolio.dbo.NashvilleHousing;

ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;

ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN SaleDate;