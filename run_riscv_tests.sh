#!/usr/bin/env bash

UI_INSTS=(sw lw add addi sub and andi or ori xor xori sll srl sra slli srli srai slt sltu slti sltiu beq bne blt bge bltu bgeu jal jalr lui auipc)
MI_INSTS=(csr scall)

WORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULT_DIR=$WORK_DIR/src/results
mkdir -p $RESULT_DIR
cd $WORK_DIR

function loop_test(){
  INSTS=${!1}
  PACKAGE_NAME=$2
  ISA=$3
  DIRECTORY_NAME=$4
  sed -e "s/{package}/$PACKAGE_NAME/" $WORK_DIR/src/test/templates/RiscvTests.scala > $WORK_DIR/src/test/scala/RiscvTests.scala

  for INST in ${INSTS[@]}; do
    echo $INST
    sed -e "s/{package}/$PACKAGE_NAME/" -e "s/{isa}/$ISA/" -e "s/{inst}/$INST/" $WORK_DIR/src/main/templates/Memory.scala > $WORK_DIR/src/main/scala/$DIRECTORY_NAME/Memory.scala
    sbt "testOnly $PACKAGE_NAME.RiscvTest" > $RESULT_DIR/$INST.txt
  done
}

# ./run_riscv_tests.sh <package_name> <directory_name>
# Example: ./run_riscv_tests.sh riscvtests 05_RiscvTests

PACKAGE_NAME=${1:?"Package name is required"}
DIRECTORY_NAME=${2:?"Directory name is required"}
loop_test UI_INSTS[@] $PACKAGE_NAME "ui" $DIRECTORY_NAME
loop_test MI_INSTS[@] $PACKAGE_NAME "mi" $DIRECTORY_NAME
