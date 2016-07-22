#! /bin/sh

BOOTSTRAP_SCRIPTDIR=`dirname $0`

ROOT=$(pwd)
# derive source directory from current working directory
SOURCEDIR="`cd ${BOOTSTRAP_SCRIPTDIR}/..;pwd`"
cd ${ROOT}

CONFIGURATION="Release"
if [ $# > 1 ]; then
  if [[ "$1" = "Debug" ]]; then
    CONFIGURATION="Debug"
  fi
fi

BUILD_SYSTEM="Xcode"

${BOOTSTRAP_SCRIPTDIR}/build_prerequisites.sh

if [[ ${BUILD_SYSTEM} = "Xcode" ]]; then
  echo "Building with Xcode"
  ${BOOTSTRAP_SCRIPTDIR}/configure.sh Xcode
  xcodebuild -project third_party.xcodeproj -target ALL_BUILD -destination 'platform=OS X,arch=x86_64'
  xcodebuild -project third_party.xcodeproj -target install -destination 'platform=OS X,arch=x86_64'
  python ${BOOTSTRAP_SCRIPTDIR}/create_framework.py ${SOURCEDIR}
else
  echo "Building with make"
  ${BOOTSTRAP_SCRIPTDIR}/configure.sh
  make -j 4
  make install
  python ${BOOTSTRAP_SCRIPTDIR}/create_framework.py ${SOURCEDIR}
fi
