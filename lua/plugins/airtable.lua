-- 23ae04a1-c71a-4bfd-bbaf-468ae29462ee
vim.pack.add {
  Gh 'nvim-lua/plenary.nvim',
  Gh 'nvim-telescope/telescope.nvim',
  { src = Gh 'maxdlr/airtable.nvim', version = 'main' },
}

local fieldNames = {
  status = 'Status',
  priority = 'Priority',
  assignee = 'Assignee',
  createdBy = 'Created By',
  lastStatusChange = 'Last status change',
  featureFlag = 'Feature Flag',
  lienPR = 'Lien PR',
  todoDev = 'Todo Dev',
  qa = 'QA',
  qaAssignee = 'QA Assignee',
  todo = 'To do',
  enCours = 'En cours',
  prAValider = 'PR à Valider',
  bloque = 'Bloqué',
  pretAQA = 'Prêt à QA',
  titre = 'Titre',
  reviewers = 'Reviewers',
  description = 'Description',
  application = 'Application',
}

local status_result_line = {
  field = fieldNames.status,
  hl = {
    { value = fieldNames.todo, color = '#E32424' },
    { value = fieldNames.enCours, color = '#FFBF5E' },
    { value = fieldNames.prAValider, color = '#5F94E3' },
    { value = fieldNames.bloque, color = '#8E8E8E' },
  },
}

local status_result_line_prefix = {
  { { icon = '󰲶', color = '#FFBF5E' }, { field = fieldNames.status, value = fieldNames.enCours } },
  { { icon = '󱖫', color = '#E32424' }, { field = fieldNames.status, value = fieldNames.todo } },
  { { icon = '', color = '#5F94E3' }, { field = fieldNames.status, value = fieldNames.prAValider } },
  { { icon = '', color = '#8E8E8E' }, { field = fieldNames.status, value = fieldNames.bloque } },
}

require('airtable').setup {
  -- export AIRTABLE_TOKEN="replace_me" in your env # — generate at airtable.com/create/tokens
  token_env = 'AIRTABLE_TOKEN',

  -- Find your base id - https://support.airtable.com/articles/4688931572-finding-airtable-ids#finding-base-ids
  base_id = 'appYmJlF6osd8y9Pi',

  -- Exact name of the table you want to query (or use its table id, e.g. 'tbllXO2M4wggGjKlO')
  table_name = '🚀 Team Gedeon',

  default_filter = 'Mine',

  buffer = {
    -- Map these to your team's actual Airtable field names
    fields = {
      { key = 'Title', field = fieldNames.titre },
      { key = 'Last update', field = fieldNames.lastStatusChange },
      { key = 'Priority', field = fieldNames.priority },
      { key = 'Status', field = fieldNames.status },
      { key = 'Feature Flag', field = fieldNames.featureFlag },
      { key = 'QA Assignee', field = fieldNames.qaAssignee },
      { key = 'Reviewers', field = fieldNames.reviewers },
      { key = 'Lien PR', field = fieldNames.lienPR },
      { key = 'Description', field = fieldNames.description },
      { key = 'Todo Dev', field = fieldNames.todoDev },
      { key = 'QA', field = fieldNames.qa },
    },

    editable = {
      { field = fieldNames.status, type = 'select' },
      { field = fieldNames.lienPR, type = 'text', name = 'Edit Lien PR' },
      { field = fieldNames.featureFlag, type = 'text', name = 'Edit ff' },
      { field = fieldNames.todoDev, type = 'text', name = 'Edit Todo Dev' },
    },
  },

  pickers = {
    {
      name = 'Mine',

      filters = {
        { field = fieldNames.assignee, value = 'Maxime' },
        {
          field = fieldNames.status,
          value = {
            fieldNames.todo,
            fieldNames.enCours,
            fieldNames.prAValider,
            fieldNames.pretAQA,
          },
        },
      },

      sort = { field = fieldNames.priority, order = 'asc' },

      result_line = {
        status_result_line,
        { field = fieldNames.titre, hl = '#E3E3E3' },
        { field = fieldNames.priority, hl = '#00FFFF' },
        { field = fieldNames.createdBy, hl = '#F2BCFF' },
        { field = fieldNames.application },
      },

      result_line_prefix = status_result_line_prefix,
    },

    {
      name = 'Everyone',

      filters = {
        {
          field = fieldNames.status,
          value = {
            fieldNames.todo,
            fieldNames.enCours,
            fieldNames.prAValider,
          },
        },
      },

      sort = { field = fieldNames.lastStatusChange, order = 'desc' },

      result_line = {
        { field = fieldNames.lastStatusChange },
        { field = fieldNames.assignee, hl = '#48FF1B' },
        { field = fieldNames.createdBy, hl = '#F2BCFF' },
        { field = fieldNames.titre, hl = '#E3E3E3' },
      },

      result_line_prefix = status_result_line_prefix,
    },
  },
}

vim.keymap.set('n', '<leader>rr', function() require('airtable').resume() end, { desc = 'Airtable' })

local airtable_menu = {
  { 'Everyone', function() require('airtable').open 'Everyone' end },
  { 'Mine', function() require('airtable').open 'Mine' end },
}

vim.keymap.set('n', '<leader>ra', Command_picker('Airtable', airtable_menu, { border_color = '#D1FF1B' }), { desc = 'Airtable ' })
