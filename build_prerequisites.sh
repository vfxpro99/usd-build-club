#! /bin/sh

PREREQ_SCRIPTDIR=`dirname $0`
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/jinja2.sh
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/bison.sh
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/flex.sh
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/boost.sh

# $? is the result of the most recent command
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/double-conversion.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/glew.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/numpy.sh
source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/OpenColorIO.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/OpenEXR.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/OpenSubdiv.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/jpeg.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/png.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/ptex.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/tiff.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/tbb.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/hdf5.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/alembic.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/OpenImageIO.sh
rc=$?
if [ $rc != 0 ]; then
  exit $rc
fi

#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/qt4.sh
#source ${PREREQ_SCRIPTDIR}/prerequisites-macOS/pyside.sh
