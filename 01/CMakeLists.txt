cmake_minimum_required(VERSION 3.24)
project(AdventOfCode01 LANGUAGES C)

add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME}
    PRIVATE
    main.c
)