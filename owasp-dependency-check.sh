#!/bin/sh

DC_VERSION="latest"
DC_PROJECT="dependency-check scan: $(pwd)"
DC_DIRECTORY="$HOME/dependency-check-data"  # Updated data directory
DATA_DIRECTORY="$DC_DIRECTORY/data"
CACHE_DIRECTORY="$DATA_DIRECTORY/cache"

if [ ! -d "$DATA_DIRECTORY" ]; then
    echo "Initially creating persistent directory: $DATA_DIRECTORY"
    mkdir -p "$DATA_DIRECTORY"
fi
if [ ! -d "$CACHE_DIRECTORY" ]; then
    echo "Initially creating persistent directory: $CACHE_DIRECTORY"
    mkdir -p "$CACHE_DIRECTORY"
fi

# Make sure we are using the latest version
docker pull owasp/dependency-check:$DC_VERSION

docker run --rm \
    -e user=$USER \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    --volume $(pwd):/src:z \
    --volume "$DATA_DIRECTORY":/usr/share/dependency-check/data:z \
    --volume $(pwd)/reports:/report:z \
    owasp/dependency-check:$DC_VERSION \
    --scan /src \
    --format "ALL" \
    --project "$DC_PROJECT" \
    --out /report \
    --cveUrl12Modified "https://nvd.nist.gov/feeds/json/cve/1.2/nvdcve-1.2-modified.json.gz"  # Added custom CVE URL

# Use suppression like this: (where /src == $pwd)
# --suppression "/src/security/dependency-check-suppression.xml"
