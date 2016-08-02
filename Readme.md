
Building USD on OSX
-------------------

```
  mkdir Projects
  cd Projects
  git clone https://github.com/AddressOfUsd/UsdDev.git
  git clone https://github.com/vfxpro99/usd-build-club.git
  mkdir stage
  cd stage
  echo get coffee... In a little while you're going to need to enter a sudo password
  ../UsdDev/usd-build-club/bootstrap.sh -p -b
```

Options for bootstrap.sh:
-------------------------

Specify source directory:
  -s=/path/to/USD
  -src=/path/to/USD

Configure a debug build:
  -d --debug

Use make to build instead of Xcode:
  -m --make

Build the prerequisite libraries such as boost and so on:
  -p --prerequisites

Perform the build after configuration:
  -b --build
