class Opensubdiv < Formula
  desc "Subdivision Surface Tessellation, Evaluation and Display"
  homepage "http://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v3_1_0.zip"
  version "3.1.0"
  sha256 "761cd5804cd15ac95c7d63284d5bc517713c1753680d3ebdf766f57ae307d6c2"

  # OpenSubdiv has many kernels and will build based on what it finds on your machine.
  # The below dependencies don't capture all the kernels (OpenMP, CUDA, OpenCL) but
  # capture enough to make it functional. If you have the other things on your machine, the
  # the build will include them. I'm not sure what this means for preparing a "bottle" for
  # this.

  depends_on "cmake" => :build
  depends_on "tbb"
  #depends_on "clew"
  depends_on "glew"
  depends_on "glfw3"
  depends_on "ptex"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
