" json_pretty.vim : pack/unpack json formats
" author : Andrew Pressel <ufotofu@whistlinglemons.com>

if exists("b:did_json_pretty")
	finish
endif
let b:did_json_pretty = 1

Nmap ;p [pack json data]    :%!jq -c -r '.'<CR>
Nmap ;u [unpack json data]  :%!jq -r '.'<CR>

set foldmethod=syntax
set foldlevel=99
