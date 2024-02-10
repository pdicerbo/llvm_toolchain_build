# This file sets up a CMakeCache for a simple distribution bootstrap build.

# My Personal Options
set(CMAKE_C_COMPILER clang CACHE STRING "")
set(CMAKE_CXX_COMPILER clang++ CACHE STRING "")


message( STATUS "EXECUTING CMAKE STAGE 0" )

#Enable LLVM projects and runtimes
set(LLVM_ENABLE_PROJECTS "clang;clang-tools-extra;lld" CACHE STRING "")
set(LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind" CACHE STRING "")

# Only build the native target in stage1 since it is a throwaway build.
set(LLVM_TARGETS_TO_BUILD Native CACHE STRING "")

# Optimize the stage1 compiler, but don't LTO it because that wastes time.
set(CMAKE_BUILD_TYPE Release CACHE STRING "")

# Setup vendor-specific settings.

# the following block is taken from google-fuchsia
set(LLVM_ENABLE_DIA_SDK OFF CACHE BOOL "")
set(LLVM_ENABLE_LIBEDIT OFF CACHE BOOL "")
set(LLVM_ENABLE_LIBXML2 OFF CACHE BOOL "")
set(LLVM_ENABLE_PER_TARGET_RUNTIME_DIR ON CACHE BOOL "")
set(LLVM_ENABLE_TERMINFO OFF CACHE BOOL "")
set(LLVM_ENABLE_UNWIND_TABLES OFF CACHE BOOL "")
set(LLVM_ENABLE_Z3_SOLVER OFF CACHE BOOL "")
set(LLVM_ENABLE_ZLIB OFF CACHE BOOL "")
set(LLVM_INCLUDE_DOCS OFF CACHE BOOL "")
set(LLVM_INCLUDE_EXAMPLES OFF CACHE BOOL "")
set(LLVM_USE_RELATIVE_PATHS_IN_FILES ON CACHE BOOL "")
set(LLDB_ENABLE_CURSES OFF CACHE BOOL "")
set(LLDB_ENABLE_LIBEDIT OFF CACHE BOOL "")


# generate a libcxx as autoconsistent as possible
set( LIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY ON CACHE BOOL "" )    # Statically link the ABI library to static library (from DEBIAN)
set( LIBCXX_CXX_ABI libcxxabi CACHE STRING "" )                         # use LLVM libc++abi
set( LIBCXXABI_ENABLE_EXCEPTIONS ON CACHE BOOL "" )                     # provide support for exceptions in the runtime
set( LIBCXXABI_ENABLE_STATIC ON CACHE BOOL "")                          # statically link the LLVM libraries
set( LIBUNWIND_ENABLE_STATIC ON CACHE BOOL "" )                         # enhance unwind_static target for CMake management of libraries

# the following block is taken from google-fuchsia
set( LIBUNWIND_ENABLE_SHARED OFF CACHE BOOL "")
# set( LIBUNWIND_INSTALL_LIBRARY OFF CACHE BOOL "")    # this variable was set in google fuchsia, here I comment it otherwise in the next stage the linker will not find it..
set( LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "")
set( LIBCXXABI_ENABLE_SHARED OFF CACHE BOOL "")
set( LIBCXXABI_ENABLE_STATIC_UNWINDER ON CACHE BOOL "")
set( LIBCXXABI_INSTALL_LIBRARY OFF CACHE BOOL "")
set( LIBCXXABI_USE_COMPILER_RT ON CACHE BOOL "")
set( LIBCXXABI_USE_LLVM_UNWINDER ON CACHE BOOL "")
# set( LIBCXX_ABI_VERSION 2 CACHE STRING "")
set( LIBCXX_ENABLE_SHARED OFF CACHE BOOL "")
set( LIBCXX_ENABLE_STATIC_ABI_LIBRARY ON CACHE BOOL "")
set( LIBCXX_USE_COMPILER_RT ON CACHE BOOL "")

set( LIBUNWIND_INSTALL_LIBRARY ON CACHE BOOL "")                        # install the libunwind library
set( SANITIZER_CXX_ABI "libc++" CACHE STRING "")
set( SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "")


# REPEAT the same variables set above, but with RUNTIMES_{target}_*
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXX_CXX_ABI libcxxabi CACHE STRING "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXXABI_ENABLE_EXCEPTIONS ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXXABI_ENABLE_STATIC ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBUNWIND_ENABLE_STATIC ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBUNWIND_ENABLE_SHARED OFF CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXXABI_ENABLE_SHARED OFF CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXXABI_ENABLE_STATIC_UNWINDER ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXXABI_INSTALL_LIBRARY OFF CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXXABI_USE_COMPILER_RT ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXXABI_USE_LLVM_UNWINDER ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXX_ENABLE_SHARED OFF CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXX_ENABLE_STATIC_ABI_LIBRARY ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBCXX_USE_COMPILER_RT ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_LIBUNWIND_INSTALL_LIBRARY ON CACHE BOOL "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_SANITIZER_CXX_ABI "libc++" CACHE STRING "" )
set( RUNTIMES_x86_64-unknown-linux-gnu_SANITIZER_CXX_ABI_INTREE ON CACHE BOOL "" )

if(UNIX)
  set(BOOTSTRAP_CMAKE_SHARED_LINKER_FLAGS "-ldl -lpthread" CACHE STRING "")
  set(BOOTSTRAP_CMAKE_MODULE_LINKER_FLAGS "-ldl -lpthread" CACHE STRING "")
  set(BOOTSTRAP_CMAKE_EXE_LINKER_FLAGS "-ldl -lpthread" CACHE STRING "")
endif()

# Setting up the stage2 LTO option needs to be done on the stage1 build so that
# the proper LTO library dependencies can be connected.
  # Since LLVM_ENABLE_LTO is ON we need a LTO capable linker
set(BOOTSTRAP_LLVM_ENABLE_LLD ON CACHE BOOL "")
set(BOOTSTRAP_LLVM_ENABLE_LTO ON CACHE BOOL "")


# Expose stage2 targets through the stage1 build configuration.
set(CLANG_BOOTSTRAP_TARGETS
  # check-all
  # check-llvm
  # check-clang
  llvm-config
  # test-suite
  # test-depends
  # llvm-test-depends
  # clang-test-depends
  distribution
  install-distribution
  clang CACHE STRING "")

# Setup the bootstrap build.
set(CLANG_ENABLE_BOOTSTRAP ON CACHE BOOL "")
set(CLANG_BOOTSTRAP_EXTRA_DEPS
  builtins
  runtimes
  CACHE STRING "")

set(CLANG_BOOTSTRAP_CMAKE_ARGS
  -C ${CMAKE_CURRENT_LIST_DIR}/base_stage1.cmake
  CACHE STRING "")
