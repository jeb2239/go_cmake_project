set(GOPATH "${CMAKE_CURRENT_BINARY_DIR}/")
file(MAKE_DIRECTORY ${GOPATH})

function(ExternalGoProject_Add TARG)
  add_custom_target(${TARG} env GOPATH=${GOPATH} ${CMAKE_Go_COMPILER} install ${ARGN})
endfunction(ExternalGoProject_Add)

function(add_go_executable NAME srcs)
  file(GLOB GO_SOURCE RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" ${srcs}) # GLOBing is needed
  
  add_custom_command(OUTPUT ${OUTPUT_DIR}/${NAME}/.timestamp 
    COMMAND env GOPATH=${GOPATH} ${CMAKE_Go_COMPILER} build -x -v# set project gopath - GO BUILD as 
    -o "${CMAKE_CURRENT_BINARY_DIR}/${NAME}"
    ${CMAKE_GO_FLAGS} ${GO_SOURCE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})

  add_custom_target(${NAME} ALL DEPENDS ${OUTPUT_DIR}/${NAME}/.timestamp ${ARGN})
  install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${NAME} DESTINATION bin)
endfunction(add_go_executable)


function(ADD_GO_LIBRARY NAME BUILD_TYPE)
  if(BUILD_TYPE STREQUAL "STATIC")
    set(BUILD_MODE -buildmode=c-archive)
    set(LIB_NAME "${NAME}.a")
  else()
    set(BUILD_MODE -buildmode=c-shared)
    set(LIB_NAME "${NAME}.so")
  endif()

  file(GLOB GO_SOURCE RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "*.go")
  add_custom_command(OUTPUT ${OUTPUT_DIR}/${NAME}/.timestamp
    COMMAND env GOPATH=${GOPATH} ${CMAKE_Go_COMPILER} build -x -v ${BUILD_MODE}
    -o "${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}"
    ${CMAKE_GO_FLAGS} ${GO_SOURCE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})

  add_custom_target(${NAME} ALL DEPENDS ${OUTPUT_DIR}/${NAME}/.timestamp ${ARGN})

  if(NOT BUILD_TYPE STREQUAL "STATIC")
    install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME} DESTINATION bin)
  endif()
endfunction(ADD_GO_LIBRARY)
