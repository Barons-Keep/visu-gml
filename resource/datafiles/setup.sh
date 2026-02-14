#!/bin/bash -e

echo -e "\n\n⬆️  Setup is starting\n===================="

# arguments
VERBOSE=""

# parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
  -v|--verbose)
    VERBOSE="-v"
    shift
    ;;
  *)
    echo -e "\nUnknown option: $1\n"
    exit 1
    ;;
  esac
done

# install track in datafiles
echo -e "\n🔧 Install track folder\n========================"
rm -rf ./track
cp -r $VERBOSE ./gm_modules/track/resource/datafiles/track/ ./track/
ls -1 ./track/

echo -e "\n\n✅ The setup is finished\n========================"
