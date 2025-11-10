#!/usr/bin/env bash

###############################################################################
# Sanitize Sensitive Data
# Removes sensitive information before committing to git
###############################################################################

set -e

# Source common functions for sed_inplace
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/scripts/common.sh" ]; then
    source "$SCRIPT_DIR/scripts/common.sh"
else
    # Fallback if common.sh doesn't exist yet
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m'

    print_error() { echo -e "${RED}✗ ${1}${NC}"; }
    print_success() { echo -e "${GREEN}✓ ${1}${NC}"; }
    print_warning() { echo -e "${YELLOW}⚠ ${1}${NC}"; }

    # Cross-platform sed in-place function
    sed_inplace() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "$@"
        else
            sed -i "$@"
        fi
    }
fi

echo "🔒 Sanitizing Sensitive Data..."
echo ""

# 1. Remove GitLab token from glab config
if [ -f "dotfiles/glab/.config/glab-cli/config.yml" ]; then
    print_warning "FOUND: GitLab token in glab config"
    sed_inplace 's/token: glpat-[A-Za-z0-9_-]*/token: YOUR_GITLAB_TOKEN_HERE/g' dotfiles/glab/.config/glab-cli/config.yml
    print_success "Sanitized GitLab token"
fi

# 2. Remove email from git config (optional - comment out if you want to keep it)
if [ -f "dotfiles/git/.gitconfig" ]; then
    print_warning "FOUND: Email in git config"
    echo "  Your email: $(grep 'email =' dotfiles/git/.gitconfig || echo 'not found')"
    read -p "  Remove email? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sed_inplace 's/email = .*/email = YOUR_EMAIL_HERE/g' dotfiles/git/.gitconfig
        print_success "Sanitized email"
    else
        print_warning "Keeping email (public)"
    fi
fi

# 3. Remove node_modules (already done but double-check)
if [ -d "dotfiles/opencode/.config/opencode/node_modules" ]; then
    print_warning "Removing node_modules..."
    rm -rf dotfiles/opencode/.config/opencode/node_modules
    print_success "Removed node_modules"
fi

# 4. Remove GitLab personal data
if [ -d "dotfiles/glab/.config/glab-cli/recover" ]; then
    print_warning "Removing GitLab recovery data..."
    rm -rf dotfiles/glab/.config/glab-cli/recover
    print_success "Removed GitLab recovery data"
fi

# 5. Check for any remaining sensitive patterns
echo ""
echo "🔍 Checking for remaining sensitive data..."

SENSITIVE_FOUND=0

# Check for tokens
if grep -r "glpat-\|ghp_\|gho_" dotfiles/ 2>/dev/null | grep -v "YOUR_.*_HERE"; then
    print_error "Found potential tokens!"
    SENSITIVE_FOUND=1
fi

# Check for AWS keys
if grep -r "AKIA\|aws_secret" dotfiles/ 2>/dev/null; then
    print_error "Found potential AWS keys!"
    SENSITIVE_FOUND=1
fi

# Check for private keys
if find dotfiles/ -name "*.pem" -o -name "*.key" -o -name "id_rsa*" -o -name "id_ed25519*" 2>/dev/null | grep -v ".pub"; then
    print_error "Found private keys!"
    SENSITIVE_FOUND=1
fi

echo ""
if [ $SENSITIVE_FOUND -eq 0 ]; then
    print_success "No obvious sensitive data found!"
else
    print_error "Please review and remove sensitive data before committing!"
    exit 1
fi

echo ""
echo "✅ Sanitization complete!"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff"
echo "  2. Add files: git add ."
echo "  3. Commit: git commit -m 'Initial dotfiles'"
echo "  4. Push: git push"
