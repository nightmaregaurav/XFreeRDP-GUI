#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
source "$PROJECT_ROOT/xfreerdp-gui"

CONFIG_DIR=$(mktemp -d "${TMPDIR:-/tmp}/xfreerdp-gui-test.XXXXXX")
trap 'rm -rf "$CONFIG_DIR"' EXIT

RDP_WINDOW_NAME='$(touch marker); "quoted"'
RDP_IP='example.test'
RDP_PORT='3389'
RDP_USERNAME='test-user'
RDP_PASSWORD='do-not-store-this-password'
RDP_FLAGS=(+clipboard -heartbeat)
save_to_file

connection_file="$CONFIG_DIR/saved-connection-1"
[[ -f "$connection_file" ]]
saved_data=$(<"$connection_file")
[[ "$saved_data" != *"$RDP_PASSWORD"* ]]
if [[ "$(uname -s)" == 'Darwin' ]]; then
    file_mode=$(stat -f '%Lp' "$connection_file")
    directory_mode=$(stat -f '%Lp' "$CONFIG_DIR")
else
    file_mode=$(stat -c '%a' "$connection_file")
    directory_mode=$(stat -c '%a' "$CONFIG_DIR")
fi
[[ "$file_mode" == '600' ]]
[[ "$directory_mode" == '700' ]]

load_saved_connection 1
[[ "$RDP_WINDOW_NAME" == '$(touch marker); "quoted"' ]]
[[ "$RDP_IP" == 'example.test' ]]
[[ "$RDP_PORT" == '3389' ]]
[[ "$RDP_USERNAME" == 'test-user' ]]
[[ -z "$RDP_PASSWORD" ]]
[[ ${RDP_FLAGS[*]} == '+clipboard -heartbeat' ]]
[[ ! -e "$CONFIG_DIR/marker" ]]

printf '$(touch "%s/marker")\n' "$CONFIG_DIR" > "$CONFIG_DIR/saved-connection-99"
if load_saved_connection 99; then
    printf 'A legacy shell-format profile unexpectedly loaded.\n' >&2
    exit 1
fi
[[ ! -e "$CONFIG_DIR/marker" ]]

RDP_WINDOW_NAME='$(touch marker)'
RDP_IP='example.test'
RDP_PORT='3389'
RDP_USERNAME='test-user'
RDP_FLAGS=(+clipboard)
build_freerdp_args
[[ " ${FREERDP_ARGS[*]} " == *' /t:$(touch marker) '* ]]
[[ " ${FREERDP_ARGS[*]} " != *' /v:'* ]]
[[ " ${FREERDP_ARGS[*]} " == *' /port:3389 '* ]]
[[ " ${FREERDP_ARGS[*]} " == *' /from-stdin '* ]]
[[ " ${FREERDP_ARGS[*]} " != *'/p:'* ]]
[[ ! -e "$CONFIG_DIR/marker" ]]

fake_freerdp="$CONFIG_DIR/fake-freerdp"
printf '%s\n' \
    '#!/bin/sh' \
    'printf "%s\n" "$@" > "$FREERDP_TEST_ARGS_FILE"' \
    'while IFS= read -r line; do printf "%s\n" "$line"; done > "$FREERDP_TEST_STDIN_FILE"' \
    > "$fake_freerdp"
chmod 700 "$fake_freerdp"
FREERDP_TEST_ARGS_FILE="$CONFIG_DIR/freerdp-args"
FREERDP_TEST_STDIN_FILE="$CONFIG_DIR/freerdp-stdin"
export FREERDP_TEST_ARGS_FILE FREERDP_TEST_STDIN_FILE
FREERDP_BIN=$fake_freerdp
RDP_PASSWORD='password-not-in-arguments'
expected_password=$RDP_PASSWORD
run_freerdp
freerdp_args=$(<"$FREERDP_TEST_ARGS_FILE")
freerdp_stdin=$(<"$FREERDP_TEST_STDIN_FILE")
[[ "$freerdp_args" != *"$expected_password"* ]]
[[ "$freerdp_args" != *'test-user'* ]]
[[ "$freerdp_stdin" == $'test-user\npassword-not-in-arguments\n\nexample.test' ]]
[[ -z "$RDP_PASSWORD" ]]

RDP_WINDOW_NAME=''
RDP_PORT='3389'
validate_connection
[[ "$RDP_WINDOW_NAME" == "$RDP_IP" ]]

RDP_PORT='70000'
if validate_connection 2>/dev/null; then
    printf 'Out-of-range port unexpectedly passed validation.\n' >&2
    exit 1
fi

printf 'All xfreerdp-gui tests passed.\n'