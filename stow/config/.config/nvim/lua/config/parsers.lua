-- Treesitter parsers every machine installs. The treesitter setup installs
-- them at startup without waiting; the headless bootstrap
-- (scripts/nvim-update.lua) installs the same list and waits for it.
return {
  'vimdoc', 'javascript', 'typescript', 'tsx', 'c', 'lua', 'rust',
  'jsdoc', 'bash', 'ruby', 'embedded_template', 'sql', 'make', 'yaml',
  'dockerfile', 'html', 'css', 'json', 'regex', 'swift', 'go', 'python',
}
