if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufRead,BufNewFile *.t    setfiletype perl
  au! BufRead,BufNewFile *.yam  setfiletype yam
  au! BufRead,BufNewFile *.p[lm]6  setfiletype perl6
augroup END
