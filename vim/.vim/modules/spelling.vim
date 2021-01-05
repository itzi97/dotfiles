function! SetDictionary() abort
  if len(&dictionary) > 0
    setlocal complete+=k
  else
    setlocal complete-=k
  endif
endfunction

function! SetThesaurus() abort
  if len(&thesaurus) > 0
    setlocal complete+=s
  else
    setlocal complete-=s
  endif
endfunction

function! SetSpellKeys() abort
  nnoremap <buffer> <leader>s vaWovEa<C-X><C-S>
  nnoremap <buffer> <leader>t vaWovEa<C-X><C-T>
  nnoremap <buffer> <leader>d vaWovEa<C-X><C-K>
endfunction

function! SpellMathES() abort
  setlocal spell
  setlocal spelllang=es,math
  setlocal complete+=kspell

  " Add spellfiles
  setlocal spellfile=~/.vim/spell/math.utf-8.add
  setlocal spellfile+=~/.vim/spell/es.utf-8.add

  " Add dictionaries
  setlocal dictionary=~/.vim/spell/dictionary/math.txt
  setlocal dictionary+=/usr/share/dict/words
  call SetDictionary()

  " Add thesaurus
  setlocal thesaurus=~/.vim/spell/thesaurus/compsci_synonyms.txt
  setlocal thesaurus+=~/.vim/spell/thesaurus/mthesaur.txt
  call SetThesaurus()

  " Set keybinds
  call SetSpellKeys()
endfunction

command! SpellMathES call SpellMathES()

function! SpellCompES() abort
  setlocal spell
  setlocal spelllang=es,compsci
  setlocal complete+=kspell

  " Add spellfiles
  setlocal spellfile=~/.vim/spell/compsci.utf-8.add
  setlocal spellfile+=~/.vim/spell/es.utf-8.add

  " Add dictionaries
  setlocal dictionary=~/.vim/spell/dictionary/compsci_terms.txt
  setlocal dictionary+=/usr/share/dict/words
  call SetDictionary()

  " Add thesaurus
  setlocal thesaurus=~/.vim/spell/thesaurus/compsci_synonyms.txt
  setlocal thesaurus+=~/.vim/spell/thesaurus/mthesaur.txt
  call SetThesaurus()

  " Set keybinds
  call SetSpellKeys()
endfunction

command! SpellCompES call SpellCompES()

function! SpellCompMathES() abort
  setlocal spell
  setlocal spelllang=es,compmath
  setlocal complete+=kspell

  " Add spellfiles
  setlocal spellfile=~/.vim/spell/compmath.utf-8.add
  setlocal spellfile+=~/.vim/spell/en.utf-8.add
  setlocal spellfile+=~/.vim/spell/es.utf-8.add

  " Add dictionaries
  setlocal dictionary=~/.vim/spell/dictionary/compmath_terms.txt
  setlocal dictionary+=/usr/share/dict/words
  call SetDictionary()

  " Add thesaurus
  setlocal thesaurus=~/.vim/spell/thesaurus/compmath_synonyms.txt
  setlocal thesaurus+=~/.vim/spell/thesaurus/mthesaur.txt
  call SetThesaurus()

  " Set keybinds
  call SetSpellKeys()

endfunction

command! SpellCompMathES call SpellCompMathES()

