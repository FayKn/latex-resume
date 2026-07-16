#!/bin/sh
set -eu

source_file=${1:-resume.tex}
source_dir=$(dirname "$source_file")
source_name=$(basename "$source_file")
pdf_file=${source_name%.tex}.pdf

cd "$source_dir"

font_dir=.zed/fonts
font_source_dir=${HOME}/Library/Fonts
if [ ! -f "$font_dir/Montserrat-Regular.ttf" ] || \
   [ ! -f "$font_dir/Montserrat-Bold.ttf" ] || \
   [ ! -f "$font_dir/Montserrat-Italic.ttf" ] || \
   [ ! -f "$font_dir/Montserrat-BoldItalic.ttf" ]; then
  mkdir -p "$font_dir"
  /opt/homebrew/bin/fonttools varLib.instancer \
    "$font_source_dir/Montserrat-VariableFont_wght.ttf" wght=400 \
    --output="$font_dir/Montserrat-Regular.ttf"
  /opt/homebrew/bin/fonttools varLib.instancer \
    "$font_source_dir/Montserrat-VariableFont_wght.ttf" wght=700 \
    --output="$font_dir/Montserrat-Bold.ttf"
  /opt/homebrew/bin/fonttools varLib.instancer \
    "$font_source_dir/Montserrat-Italic-VariableFont_wght.ttf" wght=400 \
    --output="$font_dir/Montserrat-Italic.ttf"
  /opt/homebrew/bin/fonttools varLib.instancer \
    "$font_source_dir/Montserrat-Italic-VariableFont_wght.ttf" wght=700 \
    --output="$font_dir/Montserrat-BoldItalic.ttf"
fi

/opt/homebrew/bin/tectonic -X compile "$source_name" \
  --synctex \
  --keep-logs \
  --keep-intermediates
/usr/bin/qlmanage -t -s 1400 -o "$source_dir" "$pdf_file" >/dev/null 2>&1
/bin/mv -f "$pdf_file.png" resume-preview.png
