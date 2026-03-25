# threeDotsFiles

**[ OS: Arch Linux ] [ Shell: Zsh ] [ Terminal-Focused ]**

A portable, modular, and automated bootstrap setup for Arch-family Linux machines. It installs modern CLI tools, configures your terminal environment, and manages dotfiles through symlinks.

---

## 📋 What's Included

This setup automates the complete onboarding of a new machine. 

### Core Tools & CLI Replacements
* **Modern Utilities**: `bat` (cat), `eza` (ls), `fzf` (find), `ripgrep` (grep)
* **Navigation & History**: `atuin` (shell history), `zoxide` (smart cd)
* **TUIs**: `lazygit`, `lazydocker`
* **System Monitoring**: `btop`, `fastfetch`
* **Dev Tools**: `github-cli`, `starship` (prompt), `shellcheck`

### Versioned Configurations
* **Shell**: `.zshrc` + `.p10k.zsh` (Powerlevel10k prompt)
* **Multiplexer**: `.tmux.conf`
* **Editor**: `nvim/` (Complete LazyVim setup)
* **Terminal**: `ghostty/`
* **Git**: `.gitconfig` (Aliases, delta, behavior - *no credentials included*)

### Optional Add-ons
* **AI CLIs**: OpenCode, GitHub Copilot, Gemini, Codex, Claude Code

---

## ⚙️ Prerequisites

Before running the setup, ensure your system meets these minimum requirements:
1. **Arch Linux** or an Arch-based distribution (Manjaro, EndeavourOS).
2. **git** installed (`sudo pacman -S git`).
3. Standard user account with **sudo** privileges (Do *not* run as root).

---

## 🚀 Installation

The installation process is designed to be fully automated and safe. It will automatically backup any existing configurations before creating new symlinks.

### Easy Install (Recommended)
Run this single command in your terminal. It will install `git`, clone the repo, and start the setup automatically:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Soyt0ny/threeDotsFiles/main/bootstrap.sh)"
```

### Manual Install
If you prefer to do it manually:
```bash
sudo pacman -S git base-devel

```bash
git clone https://github.com/Soyt0ny/threeDotsFiles.git
cd threeDotsFiles
```

### Step 2: Run the Setup
Run the setup script. It will check requirements, detect conflicts, and install everything.
```bash
./setup.sh --yes
```
*(Note: To see what the script will do without making any changes, run `./setup.sh --dry-run` first).*

### Step 3: Reload Your Environment
```bash
exec zsh
```

---

## 🔧 Post-Installation Checklist

After the setup finishes, complete these manual steps to personalize your environment:

1. **Configure Git Identity**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
2. **Verify the Installation**
   ```bash
   ./scripts/verify-setup.sh
   ```
3. **Authenticate Services (Optional)**
   ```bash
   gh auth login
   ```

---

## 🔄 Updating an Existing Setup

If you pull new changes from this repository, you can safely update your system without running the full installation again.

```bash
git pull origin main
./setup.sh --update --yes
```
**The `--update` flag will:**
* Skip the backup phase (assumes backups exist).
* Only install *missing* packages incrementally.
* Re-apply all dotfile symlinks with the latest versions.

---

## 🗑️ Uninstallation & Rollback

Tried it and want your old setup back? The uninstaller will safely remove the symlinks and restore your original backed-up configurations.

```bash
./scripts/uninstall.sh
```
*Important: The uninstaller does NOT remove system packages installed via pacman/yay to prevent breaking dependencies. Packages must be removed manually if desired.*

---

## 🛠️ Advanced Usage & Flags

The `setup.sh` script is modular and accepts several flags to customize its behavior.

### Execution Modes
| Flag | Description |
|------|-------------|
| `--dry-run` | Shows actions without applying any changes. |
| `-y, --yes` | Non-interactive mode (auto-confirms prompts). |
| `--interactive` | Asks for confirmation before running each module. |
| `--log` | Saves a complete installation log in `~/.dotfiles-logs/`. |

### Module Selection
By default, all modules are executed. You can isolate specific layers:
| Flag | Description |
|------|-------------|
| `--only <module>` | Runs a specific module (e.g., `./setup.sh --only ai-clis`). |
| `--skip <m1,m2>` | Skips specific modules (e.g., `./setup.sh --skip ai-clis`). |

### Available Modules
* `system`: OS requirements and post-setup tasks (like Docker).
* `devtools`: Base toolchains and core CLI packages.
* `project`: Backups existing configs and links the repo's dotfiles.
* `ai-clis`: Installs AI CLI tools (without authentication).

---

## 🧪 Testing & Validation

The repository includes a suite of tests to ensure everything works as expected. 

To run the automated tests:
```bash
./tests/run-all.sh
```

To validate shell scripts using ShellCheck:
```bash
./scripts/check-shell.sh
```

---

## 🆘 Troubleshooting

**1. The setup fails at `check-requirements.sh`**
*   **Not Arch Linux**: This setup requires an Arch-based distribution.
*   **No Internet**: Check your connection (`ping 8.8.8.8`).
*   **Running as Root**: Run the script as a normal user with `sudo` configured.

**2. The setup detects conflicts**
If the script finds existing managers (like Oh My Zsh) or hard files where symlinks should go, it will pause. You can force it to ignore conflicts:
```bash
./setup.sh --skip-conflict-check
```

**3. I need to see what went wrong**
Run the setup with the log flag and inspect the output:
```bash
./setup.sh --log
cat ~/.dotfiles-logs/setup-*.log
```

**4. Manual Backup Restoration**
If you need to manually restore your backups instead of using the uninstaller:
```bash
# List available backups
ls -la ~/.dotfiles-backup/

# Restore everything from a specific backup
cp -a ~/.dotfiles-backup/YYYYMMDD-HHMMSS/* ~/
```
