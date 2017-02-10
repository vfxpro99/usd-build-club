#! /usr/bin/python

import os, re, subprocess, stat, shutil, json

#-------------------------------------------------------------------------------
print "Rpath the python libraries"

def get_libraries(path):
    libraries = []
    if os.path.exists(path):
        output = subprocess.check_output(["otool", "-L", path])
        for line in output.split('\n'):
            m = re.match(r'^\s+(.*) \(compatibility version .*, current version .*\)$', line)
            if m:
                libraries.append(m.group(1))
    return libraries

def is_library_okay(library):
    allowed_library_prefixes = ["@executable_path", 
                                "/usr/lib/", "/System/Library/Frameworks/",
                                "/System/Library/PrivateFrameworks/"]

    for prefix in allowed_library_prefixes:
        if library.startswith(prefix) and "libGlewXXX" not in library:
            return True
        if "libtbb" in library:
            return True

    return False

def normalize_library_path(library_path):
    if is_library_okay(library_path):
        return library_path

    return "@loader_path/" + os.path.basename(library_path)

verbose = False

def rewrite_path(old, new, exe):
    if verbose:
        print "Changing", old, new, exe
    output = subprocess.check_output(["install_name_tool", "-change", old, new, exe])
    if verbose:
        print output

def rewrite_paths(libs, rpath_prefix):
    for module in libs:
        if os.path.exists(module):
            libraries = get_libraries(module)
            for library in libraries:
                if not is_library_okay(library):
                    #library_filename = os.path.split(library)[1]
                    new_library_path = normalize_library_path(library).split('/')[-1]
                    new_library_path = os.path.join(rpath_prefix, new_library_path)
                    rewrite_path(library, new_library_path, module)

            # and rewrite the self-named rpath as well
            output = subprocess.check_output(["install_name_tool", "-id",
                                              module, module])

            if verbose:
                print output

python_libs = [
    "Ar/_ar.so",
    "CameraUtil/_cameraUtil.so",
    "Garch/_garch.so",
    "Gf/_gf.so",
    "Glf/_glf.so",
    "Kind/_kind.so",
    "Pcp/_pcp.so",
    "Plug/_plug.so",
    "Sdf/_sdf.so",
    "Tf/_tf.so",
    "Usd/_usd.so",
    "UsdAbc/_usdAbc.so",
    "UsdGeom/_usdGeom.so",
    "UsdHydra/_usdHydra.so",
    "UsdImaging/_usdImaging.so",
    "UsdImagingGL/_usdImagingGL.so",
    "UsdMaya/_usdMaya.so",
    "UsdRi/_usdRi.so",
    "UsdShade/_usdShade.so",
    "UsdUI/_usdUI.so",
    "UsdUtils/_usdUtils.so",
    "Usdviewq/_usdviewq.so",
    "Vt/_vt.so",
    "Work/_work.so"
]

pathed_python_libs = []
for path in python_libs:
    pathed_python_libs.append("/tmp/maya-usd/lib/python/pxr/" + path)

rewrite_paths(pathed_python_libs, "@loader_path/")

maya_libs = [
    "/tmp/maya-usd/third_party/maya/lib/libpx_vp20.dylib",
    "/tmp/maya-usd/third_party/maya/lib/libpxrUsdMayaGL.dylib",
    "/tmp/maya-usd/third_party/maya/lib/libUsdMay.dylib",
    "/tmp/maya-usd/third_party/maya/plugin/pxrUsd.bundle"
]

rewrite_paths(pathed_python_libs, "@loader_path/../../../lib/")

usd_libs = os.listdir("/tmp/maya-usd/lib")
pathed_usd_libs = []
for path in usd_libs:
    if ".DS_Store" not in path:
        if os.path.isfile(os.path.join("/tmp/maya-usd/lib", path)):
            pathed_usd_libs.append("/tmp/maya-usd/lib/" + path)

rewrite_paths(pathed_usd_libs, "@loader_path/")
