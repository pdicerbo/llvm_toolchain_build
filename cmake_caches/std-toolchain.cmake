# This file sets up a CMakeCache for a simple distribution bootstrap build.
message( STATUS "EXECUTING CMAKE STD TOOLCHAIN STAGE" )


set( LLVM_ENABLE_PROJECTS "clang;clang-tools-extra;lld;llvm" CACHE STRING "" )
set( LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind" CACHE STRING "" )

set( CPACK_GENERATOR "RPM" CACHE STRING "" )
set( CPACK_BINARY_RPM ON CACHE BOOL "" )

set( LLVM_DEFAULT_TARGET_TRIPLE x86_64-unknown-linux-gnu CACHE STRING "" )

set( CMAKE_C_FLAGS_RELWITHDEBINFO "-O3 -gline-tables-only -DNDEBUG" CACHE STRING "" )
set( CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -gline-tables-only -DNDEBUG" CACHE STRING "" )
set( CMAKE_BUILD_TYPE Release CACHE STRING "" )

set(CMAKE_C_COMPILER clang CACHE STRING "")
set(CMAKE_CXX_COMPILER clang++ CACHE STRING "")

set( LLVM_ENABLE_WARNINGS OFF CACHE BOOL "" )                           # disable warnings
set( LLVM_ENABLE_EH ON CACHE BOOL "" )                                  # build LLVM with exception handling
set( LLVM_ENABLE_RTTI ON CACHE BOOL "" )                                # enable RTTI
set( LLVM_ENABLE_ZLIB ON CACHE STRING "" )                              # build with zlib support (this enable -gz compilation flag; CMAKE type is string since its possible values are ON, OFF AND FORCE_ON)
set( LLVM_ENABLE_LIBCXX ON CACHE BOOL "" )                              # use libc++ instead of libstdc++
set( LLVM_ENABLE_UNWIND_TABLES OFF CACHE BOOL "" )                      # disable unwind tables for the libraries
set( LLVM_BUILD_UTILS OFF CACHE BOOL "" )                               # otherwise, during the second stage something will fail because cxxabi.h not found
set( LLVM_STATIC_LINK_CXX_STDLIB ON CACHE BOOL "" )                     # static link libc++
set( LLVM_ENABLE_LLD ON CACHE BOOL "" )                                 # enable lld as default linker
set( LLVM_TARGETS_TO_BUILD X86 CACHE STRING "" )                        # build target X86
set( LLVM_INCLUDE_DOCS OFF CACHE BOOL "" )                              # disable docs
set( LLVM_INCLUDE_EXAMPLES OFF CACHE BOOL "" )                          # disable examples
set( LLVM_INCLUDE_GO_TESTS OFF CACHE BOOL "" )                          # disable go tests
set( LLVM_USE_RELATIVE_PATHS_IN_FILES ON CACHE BOOL "" )                # use relative paths
set( LLVM_USE_RELATIVE_PATHS_IN_DEBUG_INFO ON CACHE BOOL "" )           # use relative paths in debug info (from DEBIAN)
set( LLVM_ENABLE_LTO ON CACHE BOOL "" )                                 # enable Link Time Optimization: the compiler build will use approximately 10GB of RAM per Core, but the binaries will be more efficients

# from google fuchsia
set( LLVM_ENABLE_BACKTRACES OFF CACHE BOOL "" )
set( LLVM_ENABLE_DIA_SDK OFF CACHE BOOL "" )
set( LLVM_ENABLE_LIBEDIT OFF CACHE BOOL "" )
set( LLVM_ENABLE_PER_TARGET_RUNTIME_DIR ON CACHE BOOL "" )
set( LLVM_ENABLE_PLUGINS OFF CACHE BOOL "" )
set( LLVM_ENABLE_TERMINFO OFF CACHE BOOL "" )


set( CLANG_DEFAULT_UNWINDLIB libunwind CACHE STRING "" )                # use LLVM libunwind
set( CLANG_DEFAULT_CXX_STDLIB libc++ CACHE STRING "" )                  # use libc++ as standard library
set( CLANG_DEFAULT_RTLIB compiler-rt CACHE STRING "" )                  # use compiler-rt as runtime library
set( CLANG_DEFAULT_LINKER lld CACHE STRING "" )                         # use lld as default linker
set( CLANG_USE_LINKER lld CACHE STRING "" )                             # use lld as default linker
set( CLANG_DEFAULT_OBJCOPY llvm-objcopy CACHE STRING "" )               # use LLVM-objcopy (from GOOGLE-FUCHSIA)
set( CLANG_ENABLE_STATIC_ANALYZER ON CACHE BOOL "" )                    # enable static analyzer (from GOOGLE-FUCHSIA)
set( CLANG_PLUGIN_SUPPORT OFF CACHE BOOL "" )                           # do not build plugin support
set( CLANG_BUILD_EXAMPLES OFF CACHE BOOL "" )                           # do not build examples

set( CLANG_ENABLE_ARCMT OFF CACHE BOOL "" )

set( ENABLE_LINKER_BUILD_ID ON CACHE BOOL "" )
set( ENABLE_X86_RELAX_RELOCATIONS ON CACHE BOOL "" )

# set some variables for the BUILTIN and RUNTIME stages build:
# since cmake will run again, we need to pass variable this way to properly set them
foreach(target x86_64-unknown-linux-gnu)
  
  set(LLVM_BUILTIN_TARGETS "${target}" CACHE STRING "")
  set(LLVM_RUNTIME_TARGETS "${target}" CACHE STRING "")

  # Set the per-target builtins options.
  set(BUILTINS_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "" )
  set(BUILTINS_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "" )
  set(BUILTINS_${target}_CMAKE_C_FLAGS "--target=${target}" CACHE STRING "" )
  set(BUILTINS_${target}_CMAKE_CXX_FLAGS "--target=${target}" CACHE STRING "" )
  set(BUILTINS_${target}_CMAKE_ASM_FLAGS "--target=${target}" CACHE STRING "" )
  set(BUILTINS_${target}_CMAKE_SYSROOT ${LINUX_${target}_SYSROOT} CACHE STRING "" )
  set(BUILTINS_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "" )
  set(BUILTINS_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "" )
  set(BUILTINS_${target}_CMAKE_EXE_LINKER_FLAG "-fuse-ld=lld" CACHE STRING "" )

  # Set the per-target runtimes options.
  set(RUNTIMES_${target}_CMAKE_SYSTEM_NAME Linux CACHE STRING "" )
  set(RUNTIMES_${target}_CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "" )
  set(RUNTIMES_${target}_CMAKE_C_FLAGS "--target=${target}" CACHE STRING "" )
  set(RUNTIMES_${target}_CMAKE_CXX_FLAGS "--target=${target}" CACHE STRING "" )
  set(RUNTIMES_${target}_CMAKE_ASM_FLAGS "--target=${target}" CACHE STRING "" )
  set(RUNTIMES_${target}_CMAKE_SYSROOT ${LINUX_${target}_SYSROOT} CACHE STRING "" )
  set(RUNTIMES_${target}_CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "" )
  set(RUNTIMES_${target}_CMAKE_MODULE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "" )
  set(RUNTIMES_${target}_CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "" )
  set(RUNTIMES_${target}_COMPILER_RT_CXX_LIBRARY "libcxx" CACHE STRING "" )
  set(RUNTIMES_${target}_COMPILER_RT_USE_BUILTINS_LIBRARY ON CACHE BOOL "" )
  set(RUNTIMES_${target}_COMPILER_RT_USE_LLVM_UNWINDER ON CACHE BOOL "" )
  set(RUNTIMES_${target}_COMPILER_RT_CAN_EXECUTE_TESTS ON CACHE BOOL "" )
  set(RUNTIMES_${target}_LIBUNWIND_ENABLE_SHARED OFF CACHE BOOL "" )
  set(RUNTIMES_${target}_LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "" )
  set(RUNTIMES_${target}_LIBCXXABI_USE_COMPILER_RT ON CACHE BOOL "" )
  set(RUNTIMES_${target}_LIBCXXABI_ENABLE_SHARED OFF CACHE BOOL "" )
  set(RUNTIMES_${target}_LIBCXXABI_USE_LLVM_UNWINDER ON CACHE BOOL "" )
  set(RUNTIMES_${target}_LIBCXXABI_INSTALL_LIBRARY OFF CACHE BOOL "" )
  set(RUNTIMES_${target}_LIBCXX_USE_COMPILER_RT ON CACHE BOOL "" )
  set(RUNTIMES_${target}_LIBCXX_ENABLE_SHARED OFF CACHE BOOL "" )
  set(RUNTIMES_${target}_LIBCXX_ENABLE_STATIC_ABI_LIBRARY ON CACHE BOOL "" )
  set(RUNTIMES_${target}_COMPILER_RT_BUILD_LIBFUZZER OFF CACHE BOOL "")
  set(RUNTIMES_${target}_COMPILER_RT_BUILD_ORC OFF CACHE BOOL "")
  set(RUNTIMES_${target}_LLVM_ENABLE_ASSERTIONS OFF CACHE BOOL "" )
  set(RUNTIMES_${target}_SANITIZER_CXX_ABI "libc++" CACHE STRING "" )
  set(RUNTIMES_${target}_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "" )
  set(RUNTIMES_${target}_SANITIZER_TEST_CXX "libc++" CACHE STRING "" )
  set(RUNTIMES_${target}_SANITIZER_TEST_CXX_INTREE ON CACHE BOOL "" )
  set(RUNTIMES_${target}_LLVM_TOOLS_DIR "${CMAKE_BINARY_DIR}/bin" CACHE BOOL "" )
  set(RUNTIMES_${target}_LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind" CACHE STRING "" )
endforeach()

set( LIBCLANG_BUILD_STATIC ON CACHE BOOL "" )                           # build libclang only static

set( COMPILER_RT_USE_BUILTINS_LIBRARY ON CACHE BOOL "" )                # use compiler-rt builtins instead of libgcc
set( COMPILER_RT_USE_LIBCXX ON CACHE BOOL "" )                          # use LLVM libc++
set( COMPILER_RT_USE_LLVM_UNWINDER ON CACHE BOOL "" )                   # use LLVM libunwind
set( COMPILER_RT_ENABLE_STATIC_UNWINDER ON CACHE BOOL "" )              # enable static LLVM libunwind
set( COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "" )                         # XRay is a function call tracing system (more info: https://llvm.org/docs/XRay.html) currently unused by us (from DEBIAN)
set( COMPILER_RT_INCLUDE_TESTS OFF CACHE BOOL "" )                      # generate and build compiler-rt unit tests (from DEBIAN)

set( SANITIZER_USE_STATIC_LLVM_UNWINDER ON CACHE BOOL "" )
set( SANITIZER_USE_STATIC_CXX_ABI ON CACHE BOOL "" )
set( SANITIZER_USE_STATIC_TEST_CXX ON CACHE BOOL "" )
set( COMPILER_RT_CXX_LIBRARY "libcxx" CACHE STRING "" )
set( COMPILER_RT_STATIC_CXX_LIBRARY ON CACHE BOOL "" )

set( LIBCXX_ENABLE_SHARED OFF CACHE BOOL "" )                           # disable generation of libc++.so
set( LIBCXX_ENABLE_STATIC ON CACHE BOOL "" )                            # enable generation of libc++.a
set( LIBCXX_ENABLE_EXCEPTIONS ON CACHE BOOL "" )                        # enable exceptions
set( LIBCXX_ENABLE_STATIC_ABI_LIBRARY ON CACHE BOOL "" )                # use a static copy of the ABI library when linking libc++
set( LIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY ON CACHE BOOL "" )    # Statically link the ABI library to static library (from DEBIAN)
set( LIBCXX_CXX_ABI libcxxabi CACHE STRING "" )                         # use LLVM libc++abi
set( LIBCXX_USE_COMPILER_RT ON CACHE BOOL "" )                          # use LLVM compiler-rt instead of libgcc

set( LIBCXXABI_ENABLE_EXCEPTIONS ON CACHE BOOL "" )                     # provide support for exceptions in the runtime
set( LIBCXXABI_USE_LLVM_UNWINDER ON CACHE BOOL "" )                     # use the LLVM unwinder
set( LIBCXXABI_USE_COMPILER_RT ON CACHE BOOL "" )                       # use LLVM compiler-rt
set( LIBCXXABI_ENABLE_SHARED OFF CACHE BOOL "" )                        # disable generation of libc++abi.so
set( LIBCXXABI_ENABLE_STATIC_UNWINDER ON CACHE BOOL "" )                # statically link the LLVM unwinder
set( LIBCXXABI_ENABLE_STATIC ON CACHE BOOL "" )                         # statically link the LLVM libraries

set( LIBUNWIND_ENABLE_STATIC ON CACHE BOOL "" )                         # enhance unwind_static target for CMake management of libraries
set( LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "" )                       # use LLVM compiler-rt
set( LIBUNWIND_ENABLE_SHARED OFF CACHE BOOL "" )                        # disable generation of libunwind.so
set( LIBUNWIND_INSTALL_LIBRARY ON CACHE BOOL "" )                       # install the libunwind library

set( ENABLE_X86_RELAX_RELOCATIONS ON CACHE BOOL "" )                    # enable x86 relax relocations by default (from GOOGLE-FUCHSIA)

# setup toolchain
set( LLVM_INSTALL_TOOLCHAIN_ONLY ON CACHE BOOL "" )
set( LLVM_TOOLCHAIN_TOOLS
  dsymutil                      # manipulate archived DWARF debug symbol files
  llvm-addr2line                # a drop-in replacement for addr2line
  llvm-ar                       # LLVM archiver
  llvm-as                       # LLVM assembler
  llvm-config                   # Print LLVM compilation options
  llvm-cov                      # emit coverage information
  llvm-cxxfilt                  # LLVM symbol name demangler
  llvm-dis                      # LLVM disassembler
  llvm-dwarfdump                # dump and verify DWARF debug information
  llvm-lto                      # LLVM LTO linker
  llvm-objdump                  # LLVM’s object file dumper
  llvm-objcopy                  # LLVM’s object file copy tool
  llvm-nm                       # list LLVM bitcode and object file’s symbol table
  llvm-profdata                 # Profile data tool
  # llvm-readelf                  # GNU-style LLVM Object Reader
  llvm-size                     # print size information
  llvm-strip                    # object stripping tool
  llvm-symbolizer               # convert addresses into source code locations
  CACHE STRING "" )


set(LLVM_DISTRIBUTION_COMPONENTS
  clang
  lld
  LTO
  # clang-apply-replacements
  # clang-doc
  clang-format
  clang-resource-headers
  # clang-include-fixer
  clang-refactor
  clang-scan-deps
  # clang-tidy
  # clangd
  # find-all-symbols
  builtins
  runtimes
  ${LLVM_TOOLCHAIN_TOOLS}
  CACHE STRING "" )
