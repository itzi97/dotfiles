local set_keymap_noremap = function(mode, keys, command)
  vim.api.nvim_set_keymap(mode, keys, command, {noremap = true, silent = true})
end

local function SetDictionary()
  -- if #vim.bo.dictionary > 0 then vim.bo.complete:append(k) end
  print("Hello world")
end

local function SetSpellKeys()
  set_keymap_noremap("n", "<leader>s", "vaWovEa<C-X><C-S>")
  set_keymap_noremap("n", "<leader>t", "vaWovEa<C-X><C-T>")
  set_keymap_noremap("n", "<leader>d", "vaWovEa<C-X><C-K>")
end

function SpellMathES()
  vim.wo.spell = true
  vim.bo.spelllang = 'es,math'
  -- vim.opt.complete:append("kspell")

  -- Add spellfiles
  vim.bo.spellfile = "$HOME/.vim/spell/math.utf-8.add"
  vim.bo.spellfile = vim.bo.spellfile .. ",$HOME/.vim/spell/es.utf-8.add"

  -- Add dictionaries
  vim.bo.dictionary = "$HOME/.vim/spell/dictionary/math_terms.txt"
  vim.bo.dictionary = vim.bo.dictionary .. ",/usr/share/dict/words"
  SetDictionary()

  -- Set keybinds
  SetSpellKeys()
end

function SpellCompES()
  vim.wo.spell = true
  vim.bo.spelllang = 'es,compsci'
  -- vim.opt.complete:append("kspell")

  -- Add spellfiles
  vim.bo.spellfile = "$HOME/.vim/spell/compsci.utf-8.add"
  vim.bo.spellfile = vim.bo.spellfile .. ",$HOME/.vim/spell/es.utf-8.add"
  vim.bo.spellfile = vim.bo.spellfile .. ",$HOME/.vim/spell/en.utf-8.add"

  -- Add dictionaries
  vim.bo.dictionary = "$HOME/.vim/spell/dictionary/compsci_terms.txt"
  vim.bo.dictionary = vim.bo.dictionary .. ",/usr/share/dict/words"
  SetDictionary()

  -- Set keybinds
  SetSpellKeys()
end

function SpellCompMathES()
  vim.wo.spell = true
  vim.bo.spelllang = 'es,compmath'
  -- vim.opt.complete:append("kspell")

  -- Add spellfiles
  vim.bo.spellfile = "$HOME/.vim/spell/compmath.utf-8.add"
  vim.bo.spellfile = vim.bo.spellfile .. ",$HOME/.vim/spell/es.utf-8.add"
  vim.bo.spellfile = vim.bo.spellfile .. ",$HOME/.vim/spell/en.utf-8.add"

  -- Add dictionaries
  vim.bo.dictionary = "$HOME/.vim/spell/dictionary/compmath_terms.txt"
  vim.bo.dictionary = vim.bo.dictionary .. ",/usr/share/dict/words"
  SetDictionary()

  -- Set keybinds
  SetSpellKeys()
end

function SpellPhysicsES()
  vim.wo.spell = true
  vim.bo.spelllang = 'es,physics'
  -- vim.opt.complete:append("kspell")

  -- Add spellfiles
  vim.bo.spellfile = "$HOME/.vim/spell/physics.utf-8.add"
  vim.bo.spellfile = vim.bo.spellfile .. ",$HOME/.vim/spell/es.utf-8.add"

  -- Add dictionaries
  vim.bo.dictionary = "$HOME/.vim/spell/dictionary/physics_terms.txt"
  vim.bo.dictionary = vim.bo.dictionary .. ",/usr/share/dict/words"
  SetDictionary()

  -- Set keybinds
  SetSpellKeys()
end
