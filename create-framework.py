#!/usr/bin/python

import sys

if len(sys.argv) < 2:
    print "Usage: create_framework ./srcroot [--install]"
    sys.exit()

#-------------------------------------------------------------------------------
# Configuration

import os, re, subprocess, stat, shutil, json

src_dir = sys.argv[1]
framework_directory = "usd.framework"
framework_prefix = framework_directory + "/Versions/A/"
install_prefix = "/Library/Pixar"

install = True # why would you not want to do this?

if len(sys.argv) > 2:
    if sys.argv[2] == "--install":
        install = True

#-------------------------------------------------------------------------------
# Copy Utility

import glob

def file_is_newer(src, dst):
    return True # @TODO do this for real using fstat etc.

def copy_newer(src_path, out_path):
    if os.path.exists(src_path) and file_is_newer(src_path, out_path):
        file = open(src_path, 'r')
        schema_data = file.read()
        file.close
        file = open(out_path, 'w')
        file.write(schema_data)
        file.close()

#-------------------------------------------------------------------------------
print "Creating directory structure for usd.framework"

def create_directory(path):
    exists = os.path.exists(path)
    if not os.path.isdir(path):
        if exists:
            print "Path exists but is not directory", path
            sys.exit(1)

        try:
            os.makedirs(path)
        except:
            print "Could not create directory", path
            sys.exit(1)

def create_symlink(source, link):
	try:
		os.symlink(source, link)
	except:
		pass

def create_framework_directory_structure():
    directory_paths = [
    	framework_prefix + "Headers",
    	framework_prefix + "Resources"
    ]

    for directory_path in directory_paths:
    	create_directory(directory_path)

    os.system("cp -R ./include/pxr/ " +                  framework_prefix + "/Headers/pxr")
    os.system("cp -R ./local/include/boost/ " +          framework_prefix + "/Headers/boost")
    os.system("cp -R ./local/include/tbb/ " +            framework_prefix + "/Headers/tbb")
    os.system("cp -R ./local/include/OpenEXR/half*.* " + framework_prefix + "/Headers/")

os.system("rm -rf " + framework_directory)
create_framework_directory_structure()

#-----------------------------------------------------------------------------------------------------------
print "Publishing plugin info"

# there's still a bug that these plugins are found in preference to the 
# published plugins, so rename it to usd.bak to avoid that problem for now.
if os.path.exists("./local/share/usd"):
    if os.path.exists("./local/share/usd.bak"):
        os.system("rm -rf ./local/share/usd.bak")
    os.system("mv ./local/share/usd ./local/share/usd.bak")

os.system("cp -R -v ./local/share/usd.bak/plugins/ " + framework_prefix)

pluginfos = glob.glob(framework_prefix + "*/resources/pluginfo.json")
for p in pluginfos:
    f = open(p)
    s = f.read()
    s = s.replace("../../../../lib", "..")
    f = open(p, "w")
    f.write(s)
    f.close()

#-------------------------------------------------------------------------------
print "Publishing dylibs"

dylibs = [
	"arch", "garch", "gf", "js", "plug", "tf", "tracelite", "work",
	"pxOsd",
	"ar", "kind", "pcp", "usdUtils",
	"usdviewq",
	"tbb"
]

for dylib in dylibs:
    plugin = dylib
    src_path = os.path.join("local", "lib", "lib" + dylib + ".dylib")
    out_path = os.path.join(framework_prefix, "lib" + dylib + ".dylib")
    copy_newer(src_path, out_path)

#-------------------------------------------------------------------------------
# Publish the dylibs that also have frameworks

framework_dylibs = [
	"cameraUtil", "glf",
    "glfq",
    "hd", "hdx", "pcp", "plug", "sdf", "vt",
	"usd",
	"usdAbc",
	"usdGeom", "usdHydra", "usdImaging", "usdRi", "usdShade"
]

for dylib in framework_dylibs:
    plugin = dylib
    src_path = os.path.join("local", "lib", "lib" + dylib + ".dylib")
    out_path = os.path.join(framework_prefix, "lib" + dylib + ".dylib")
    copy_newer(src_path, out_path)

#-------------------------------------------------------------------------------
# Publish the third party dylibs

third_party_dylibs = [
	"libAlembic*.dylib",
    "libdouble-conversion*.dylib",
    "libGLEW*.dylib",
    "libHalf*.dylib",
    "libIex*.dylib",
    "libIlmImf*.dylib",
    "libIlmThread*.dylib",
    "libImath*.dylib",
	"libjpeg*.dylib",
    "libOpenColorIO*.dylib",
    "libOpenImageIO*.dylib",
    "libosdCPU*.dylib",
    "libosdGPU*.dylib",
    "libpng16*.dylib",
    "libPtex*.dylib",
    "libtiff*.dylib"
]

for dylib in third_party_dylibs:
    src_path_glob = os.path.join("local", "lib", dylib)
    src_paths = glob.glob(src_path_glob)
    for src_path in src_paths:
        out_path = os.path.join(framework_prefix, os.path.basename(src_path))
        if os.path.islink(src_path):
            src_path = os.path.basename(os.readlink(src_path))
            #src_path = os.path.join(framework_prefix, src_path)
            print "Linking ", src_path, " to ", out_path
            os.symlink(src_path, out_path)
        else:
            print "Copying ", src_path, " to ", out_path
            copy_newer(src_path, out_path)

#os.system("sudo ln -sf " + install_prefix + "/" + framework_prefix + "libdouble-conversion.1.0.0.dylib" + " " + framework_prefix + "libdouble-conversion.1.dylib")

boost_dylibs = [
    "atomic", "chrono", "container", "date_time", "filesystem", "graph",
    "iostreams", "locale", "log", "log_setup",
    "math_c99", "math_c99f", "math_c99l", "math_tr1", "math_tr1f", "math_tr1l",
    "prg_exec_monitor", "program_options", "python", "random", "regex",
    "serialization", "signals", "system", "thread", "timer", "type_erasure",
    "unit_test_framework", "wave", "serialization"
]

for dylib in boost_dylibs:
    boost_name = "libboost_" + dylib + ".dylib"
    src_path = os.path.join("local", "lib", boost_name)
    out_path = os.path.join(framework_prefix, boost_name)
    copy_newer(src_path, out_path)

#-------------------------------------------------------------------------------
print "Deploying to /Library/Pixar"

if install:
    exists = os.path.exists(install_prefix)
    if exists and not os.path.isdir(install_prefix):
        print install_prefix, "exists but is not directory"
        sys.exit(1)
    if exists:
        os.system("sudo rm -rf " + install_prefix)
    os.system("sudo mkdir " + install_prefix)
    os.system("sudo cp -v -R usd.framework " + install_prefix + "/")

    #os.system("sudo ln -sf " + install_prefix + "/" + framework_prefix + "Headers" + " " + "./usd.framework/Headers")
    #os.system("sudo ln -sf " + install_prefix + "/" + framework_prefix + "Resources" + " " + "./usd.framework/Resources")

#-------------------------------------------------------------------------------
print "Creating Python egg"

py_dir = "/Library/Python/2.7/site-packages" # sys.argv[2]
easy_install_path = os.path.join(py_dir, "easy-install.pth")

if not os.path.isfile(easy_install_path):
    print py_dir, "is not recognized as a Python site-packages directory because"
    print "there is no easy-install.pth file in that directory."
    sys.exit()

libs = [
    "pxr/Ar/_ar.so",
    "pxr/CameraUtil/_cameraUtil.so",
    "pxr/Gf/_gf.so",
    "pxr/Glf/_glf.so",
    "pxr/Kind/_kind.so",
    "pxr/Pcp/_pcp.so",
    "pxr/Plug/_plug.so",
    "pxr/Sdf/_sdf.so",
    "pxr/Tf/_tf.so",
    "pxr/Usd/_usd.so",
    "pxr/UsdAbc/_usdAbc.so",
    "pxr/UsdGeom/_usdGeom.so",
    "pxr/UsdHydra/_usdHydra.so",
    "pxr/UsdImaging/_usdImaging.so",
    "pxr/UsdRi/_usdRi.so",
    "pxr/UsdShade/_usdShade.so",
    "pxr/UsdUtils/_usdUtils.so",
    "pxr/Vt/_vt.so",
    "pxr/Work/_work.so"
]

egg_path = "pxr-0.8-py2.7-macosx-10.11-intel.egg"

os.system("rm -rf " + egg_path)

this_script_path = os.path.dirname(os.path.realpath(__file__))

#-------------------------------------------------------------------------------

# build the egg
create_directory(os.path.join(egg_path, "EGG-INFO"))

file = open(os.path.join(egg_path, "EGG-INFO", "native_libs.txt"), 'w')
for lib_path in libs:
    #path_parts = lib_path.split('/')
    #dir_path = os.path.join(*path_parts[:-1])
    file.write(lib_path + "\n")
file.close()



copy_newer(os.path.join(this_script_path, "PKG-INFO"),
           os.path.join(egg_path, "EGG-INFO", "PKG-INFO"))

file = open(os.path.join(egg_path, "EGG-INFO", "dependency_links.txt"), 'w')
file.write('\n')
file.close()

file = open(os.path.join(egg_path, "EGG-INFO", "not-zip-safe"), 'w')
file.write('\n')
file.close()

file = open(os.path.join(egg_path, "EGG-INFO", "SOURCES.txt"), 'w')
file.write('\n')
file.close()

file = open(os.path.join(egg_path, "EGG-INFO", "top_level.txt"), 'w')
file.write("pxr\n")
file.close()

curr_dir = os.getcwd()

# remove the pycs because they are compiled for where they sit, not the deploy location
pycs = glob.glob("local/lib/python/pxr/*/__init__.pyc")
for pyc in pycs:
    os.system("rm " + pyc)

# Copy the python build to the egg
os.system("cp -R " + "local/lib/python/pxr " + egg_path)

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
    allowed_library_prefixes = ["/usr/lib/", "/System/Library/Frameworks/", 
                                "/System/Library/PrivateFrameworks/", 
                                "/Library/Pixar/"] 
 
    for prefix in allowed_library_prefixes: 
        if library.startswith(prefix) and "libGlew" not in library: 
            return True 
    return False 

normalize_me = [ 
    "libAlembic", "libdouble-conversion", 
    "libGLEW", "libHalf", "libIex", "libIexMath", 
    "libIlmImfUtil", "libIlmImf", "libIlmThread", 
    "libImath", "libjpeg", "libOpenColorIO",  
    "libOpenImageIO",  
    "libosd", "libpng", "libPtex", "libtiff" 
] 
def normalize_library_path(library_path): 
    for test in normalize_me: 
        if test in library_path: 
            return "@rpath/" + os.path.basename(library_path) 
 
    if is_library_okay(library_path): 
        return library_path 
    return "@rpath/" + os.path.split(library_path)[-1] 

def rewrite_path(old, new, exe): 
    if False: 
        print "Changing", old, new, exe 
    output = subprocess.check_output(["install_name_tool", "-change", old, new, exe]) 
 
if False:
    for module in libs: 
        path_parts = module.split('/') 
        lib = path_parts[-1].split('.')[0] + ".dylib" 
        dylib_path = os.path.join(egg_path, os.path.join(*path_parts[:-1]), lib) 
        if (os.path.exists(dylib_path)):
            libraries = get_libraries(dylib_path) 
            for library in libraries: 
                if not is_library_okay(library): 
                    library_filename = os.path.split(library)[1] 
                    new_library_path = normalize_library_path(library).split('/')[-1] 
                    new_library_path = os.path.join(install_prefix, framework_prefix, new_library_path) 
                    rewrite_path(library, new_library_path, dylib_path) 

            # and rewrite the self-named rpath as well
            output = subprocess.check_output(["install_name_tool",  "-id",
                                              py_dir + "/" + dylib_path, 
                                              dylib_path])
 
#-------------------------------------------------------------------------------
print "Copy the egg into site-packages"
os.system("sudo rm -rf " + py_dir + "/" + egg_path)
os.system("sudo cp -R " + egg_path + " " + py_dir + "/")

#-------------------------------------------------------------------------------
print "Symlinking so files"

for lib_path in libs:
    path_parts = lib_path.split('/')
    dir = path_parts[-2]
    lib = path_parts[-1].split('.')[0]
    cd_dir = os.path.join(py_dir, egg_path, *path_parts[:-1])
    if os.path.isdir(cd_dir):
        os.chdir(cd_dir)
        # cbb: use os.path.join
        src = py_dir + "/" + egg_path + "/pxr/" + dir + "/" + lib + ".dylib"
        link = lib + ".so"
        os.system("sudo ln -sf " + src + " " + link)

os.chdir(curr_dir)

#-------------------------------------------------------------------------------
print "Finalize Python install"

file = open(easy_install_path, 'r')
easy_lines = file.readlines()
file.close()
found_install = False
for line in easy_lines:
    if egg_path in line:
        found_install = True

if not found_install:
    easy_lines.insert(1, './' + egg_path + '\n')
    file = open('/Library/Python/2.7/site-packages/easy-install.pth', 'w')
    file.writelines(easy_lines)
    file.close()
