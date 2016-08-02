#! /bin/sh

BOOTSTRAP_SCRIPTDIR=`dirname $0`

ROOT=$(pwd)
# derive source directory from current working directory
SOURCEDIR="`cd ${BOOTSTRAP_SCRIPTDIR}/../USD;pwd`"
cd ${ROOT}

# arguments that can be overridden from the command line
CONFIGURATION="Release"
BUILD_SYSTEM="Xcode"
BUILD_PREREQUISITES="No"
PERFORM_BUILD="No"

for i in "$@"; do
case $i in
    -s=*|--src=*)
    SOURCEDIR="${i#*=}"
    shift # past argument=value
    ;;
    -d|--debug)
    CONFIGURATION="Debug"
    ;;
    -m|--make)
    BUILD_SYSTEM="make"
    ;;
    -p|--prerequisites)
    BUILD_PREREQUISITES="Yes"
    ;;
    -b|--build)
    PERFORM_BUILD="Yes"
    ;;
    *)
    # unknown option
    ;;
esac
done

echo "USD Source directory: " ${SOURCEDIR}
echo "Build system: " ${BUILD_SYSTEM}
echo "Build type: " ${CONFIGURATION}
echo "Building prerequisites: " ${BUILD_PREREQUISITES}
echo "Building USD:" ${PERFORM_BUILD}

if [[ ${BUILD_PREREQUISITES} = "Yes" ]]; then
  ${BOOTSTRAP_SCRIPTDIR}/build_prerequisites.sh
fi

if [[ ${BUILD_SYSTEM} = "Xcode" ]]; then
  ${BOOTSTRAP_SCRIPTDIR}/configure.sh Xcode
  if [[ ${PERFORM_BUILD} = "Yes" ]]; then
    xcodebuild -project third_party.xcodeproj -target ALL_BUILD -destination 'platform=OS X,arch=x86_64'
    xcodebuild -project third_party.xcodeproj -target install -destination 'platform=OS X,arch=x86_64'
    python ${BOOTSTRAP_SCRIPTDIR}/create_framework.py ${SOURCEDIR}
  fi
else
  ${BOOTSTRAP_SCRIPTDIR}/configure.sh
  if [[ ${PERFORM_BUILD} = "Yes" ]]; then
    make -j 4
    make install
    python ${BOOTSTRAP_SCRIPTDIR}/create_framework.py ${SOURCEDIR}
  fi
fi
