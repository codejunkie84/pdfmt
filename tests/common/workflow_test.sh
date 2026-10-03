#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    export TEST_DIR="/tmp/bashunit_test_$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR" || exit 1

    export WORKFLOW_PATHS="$TEST_DIR/workflows/:$TEST_DIR/wip/workflows"

    # dummy workflow 1
    mkdir -p "$TEST_DIR/workflows/"
    cat <<EOF > "$TEST_DIR/workflows/foobar"
#!/usr/bin/env bash
# =========
# my foobar workflow
echo "\$@"

EOF
    chmod +x "$TEST_DIR/workflows/foobar"

    # dummy workflow 2
    mkdir -p "$TEST_DIR/workflows/"
    cat <<EOF > "$TEST_DIR/workflows/foobaz"
#!/usr/bin/env bash
# =========
# my foobaz workflow
echo "\$@"

EOF
    chmod +x "$TEST_DIR/workflows/foobaz"

    # dummy workflow 3
    mkdir -p "$TEST_DIR/wip/workflows/"
    cat <<EOF > "$TEST_DIR/wip/workflows/foobar"
#!/usr/bin/env bash
# =========
# my foobar (2) workflow
echo "\$@"

EOF
    chmod +x "$TEST_DIR/wip/workflows/foobar"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "$TEST_DIR"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_workflow_assert_valid_name()
{
    local exit_code=0

    _workflow_assert_valid_name "scan-duplex" || exit_code=$?
    assert_same "0" "${exit_code}"

    _workflow_assert_valid_name "../scan-duplex" || exit_code=$?
    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_workflow_get_paths()
{
    local exit_code=0
    local result

    result=$(_workflow_get_paths) || exit_code=$?

    local expected="$TEST_DIR/workflows"$'\n'"$TEST_DIR/wip/workflows"

    assert_same "0" "${exit_code}"
    assert_same "${expected}" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_workflow_find_all()
{
    local exit_code=0
    local result

    # multiple matches for "foobar" in both paths
    result=$(_workflow_find_all "foobar") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "$TEST_DIR/workflows/foobar"$'\n'"$TEST_DIR/wip/workflows/foobar" "${result}"

    # only one match for "foobaz"
    result=$(_workflow_find_all "foobaz") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "$TEST_DIR/workflows/foobaz" "${result}"

    # no match for "nonexistent"
    result=$(_workflow_find_all "nonexistent") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_workflow_find()
{
    local exit_code=0
    local result

    # the last match of will be used
    result=$(_workflow_find "foobar") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "$TEST_DIR/wip/workflows/foobar" "${result}"

    # only one match
    result=$(_workflow_find "foobaz") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "$TEST_DIR/workflows/foobaz" "${result}"

    # no match
    result=$(_workflow_find "nonexistent") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_workflow_get_description()
{
    local exit_code=0
    local result

    result=$(_workflow_get_description "$TEST_DIR/workflows/foobar") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "my foobar workflow" "${result}"

    result=$(_workflow_get_description "$TEST_DIR/wip/workflows/foobar") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "my foobar (2) workflow" "${result}"

    result=$(_workflow_get_description "$TEST_DIR/workflows/nonexistent") || exit_code=$?
    assert_not_same "0" "${exit_code}"
    assert_same "" "${result}"
}
