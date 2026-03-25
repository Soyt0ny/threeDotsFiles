# threeDotsFiles

Bootstrap portable para maquinas Arch-family con instalacion por capas y dotfiles versionados.

## Que instala

Este setup automatiza el onboarding completo de una maquina nueva con:

**Herramientas CLI modernas:**
- `bat`, `eza`, `fzf`, `ripgrep` - Modern replacements (cat, ls, find, grep)
- `atuin`, `zoxide` - Smart shell history & navigation
- `lazygit`, `lazydocker` - Interactive TUIs
- `btop`, `fastfetch` - System monitoring
- `github-cli`, `starship` - Git integration & prompt
- `neovim`, `tmux`, `zsh` - Core dev tools
- `docker`, `docker-compose` - Containerization

**Configs versionadas:**
- `.zshrc` + `.p10k.zsh` - Shell personalizada con plugins
- `.tmux.conf` - Multiplexor
- `nvim/` - Editor config
- `ghostty/` - Terminal emulator
- `.gitconfig` - Git aliases, delta, comportamiento (sin credenciales)
- `git/user.template` - Template para configurar tu identidad

**Opcionales:**
- AI CLIs: OpenCode, GitHub Copilot, etc. (capa separada)

## Instalacion (3 pasos)

```bash
# 1. Clonar el repo
git clone <repo-url> threeDotsFiles
cd threeDotsFiles

# 2. Ejecutar setup
./setup.sh

# 3. Reiniciar terminal
exec zsh
```

`./setup.sh` instala paquetes, linkea dotfiles y configura Docker. Por defecto ejecuta en modo apply y NO instala AI CLIs.

## Despues de instalar

Checklist post-instalacion:

```bash
# Configurar tu identidad en git
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"

# Reiniciar terminal para aplicar zsh/PATH
exec zsh

# Verificar instalacion
./scripts/verify-setup.sh

# (Opcional) Autenticar GitHub CLI
gh auth login

# (Opcional) Autenticar AI CLIs segun necesites
# opencode auth, etc.
```

## Capas de instalacion

El instalador soporta estas capas:

1. `toolchains`
2. `dotfiles-core` (`zsh`, `tmux`, `nvim`, `ghostty`)
3. `ai-clis` (**install-only**, sin link/sync de configs)
4. `post-setup` (docker/system setup)

Por defecto se usa el perfil `dev` (`packages/profiles/dev.layers`) con esas cuatro capas.

## Modulos disponibles

`setup.sh` ejecuta estos modulos:

- `system` - Checks + post-setup de sistema (docker)
- `devtools` - Toolchains base
- `ai-clis` - Capa de paquetes AI + instaladores
- `project` - Backup + link de dotfiles del repo

**Ejemplos:**

```bash
# Ejecutar solo un modulo
./setup.sh --only devtools

# Ejecutar todo excepto AI CLIs
./setup.sh --skip ai-clis

# Dry-run para ver acciones sin aplicar
./setup.sh --dry-run

# Modo no interactivo (auto-confirm)
./setup.sh --yes
```

## Flags disponibles

**Setup (`./setup.sh`):**
- `--all` - Ejecuta todos los modulos (default)
- `--only <module>` - Ejecuta solo un modulo
- `--skip <m1,m2>` - Omite modulos
- `--dry-run` - Muestra acciones sin aplicar cambios
- `-y, --yes` - Modo no interactivo (auto-confirmaciones)
- `--interactive` - Pregunta por cada modulo antes de ejecutar
- `--log` - Guarda log completo en `~/.dotfiles-logs/`
- `--update` - Modo actualizacion (sin backups, incremental)
- `--skip-conflict-check` - Omite deteccion de conflictos pre-instalacion

**Install (`./install.sh`):**
- `--apply` - Aplica cambios (default en setup.sh)
- `--dry-run` - Solo previsualiza (default en install.sh)
- `--profile <name>` - Usa perfil especifico
- `--layers <csv>` - Override de capas explicitas
- `--preserve <backup|skip>` - Preservacion de configs locales (default: backup)

## Defaults explicitos: `setup.sh` vs `install.sh`

Para evitar confusion, estos son los defaults reales:

- `./setup.sh` (sin flags): `--all` + modo `apply`.
- `./install.sh` (sin flags): modo `dry-run` + `--profile dev`.

En otras palabras: `setup.sh` aplica cambios por defecto; `install.sh` solo previsualiza por defecto.

## Uso rapido

```bash
# Ver que haria el setup sin aplicar cambios
./setup.sh --dry-run

# Setup completo (default: aplica cambios)
./setup.sh

# Setup no interactivo + dry-run
./setup.sh --yes --dry-run

# Setup con log completo guardado
./setup.sh --log

# Correr solo un modulo
./setup.sh --only devtools

# Correr todo excepto modulos puntuales
./setup.sh --skip ai-clis,project

# --- install.sh (granular, por capas) ---

# Default: dry-run + profile dev
./install.sh

# Aplicar perfil default (dev)
./install.sh --apply

# Elegir perfil
./install.sh --dry-run --profile dev

# Elegir capas explicitas (override de profile)
./install.sh --apply --layers toolchains,dotfiles-core

# Controlar preservacion de configs locales
./install.sh --apply --layers dotfiles-core --preserve backup
./install.sh --apply --layers dotfiles-core --preserve skip
```

## Actualizar setup existente

Si ya ejecutaste el setup y quieres actualizar paquetes/configs:

```bash
# Modo update: omite backups y checks, solo instala paquetes faltantes
./setup.sh --update

# Update con dry-run para ver que instalaria
./setup.sh --update --dry-run

# Update de un solo modulo
./setup.sh --update --only devtools
```

El modo `--update`:
- NO ejecuta `check-requirements` ni `detect-conflicts` (asume setup inicial OK)
- NO crea backups (asume que ya existen del setup inicial)
- Instala solo paquetes faltantes (modo incremental)
- Re-aplica symlinks (actualiza configs)

## Shell lint reproducible

No hay CI configurada en este repo. Para validar shell scripts de forma reproducible:

1) Instalar `shellcheck`:

```bash
# Arch / Manjaro
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
