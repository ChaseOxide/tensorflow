# Copyright 2017 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
include (ExternalProject)

set(PROTOBUF_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/protobuf/src/protobuf/src)
set(PROTOBUF_URL https://github.com/google/protobuf.git)
set(PROTOBUF_TAG b04e5cba356212e4e8c66c61bbe0c3a20537c5b9)

if(WIN32)
  set(protobuf_STATIC_LIBRARIES 
    debug ${CMAKE_CURRENT_BINARY_DIR}/protobuf/src/protobuf/libprotobufd.lib
    optimized ${CMAKE_CURRENT_BINARY_DIR}/protobuf/src/protobuf/libprotobuf.lib)
  set(PROTOBUF_PROTOC_EXECUTABLE ${CMAKE_CURRENT_BINARY_DIR}/protobuf/src/protobuf/protoc.exe)
  set(PROTOBUF_GENERATOR_PLATFORM)
  if (CMAKE_GENERATOR_PLATFORM)
    set(PROTOBUF_GENERATOR_PLATFORM -A ${CMAKE_GENERATOR_PLATFORM})
  endif()
  set(PROTOBUF_ADDITIONAL_CMAKE_OPTIONS	-Dprotobuf_MSVC_STATIC_RUNTIME:BOOL=OFF
    -G${CMAKE_GENERATOR} ${PROTOBUF_GENERATOR_PLATFORM})
else()
  set(protobuf_STATIC_LIBRARIES ${CMAKE_CURRENT_BINARY_DIR}/protobuf/src/protobuf/libprotobuf.a)
  set(PROTOBUF_PROTOC_EXECUTABLE ${CMAKE_CURRENT_BINARY_DIR}/protobuf/src/protobuf/protoc)
endif()

ExternalProject_Add(protobuf
    PREFIX protobuf
    DEPENDS zlib
    GIT_REPOSITORY ${PROTOBUF_URL}
    GIT_TAG ${PROTOBUF_TAG}
    DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
    BUILD_IN_SOURCE 1
    SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/protobuf/src/protobuf
    CONFIGURE_COMMAND ${CMAKE_COMMAND} cmake/
        -Dprotobuf_WITH_ZLIB=ON
        -Dprotobuf_BUILD_TESTS=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}
        -DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
        -DZLIB_ROOT=${ZLIB_INSTALL}
        ${PROTOBUF_ADDITIONAL_CMAKE_OPTIONS}
    INSTALL_COMMAND ""
    CMAKE_CACHE_ARGS
		if(tensorflow_ENABLE_POSITION_INDEPENDENT_CODE)
			-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
		else()
			-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=OFF
		endif()
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_C_FLAGS_RELEASE:STRING=${CMAKE_C_FLAGS_RELEASE}
        -DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}
        -DCMAKE_MAKE_PROGRAM:FILEPATH=${CMAKE_MAKE_PROGRAM}
        -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
        -DZLIB_ROOT:STRING=${ZLIB_INSTALL}
)
