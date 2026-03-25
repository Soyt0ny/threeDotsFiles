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

### Step 1: Clone the Repository
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
Ensure you are on an Arch-based system, have internet access, and are running the script as a normal user (not root).

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
sudo pacman -S shellcheck

# Debian / Ubuntu
sudo apt-get install shellcheck
```

2) Ejecutar el check:

```bash
./scripts/check-shell.sh
```

El script falla con mensaje claro si `shellcheck` no esta instalado.

## Tests

Para ejecutar tests basicos:

```bash
# Ejecutar todos los tests
./tests/run-all.sh

# Ejecutar tests individuales
./tests/test-setup-dry-run.sh
./tests/test-requirements.sh
./tests/test-conflicts.sh
./tests/test-uninstall.sh
```

Los tests verifican:
- Sintaxis de scripts
- Ejecucion de dry-run completo
- Pre-checks de requisitos
- Deteccion de conflictos

## Semantica de seguridad

- `dry-run/apply` se mantiene en todo el flujo.
- Preservacion segura por defecto: antes de linkear `dotfiles-core`, se backuppea a `~/.dotfiles-backup/<timestamp>/`.
- Si usas `--preserve skip`, no se genera backup.

## Dotfiles core (linkeo)

`scripts/link.sh` crea symlinks para:

- `configs/zsh/.zshrc` -> `~/.zshrc`
- `configs/tmux/.tmux.conf` -> `~/.tmux.conf`
- `configs/nvim/` -> `~/.config/nvim`
- `configs/ghostty/` -> `~/.config/ghostty`

## Politica AI CLIs

La capa `ai-clis` es **solo instalacion de paquetes**.

- No linkea configuraciones AI.
- No sincroniza configuraciones AI por default.
- `opencode` fue removido del mapping de link/sync para evitar acoplar estado local de herramientas AI.
- `scripts/install-ai-clis-linux.sh` no acepta `--yes`: el flujo local ya es no interactivo en lo que controla el script, pero los instaladores oficiales remotos pueden mostrar prompts propios.

## Configs incluidas en el repo

Configs versionadas usadas por el flujo "apps + configs + cli":

- `configs/zsh/.zshrc` -> `~/.zshrc` (sanitizada, sin paths hardcodeados)
- `configs/zsh/.p10k.zsh` -> `~/.p10k.zsh` (powerlevel10k theme)
- `configs/tmux/.tmux.conf` -> `~/.tmux.conf`
- `configs/nvim/` (incluye `init.lua`) -> `~/.config/nvim`
- `configs/ghostty/config` -> `~/.config/ghostty/config`
- `configs/git/.gitconfig` -> `~/.config/git/config` (sin credenciales ni user)
- `configs/git/user.template` - Template para tu [user] section

Config adicional versionada (no linkeada por setup por politica actual):

- `configs/opencode/` (placeholder documental)

## Manifiestos de paquetes

Estructura nueva:

```text
packages/
|-- official.txt                  # legacy fallback
|-- aur.txt                       # legacy fallback
|-- layers/
|   |-- toolchains-official.txt
|   |-- toolchains-aur.txt
|   |-- ai-clis-official.txt
|   `-- ai-clis-aur.txt
`-- profiles/
    `-- dev.layers
```

`scripts/packages.sh` soporta:

- `--layers toolchains,ai-clis` (nuevo modo por capas)
- fallback legacy (`official.txt` + `aur.txt`) si no se pasan capas

## Sync (maquina -> repo)

`sync.sh` mantiene whitelist de rutas versionadas:

- `~/.zshrc` -> `configs/zsh/.zshrc`
- `~/.tmux.conf` -> `configs/tmux/.tmux.conf`
- `~/.config/nvim/` -> `configs/nvim/`
- `~/.config/ghostty/` -> `configs/ghostty/`

Ejemplos:

```bash
./sync.sh --dry-run
./sync.sh --apply
./sync.sh --apply --prune
```

## Nota de post-setup

`post-setup` ejecuta setup de Docker/system (enable service + grupo docker) solo si esa capa esta seleccionada.

## Uninstall

Si necesitas remover los dotfiles linkeados:

```bash
# Listar symlinks y removerlos con confirmacion
./scripts/uninstall.sh

# Remover sin confirmacion
./scripts/uninstall.sh --force
```

**IMPORTANTE:** El uninstaller NO desinstala paquetes del sistema (muy peligroso). Solo remueve symlinks de dotfiles. Los paquetes deben desinstalarse manualmente si es necesario.

### Restaurar backups

El uninstaller detecta backups en `~/.dotfiles-backup/` y ofrece restaurar el mas reciente:

```bash
./scripts/uninstall.sh
# Despues de remover symlinks, pregunta: "¿Restaurar backup mas reciente? (y/N)"
```

Para restaurar backups manualmente:

```bash
# Listar backups disponibles
ls -la ~/.dotfiles-backup/

# Restaurar archivo especifico
cp -a ~/.dotfiles-backup/YYYYMMDD-HHMMSS/.zshrc ~/

# Restaurar todo un backup
cp -a ~/.dotfiles-backup/YYYYMMDD-HHMMSS/* ~/
```

## Troubleshooting

### Pre-checks fallan

Si `check-requirements.sh` falla:

1. **No es Arch Linux**: Este setup requiere Arch Linux
2. **pacman no encontrado**: Instala Arch Linux o usa distro compatible
3. **Sin conexion a internet**: Verifica tu conexion (ping 8.8.8.8)
4. **Espacio insuficiente**: Libera espacio en `/` (minimo 2GB recomendado)
5. **Ejecutando como root**: Ejecuta como usuario normal con sudo configurado
6. **sudo no disponible**: Instala sudo y configura tu usuario

### Conflictos detectados

Si `detect-conflicts.sh` encuentra conflictos:

- **Oh My Zsh detectado**: Este setup usa zsh con powerlevel10k standalone. Puedes continuar pero puede haber conflictos en `.zshrc`
- **chezmoi/yadm detectado**: Este setup usa symlinks directos. Considera desinstalar el otro gestor primero
- **Configs existentes**: Tus archivos actuales seran respaldados en `~/.dotfiles-backup/` antes de crear symlinks

Para continuar de todas formas: responde `y` al prompt o usa `--skip-conflict-check`

### Logs de instalacion

Si algo falla durante el setup:

```bash
# Ejecutar con log
./setup.sh --log

# Ver log mas reciente
ls -t ~/.dotfiles-logs/ | head -1
cat ~/.dotfiles-logs/setup-YYYYMMDD-HHMMSS.log
```
