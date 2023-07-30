local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') ..
                             '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            'git', 'clone', '--depth', '1',
            'https://github.com/wbthomason/packer.nvim', install_path
        })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- NOTE: do not move pinned pkg versions to flake.nix to allow
-- this Neovim configuration to be used in other systems
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'junegunn/fzf',
        commit = 'dad26d81dfb7393388ec31b6a4b921c4d722a95a',
        run = ":call fzf#install()"
    }
    use {
        'junegunn/fzf.vim',
        commit = '9ceac718026fd39498d95ff04fa04d3e40c465d7'
    }
    use {
        'airblade/vim-gitgutter',
        commit = 'f19b6203191d69de955d91467a5707959572119b'
    }
    use {
        'f-person/git-blame.nvim',
        commit = '08e75b7061f4a654ef62b0cac43a9015c87744a2'
    }
    use {
        'tpope/vim-commentary',
        commit = '3654775824337f466109f00eaf6759760f65be34'
    }
    use {
        'tpope/vim-surround',
        commit = 'bf3480dc9ae7bea34c78fbba4c65b4548b5b1fea'
    }
    use {'lambdalisue/fern.vim', tag = 'v1.51.1'}
    use {
        'preservim/vim-markdown',
        commit = 'c3f83ebb43b560af066d2a5d66bc77c6c05293b1'
    }
    use {
        'neovim/nvim-lspconfig',
        commit = 'b6091272422bb0fbd729f7f5d17a56d37499c54f'
    }
    use {
        'hrsh7th/cmp-nvim-lsp',
        commit = '44b16d11215dce86f253ce0c30949813c0a90765'
    }
    use {
        'L3MON4D3/LuaSnip',
        commit = 'e81cbe6004051c390721d8570a4a0541ceb0df10'
    }
    use {
        'saadparwaiz1/cmp_luasnip',
        commit = '18095520391186d634a0045dacaa346291096566'
    }
    use {
        'hrsh7th/nvim-cmp',
        commit = 'c4e491a87eeacf0408902c32f031d802c7eafce8'
    }
    -- depends on $OPENAI_API_KEY https://beta.openai.com/account/api-keys
    use {'aduros/ai.vim', commit = '7051afa7a5f43b3fe79b7ad20d976d75e07e4e48'}
    -- cosmetic
    use {
        'sheerun/vim-polyglot',
        commit = 'bc8a81d3592dab86334f27d1d43c080ebf680d42'
    }
    use {
        'arcticicestudio/nord-vim',
        commit = '0748955e9e8d9770b44f2bec8456189430b37d9d'
    }
    use {
        'wuelnerdotexe/vim-astro',
        commit = '34732be5e9a5c28c2409f4490edf92d46d8b55a9'
    }

    if packer_bootstrap then require('packer').sync() end
    -- always install missing packages on startup
    require('packer').install()
end)
