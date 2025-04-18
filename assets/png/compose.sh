#!/usr/bin/env zsh

# Background / Objective: to quickly and easily capture screenshot images of pagination links
# with their respective "masks". This allows us to dispaly the images with transparency
# to make it look good on whatever background we desire in the Pagy docs.
# We found that doing things manually was extremely time consuming and error prone.

# 1. PREPARATION
#   * Install the Chrome extension FusionBase Pro
#     https://chromewebstore.google.com/detail/fusebase-pro-capture-scre/fddbloohgcjopkmnjdeodjcfbgiimpcn
#   * Use the "Capture Fragment" feature to capture the `.pagy` nav/div,
#     save the screenshots/masks and name each file with the file name indicated in the demo.app
#   * Open the the gem/apps/demo.ru app
#   * WARNING: if you have installed pagy as a gem, it is important that you run the correct version
#     of the pagy bin and demo app. To run the latest version, run the Pagy bin directly from the pagy repository:
#     i.e.: `./gem/bin/pagy demo`

# 2. SCREENSHOTS
#   * Comment the `APP_MODE = :demo` line and uncomment the `APP_MODE = :screenshot`
#     in the gem/apps/demo.ru and run `pagy demo`
#   * Save the png files in the assets/png/screenshots dir
#   * Slots: capture the 3 different slots sizes for bootstrap and bulma as well (e.g.:
#     series_nav_js-7-bootstrap, series_nav_js-9-bootstrap, series_nav_js-11-bootstrap,
#     series_nav_js-7-bulma, series_nav_js-9-bulma, series_nav_js-11-bulma)
#     as indicated in their pages. You will need to re-size the screen in order to do this.

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
