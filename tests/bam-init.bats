#!/usr/bin/env bats

set -o pipefail

setup() {
  export MANWIDTH=80
  export BAM_OUTPUT_DIR=".tmp"
}

before_each() {
  rm -rf .tmp*
}

after_each() {
  rm -rf .tmp*
}

function get_install_prefix() {
  if [ $BAM_TEST_ENV == 1 ]; then
    echo "@prefix@"
  else
    echo "$(dirname $(dirname $(which bam)))"
  fi
}

function print_result() {
  for line in "${lines[@]}"; do
    echo "$line"
  done
}

@test "'bam init --help' displays help" {
  function expected() {
    cat << EOF
BAM-INIT(1)                       Bam Manual                       BAM-INIT(1)



NAME
       bam-init - Create an empty project or reinitialize an existing one

SYNOPSIS
       bam init [-h|--help] [--template <template_directory>]
                [-p <platforms>|--platforms <platforms>]
                [--config <path>] [-n <name>|--name <name>] [<directory>]

DESCRIPTION
       This command creates an empty bam project or reinitializes an existing
       one. If <directory> is specified, the command is run inside it, other-
       wise the current working directory is used. If the directory does not
       exist, it will be created.

OPTIONS
  -h, --help
        Display this help and exit.

  --config <path>
        Set the path to the build configuration directory. It must be a
        path relative to <directory>. This defaults to "build".

  -n <name>, --name <name>
        Sets the name for the project in the top level BUILD.gn file.
        The default project name is the name of the directory where this
        command is run.

  -p <platforms>, --platforms <platforms>
        Specifies the list of platforms to support for the project.
        <platforms> will be interpreted as a comma separated list of
        platforms (use -p list to list available platforms).

  --template <template_directory>
        Specifies the directory from which templates will be used. (See
        the "TEMPLATE DIRECTORY" section below.)

  <directory>
        The name of the directory in which to create the project. If
        specified, the command is run inside this directory, otherwise
        the current working directory is used.

TEMPLATE DIRECTORY
       The template directory contains files and directories that are used to
       generate an empty bam project.

       The template directory used will be (in order):

       o The argument given with the --template option

       o The contents of the \$BAM_TEMPLATE_DIR environment variable.

       o The init.templateDir configuration variable

       o The core-path template directory:
           \$BAM_CORE_PATH/templates

       o The default template directory:
           $(get_install_prefix)/share/bam-core/templates

       The default template directory includes some directory structure, sug-
       gested build configuration, and copies of common pre-configured
       toolchains.



Bam $BAM_VERSION                                                   BAM-INIT(1)
EOF
  }
  function filter_man() {
    INSTALL_PREFIX="$(get_install_prefix)"
    if [ "${#INSTALL_PREFIX}" -gt 35 ]; then
      sed -e '/o The default template directory:/,/^$/d'
    else
      cat
    fi
  }
  LC_ALL=C bam init --help | col -bx | filter_man | diff -Bbu <(expected | filter_man) -
}

@test "'bam init -h' is the same as 'bam init --help'" {
  bam init -h | diff -u <(bam init --help) -
}

@test "'bam help init' is the same as 'bam init --help'" {
  bam help init | diff -u <(bam init --help) -
}

@test "'bam init' defaults" {
  function expected_files() {
    echo ".tmp/.bam/config"
    echo ".tmp/.gn"
    echo ".tmp/BUILD.gn"
    echo ".tmp/build/config/BUILD.gn"
    echo ".tmp/build/config/BUILDCONFIG.gn"
    echo ".tmp/build/config/armv7a-apple-ios/BUILD.gn"
    echo ".tmp/build/config/armv7a-apple-ios/lint/BUILD.gn"
    echo ".tmp/build/config/armv7a-ghs-eabihf/BUILD.gn"
    echo ".tmp/build/config/armv7a-ghs-eabihf/lint/BUILD.gn"
    echo ".tmp/build/config/armv7a-gnu-eabihf/BUILD.gn"
    echo ".tmp/build/config/armv7a-gnu-eabihf/lint/BUILD.gn"
    echo ".tmp/build/config/armv7a-linux-gnueabihf/BUILD.gn"
    echo ".tmp/build/config/armv7a-linux-gnueabihf/lint/BUILD.gn"
    echo ".tmp/build/config/armv8a-apple-ios/BUILD.gn"
    echo ".tmp/build/config/armv8a-apple-ios/lint/BUILD.gn"
    echo ".tmp/build/config/armv8a-gnu-eabihf/BUILD.gn"
    echo ".tmp/build/config/armv8a-gnu-eabihf/lint/BUILD.gn"
    echo ".tmp/build/config/armv8a-linux-gnueabihf/BUILD.gn"
    echo ".tmp/build/config/armv8a-linux-gnueabihf/lint/BUILD.gn"
    echo ".tmp/build/config/c28x-ti-coff/BUILD.gn"
    echo ".tmp/build/config/c28x-ti-coff/lint/BUILD.gn"
    echo ".tmp/build/config/external/BUILD.gn"
    echo ".tmp/build/config/i686-apple-ios/BUILD.gn"
    echo ".tmp/build/config/i686-apple-ios/lint/BUILD.gn"
    echo ".tmp/build/config/i686-linux-gnu/BUILD.gn"
    echo ".tmp/build/config/i686-linux-gnu/lint/BUILD.gn"
    echo ".tmp/build/config/i686-w64-mingw32/BUILD.gn"
    echo ".tmp/build/config/i686-w64-mingw32/lint/BUILD.gn"
    echo ".tmp/build/config/lint/BUILD.gn"
    echo ".tmp/build/config/lint_dep.gni"
    echo ".tmp/build/config/msp430-ti-eabi/BUILD.gn"
    echo ".tmp/build/config/msp430-ti-eabi/lint/BUILD.gn"
    echo ".tmp/build/config/style/BUILD.gn"
    echo ".tmp/build/config/ut/BUILD.gn"
    echo ".tmp/build/config/ut/lint/BUILD.gn"
    echo ".tmp/build/config/x86_64-apple-ios/BUILD.gn"
    echo ".tmp/build/config/x86_64-apple-ios/lint/BUILD.gn"
    echo ".tmp/build/config/x86_64-apple-mac/BUILD.gn"
    echo ".tmp/build/config/x86_64-apple-mac/lint/BUILD.gn"
    echo ".tmp/build/config/x86_64-darwin-gnu/BUILD.gn"
    echo ".tmp/build/config/x86_64-darwin-gnu/lint/BUILD.gn"
    echo ".tmp/build/config/x86_64-linux-gnu/BUILD.gn"
    echo ".tmp/build/config/x86_64-linux-gnu/lint/BUILD.gn"
    echo ".tmp/build/config/x86_64-w64-mingw32/BUILD.gn"
    echo ".tmp/build/config/x86_64-w64-mingw32/lint/BUILD.gn"
    echo ".tmp/build/lnt/co-gcc.h"
    echo ".tmp/build/lnt/co-gcc.lnt"
    echo ".tmp/build/lnt/co-gcc.mak"
    echo ".tmp/build/lnt/co-ghs.h"
    echo ".tmp/build/lnt/co-ghs.lnt"
    echo ".tmp/build/lnt/co-ghs.mak"
    echo ".tmp/build/lnt/co-ti.h"
    echo ".tmp/build/lnt/co-ti.lnt"
    echo ".tmp/build/lnt/co-ti.mak"
    echo ".tmp/build/lnt/env-common.lnt"
    echo ".tmp/build/lnt/gcc-readme.txt"
    echo ".tmp/build/toolchain/BUILD.gn"
  }

  mkdir .tmp
  bam -C .tmp init
  diff -u <(expected_files) <(find .tmp -type f | sort)
  grep "\.tmp" .tmp/BUILD.gn
}

@test "'bam init --template=<dir>' uses <dir> for templates" {
  function expected_files() {
    echo ".tmp/.bam/config"
    echo ".tmp/.gn"
    echo ".tmp/BUILD.gn"
    echo ".tmp/build/config/BUILD.gn"
    echo ".tmp/build/config/BUILDCONFIG.gn"
    echo ".tmp/build/config/another/BUILD.gn"
    echo ".tmp/build/config/bar/BUILD.gn"
    echo ".tmp/build/config/foo/BUILD.gn"
    echo ".tmp/build/config/other/BUILD.gn"
    echo ".tmp/build/toolchain/BUILD.gn"
  }
  function expected_platforms() {
    echo "Available platforms:"
    echo "    bar"
    echo "    foo"
  }
  function expected_missing() {
    echo "bam-init: error: the following platforms are not supported:"
    echo "    fubar"
    echo "    i686-linux-gnu"
  }

  mkdir -p .tmp .tmp-template_dir/config .tmp-template_dir/toolchains/platforms
  mkdir .tmp-template_dir/config/foo
  mkdir .tmp-template_dir/config/bar
  mkdir .tmp-template_dir/config/other
  mkdir .tmp-template_dir/config/another
  touch .tmp-template_dir/.gn
  touch .tmp-template_dir/BUILD.gn
  touch .tmp-template_dir/config/BUILD.gn
  touch .tmp-template_dir/config/BUILDCONFIG.gn
  touch .tmp-template_dir/config/foo/BUILD.gn
  touch .tmp-template_dir/config/bar/BUILD.gn
  touch .tmp-template_dir/config/other/BUILD.gn
  touch .tmp-template_dir/config/another/BUILD.gn
  touch .tmp-template_dir/toolchains/platforms/foo.gn
  touch .tmp-template_dir/toolchains/platforms/bar.gn
  bam -C .tmp init --template ../.tmp-template_dir

  diff -u <(expected_files) <(find .tmp -type f | sort)
  diff -u <(expected_platforms) <(bam -C .tmp init --template ../.tmp-template_dir -p list)
  diff -u <(expected_missing) <(bam -C .tmp init --template ../.tmp-template_dir -p foo,bar,fubar,i686-linux-gnu)
}

@test "'bam init' with BAM_TEMPLATE_DIR=<dir> uses <dir> for templates" {
  function expected_files() {
    echo ".tmp/.bam/config"
    echo ".tmp/.gn"
    echo ".tmp/BUILD.gn"
    echo ".tmp/build/config/BUILD.gn"
    echo ".tmp/build/config/BUILDCONFIG.gn"
    echo ".tmp/build/config/barbar/BUILD.gn"
    echo ".tmp/build/config/bbar/BUILD.gn"
    echo ".tmp/build/config/other/BUILD.gn"
    echo ".tmp/build/toolchain/BUILD.gn"
  }
  function expected_platforms() {
    echo "Available platforms:"
    echo "    barbar"
    echo "    bbar"
  }
  function expected_missing() {
    echo "bam-init: error: the following platforms are not supported:"
    echo "    fu"
    echo "    i686-linux-gnu"
  }

  mkdir -p .tmp .tmp-template-dir/config .tmp-template-dir/toolchains/platforms
  mkdir .tmp-template-dir/config/barbar
  mkdir .tmp-template-dir/config/bbar
  mkdir .tmp-template-dir/config/other
  touch .tmp-template-dir/.gn
  touch .tmp-template-dir/BUILD.gn
  touch .tmp-template-dir/config/BUILD.gn
  touch .tmp-template-dir/config/BUILDCONFIG.gn
  touch .tmp-template-dir/config/barbar/BUILD.gn
  touch .tmp-template-dir/config/bbar/BUILD.gn
  touch .tmp-template-dir/config/other/BUILD.gn
  touch .tmp-template-dir/toolchains/platforms/barbar.gn
  touch .tmp-template-dir/toolchains/platforms/bbar.gn
  BAM_TEMPLATE_DIR=../.tmp-template-dir bam -C .tmp init

  diff -u <(expected_files) <(find .tmp -type f | sort)
  diff -u <(expected_platforms) <(BAM_TEMPLATE_DIR=../.tmp-template-dir bam -C .tmp init -p list)
  diff -u <(expected_missing) <(BAM_TEMPLATE_DIR=../.tmp-template-dir bam -C .tmp init -p barbar,fu,i686-linux-gnu)
}

@test "'bam init' with init.templateDir=<dir> uses <dir> for templates" {
  function expected_files() {
    echo ".tmp/.bam/config"
    echo ".tmp/.gn"
    echo ".tmp/BUILD.gn"
    echo ".tmp/build/config/BUILD.gn"
    echo ".tmp/build/config/BUILDCONFIG.gn"
    echo ".tmp/build/config/foobar/BUILD.gn"
    echo ".tmp/build/config/fubar/BUILD.gn"
    echo ".tmp/build/config/other/BUILD.gn"
    echo ".tmp/build/toolchain/BUILD.gn"
  }
  function expected_platforms() {
    echo "Available platforms:"
    echo "    foobar"
    echo "    fubar"
  }
  function expected_missing() {
    echo "bam-init: error: the following platforms are not supported:"
    echo "    bar"
    echo "    foo"
    echo "    i686-linux-gnu"
  }

  mkdir -p .tmp .tmp-template_dir/config .tmp-template_dir/toolchains/platforms
  mkdir .tmp-template_dir/config/foobar
  mkdir .tmp-template_dir/config/fubar
  mkdir .tmp-template_dir/config/other
  touch .tmp-template_dir/.gn
  touch .tmp-template_dir/BUILD.gn
  touch .tmp-template_dir/config/BUILD.gn
  touch .tmp-template_dir/config/BUILDCONFIG.gn
  touch .tmp-template_dir/config/fubar/BUILD.gn
  touch .tmp-template_dir/config/foobar/BUILD.gn
  touch .tmp-template_dir/config/other/BUILD.gn
  touch .tmp-template_dir/toolchains/platforms/foobar.gn
  touch .tmp-template_dir/toolchains/platforms/fubar.gn
  cat > .tmp-config << EOF
[init]
    templateDir = $(pwd)/.tmp-template_dir
EOF
  BAM_CONFIG=../.tmp-config bam -C .tmp init

  diff -u <(expected_files) <(find .tmp -type f | sort)
  diff -u <(expected_platforms) <(BAM_CONFIG=../.tmp-config bam -C .tmp init -p list)
  diff -u <(expected_missing) <(BAM_CONFIG=../.tmp-config bam -C .tmp init -p foobar,fubar,foo,bar,i686-linux-gnu)
}

@test "'bam -o <path> init' still uses cwd" {
  mkdir .tmp
  bam -C .tmp -o .tmp1 init
  [ -f .tmp/.gn ]
}

@test "'bam --out-dir <path> init' still uses cwd" {
  mkdir .tmp1
  bam -C .tmp1 --out-dir .tmp2 init
  [ -f .tmp1/.gn ]
}

@test "'bam init <directory>' writes files to <directory>" {
  bam init .tmp1
  [ -f .tmp1/.gn ]
  grep "\.tmp1" .tmp2/BUILD.gn
}

@test "'bam init <directory>' writes files to <directory>" {
  bam --out-dir .tmp1 init .tmp2
  [ -f .tmp2/.gn ]
  grep "\.tmp2" .tmp2/BUILD.gn
}

@test "'bam init' ignores BAM_OUTPUT_DIR" {
  export BAM_OUTPUT_DIR=".tmp3"
  mkdir .tmp1
  bam -C .tmp1 init
  [ -f .tmp1/.gn ]
}

@test "'bam init --config <path>' writes config files to <path>" {
  mkdir .tmp
  bam -C .tmp init --config buildcfg
  [ -d .tmp/buildcfg/config ]
  [ -d .tmp/buildcfg/toolchain ]
}

@test "'bam init -n <name>' sets the project name to <name>" {
  mkdir .tmp
  bam -C .tmp init -n myproj
  grep myproj .tmp/BUILD.gn
}

@test "'bam init --name <name>' sets the project name to <name>" {
  mkdir .tmp
  bam -C .tmp init --name mytestproj
  grep mytestproj .tmp/BUILD.gn
}

@test "'bam init -p <unsupported-platforms>' generates error" {
  function expected() {
    echo "bam-init: error: the following platforms are not supported:"
    echo "    dne"
    echo "    doesnotexist"
  }
  mkdir .tmp
  run bam -C .tmp init -p dne,i686-linux-gnu,doesnotexist
  diff -u <(expected) <(print_result)
  [ "$status" -eq 1 ]
}

@test "'bam init -p <platforms>' only generates the specified platforms" {
  function expected_files() {
    echo ".tmp/.bam/config"
    echo ".tmp/.gn"
    echo ".tmp/BUILD.gn"
    echo ".tmp/build/config/BUILD.gn"
    echo ".tmp/build/config/BUILDCONFIG.gn"
    echo ".tmp/build/config/c28x-ti-coff/BUILD.gn"
    echo ".tmp/build/config/c28x-ti-coff/lint/BUILD.gn"
    echo ".tmp/build/config/external/BUILD.gn"
    echo ".tmp/build/config/i686-linux-gnu/BUILD.gn"
    echo ".tmp/build/config/i686-linux-gnu/lint/BUILD.gn"
    echo ".tmp/build/config/i686-w64-mingw32/BUILD.gn"
    echo ".tmp/build/config/i686-w64-mingw32/lint/BUILD.gn"
    echo ".tmp/build/config/lint/BUILD.gn"
    echo ".tmp/build/config/lint_dep.gni"
    echo ".tmp/build/config/style/BUILD.gn"
    echo ".tmp/build/config/ut/BUILD.gn"
    echo ".tmp/build/config/ut/lint/BUILD.gn"
    echo ".tmp/build/lnt/co-gcc.h"
    echo ".tmp/build/lnt/co-gcc.lnt"
    echo ".tmp/build/lnt/co-gcc.mak"
    echo ".tmp/build/lnt/co-ghs.h"
    echo ".tmp/build/lnt/co-ghs.lnt"
    echo ".tmp/build/lnt/co-ghs.mak"
    echo ".tmp/build/lnt/co-ti.h"
    echo ".tmp/build/lnt/co-ti.lnt"
    echo ".tmp/build/lnt/co-ti.mak"
    echo ".tmp/build/lnt/env-common.lnt"
    echo ".tmp/build/lnt/gcc-readme.txt"
    echo ".tmp/build/toolchain/BUILD.gn"
  }

  mkdir .tmp
  bam -C .tmp init -p "i686-linux-gnu,i686-w64-mingw32,c28x-ti-coff"
  diff -u <(expected_files) <(find .tmp -type f | sort)
}

@test "'bam init --platforms <platforms>' is the same as 'bam init -p <platforms>'" {
  mkdir .tmp1 .tmp2
  bam -C .tmp1 init -n pname -p "i686-linux-gnu,i686-w64-mingw32,c28x-ti-coff"
  bam -C .tmp2 init -n pname --platforms "i686-linux-gnu,i686-w64-mingw32,c28x-ti-coff"
  diff -r .tmp1 .tmp2
}

@test "'bam init' generates valid BUILD.gn files" {
  mkdir .tmp .tmp/include .tmp/src
  bam -C .tmp -o . init -n testproj
  echo "Executable(\"testproj\") { sources = [\"main.cpp\"] }" > .tmp/src/BUILD.gn
  PATH="$(pwd)/.tmp:$PATH" bam -C .tmp -o out gen --args=''
}

@test "'bam init --config <path>' generates valid BUILD.gn files in <path>" {
  mkdir .tmp .tmp/include .tmp/src
  bam -C .tmp -o . init -n testproj --config build
  echo "Executable(\"testproj\") { sources = [\"main.cpp\"] }" > .tmp/src/BUILD.gn
  bam -C .tmp -o out gen --args='platforms=["i686-linux-gnu"]'
}
