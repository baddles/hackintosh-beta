
#!/usr/bin/env sh

#  get_latest.sh
#
#
#  Created by Baddles Nguyễn on 8/12/19.
#  Credits to Dids for helping with the error-handling stuffs.

# Enable error handling
set -e
set -o pipefail

# Enable script debugging
#set -x
dir="${0%/*}"
echo "Runing script to grab Latest commit of Kexts."

echo "Kexts will ended up in Kexts folder at the same place where this script is placed."

sleep 4

echo "Error-checking: In order to prevent cloning git stage fail, these commands are to check if there are existing folder already in the lists."
mkdir "$dir"/Kexts
mkdir "$dir"/Lilu
mkdir "$dir"/AppleALC
mkdir "$dir"/WhateverGreen
mkdir "$dir"/VirtualSMC

rmdir "$dir"/Kexts
rmdir "$dir"/Lilu
rmdir "$dir"/AppleALC
rmdir "$dir"/WhateverGreen
rmdir "$dir"/VirtualSMC

echo "Recreating kexts folder."
mkdir -p "$dir"/Kexts/{Debug,Release}/{Lilu,AppleALC,WhateverGreen,VirtualSMC}.kext

echo "Cloning Lilu"
git clone https://github.com/acidanthera/Lilu.git "$dir"/Lilu

#  Build Lilu.
echo "Finished cloning Lilu."
echo "Preparing to build Lilu."
sleep 2

xcodebuild -project ./Lilu.xcodeproj -configuration Debug CONFIGURATION_BUILD_DIR=$(echo "$dir"/Product/Debug/)

xcodebuild -project ./Lilu/Lilu.xcodeproj -configuration Release CONFIGURATION_BUILD_DIR=$(echo "$dir"/Product/Release/)
echo "Copying Lilu to Kexts folder."
cp -R "$dir"/Lilu/Product/Debug/Lilu.kext "$dir"/Kexts/Debug
cp -R "$dir"/Lilu/Product/Release/Lilu.kext "$dir"/Kexts/Release

echo "Delete Lilu build folder to clean up."
rm -rf "$dir"/Lilu

#  Clone AppleALC:
git clone https://github.com/acidanthera/AppleALC.git "$dir"/AppleALC

echo "Copying LiluDebug to AppleALC Folder."
cp -R "$dir"/Kexts/Debug/Lilu.kext "$dir"/AppleALC

#  Build AppleALC
echo "Preparing to build AppleALC."
sleep 2
xcodebuild -project "$dir"/AppleALC/AppleALC.xcodeproj -configuration Release CONFIGURATION_BUILD_DIR=$(echo "$dir"/Product/Release)
xcodebuild -project "$dir"/AppleALC/AppleALC.xcodeproj -configuration Debug CONFIGURATION_BUILD_DIR=$(echo "$dir"/Product/Debug)
echo "Copy AppleALC into Kext folder."
cp -R "$dir"/AppleALC/Product/Release/AppleALC.kext "$dir"/Kexts/Release
cp -R "$dir"/AppleALC/Product/Debug/AppleALC.kext "$dir"/Kexts/Debug

echo "Deleting AppleALC folder."
rm -rf "$dir"/AppleALC

sleep 2
echo "Cloning Lilu."
git clone https://github.com/acidanthera/VirtualSMC.git "$dir"/WhateverGreen

echo "Copying LiluDebug to WhateverGreen Folder."
cp -R "$dir"/Kexts/Debug/Lilu.kext "$dir"/WhateverGreen

#  Build WhateverGreen
echo "Preparing to build WhateverGreen."
sleep 2

xcodebuild -project "$dir"/WhateverGreen/WhateverGreen.xcodeproj -configuration Release CONFIGURATION_BUILD_DIR=$(echo "$dir"/Product/Release)
sleep 2

xcodebuild -project "$dir"/WhateverGreen/WhateverGreen.xcodeproj -configuration Debug CONFIGURATION_BUILD_DIR=$(echo "$dir"/Product/Debug)

echo "Copy WhateverGreen into Kext folder."
cp -R "$dir"/WhateverGreen/Product/Release/WhateverGreen.Kexts "$dir"/Kexts/Release
cp -R "$dir"/WhateverGreen/Product/Debug/WhateverGreen.kext "$dir"/Kexts/Debug
echo "Deleting WhateverGreen folder."
rm -rf "$dir"/WhateverGreen
