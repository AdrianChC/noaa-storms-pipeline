# NOAA Storms Pipeline

A one-command pipeline that downloads a year of NOAA Storm Events data, converts it to GeoParquet, and lands it ready for analysis in DuckDB, GeoPandas, or QGIS.

## What it does

`pipeline.sh` takes a year (default: 2025), pulls the raw `locations` files from NOAA's public archive, merge and converts them into a single GeoParquet file at `data/processed/StormEvents_locations_{YEAR}.parquet`.

Total runtime: about 90 seconds for a typical year on a home internet connection.

## The data

- **Source:** [NOAA Storm Events Database](https://www.ncei.noaa.gov/data/storm-events/)
- **License:** Public domain (US federal data)
- **What's in it:** every recorded storm event in the United States for the given year, including type, location, and damages

## How to run it

Requires GDAL (for `ogr2ogr`) and standard Unix utilities (`curl`, `grep`, `sed`, `read`, `echo`).

```bash
git clone https://github.com/AdrianChC/noaa-storms-pipeline.git
cd noaa-storms-pipeline
chmod +x pipeline.sh
./pipeline.sh
```

To run for a specific year:

```bash
./pipeline.sh 2023
```

## What I learned

I learned to design a bash end-to-end pipeline to extract stream csv data, transform it into a ready-to-use geospatial format with GDAL, and upload it into a GitHub repository. I did not expect that making commits to my GitHub would have been so hard to understand. But once connection is done, then is easy to make keep making commits. If I have to re-do this ETL project, I would up-scale it by including the ability to extract multiple years, the detailes and fatalities datasets.


## Stack

- bash
- curl
- GDAL / ogr2ogr
- GeoParquet
