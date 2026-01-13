#!/usr/bin/env bash
#
# Copyright 2026 Saalim Quadri
# SPDX-License-Identifier: Apache-2.0
#

set -e

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
BASE_DIR="$SCRIPT_DIR"

log() {
    printf "[%s] %s\n" "$(date +%H:%M:%S)" "$*" >&2
}

fetch_github() {
    local repo_url="$1"
    local tag="$2"
    local asset="$3"
    local sha_field="$4"
    local dest="$5"

    local sha_expected="${sha_field#sha256:}"

    mkdir -p "$(dirname "$dest")"

    local repo="${repo_url#https://github.com/}"

    local url="https://github.com/$repo/releases/download/$tag/$asset"

    if [ -f "$dest" ]; then
        log "$dest exists; verifying checksum"
        sha_actual=$(sha256sum "$dest" | awk '{print $1}')
        if [ "$sha_actual" = "$sha_expected" ]; then
            log "checksum OK; skipping download"
            return 0
        else
            log "checksum mismatch; re-downloading"
            rm -f "$dest"
        fi
    fi

    tmp=$(mktemp)

    log "downloading $url"
    curl -L --fail --retry 3 -o "$tmp" "$url"

    log "verifying checksum"
    sha_actual=$(sha256sum "$tmp" | awk '{print $1}')
    if [ "$sha_actual" != "$sha_expected" ]; then
        rm -f "$tmp"
        log "checksum mismatch!"
        log "expected: $sha_expected"
        log "got:      $sha_actual"
        exit 1
    fi

    mv "$tmp" "$dest"
    log "stored at $dest"
}

fetch_fdroid() {
    local apk_url="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    local tmp_apk
    tmp_apk=$(mktemp)

    log "downloading $apk_url"
    curl -L --fail --retry 3 -o "$tmp_apk" "$apk_url"

    mv "$tmp_apk" "$dest"
    log "stored apk at $dest"
}

RELEASE_FILE="$BASE_DIR/.pvot_release"

while IFS= read -r line; do
    [ -z "$line" ] && continue
    [[ "$line" == \#* ]] && continue

    type=$(echo "$line" | awk '{print $1}')

    if [ "$type" = "gh" ]; then
        repo_url=$(echo "$line" | awk '{print $2}')
        tag=$(echo "$line" | awk '{print $3}')
        asset=$(echo "$line" | awk '{print $4}')
        sha=$(echo "$line" | awk '{print $5}')
        dest=$(echo "$line" | awk '{print $6}')
        dest="$BASE_DIR/${dest#./}"

        fetch_github "$repo_url" "$tag" "$asset" "$sha" "$dest"
    elif [ "$type" = "fdroid" ]; then
        apk_url=$(echo "$line" | awk '{print $2}')
        dest=$(echo "$line" | awk '{print $3}')
        dest="$BASE_DIR/${dest#./}"
        fetch_fdroid "$apk_url" "$dest"


    else
        log "unknown type '$type' in manifest"
        #exit 1
    fi

done < "$RELEASE_FILE"