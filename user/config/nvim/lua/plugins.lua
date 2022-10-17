local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'junegunn/fzf',
    commit = 'dad26d81dfb7393388ec31b6a4b921c4d722a95a',
    run = ":call fzf#install()"
  }
  use {
    'junegunn/fzf.vim',
    commit = '9ceac718026fd39498d95ff04fa04d3e40c465d7',
  }
  use {
    'airblade/vim-gitgutter',
    commit = 'f19b6203191d69de955d91467a5707959572119b',
  }
  use {
    'f-person/git-blame.nvim',
    commit = '08e75b7061f4a654ef62b0cac43a9015c87744a2',
  }
  use {
    'tpope/vim-commentary',
    commit = '3654775824337f466109f00eaf6759760f65be34',
  }
  use {
    'tpope/vim-surround',
    commit = 'bf3480dc9ae7bea34c78fbba4c65b4548b5b1fea',
  }
  use {
    'lambdalisue/fern.vim',
    tag = 'v1.51.1',
  }
  use {
    'preservim/vim-markdown',
    commit = 'c3f83ebb43b560af066d2a5d66bc77c6c05293b1',
  }
  -- cosmetic
  use {
    'sheerun/vim-polyglot',
    commit = 'bc8a81d3592dab86334f27d1d43c080ebf680d42',
  }
  use {
    'arcticicestudio/nord-vim',
    commit = '0748955e9e8d9770b44f2bec8456189430b37d9d',
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)