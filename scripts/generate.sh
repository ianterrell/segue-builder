echo "Segue Generator: Determining if generated Swift file is up-to-date."

GENERATOR_PATH="$PROJECT_DIR/scripts/segue-generator.swift"

if [ -f $GENERATOR_PATH ]; then
  BASE_PATH="$PROJECT_DIR/$PROJECT_NAME"

  OUTPUT_PATH="$BASE_PATH/SegueExtensions.swift"

  if [ ! -e "$OUTPUT_PATH" ] || [ -n "$(find "$BASE_PATH" -type f -name "*.storyboard" -newer "$OUTPUT_PATH" -print -quit)" ]; then
    echo "Segue Generator: Generated Swift is out-of-date; re-generating..."

    if [ -f $OUTPUT_PATH ]; then
      /usr/bin/chflags -f nouchg "$OUTPUT_PATH"
    fi
    "$GENERATOR_PATH" "$BASE_PATH" > "$OUTPUT_PATH"
    /usr/bin/chflags uchg "$OUTPUT_PATH"

    echo "Segue Generator: Done."
  else
    echo "Segue Generator: Generated Swift is up-to-date; skipping re-generation."
  fi
fi
