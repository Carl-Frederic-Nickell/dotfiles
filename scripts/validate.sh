#!/usr/bin/env bash

###############################################################################
# Validation Script
# Runs shellcheck on all shell scripts to ensure code quality
###############################################################################

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

print_info "Running shellcheck on all scripts..."
echo ""

# Find all .sh files, excluding node_modules and .git directories
SCRIPT_COUNT=0
FAILED_COUNT=0
PASSED_COUNT=0

while IFS= read -r -d '' script; do
    ((SCRIPT_COUNT++))

    # Get relative path for cleaner output
    rel_path="${script#$(dirname "$SCRIPT_DIR")/}"

    echo -n "Checking $rel_path... "

    if shellcheck -x "$script" 2>&1 | grep -v "^$" > /tmp/shellcheck-$$.txt; then
        if [ -s /tmp/shellcheck-$$.txt ]; then
            print_error "FAILED"
            cat /tmp/shellcheck-$$.txt
            echo ""
            ((FAILED_COUNT++))
        else
            print_success "PASSED"
            ((PASSED_COUNT++))
        fi
    else
        print_success "PASSED"
        ((PASSED_COUNT++))
    fi

    rm -f /tmp/shellcheck-$$.txt
done < <(find "$(dirname "$SCRIPT_DIR")" -name "*.sh" -type f \
    ! -path "*/node_modules/*" \
    ! -path "*/.git/*" \
    ! -path "*/dotfiles/*" \
    -print0)

echo ""
echo "================================"
echo "Summary:"
echo "  Total scripts: $SCRIPT_COUNT"
echo "  Passed: $PASSED_COUNT"
echo "  Failed: $FAILED_COUNT"
echo "================================"

if [ $FAILED_COUNT -eq 0 ]; then
    print_success "All scripts passed shellcheck!"
    exit 0
else
    print_error "$FAILED_COUNT script(s) failed shellcheck"
    exit 1
fi
