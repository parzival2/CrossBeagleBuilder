# 
# Please make sure to set the BEAGLE_SYSROOT environment variable
# before using this toolchain file. It should point to the
# BeagleBone Black sysroot directory. For example:
# 
# export BEAGLE_SYSROOT=/path/to/beaglebone/sysroot
# 
if(NOT DEFINED ENV{BEAGLE_SYSROOT})
	message(FATAL_ERROR 
		"Define the BEAGLE_SYSROOT variable to point to the Beagle Bone Black sysroot."
	)
else()
	set(SYSROOT_PATH "$ENV{BEAGLE_SYSROOT}")
	message(STATUS "Beagle Bone Black sysroot: ${SYSROOT_PATH}")
endif()

#
# Before compiling the project, please ensure that you set the CROSS_COMPILER_PATH
# and CROSS_COMPILER_FRONT variables appropriately. These variables are used to
# specify the path to the cross-compiler toolchain and the front prefix for the
# cross-compiler commands, respectively.
#
# Example:
#   If your cross-compiler is located at /path/to/cross-compiler/arm-linux-gnueabihf-gcc,
#   set CROSS_COMPILER_PATH to /path/to/cross-compiler and CROSS_COMPILER_FRONT to arm-linux-gnueabihf.
#
#   export CROSS_COMPILER_PATH=/path/to/cross-compiler
#   export CROSS_COMPILER_FRONT=arm-linux-gnueabihf
#
if (NOT DEFINED ENV{CROSS_COMPILER_PATH})
    set(CROSS_COMPILER_PATH "/usr/bin")
    message(STATUS "Cross compiler path not set as an environment variable. Using default ARM linux compiler at /usr/bin")
else()
    set(COMPILER_PATH $ENV{CROSS_COMPILER_PATH})
    message(STATUS "Using environment variable $ENV{CROSS_COMPILER_PATH} as the path to compiler.")
endif()

if(NOT DEFINED ENV{CROSS_COMPILER_FRONT})
    set(COMPILER_FRONT "arm-linux-gnueabihf")
    message(STATUS "Cross compiler front not set as an environment variable. Using default ARM linux compiler front as arm-linux-gnueabihf")
else()
    set(COMPILER_FRONT $ENV{CROSS_COMPILER_FRONT})
    message(STATUS "Using environment variable $ENV{CROSS_COMPILER_FRONT} as the front of the compiler.")
endif()

# Find out the reason for this setting
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Setting GCC and G++ compilers
#
# The following lines set the GCC and G++ compilers to be used for building the project.
# By default, we will identify compilers based on the environment variables. However, if you want to
# override them and specify custom compilers, you can modify the variables CC and CXX
# to point to the desired compiler executables.
#
set(CROSS_COMPILER_CC ${COMPILER_PATH}/${COMPILER_FRONT}-gcc)
set(CROSS_COMPILER_CXX ${COMPILER_PATH}/${COMPILER_FRONT}-g++)
set(CROSS_COMPILER_LD ${COMPILER_PATH}/${COMPILER_FRONT}-ld)
set(CROSS_COMPILER_AR ${COMPILER_PATH}/${COMPILER_FRONT}-ar)
set(CROSS_COMPILER_RANLIB ${COMPILER_PATH}/${COMPILER_FRONT}-ranlib)
set(CROSS_COMPILER_STRIP ${COMPILER_PATH}/${COMPILER_FRONT}-strip)
set(CROSS_COMPILER_NM ${COMPILER_PATH}/${COMPILER_FRONT}-nm)
set(CROSS_COMPILER_OBJCOPY ${COMPILER_PATH}/${COMPILER_FRONT}-objcopy)
set(CROSS_COMPILER_SIZE ${COMPILER_PATH}/${COMPILER_FRONT}-size)

# Using find_program to locate a program or executable
#
# The `find_program` command in CMake is used to search for the location of a specific
# program or executable in the system. It provides a convenient way to locate tools or
# utilities needed for the project build process.
#
# Example:
#   The following code snippet demonstrates the usage of `find_program` to locate the
#   "myprogram" executable and assign its path to the MYPROGRAM_EXECUTABLE variable.
#   If the program is found, the variable will hold the full path to the executable.
#   Otherwise, the variable will be set to an empty string.
#
#   find_program(MYPROGRAM_EXECUTABLE myprogram)
#
#   if (MYPROGRAM_EXECUTABLE)
#       message(STATUS "Found myprogram: ${MYPROGRAM_EXECUTABLE}")
#   else()
#       message(STATUS "myprogram not found")
#   endif()
#
find_program (CROSS_COMPILER_CC_FOUND ${CROSS_COMPILER_CC} REQUIRED)
find_program (CROSS_COMPILER_CXX_FOUND ${CROSS_COMPILER_CXX} REQUIRED)

set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_SYSTEM_NAME "Linux")
set(CMAKE_SYSTEM_PROCESSOR "ARM")

# Set the compiler
set(CMAKE_C_COMPILER ${CROSS_COMPILER_CC})
set(CMAKE_CXX_COMPILER ${CROSS_COMPILER_CXX})

#
# -march=armv7-a: Specifies the ARM architecture version.
# -mtune=cortex-a8: Optimizes the code for the Cortex-A8 processor on BeagleBone.
# -mfpu=neon: Enables NEON (Advanced SIMD) instructions for SIMD operations.
# -mfloat-abi=hard: Specifies the floating-point ABI (Application Binary Interface) as hard, 
#  which indicates that floating-point operations should be executed using hardware instructions.
set(CMAKE_C_FLAGS 
	"-march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard ${COMMON_FLAGS}" 
	CACHE STRING "Flags for Beagle Bone Black"
)

set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" 
	CACHE STRING "Flags for Beagle Bone Black"
)

# Set the sysroot path
set(CMAKE_SYSROOT ${SYSROOT_PATH})

# These lines are necessary to let cmake know to only look in the
# beaglebones sysroot for the libraries instead of looking in host pc.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)