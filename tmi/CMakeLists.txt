add_custom_target(tmi)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(LLVM_LINK_COMPONENTS Support)

add_llvm_excutable(tmi main.cc)

install(TARGETS tmi RUNTIME DESTINATION bin)

target_link_libraries(tmi
    PRIVATE
        MLIRAnalysis
        MLIRIR
        MLIRParser
        MLIRTransforms)