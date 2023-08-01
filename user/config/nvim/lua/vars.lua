vim.g.openedWithDir = 0

local argc = vim.fn.argc()

if argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) ~= 0 then
    vim.cmd.cd(vim.fn.argv(0))
    vim.g.openedWithDir = 1
end
if argc == 0 then vim.g.openedWithDir = 1 end

-- resolve() resolves any symbolic links.
-- fnameescape() escapes paths with spaces, e.g. "My\ Docs/".
vim.g.projectDir = vim.fn.fnameescape(vim.fn.resolve(vim.fn.getcwd()))

vim.g.border = {
    { "┌", "FloatBorder" }, { "─", "FloatBorder" }, { "┐", "FloatBorder" },
    { "│", "FloatBorder" }, { "┘", "FloatBorder" }, { "─", "FloatBorder" },
    { "└", "FloatBorder" }, { "│", "FloatBorder" }
}
