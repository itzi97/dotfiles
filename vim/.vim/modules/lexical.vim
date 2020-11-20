func! SpellMath()
  set spell
  set complete+=kspell
  set spelllang=es_es,en_us,math

  " Add spellfiles
  set spellfile=~/.vim/spell/math.utf-8.add
  set spellfile+=~/.vim/spell/en.utf-8.add
  set spellfile+=~/.vim/spell/es.utf-8.add

  " Add dictionaries
  set dictionary=~/.vim/spell/dictionary/math_terms.txt
  set dictionary+=/usr/share/dict/words

  if len(&dictionary) > 0
    setlocal complete+=k
  else
    setlocal complete-=k
  endif

  " Add thesaurus
  set thesaurus=~/.vim/spell/thesaurus/math_synonyms.txt
  set thesaurus+=~/.vim/spell/thesaurus/mthesaur.txt

  if len(&thesaurus) > 0
    setlocal complete+=s
  else
    setlocal complete-=s
  endif
endfunc

command! SpellMath call SpellMath()

func! SpellComp()
  set spell
  set complete+=kspell
  set spelllang=es_es,en_us,compsci

  " Add spellfiles
  set spellfile=~/.vim/spell/compsci.utf-8.add
  set spellfile+=~/.vim/spell/en.utf-8.add
  set spellfile+=~/.vim/spell/es.utf-8.add

  " Add dictionaries
  set dictionary=~/.vim/spell/dictionary/compsci_terms.txt
  set dictionary+=/usr/share/dict/words

  if len(&dictionary) > 0
    setlocal complete+=k
  else
    setlocal complete-=k
  endif

  " Add thesaurus
  set thesaurus=~/.vim/spell/thesaurus/compsci_synonyms.txt
  set thesaurus+=~/.vim/spell/thesaurus/mthesaur.txt

  if len(&thesaurus) > 0
    setlocal complete+=s
  else
    setlocal complete-=s
  endif
endfunc

command! SpellComp call SpellComp()

func! SpellCompMath()
  set spell
  set complete+=kspell
  set spelllang=es_es,en_us,compmath

  " Add spellfiles
  set spellfile=~/.vim/spell/compmath.utf-8.add
  set spellfile+=~/.vim/spell/en.utf-8.add
  set spellfile+=~/.vim/spell/es.utf-8.add

  " Add dictionaries
  set dictionary=~/.vim/spell/dictionary/compmath_terms.txt
  set dictionary+=/usr/share/dict/words

  if len(&dictionary) > 0
    setlocal complete+=k
  else
    setlocal complete-=k
  endif

  " Add thesaurus
  set thesaurus=~/.vim/spell/thesaurus/compmath_synonyms.txt
  set thesaurus+=~/.vim/spell/thesaurus/mthesaur.txt

  if len(&thesaurus) > 0
    setlocal complete+=s
  else
    setlocal complete-=s
  endif
endfunc

command! SpellCompMath call SpellCompMath()

nnoremap <buffer> <leader>s vaWovEa<C-X><C-S>
nnoremap <buffer> <leader>t vaWovEa<C-X><C-T>
nnoremap <buffer> <leader>d vaWovEa<C-X><C-K>

augroup au_spelling abort
  autocmd!
  autocmd FileType textile,pandoc call SpellMath()
augroup END
