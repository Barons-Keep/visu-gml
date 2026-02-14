#!/bin/bash -ex

# install track in datafiles
echo "\n🔧 Install track folder\n========================"
rm -rf ./track
cp -rv ./gm_modules/track/resource/datafiles/track/ ./track/

