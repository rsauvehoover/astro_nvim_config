-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Mason installs the npm-based language servers (vtsls, vue, json/html/css,
-- yaml, docker, ...) by spawning `npm`. Node lives under nvm, which is only
-- sourced from `.zprofile` -- a login shell -- so starting Neovim from a GUI or
-- any non-login shell leaves it off `$PATH` and every npm package fails with
-- `Could not find executable "npm" in PATH`. Put nvm's Node on `$PATH` here so
-- it is present however Neovim was started.
local nvm_dir = vim.env.NVM_DIR or vim.fn.expand "~/.nvm"

local function parse(version)
  local parts = {}
  for n in version:gmatch "%d+" do
    parts[#parts + 1] = tonumber(n)
  end
  return parts
end

---@return boolean # whether version `a` sorts above version `b`
local function newer(a, b)
  local left, right = parse(a), parse(b)
  for i = 1, math.max(#left, #right) do
    local x, y = left[i] or 0, right[i] or 0
    if x ~= y then return x > y end
  end
  return false
end

local function nvm_node_bin()
  local root = nvm_dir .. "/versions/node"
  if vim.fn.isdirectory(root) == 0 then return end
  local installed = vim.fn.readdir(root)

  -- `nvm alias default` may hold a full version ("v24.20.0"), a bare major
  -- ("24"), or name a version that is no longer installed
  local alias_file, default = nvm_dir .. "/alias/default", nil
  if vim.fn.filereadable(alias_file) == 1 then default = vim.trim(vim.fn.readfile(alias_file)[1] or "") end

  local function best_of(matches)
    local best
    for _, version in ipairs(installed) do
      if matches(version) and (not best or newer(version, best)) then best = version end
    end
    return best
  end

  local best
  if default and default ~= "" then
    best = best_of(
      function(version)
        return version == default or version == "v" .. default or vim.startswith(version, "v" .. default .. ".")
      end
    )
  end
  best = best or best_of(function() return true end)

  if best then return root .. "/" .. best .. "/bin" end
end

local node_bin = nvm_node_bin()
if node_bin and vim.fn.isdirectory(node_bin) == 1 and not vim.env.PATH:find(node_bin, 1, true) then
  vim.env.PATH = node_bin .. ":" .. vim.env.PATH
end
