#!/usr/bin/env zsh

# 1. PREPARATION
#   * Install the Chrome extension FusionBase Pro
#   * Use the "Capture Fragment" feature to save the screenshots
#   * Open the the gem/apps/demo.ru app

# 2. SCREENSHOTS
#   * Uncomment the erb tag <%# SCREENSHOT_STYLE %> in the gem/apps/demo.ru and run `pagy demo`
#   * Save the screenshot png files in the assets/png dir
#   * IMPORTANT: respect the file names (take a look at the images to understand which is which)\

# 3. SCREENSHOT MASKS
#   * Uncomment the erb tag <%# MASK_STYLE %> in the gem/apps/demo.ru and reboot `pagy demo`
#   * Save the screenshot masks of the same pagination bars captured before
#   * IMPORTANT: use the same base name as the screenshot, suffixing it with "-mask"

# 4. REVERT
#   * Revert the changes made to the *_STYLE erb tags in the gem/apps/demo.ru

# 5. COMPOSE THE FINAL IMAGES
#   * Run this script from its dir: ./mask.sh

destination="${PWD}/../images"

for file in *.png; do
  mask_file="${file%.png}-mask.png"
  if [[ -f "$mask_file" ]]; then
    echo $file, $mask_file
    convert "$file" -shave 1x1 -bordercolor transparent -border 1 temp_file.png
    convert "$mask_file" -shave 1x1 -bordercolor transparent -border 1 temp_mask.png
    convert temp_file.png temp_mask.png -alpha off -compose CopyOpacity -composite "$destination/$file"
    rm temp_file.png temp_mask.png
  else
    echo ">>> $mask_file not found"
  fi
done
