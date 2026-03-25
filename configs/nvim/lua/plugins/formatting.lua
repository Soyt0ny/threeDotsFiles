-- Formatters configuration with conform.nvim
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Web
        html = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        -- Python
        python = { "ruff_format", "ruff_organize_imports" },

        -- Go
        go = { "goimports", "gofumpt" },

        -- Rust (usa rustfmt via rust-analyzer, no necesita config extra)

        -- C++
        cpp = { "clang_format" },
        c = { "clang_format" },

        -- PHP/Laravel
        php = { "php_cs_fixer" },

        -- Bash
        sh = { "shfmt" },
        bash = { "shfmt" },

        -- Lua
        lua = { "stylua" },

        -- SQL
        sql = { "sql_formatter" },
      },
      format_on_save = {
        -- Formato automático al guardar (opcional, comentá si no querés)
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
