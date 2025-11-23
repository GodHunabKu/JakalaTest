<?php
/**
 * CSS Minification Script
 * Minifica shop-features-2025.css rimuovendo commenti, whitespace, duplicati
 */

$cssFile = __DIR__ . '/../assets/css/shop-features-2025.css';
$minFile = __DIR__ . '/../assets/css/shop-features-2025.min.css';

if (!file_exists($cssFile)) {
    die("File CSS non trovato!\n");
}

$css = file_get_contents($cssFile);
$originalSize = strlen($css);

echo "🔧 Minificazione CSS in corso...\n";
echo "📁 File originale: " . number_format($originalSize) . " bytes\n";

// 1. Rimuovi commenti CSS
$css = preg_replace('!/\*[^*]*\*+([^/][^*]*\*+)*/!', '', $css);

// 2. Rimuovi whitespace multipli
$css = preg_replace('/\s+/', ' ', $css);

// 3. Rimuovi spazi intorno a caratteri speciali
$css = preg_replace('/\s*([{}:;,>~+])\s*/', '$1', $css);

// 4. Rimuovi ultimo ; prima di }
$css = str_replace(';}', '}', $css);

// 5. Rimuovi spazi dopo : nelle proprietà
$css = preg_replace('/:\s+/', ':', $css);

// 6. Trim finale
$css = trim($css);

$minSize = strlen($css);
$reduction = (($originalSize - $minSize) / $originalSize) * 100;

// Salva file minificato
file_put_contents($minFile, $css);

echo "✅ Minificazione completata!\n";
echo "📁 File minificato: " . number_format($minSize) . " bytes\n";
echo "💾 Riduzione: " . number_format($reduction, 1) . "%\n";
echo "✨ Risparmiati: " . number_format($originalSize - $minSize) . " bytes\n\n";
echo "File salvato in: assets/css/shop-features-2025.min.css\n";
?>
