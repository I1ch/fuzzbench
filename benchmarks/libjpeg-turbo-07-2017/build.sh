#!/bin/bash -ex
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. $(dirname $0)/../common.sh

build_lib() {
  rm -rf BUILD
  cp -rf SRC BUILD
  (cd BUILD && autoreconf -fiv && ./configure && make -j $JOBS)
}

get_git_revision https://github.com/libjpeg-turbo/libjpeg-turbo.git b0971e47d76fdb81270e93bbf11ff5558073350d SRC
build_lib

$CXX $CXXFLAGS -std=c++11 $SCRIPT_DIR/libjpeg_turbo_fuzzer.cc -I BUILD BUILD/.libs/libturbojpeg.a $FUZZER_LIB -o $FUZZ_TARGET
cp -r $SCRIPT_DIR/seeds $OUT/
