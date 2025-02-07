# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "C:/Users/User/Documents/Projects/delightsome_software/windows/out/build/x64-Debug/pdfium-src"
  "C:/Users/User/Documents/Projects/delightsome_software/windows/out/build/x64-Debug/pdfium-build"
  "C:/Users/User/Documents/Projects/delightsome_software/windows/out/build/x64-Debug/pdfium-download/pdfium-download-prefix"
  "C:/Users/User/Documents/Projects/delightsome_software/windows/out/build/x64-Debug/pdfium-download/pdfium-download-prefix/tmp"
  "C:/Users/User/Documents/Projects/delightsome_software/windows/out/build/x64-Debug/pdfium-download/pdfium-download-prefix/src/pdfium-download-stamp"
  "C:/Users/User/Documents/Projects/delightsome_software/windows/out/build/x64-Debug/pdfium-download/pdfium-download-prefix/src"
  "C:/Users/User/Documents/Projects/delightsome_software/windows/out/build/x64-Debug/pdfium-download/pdfium-download-prefix/src/pdfium-download-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/Users/User/Documents/Projects/delightsome_software/windows/out/build/x64-Debug/pdfium-download/pdfium-download-prefix/src/pdfium-download-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/Users/User/Documents/Projects/delightsome_software/windows/out/build/x64-Debug/pdfium-download/pdfium-download-prefix/src/pdfium-download-stamp${cfgdir}") # cfgdir has leading slash
endif()
