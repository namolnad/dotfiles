-- Paths the rg-backed telescope pickers skip. They run rg with --no-ignore so
-- gitignored files (.env, local settings) stay findable, which means build
-- output has to be excluded here rather than by each repo's .gitignore.
--
-- Globs follow .gitignore rules: a bare name matches at any depth, a leading or
-- inner / anchors it to the cwd, and a trailing / matches directories only.

-- Skipped by every picker
local ignored = {
  '.git/',
  'node_modules/',
  '.DS_Store',
  'tmp/',
  '.vim/undodir/',
  '.rbenv/versions/',
  '.rbenv/shims/',
  'Alfred.alfredpreferences/',
  -- Build output
  'app/assets/builds/',
  '.build/', -- SwiftPM
  '*.app/', -- built macOS app bundles
  '/build/', -- root only: a nested build/ can be source code
}

-- Fine to open by name, but only noise in grep results
local grep_only = {
  'log/',
  'package-lock.json',
}

local function exclude(globs)
  return vim.tbl_map(function(glob) return '--glob=!' .. glob end, globs)
end

return {
  files = exclude(ignored),
  grep = vim.list_extend(exclude(ignored), exclude(grep_only)),
}
