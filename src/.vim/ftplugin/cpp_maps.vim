if exists("b:did_cpp_maps")
	finish
endif
let b:did_cpp_maps = 1

nmap <F10> 0o// ######## DEV-ONLY ########<ESC>o

set iskeyword+=:

"=====[ Shortcuts ]=========================================================
inoreab utq quick << 
inoreab cout std::cout
inoreab cerr std::cerr
inoreab endl std::endl

"=====[ Cpp Tidy ]==========================================================
nmap ;p :!clang-format -i %<CR>:e!<CR>
