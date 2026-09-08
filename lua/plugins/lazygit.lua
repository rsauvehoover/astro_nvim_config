-- AstroNvim maps `<Leader>gg` and `<Leader>tl` straight at `lazygit`, which exits
-- immediately when it is not given a git repository. toggleterm closes the float
-- as soon as the process exits, so that failure shows up as a floating window
-- that flashes for a split second -- lazygit's own "Must open lazygit in a git
-- repository" message is wiped along with it. Check first and say so plainly.

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    local maps = opts.mappings

    local function toggle_lazygit()
      local astro = require "astrocore"

      -- `file_worktree` only resolves the bare repositories registered in
      -- `vim.g.git_worktrees` (the dotfile-repo setup). A normal checkout
      -- returns `nil`, and lazygit is left to find the repository itself.
      local worktree = astro.file_worktree()
      if not worktree then
        local file = vim.api.nvim_buf_get_name(0)
        local dir = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
        -- `.git` is a directory in a normal checkout but a file in submodules
        -- and linked worktrees, so accept either
        if not vim.fs.find(".git", { path = dir, upward = true })[1] then
          vim.notify("Not in a git repository", vim.log.levels.WARN, { title = "lazygit" })
          return
        end
      end

      local flags = worktree
          and (" --work-tree=%s --git-dir=%s"):format(
            vim.fn.shellescape(worktree.toplevel),
            vim.fn.shellescape(worktree.gitdir)
          )
        or ""
      astro.toggle_term_cmd { cmd = "lazygit " .. flags, direction = "float" }
    end

    -- only wrap the mappings AstroNvim actually created; it sets them up only
    -- when both `git` and `lazygit` are executable
    for _, lhs in ipairs { "<Leader>gg", "<Leader>tl" } do
      local existing = maps.n[lhs]
      if existing then maps.n[lhs] = { toggle_lazygit, desc = existing.desc } end
    end
  end,
}
