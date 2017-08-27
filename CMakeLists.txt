set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
cmake_minimum_required(VERSION 3.0)
project(nova Go)
INCLUDE(CPack)
include(cmake/golang.cmake)
ExternalGoProject_Add(go_logrus github.com/sirupsen/logrus) 
add_subdirectory(src)



