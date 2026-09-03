-- 23ae04a1-c71a-4bfd-bbaf-468ae29462ee
vim.pack.add {
  Gh 'nvim-lua/plenary.nvim',
  Gh 'nvim-telescope/telescope.nvim',
  { src = Gh 'maxdlr/airtable.nvim', version = 'styling' },
}

require('airtable').setup {
  -- export AIRTABLE_TOKEN="replace_me" in your env # — generate at airtable.com/create/tokens
  token_env = 'AIRTABLE_TOKEN',

  -- Find your base id - https://support.airtable.com/articles/4688931572-finding-airtable-ids#finding-base-ids
  base_id = 'appYmJlF6osd8y9Pi',

  -- Exact name of the table you want to query (or use its table id, e.g. 'tbllXO2M4wggGjKlO')
  table_name = '🚀 Team Gedeon',

  buffer = {
    -- Map these to your team's actual Airtable field names
    fields = {
      title = 'Titre',
      feature_flag = 'Feature Flag',
      lien_pr = 'Lien PR',
      priority = 'Priority',
      description = 'Description',
      todo_dev = 'Todo Dev',
      qa = 'QA',
      qa_assignee = 'Assignee QA',
    },
  },

  default_filter = 'All',

  pickers = {
    {
      name = 'All',

      filters = {
        { field = 'Assignee', value = 'Maxime' },
        { field = 'Status', value = { 'To do', 'En cours', 'PR à Valider' } },
      },

      sort = { field = 'Priority', order = 'asc' },

      result_line = {
        {
          field = 'Status',
          hl = {
            { value = 'To do', color = '#E32424' },
            { value = 'En cours', color = '#FFBF5E' },
            { value = 'PR à Valider', color = '#5F94E3' },
            -- { value = 'Bloqué', color = '#8E8E8E' },
          },
        },
        { field = 'Titre', hl = '#E3E3E3' },
        { field = 'Priority', hl = '#00FFFF' },
        { field = 'Created By', hl = '#F2BCFF' },
        { field = 'Application' },
      },

      result_line_prefix = {
        { { icon = '󰲶', color = '#FFBF5E' }, { field = 'Status', value = 'En cours' } },
        { { icon = '󱖫', color = '#E32424' }, { field = 'Status', value = 'To do' } },
        { { icon = '', color = '#5F94E3' }, { field = 'Status', value = 'PR à Valider' } },
        -- { { icon = '', color = '#8E8E8E' }, { field = 'Status', value = 'Bloqué' } },
      },
    },
  },
}

vim.keymap.set('n', '<leader>^', function() require('airtable').open() end, { desc = 'Airtable' })
