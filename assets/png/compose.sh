#!/usr/bin/env zsh

# 1. PREPARATION
#   * Install the Chrome extension FusionBase Pro
#     https://chromewebstore.google.com/detail/fusebase-pro-capture-scre/fddbloohgcjopkmnjdeodjcfbgiimpcn
#   * Use the "Capture Fragment" feature to capture the `.pagy` nav/div,
#     save the screenshots/masks and name each file with the file name indicated in the demo.app
#   * Open the the gem/apps/demo.ru app

# 2. SCREENSHOTS
#   * Comment the `APP_MODE = :demo` line and uncomment the `APP_MODE = :screenshot`
#     in the gem/apps/demo.ru and run `pagy demo`
#   * Save the png files in the assets/png/screenshots dir

# 3. SCREENSHOT MASKS
#   * Comment the `APP_MODE = :screenshot` line and uncomment the `APP_MODE = :mask`
#     in the gem/apps/demo.ru and reboot `pagy demo`
#   * Save the png files in the assets/png/masks dir

# 4. REVERT
#   * Comment the `APP_MODE = :mask` line and uncomment the `APP_MODE = :demo`

# 5. COMPOSE THE FINAL IMAGES
#   * Run this script from its dir: ./compose.sh

destination="${PWD}/../images"
screenshots='screenshots/'
masks='masks/'

for file in "$screenshots"*.png; do
  local_file="${file#$screenshots}"
  mask_file="$masks$local_file"
  if [[ -f "$mask_file" ]]; then
    echo $file, $mask_file
    convert "$file" -shave 1x1 -bordercolor transparent -border 1 temp_file.png
    convert "$mask_file" -shave 1x1 -bordercolor transparent -border 1 temp_mask.png
    convert temp_file.png temp_mask.png -alpha off -compose CopyOpacity -composite "$destination/$local_file"
    rm temp_file.png temp_mask.png
  else
    echo ">>> $mask_file not found"
  fi
done
