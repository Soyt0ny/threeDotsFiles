-- Mason auto-install configuration
-- This ensures all necessary LSPs, formatters, and linters are installed
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- HTML/CSS/Web
        "html-lsp", -- HTML language server
        "css-lsp", -- CSS language server
        "emmet-ls", -- Emmet for HTML/CSS
        "tailwindcss-language-server", -- Tailwind CSS

        -- JavaScript/TypeScript/React
        "typescript-language-server", -- TypeScript/JavaScript
        "eslint-lsp", -- ESLint
        "prettier", -- Formatter for JS/TS/React/HTML/CSS

        -- Python
        "pyright", -- Python LSP (más rápido que pylsp)
        "ruff", -- Python linter y formatter (súper rápido)
        "debugpy", -- Python debugger

        -- Go
        "gopls", -- Go language server
        "goimports", -- Go imports formatter
        "gofumpt", -- Go formatter (mejor que gofmt)
        "golangci-lint", -- Go linter

        -- Rust
        "rust-analyzer", -- Rust LSP
        "codelldb", -- Debugger para Rust/C++

        -- C++
        "clangd", -- C/C++ language server
        "clang-format", -- C++ formatter

        -- PHP/Laravel
        "intelephense", -- PHP LSP (mejor que phpactor)
        "php-cs-fixer", -- PHP formatter

        -- Bash
        "bash-language-server", -- Bash LSP
        "shellcheck", -- Bash linter
        "shfmt", -- Shell script formatter

        -- Markdown
        "marksman", -- Markdown LSP
        "markdownlint-cli2", -- Markdown linter

        -- Lua (para configurar Neovim)
        "lua-language-server",
        "stylua", -- Lua formatter

        -- JSON/YAML
        "json-lsp",
        "yaml-language-server",

        -- SQL (recomendado si usás bases de datos)
        "sqlls", -- SQL language server

        -- Docker (recomendado)
        "docker-compose-language-service",
        "dockerfile-language-server",

        -- TOML (para Rust Cargo.toml)
        "taplo", -- TOML LSP
      },
    },
  },
}
