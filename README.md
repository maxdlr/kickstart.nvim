https://github.com/nvim-telescope/telescope.nvim/issues/2778#issuecomment-2202572413

You can do that with the `toggle_preview` action

    telescope.setup({                                                                                                                                                             
      defaults = {                                                                                                                                                                  
        mappings = {                                                                                                                                                                  
          i = {                                                                                                                                                                         
            ['<C-p>'] = require('telescope.actions.layout').toggle_preview                                                                                                            
          }                                                                                                                                                                         
        },
        preview = {                                                                                                                                                                          
          hide_on_startup = true -- hide previewer when picker starts
        }                                                                                                               
      }
    })