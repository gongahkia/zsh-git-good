local M = {}

function M.check()
  local adapter = require("zsh-git-good")
  local config = adapter.config()
  vim.health.start("zsh-git-good")
  if type(vim.system) ~= "function" then
    vim.health.error("Neovim 0.10 or later is required for the event adapter")
    return
  end
  if vim.fn.executable(config.executable) ~= 1 then
    vim.health.error("zsh-git-good executable is unavailable", { "Set executable in require('zsh-git-good').setup({ executable = '/path/to/zsh-git-good' })" })
    return
  end
  vim.health.ok("event emitter executable is available")
  local ok, result = pcall(function()
    return vim.system({ config.executable, "permissions" }, { text = true }):wait(250)
  end)
  if not ok or type(result) ~= "table" then
    vim.health.warn("could not read activity permission state")
  elseif result.code == 0 and (result.stdout or ""):find('"activity": true', 1, true) then
    vim.health.ok("activity permission is enabled")
  elseif result.code == 0 then
    vim.health.warn("activity permission is disabled; no Neovim events will be retained", { "Run: zsh-git-good permissions enable activity" })
  else
    vim.health.warn("could not read activity permission state")
  end
end

return M
