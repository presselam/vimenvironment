if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufRead,BufNewFile *.t    setfiletype perl
  au! BufRead,BufNewFile *.yam  setfiletype yam
augroup END
