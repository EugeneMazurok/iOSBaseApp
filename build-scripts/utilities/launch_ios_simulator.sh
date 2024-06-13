 #!/usr/bin/env bash

if [ "$1" = "" ]; then
    echo "Usage: launch_ios_simulator.sh <device name>"
    exit 1;
fi

device="$1"
printf "Closing any open instances of the iphone simulator...\n"
killall "Simulator" || true
printf "Determining latest iOS simulator...\n"
latest_ios=$(xcodebuild -showsdks | grep -Eo "iphonesimulator(.+)" | tail -1)
latest_ios=${latest_ios##iphonesimulator}
printf "Detected latest iOS simulator version: ${latest_ios}\n"
printf "Pre-Launching iphone simulator for ${device} (${latest_ios})\n"
simulator_id=$(xcrun instruments -s | grep -Eo "${device} \(${latest_ios}\) \[.*\]" | grep -Eo "\[.*\]" | sed "s/^\[\(.*\)\]$/\1/")
open -b com.apple.iphonesimulator --args -CurrentDeviceUDID $simulator_id

RETVALUE=$?
if [ "$RETVALUE" != "0" ]; then
   printf "Something went wrong when attempting to launch the simulator for ${device} (${latest_ios})\n"
   exit 1;
fi 
printf "Simulator launched for ${device} (${latest_ios})\n"
