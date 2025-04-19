#!/usr/bin/env zsh

# This script composes the image and masks screenshot prepared with the `pagy docshots` app.
# Run it from its dir: ./compose.zsh

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
