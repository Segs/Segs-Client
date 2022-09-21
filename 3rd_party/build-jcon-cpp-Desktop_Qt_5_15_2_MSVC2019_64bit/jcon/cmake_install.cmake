# Install script for directory: C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/Project")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Code/Segs-Client/3rd_party/build-jcon-cpp-Desktop_Qt_5_15_2_MSVC2019_64bit/bin/Debug/jcon.lib")
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Code/Segs-Client/3rd_party/build-jcon-cpp-Desktop_Qt_5_15_2_MSVC2019_64bit/bin/Release/jcon.lib")
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Code/Segs-Client/3rd_party/build-jcon-cpp-Desktop_Qt_5_15_2_MSVC2019_64bit/bin/MinSizeRel/jcon.lib")
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Code/Segs-Client/3rd_party/build-jcon-cpp-Desktop_Qt_5_15_2_MSVC2019_64bit/bin/RelWithDebInfo/jcon.lib")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/jcon" TYPE FILE FILES
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/jcon.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/jcon_assert.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_client.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_debug_logger.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_endpoint.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_error.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_file_logger.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_logger.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_request.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_result.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_server.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_socket.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_success.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_tcp_client.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_tcp_server.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_tcp_socket.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_websocket.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_websocket_client.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/json_rpc_websocket_server.h"
    "C:/Code/Segs-Client/3rd_party/jcon-cpp/jcon/string_util.h"
    )
endif()

