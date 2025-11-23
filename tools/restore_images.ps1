$sourcePath = "..\shopdacuiprendereidati\icon\item"
$destPath = "images\items"

Write-Host "Restoring images from $sourcePath to $destPath..."

if (Test-Path $sourcePath) {
    $files = Get-ChildItem $sourcePath -Filter "*.png"
    $count = 0
    foreach ($file in $files) {
        Copy-Item $file.FullName -Destination $destPath -Force
        $count++
    }
    Write-Host "Restored $count images."
} else {
    Write-Error "Source path not found: $sourcePath"
}
