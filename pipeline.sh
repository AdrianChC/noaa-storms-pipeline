#!/usr/bin/env bash

# pipeline.sh - Download a year of NOAA Storm Events, and converts them to GeoParquet.

# Requires: bash, curl, gunzip, ogr2ogr (GDAL >= 3.5)

set -euo pipefail

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


# ---------------------------
# Step 1: Set up directories
# ---------------------------

# Project structure
#RAW_DIR="data/raw"
#PROCESSED_DIR="data/processed"


# ------------------------------
# Step 2: Download the raw file
# ------------------------------




# ------------------------------
# Step 3: Decompress
# ------------------------------




# ----------------------------------
# Step 4: Convert CSV to GeoParquet
# ----------------------------------