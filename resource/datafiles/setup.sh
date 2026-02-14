#!/bin/bash -ex

# arguments
CLEAN_GM_MODULES=false

# parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
  -c|--clean)
    CLEAN_GM_MODULES=true
    shift
    ;;
  *)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac
done

# init gm_modules
if [[ "$CLEAN_GM_MODULES" == true ]]; then
  echo "Remove gm_modules"
  rm -rf ./gm_modules
fi
gm-cli install

# sync gm_modules
gm-cli sync

# install track
rm -rf ./track
cp -rv ./gm_modules/track/resource/datafiles/track/ ./track/

