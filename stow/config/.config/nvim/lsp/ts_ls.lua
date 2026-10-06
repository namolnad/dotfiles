-- Where typescript-language-server looks for the workspace's TypeScript: it
-- walks up from the root and takes the first of these that exists
local ts_lib_dirs = {
  'node_modules/typescript/lib',
  '.vscode/pnpify/typescript/lib',
  '.yarn/sdks/typescript/lib',
  '.pnpm/sdks/typescript/lib',
}

--- Whether typescript-language-server will find a usable tsserver for `root`.
---@param root string
---@return boolean
local function has_workspace_tsserver(root)
  local dir = root
  while true do
    for _, lib in ipairs(ts_lib_dirs) do
      local path = vim.fs.joinpath(dir, lib)
      if vim.uv.fs_stat(path) then
        return vim.uv.fs_stat(vim.fs.joinpath(path, 'tsserver.js')) ~= nil
      end
    end
    local parent = vim.fs.dirname(dir)
    if parent == dir then
      return false
    end
    dir = parent
  end
end

---@type vim.lsp.Config
return {
  init_options = { hostInfo = 'neovim' },
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
        or vim.list_extend(root_markers, { '.git' })
    -- exclude deno
    local deno_path = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' })
    local project_root = vim.fs.root(bufnr, root_markers)
    if deno_path and (not project_root or #deno_path >= #project_root) then
      return
    end
    -- We fallback to the current working directory if no project root is found
    local root = project_root or vim.fn.getcwd()
    -- Without the workspace's own TypeScript the server can only fail to start:
    -- Homebrew's typescript is the native compiler from 7.0 on and ships no tsserver
    if not has_workspace_tsserver(root) then
      return
    end
    on_dir(root)
  end,
  handlers = {
    -- handle rename request for certain code actions like extracting functions / types
    ['_typescript.rename'] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.show_document({
        uri = result.textDocument.uri,
        range = {
          start = result.position,
          ['end'] = result.position,
        },
      }, client.offset_encoding)
      vim.lsp.buf.rename()
      return vim.NIL
    end,
  },
  commands = {
    ['editor.action.showReferences'] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local file_uri, position, references = unpack(command.arguments)

      local quickfix_items = vim.lsp.util.locations_to_items(references --[[@as any]], client.offset_encoding)
      vim.fn.setqflist({}, ' ', {
        title = command.title,
        items = quickfix_items,
        context = {
          command = command,
          bufnr = ctx.bufnr,
        },
      })

      vim.lsp.util.show_document({
        uri = file_uri --[[@as string]],
        range = {
          start = position --[[@as lsp.Position]],
          ['end'] = position --[[@as lsp.Position]],
        },
      }, client.offset_encoding)
      ---@diagnostic enable: assign-type-mismatch

      vim.cmd('botright copen')
    end,
  },
  on_attach = function(client, bufnr)
    -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
    -- `vim.lsp.buf.code_action()` if specified in `context.only`.
    vim.api.nvim_buf_create_user_command(bufnr, 'LspTypescriptSourceAction', function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, 'source.')
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
          diagnostics = {},
        },
      })
    end, {})
  end,
}
