local rbenv_root = vim.fn.trim(vim.fn.system('rbenv root'))
return {
  cmd = { rbenv_root .. '/shims/ruby-lsp' },
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  init_options = {
    formatter = 'auto',
  },
}
