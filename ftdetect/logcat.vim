fun! s:DetectLogcat()
	" Detect from the 2nd line. The 1st line could be:
	" -------- beginning of system
	if line('$') > 1 && getline(2) =~# '.* [F|E|W|I|D|V] .*:.*'
		set filetype=logcat
	endif
endfun

au BufNewFile,BufRead *.lc set filetype=logcat
au BufNewFile,BufRead *.logcat set filetype=logcat
au BufNewFile,BufRead Boot-*_Set-*_Stream-*.txt set filetype=logcat
au BufNewFile,BufRead * call s:DetectLogcat()

