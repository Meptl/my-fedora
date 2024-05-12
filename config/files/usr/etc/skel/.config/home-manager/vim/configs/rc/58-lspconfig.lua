vim.cmd("nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>")
vim.cmd("nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>")
vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
vim.keymap.set('n', '<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, opts)


local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- These are whatever's not provided by lazy-lsp
local servers = { 'nixd', 'openscad_lsp' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
    handlers = {['textDocument/publishDiagnostics'] = function(...) end  }
  }
end

vim.api.nvim_create_autocmd(
  { "BufEnter"},
  { pattern = "*",
    callback = function()
      vim.lsp.diagnostic.on_publish_diagnostics = function(...) end
    end,
  }
)
