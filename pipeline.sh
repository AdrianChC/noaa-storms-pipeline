#!/usr/bin/env bash

# pipeline.sh - Download a year of NOAA Storm Events, and converts them to GeoParquet.

# Requires: bash, curl, sed, read, echo, 
# Requires: GDAL>=3.5 for ogr2ogr 

set -euo pipefail

# -e exit on command failure
# -u error on undefined variables
# -o fail a pipeline if any command fails

# ----------
# Config
# ----------

# Year to pull. Override by passing as the first argument.
YEAR="${1:-2025}"

# Root dataset endpoint
BASE_URL="https://www.ncei.noaa.gov/data/storm-events/access/original/"

# Only ingest LOCATIONS files
DATA_TYPE="locations"
FILE_PREFIX="StormEvents_${DATA_TYPE}"

# File pattern inside each year folder
FILE_PATTERN="${FILE_PREFIX}_*.csv"

# Full URL for the year directory
YEAR_URL="${BASE_URL}${YEAR}/"

echo "Fetching file list from: $YEAR_URL"
echo ""

# Defining Folders
RAW_DIR="data/raw"
PROCESSED_DIR="data/processed"

# Defining Files
OUT_PARQUET="../processed/${FILE_PREFIX}_${YEAR}.parquet"


# ---------------------------
# Step 1: Set up directories
# ---------------------------

echo "[1/4] Setting up directories"
# [TODO] Use mkdir -p to create RAW_DIR and PROCESSED_DIR. 
# Both should be safe to call even if the directories already exist.

mkdir -p "$RAW_DIR" "$PROCESSED_DIR"

echo ""

# ------------------------------
# Step 2: Download the raw file
# ------------------------------

echo "[2/4] Streaming directory listing and downloading files"
echo ""

# set current directory to data/raw
cd "$RAW_DIR"

# Stream remote directory listing and 
#  download each matching CSV file if 
#   not already present locally
curl -s "$YEAR_URL" \
  | grep -oE "href=\"${FILE_PREFIX}_[^\"]+\.csv\"" \
  | sed -E 's/href=\"|\"//g' \
  | while read -r file; do

      if [[ -z "$file" ]]; then
        continue
      fi

      if [[ -f "$file" ]]; then
        echo "Skipping existing file: $file"
        continue
      fi

      echo "Downloading $file"
      # actual download happens here
      curl -O "${YEAR_URL}${file}"
    done

echo ""
echo "Download complete."
echo ""

# -----------------------------------------------------
# Step 3: Convert CSV files into a single GeoParquet
# -----------------------------------------------------

echo "[3/4] Converting to GeoParquet"
echo ""

# Merge all CSV files into a GeoParquet file at OUT_PARQUET
ogr2ogr \
  -f Parquet "${OUT_PARQUET}" StormEvents_locations_*.csv \
  -oo X_POSSIBLE_NAMES=lon -oo Y_POSSIBLE_NAMES=lat \
  -a_srs EPSG:4326

echo "Done. Output: ${OUT_PARQUET}"


