#!/bin/bash

readonly TARGET_IP="$1"
readonly PROGRAM="$2"
readonly PROGRAM_PATH="$3"
readonly TARGET_DIR="/home/debian"

# Print some debug info
echo "Deploying to target"

# Kill gdbserver on the target and delete the old binary
echo "TARGET DIR : ${TARGET_DIR}"
echo "Program to be deleted: ${TARGET_DIR}/${PROGRAM}"
echo "Program path : ${PROGRAM_PATH}"
ssh debian@${TARGET_IP} "sh -c 'pkill -f gdbserver; rm -rf ${TARGET_DIR}/${PROGRAM} exit 0'"

# Copy the program to the target
scp ${PROGRAM_PATH} debian@${TARGET_IP}:${TARGET_DIR}

# Start gdb
echo "Starting GDB server on target"

ssh -t debian@${TARGET_IP} "sh -c 'cd ${TARGET_DIR}; gdbserver localhost:3000 ${PROGRAM}'"