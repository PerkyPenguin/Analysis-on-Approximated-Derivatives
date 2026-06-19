# CMake generated Testfile for 
# Source directory: /home/davidrussell/TrajOptKP
# Build directory: /home/davidrussell/TrajOptKP/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(Derivs "/home/davidrussell/TrajOptKP/build/test_derivs")
set_tests_properties(Derivs PROPERTIES  _BACKTRACE_TRIPLES "/home/davidrussell/TrajOptKP/CMakeLists.txt;232;add_test;/home/davidrussell/TrajOptKP/CMakeLists.txt;0;")
add_test(ModelTranslatorState "/home/davidrussell/TrajOptKP/build/test_model_translator")
set_tests_properties(ModelTranslatorState PROPERTIES  _BACKTRACE_TRIPLES "/home/davidrussell/TrajOptKP/CMakeLists.txt;256;add_test;/home/davidrussell/TrajOptKP/CMakeLists.txt;0;")
add_test(ModelTranslatorKin "/home/davidrussell/TrajOptKP/build/test_kinematic_chain")
set_tests_properties(ModelTranslatorKin PROPERTIES  _BACKTRACE_TRIPLES "/home/davidrussell/TrajOptKP/CMakeLists.txt;268;add_test;/home/davidrussell/TrajOptKP/CMakeLists.txt;0;")
