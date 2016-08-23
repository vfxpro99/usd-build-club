#!/bin/bash

PREREQ_SCRIPTDIR=`dirname $0`
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/jinja2.sh
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/bison.sh
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/flex.sh

echo --- boost ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/boost.sh

# $? is the result of the most recent command
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

echo --- double-conversion ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/double-conversion.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

echo --- glew ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/glew.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

#echo --- numpy ---
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/numpy.sh

echo --- OpenColorIO.sh ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/OpenColorIO.sh
rc=$?
if [ $rc != 0 ]; then
  echo OpenColorIO build did not finish with a clean exit code, continuing nonetheless
fi

echo --- OpenEXR ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/OpenEXR.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

echo --- OpenSubdiv ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/OpenSubdiv.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

echo --- jpeg ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/jpeg.sh
rc=$?
if [ $rc != 0 ]; then
  echo jpeg build did not finish with a clean exit code, continuing nonetheless
fi

echo --- png ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/png.sh
rc=$?
if [ $rc != 0 ]; then
  echo png build did not finish with a clean exit code, continuing nonetheless
fi

echo --- ptex ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/ptex.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

echo --- tiff ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/tiff.sh
rc=$?
if [ $rc != 0 ]; then
  echo tiff build did not finish with a clean exit code, continuing nonetheless
fi

echo --- tbb ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/tbb.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

echo --- hdf5 ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/hdf5.sh
rc=$?
if [ $rc != 0 ]; then
  echo HDF5 build did not finish with a clean exit code, continuing nonetheless
fi

echo --- alembic ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/alembic.sh
rc=$?
if [ $rc != 0 ]; then
  echo Alembic build did not finish with a clean exit code, continuing nonetheless
fi

echo --- OpenImageIO ---
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/OpenImageIO.sh
rc=$?
if [ $rc != 0 ]; then
  echo OpenImageIO build did not finish with a clean exit code, continuing nonetheless
fi

# echo --- qt4 ---
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/qt4.sh

# echo --- pyside ---
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/pyside.sh

exit 0

