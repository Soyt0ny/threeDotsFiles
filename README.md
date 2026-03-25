# threeDotsFiles

Repositorio de bootstrap portable para una maquina Arch-family, centrado en configuraciones de terminal/editor y sincronizacion controlada de dotfiles.

## Que es este proyecto

`threeDotsFiles` sirve para:

- Preparar una maquina nueva con un set base de herramientas y configuraciones.
- Mantener configuraciones versionadas de forma reproducible.
- Sincronizar cambios desde una maquina local hacia este repo con modo seguro por defecto.

Alcance actual:

- Configs de `zsh`, `tmux`, `nvim` y `opencode`.
- Listas de paquetes oficiales y AUR.
- Scripts de backup, linkeo por symlink y sync maquina -> repo.

No incluye:

- Autenticaciones, credenciales, tokens, claves privadas o secretos.
- Estado local de aplicaciones (cache, history, sesiones, etc.).

## Estructura del repo

```text
threeDotsFiles/
|-- install.sh
|-- sync.sh
|-- .gitignore
|-- README.md
|-- packages/
|   |-- official.txt
|   `-- aur.txt
|-- scripts/
|   |-- checks.sh
|   |-- backup.sh
|   |-- link.sh
|   `-- sync-excludes.txt
`-- configs/
    |-- zsh/.zshrc
    |-- tmux/.tmux.conf
    |-- nvim/README.md
    `-- opencode/README.md
```

Proposito por carpeta:

- `configs/`: fuente versionada de configuraciones portables.
- `packages/`: listas declarativas de paquetes a instalar manualmente.
- `scripts/`: bloques reutilizables usados por `install.sh` y `sync.sh`.

## Requisitos

- Sistema basado en Arch Linux.
- `pacman` (obligatorio).
- `yay` (opcional, solo para AUR).
- `git`.
- Recomendado: `rsync` para sincronizacion mas precisa en `sync.sh`.

## Que instala/configura exactamente

Paquetes (guiado, no instalacion automatica):

- Oficiales de Arch desde `packages/official.txt`.
- AUR desde `packages/aur.txt`.

Configuraciones por symlink:

- `configs/zsh/.zshrc` -> `~/.zshrc`
- `configs/tmux/.tmux.conf` -> `~/.tmux.conf`
- `configs/nvim/` -> `~/.config/nvim`
- `configs/opencode/` -> `~/.config/opencode`

Importante: hoy `install.sh` muestra comandos sugeridos para paquetes, pero no ejecuta `pacman` ni `yay` automaticamente.

## Como funciona `install.sh`

Modo por defecto: `dry-run` (seguro).

Comportamiento:

1. Ejecuta chequeos de entorno (`scripts/checks.sh`).
2. Muestra guia de instalacion de paquetes segun `packages/*.txt`.
3. Ejecuta backup de objetivos existentes (`scripts/backup.sh`).
4. Linkea configs por symlink (`scripts/link.sh`).

Uso:

```bash
./install.sh
./install.sh --dry-run
./install.sh --apply
```

## Como funciona `sync.sh`

Direccion fija: **maquina actual -> repo**.

Mapeos permitidos:

- `~/.zshrc` -> `configs/zsh/.zshrc`
- `~/.tmux.conf` -> `configs/tmux/.tmux.conf`
- `~/.config/nvim/` -> `configs/nvim/`
- `~/.config/opencode/` -> `configs/opencode/`

Modos y flags:

- `--dry-run`: vista previa (default).
- `--apply`: aplica copias/actualizaciones.
- `--prune`: elimina del repo archivos que ya no existen en origen (solo con `--apply`).
- `--verbose`: salida detallada.

Backups de sync:

- Antes de sobreescribir o borrar en modo apply, guarda backup en `.sync-backup/<timestamp>/`.

Uso:

```bash
./sync.sh --dry-run
./sync.sh --apply
./sync.sh --apply --prune
```

Advertencia sobre `--prune`:

- Puede borrar archivos versionados del repo si no existen en la maquina origen.
- Recomendado correr primero `--dry-run` y revisar candidatos de borrado.

## Flujo recomendado

1. `./sync.sh --dry-run`
2. Revisar plan de cambios en consola.
3. Revisar `git diff`.
4. `./sync.sh --apply`
5. Revisar de nuevo `git diff` y recien ahi commit.

## Seguridad

Este repo esta pensado para ser publico. Regla base: **no subir secretos**.

Controles incluidos:

- `.gitignore` con exclusiones para `.env`, llaves, credenciales, historiales, cache y estado local.
- `scripts/sync-excludes.txt` para bloquear patrones sensibles durante sync.
- Filtros extra en `sync.sh` para nombres/patrones de riesgo (`token`, `secret`, `auth`, etc.).
- Backups previos a sobrescrituras y borrados en modo apply.

Cosas que no se versionan:

- Tokens/API keys/credenciales.
- Archivos de autenticacion (`auth*`, `tokens*`, `credentials*`).
- Claves privadas/certificados (`*.pem`, `*.key`, `*.p12`, etc.).
- Historiales, sesiones, state y caches.

## Uso en maquina nueva (paso a paso)

1. Clonar repo.
2. Entrar al directorio.
3. Revisar listas en `packages/official.txt` y `packages/aur.txt`.
4. Instalar paquetes manualmente con `pacman`/`yay`.
5. Ejecutar `./install.sh` (dry-run).
6. Verificar salida y luego `./install.sh --apply`.
7. Abrir `zsh`, `tmux`, `nvim` y validar que los symlinks quedaron bien.

## Mantenimiento

- Para actualizar paquetes declarados:
  - editar `packages/official.txt` y/o `packages/aur.txt`.
- Para actualizar configuraciones desde la maquina:
  - `./sync.sh --dry-run`
  - revisar `git diff`
  - `./sync.sh --apply`
  - commit
- Para agregar nuevas rutas versionables:
  - sumar mapping en `scripts/link.sh` y en `sync.sh`.
  - reforzar exclusiones en `scripts/sync-excludes.txt` y `.gitignore`.

## Troubleshooting basico

- `pacman` no encontrado:
  - estas fuera de Arch-family o falta el binario en PATH.
- `yay` no encontrado:
  - es opcional; solo afecta instalacion de paquetes AUR.
- `sync.sh` no detecta cambios esperados:
  - correr con `--verbose`.
  - verificar si el archivo quedo excluido por seguridad.
- symlink no apunta a lo esperado:
  - revisar mapeos en `scripts/link.sh`.
  - re-ejecutar `./install.sh --apply`.

## Licencia

MIT (placeholder). Si todavia no existe `LICENSE`, agregarlo antes de distribuir formalmente.
