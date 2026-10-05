-- Secret files, and the guard that keeps them away from the AI completion
-- source (minuet, which sends buffer text to Codestral).
local M = {}

-- Secret files by name. cloak masks their values on screen, and minuet never
-- runs in them. Matched against the file name, like an autocmd pattern without a /
M.patterns = {
  '.env*',
  'wrangler.toml',
  '.dev.vars',
  '.credentials',
  '*credentials*.yml', -- includes the decrypted temp file `rails credentials:edit` opens
  '*secrets*.yml',
  '*-production.yml', -- per-environment Rails credentials
  '*-development.yml',
  '*-test.yml',
  '.npmrc',
  '.netrc',
  '*.pem',
  '*.key', -- Rails master.key and credentials/*.key
}

-- The only filetypes minuet may complete in. An allowlist, so config and data
-- files (yaml, json, toml, .env, shell rc files, SQL with its connection
-- strings) and anything with no filetype fail safe and stay local.
M.ai_filetypes = {
  'lua', 'vim', 'ruby', 'eruby', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
  'swift', 'go', 'python', 'rust', 'c', 'cpp', 'html', 'css', 'scss',
}

-- Tools that decrypt secrets for editing (rails credentials:edit, sops, ...)
-- write them to the system temp dir under names nothing above can predict
local temp_dirs = { vim.uv.os_tmpdir(), '/tmp/', '/private/tmp/', '/var/folders/', '/private/var/folders/' }

local regexes = vim.tbl_map(function(pattern)
  return vim.regex(vim.fn.glob2regpat(pattern))
end, M.patterns)

--- Whether a buffer's file name matches one of the secret patterns
---@param bufnr? integer defaults to the current buffer
---@return boolean
function M.is_secret(bufnr)
  local name = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr or 0))
  for _, regex in ipairs(regexes) do
    if regex:match_str(name) then
      return true
    end
  end
  return false
end

--- Whether minuet may send this buffer's text to its provider
---@param bufnr? integer defaults to the current buffer
---@return boolean
function M.ai_allowed(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.tbl_contains(M.ai_filetypes, vim.bo[bufnr].filetype) or M.is_secret(bufnr) then
    return false
  end
  local path = vim.api.nvim_buf_get_name(bufnr)
  for _, dir in ipairs(temp_dirs) do
    if dir ~= '' and vim.startswith(path, dir) then
      return false
    end
  end
  return true
end

return M
