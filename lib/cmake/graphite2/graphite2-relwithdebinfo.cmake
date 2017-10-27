#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "gr2_graphite2" for configuration "RelWithDebInfo"
set_property(TARGET gr2_graphite2 APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(gr2_graphite2 PROPERTIES
  IMPORTED_IMPLIB_RELWITHDEBINFO "${_IMPORT_PREFIX}/lib/libgraphite2.dll.a"
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/bin/cyggraphite2-3.dll"
  )

list(APPEND _IMPORT_CHECK_TARGETS gr2_graphite2 )
list(APPEND _IMPORT_CHECK_FILES_FOR_gr2_graphite2 "${_IMPORT_PREFIX}/lib/libgraphite2.dll.a" "${_IMPORT_PREFIX}/bin/cyggraphite2-3.dll" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
