# cleanup_images.ps1
# Script to clean up unused images in images/items and images/categories

$ErrorActionPreference = "Stop"

Write-Host "Reading Database Files..."
# 1. Get VNUMs
$shopItemsContent = Get-Content "tools/migration_source/shop_items.sql" -Raw
$vnums = [regex]::Matches($shopItemsContent, "INSERT INTO `shop_items` VALUES \(\d+, \d+, (\d+),") | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique

# 2. Get Category IDs
$shopCatsContent = Get-Content "tools/migration_source/shop_categories.sql" -Raw
$catIds = [regex]::Matches($shopCatsContent, "INSERT INTO `shop_categories` VALUES \((\d+),") | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique

Write-Host "Found $($vnums.Count) Items and $($catIds.Count) Categories."

# 3. Parse get_item_image.php
Write-Host "Parsing get_item_image.php..."
$phpContent = Get-Content "include/functions/get_item_image.php" -Raw
$imageMap = @{}
[regex]::Matches($phpContent, "case\s+(\d+):\s+return\s+[""']([^""']+)[""'];") | ForEach-Object {
    $imageMap[$_.Groups[1].Value] = $_.Groups[2].Value
}

# 4. Build Whitelists
Write-Host "Building Whitelists..."
$whitelistCats = $catIds | ForEach-Object { "$_.png" }
$whitelistItems = New-Object System.Collections.Generic.HashSet[string]

foreach ($v in $vnums) {
    # Direct
    $null = $whitelistItems.Add("$v.png")
    
    # Padded (Logic from PHP: pads to 5 digits if < 5)
    $padded = $v
    if ($v.Length -lt 5) {
        $padded = "0" * (5 - $v.Length) + $v
    }
    $null = $whitelistItems.Add("$padded.png")

    # Mapped from switch case
    if ($imageMap.ContainsKey($v)) {
        $mapped = $imageMap[$v]
        $null = $whitelistItems.Add("$mapped.png")
    }

    # Rounded logic (PHP else block)
    try {
        $vInt = [int]$v
        $rounded = $vInt - ($vInt % 10)
        $roundedStr = $rounded.ToString()
        $paddedRounded = $roundedStr
        if ($roundedStr.Length -lt 5) {
            $paddedRounded = "0" * (5 - $roundedStr.Length) + $roundedStr
        }
        $null = $whitelistItems.Add("$paddedRounded.png")
    } catch {}
}

Write-Host "Whitelisted Items Count: $($whitelistItems.Count)"

if ($whitelistItems.Count -eq 0) {
    Write-Error "Whitelist is empty! Aborting to prevent data loss."
    exit 1
}

# 5. Clean Categories
$catPath = "images/categories"
if (Test-Path $catPath) {
    Write-Host "Cleaning Categories..."
    Get-ChildItem $catPath -Filter "*.png" | ForEach-Object {
        if ($whitelistCats -notcontains $_.Name) {
            Write-Host "Deleting Category Image: $($_.Name)"
            Remove-Item $_.FullName -Force
        }
    }
}

# 6. Clean Items
$itemPath = "images/items"
if (Test-Path $itemPath) {
    Write-Host "Cleaning Items..."
    Get-ChildItem $itemPath -Recurse -Filter "*.png" | ForEach-Object {
        # Get relative path
        $relPath = $_.FullName.Substring((Get-Item $itemPath).FullName.Length + 1).Replace("\", "/")
        
        if (-not $whitelistItems.Contains($relPath)) {
            Write-Host "Deleting Item Image: $relPath"
            Remove-Item $_.FullName -Force
        }
    }
}

# Clean empty directories in images/items
Get-ChildItem $itemPath -Recurse -Directory | Sort-Object FullName -Descending | ForEach-Object {
    if ((Get-ChildItem $_.FullName).Count -eq 0) {
        Remove-Item $_.FullName
    }
}

Write-Host "Cleanup Complete."
