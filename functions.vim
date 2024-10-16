augroup filetype_fold
  autocmd!
  autocmd filetype vim,yaml setlocal foldmethod=marker
  autocmd filetype json setlocal foldmethod=indent conceallevel=2
  autocmd filetype html setlocal tabstop=2 shiftwidth=2 expandtab
augroup end

" if the current file type is html set indentation to 2 spaces.

" sort JSON
command SortJSON %!jq -S .

" you can split a window into sections by typing `:split` or `:vsplit`.
" display cursorline and cursorcolumn only in active window.
augroup cursor_off
  autocmd!
  autocmd winleave * set nocursorline
  autocmd winenter * set cursorline
augroup end

" save on lost focus/exit
autocmd focuslost,vimleavepre * silent! w

function! Relpath(filename)
  let cwd = getcwd()
  let s = substitute(a:filename, l:cwd . "/" , "", "")
  return s
endfunction

" https://vim.fandom.com/wiki/Auto_highlight_current_word_when_idle#Script
" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
