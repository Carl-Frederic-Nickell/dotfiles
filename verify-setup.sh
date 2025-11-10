#!/usr/bin/env bash

###############################################################################
# Setup Verification Script
# Checks that all components are in place
###############################################################################

print_check() {
    if [ $1 -eq 0 ]; then
        echo "✓ $2"
    else
        echo "✗ $2"
    fi
}

echo "Verifying dotfiles setup..."
echo ""

# Check main scripts exist
echo "Main Scripts:"
[ -f "install.sh" ] && [ -x "install.sh" ]; print_check $? "install.sh is present and executable"
[ -f "collect-dotfiles.sh" ] && [ -x "collect-dotfiles.sh" ]; print_check $? "collect-dotfiles.sh is present and executable"

echo ""
echo "Installation Scripts:"
for script in scripts/install-*.sh; do
    [ -f "$script" ] && [ -x "$script" ]
    print_check $? "$(basename $script) is present and executable"
done

echo ""
echo "Documentation:"
[ -f "README.md" ]; print_check $? "README.md exists"
[ -f "QUICKSTART.md" ]; print_check $? "QUICKSTART.md exists"
[ -f "SETUP-COMPLETE.md" ]; print_check $? "SETUP-COMPLETE.md exists"

echo ""
echo "Directory Structure:"
[ -d "scripts" ]; print_check $? "scripts/ directory exists"
[ -d "dotfiles" ]; print_check $? "dotfiles/ directory exists"
[ -d "packages" ]; print_check $? "packages/ directory exists"
[ -d "configs" ]; print_check $? "configs/ directory exists"

echo ""
echo "Package Lists:"
[ -f "packages/macos.txt" ]; print_check $? "macos.txt exists"
[ -f "packages/linux.txt" ]; print_check $? "linux.txt exists"
[ -f "packages/windows.txt" ]; print_check $? "windows.txt exists"

echo ""
echo "Dotfiles Structure:"
for dir in nvim tmux zsh starship git ghostty wezterm; do
    [ -d "dotfiles/$dir" ]
    print_check $? "$dir/ directory exists"
done

echo ""
echo "═══════════════════════════════════════════════════════════"

# Count script files
script_count=$(ls -1 scripts/install-*.sh 2>/dev/null | wc -l | tr -d ' ')
dotfiles_count=$(ls -d dotfiles/*/ 2>/dev/null | wc -l | tr -d ' ')

echo "Summary:"
echo "  • $script_count installation scripts"
echo "  • $dotfiles_count dotfile directories"
echo "  • 3 package lists (macOS, Linux, Windows)"
echo ""

if [ -d ".git" ]; then
    echo "✓ Git repository initialized"
else
    echo "⚠ Git repository not initialized yet"
    echo "  Run: git init"
fi

echo ""
echo "Next steps:"
echo "  1. Run ./collect-dotfiles.sh to gather your configs"
echo "  2. Review dotfiles/ and remove sensitive data"
echo "  3. git init && git add . && git commit -m 'Initial setup'"
echo "  4. git remote add origin <your-repo-url>"
echo "  5. git push -u origin main"
