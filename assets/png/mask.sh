#!/usr/bin/env zsh

# Uncomment the styles for screnshoot masking in the demo.ru app
# Capture the screenshot masks using FusionBase Pro > Capture Fragment

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
