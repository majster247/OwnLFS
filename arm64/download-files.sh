#!/bin/bash

# Define download and package directories
DOWNLOAD_DIR="download"
PACKAGES_DIR="packages"

# Create directories if they don't exist
mkdir -p "$DOWNLOAD_DIR"
mkdir -p "$PACKAGES_DIR"

# Read the CSV-like structure and process each line
IFS=";"
while read -r package version url md5sum; do
    download_path="$DOWNLOAD_DIR/$(basename "$url")"
    package_dir="$PACKAGES_DIR/$package"

    # Check if file is already downloaded
    if [ -f "$download_path" ]; then
        echo "$package is already downloaded."
    else
        echo "Downloading $package..."
        wget -q --show-progress -P "$DOWNLOAD_DIR" "$url"

        # Verify MD5 sum
        md5sum_actual=$(md5sum "$download_path" | awk '{print $1}')
        if [ "$md5sum_actual" != "$md5sum" ]; then
            echo "MD5 sum verification failed for $package. Exiting."
            exit 1
        else
            echo "MD5 sum verified for $package."
        fi
    fi

    # Check if package is already extracted
    if [ -d "$package_dir" ]; then
        echo "$package is already extracted."
    else
        # Create package directory and extract the contents
        echo "Extracting $(basename "$url") to $package_dir..."
        
        if [[ "$url" == *".tar.gz" ]]; then
            tar -xzf "$download_path" -C "$package_dir"
        elif [[ "$url" == *".tar.bz2" ]]; then
            tar -xjf "$download_path" -C "$package_dir"
        elif [[ "$url" == *".tar.xz" ]]; then
            tar -xf "$download_path" -C "$package_dir"
        else
            echo "Unsupported archive format for $package. Exiting."
            exit 1
        fi

        echo "Finished processing $package."
    fi

done < packages.csv

echo "All packages downloaded, verified, and extracted successfully."
