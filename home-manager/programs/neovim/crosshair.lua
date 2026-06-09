local augroup = vim.api.nvim_create_augroup('CursorColumnMode', { clear = true })

vim.api.nvim_create_autocmd('ModeChanged', {
  group = augroup,
  callback = function()
    if vim.fn.mode():match('[vV\22]') then
      vim.api.nvim_set_hl(0, 'CursorColumn', { link = 'Visual' })
    else
      vim.api.nvim_set_hl(0, 'CursorColumn', { link = 'CursorLine' })
    end
  end,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = augroup,
  pattern = { '/', '?' },
  callback = function()
    vim.api.nvim_set_hl(0, 'CursorColumn', { link = 'IncSearch' })
  end,
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = augroup,
  pattern = { '/', '?' },
  callback = function()
    vim.api.nvim_set_hl(0, 'CursorColumn', { link = 'CursorLine' })
  end,
})
