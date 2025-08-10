  local rbenv_root = vim.fn.trim(vim.fn.system('rbenv root'))
return {
  cmd = { rbenv_root .. '/shims/rubocop', '--lsp' },
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },
}
