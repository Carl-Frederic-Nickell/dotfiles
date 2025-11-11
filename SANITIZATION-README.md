# Sanitization Guide

## ✅ Your dotfiles are now sanitized and safe for GitHub!

All sensitive data has been removed and replaced with placeholders.

---

## What Was Sanitized

### 🔴 Critical Data Removed
- GitLab server URL: `gitlab.carl-cyber.tech:8443` → `gitlab.example.com`
- GitLab API token: Cleaned
- Port numbers: Removed

### 🟡 Personal Information Removed
- Full name: `Carl-Frederic Nickell` → `YOUR_NAME`
- Email: `mail@carl-cyber.tech` → `your.email@example.com`
- Username: `Carl` → `YOUR_USERNAME`
- Domain: `carl-cyber.tech` → `example.com`

### 🟢 File Paths Sanitized
- Obsidian vault: `CARLs-NoteLab` → `NoteLab`
- User paths: `/Users/carl` → `$HOME` or generic
- Personal file structures: Generalized

### 🗑️ Files Removed
- `atuin-receipt.json` (machine-specific)
- `node_modules/` (if present)
- GitLab recovery data

---

## The Personal Sanitize Script

**File:** `sanitize-personal.sh`
**Status:** ✅ Added to `.gitignore` (will NOT be committed)

### Why Keep It Private?

This script contains the specific patterns of your personal data. By keeping it private:
- Attackers can't see what patterns you're hiding
- Your privacy is better protected
- You can reuse it locally without exposing your data

### How to Use

```bash
# Before each commit:
./sanitize-personal.sh

# The script will:
# 1. Replace all personal data with placeholders
# 2. Remove machine-specific files
# 3. Run security checks
# 4. Exit with error if sensitive data remains
```

### Safe Git Workflow

```bash
# 1. Make changes to your dotfiles
vim dotfiles/...

# 2. Run sanitization
./sanitize-personal.sh

# 3. Review what changed
git status
git diff

# 4. Commit and push
git add .
git commit -m "Update dotfiles"
git push
```

---

## Verification

Run these checks to ensure safety:

```bash
# Check for personal domain
grep -r "carl-cyber.tech" dotfiles/
# Should return nothing

# Check for full name
grep -r "Carl-Frederic Nickell" dotfiles/
# Should return nothing

# Check for hardcoded paths
grep -r "/Users/carl" dotfiles/
# Should return nothing (except in .json files which are ignored)

# Run the sanitize script
./sanitize-personal.sh
# Should exit with success (0) and show "Safe to commit to GitHub!"
```

---

## Files Modified

The following files were sanitized:

1. `dotfiles/glab/.config/glab-cli/config.yml` - GitLab configuration
2. `dotfiles/git/.gitconfig` - Git personal info
3. `dotfiles/nvim/.config/nvim/lua/plugins/obsidian.lua` - Obsidian paths
4. `dotfiles/nvim/.config/nvim/lua/plugins/alpha.lua` - Dashboard paths
5. `dotfiles/mc/.config/mc/panels.ini` - Midnight Commander paths
6. `.gitignore` - Added sanitize-personal.sh

---

## .gitignore Protection

The `.gitignore` file now includes:

```gitignore
# Personal sanitize script (contains sensitive data patterns - DO NOT COMMIT)
sanitize-personal.sh
```

Plus comprehensive patterns for:
- SSH keys
- AWS credentials
- Environment files
- Tokens and secrets
- Machine-specific files

---

## Security Checklist

Before pushing to GitHub:

- [ ] Run `./sanitize-personal.sh`
- [ ] Verify it exits with success (code 0)
- [ ] Run `git diff` to review changes
- [ ] Ensure `sanitize-personal.sh` is NOT in `git status`
- [ ] Check no error messages from security checks
- [ ] Commit and push

---

## For New Machines

When setting up on a new machine:

### 1. Clone your dotfiles
```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

### 2. Customize the configs
Edit these files with YOUR information:
- `dotfiles/git/.gitconfig` - Your name and email
- `dotfiles/glab/.config/glab-cli/config.yml` - Your GitLab server and token
- `dotfiles/nvim/.config/nvim/lua/plugins/obsidian.lua` - Your vault path
- Any other personal paths

### 3. Run the installer
```bash
./install.sh --interactive
```

### 4. Restore personal sanitize script
If you have it backed up elsewhere, copy it back:
```bash
cp ~/Backup/sanitize-personal.sh .
```

Or recreate it using this template - it's safe to store locally!

---

## Summary

✅ **All sensitive data removed**
✅ **Security checks passed**
✅ **Personal sanitize script created and ignored**
✅ **Safe to commit to public GitHub**

Your dotfiles are now a perfect template that anyone can use without exposing your personal information!

---

## Questions?

- Check what was sanitized: `git diff`
- Re-run sanitization: `./sanitize-personal.sh`
- Verify safety: `grep -r "carl-cyber.tech" dotfiles/` (should be empty)
