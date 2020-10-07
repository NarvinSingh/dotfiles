"
" Appearance
"

" Cursors
if &term =~ 'xterm'
  let s:cursor_normal = "\<Esc>[2 q\<Esc>]12;DeepSkyBlue1\x7"
  let s:cursor_insert = "\<Esc>[5 q\<Esc>]12;DeepSkyBlue1\x7"
  let s:cursor_replace = "\<Esc>[3 q\<Esc>]12;DeepSkyBlue1\x7"
  let s:cursor_reset = s:cursor_insert

  autocmd VimEnter * silent execute '!printf "' . s:cursor_normal . '"'
  autocmd VimLeave * silent execute '!printf "' . s:cursor_reset . '"'

  if exists('$TMUX')
    let s:tmux_pre = "\<Esc>Ptmux;\<Esc>"
    let s:tmux_post = "\<Esc>\\"
    let &t_EI .= s:tmux_pre . s:cursor_normal . s:tmux_post
    let &t_SI .= s:tmux_pre . s:cursor_insert . s:tmux_post
    let &t_SR .= s:tmux_pre . s:cursor_replace . s:tmux_post
  else
    let &t_EI .= s:cursor_normal
    let &t_SI .= s:cursor_insert
    let &t_SR .= s:cursor_replace
  endif
endif

" Colors
let s:bwc_plain = 15
let s:bwc_snow = 15
let s:bwc_coal = 16
let s:bwc_brightgravel = 252
let s:bwc_lightgravel = 245
let s:bwc_gravel = 243
let s:bwc_mediumgravel = 241
let s:bwc_deepgravel = 238
let s:bwc_deepergravel = 236
let s:bwc_darkgravel = 235
let s:bwc_blackgravel = 233
" let s:bwc_blackestgravel = 232
let s:bwc_dalespale = 221
let s:bwc_dirtyblonde = 222
let s:bwc_taffy = 196
" let s:bwc_saltwatertaffy = 121
let s:bwc_tardis = 39
let s:bwc_orange = 214
let s:bwc_lime = 154
let s:bwc_dress = 211
let s:bwc_toffee = 137
" let s:bwc_coffee = 173
" let s:bwc_darkroast = 95
let s:bwc_gutter = s:bwc_blackgravel
let s:bwc_tabline = s:bwc_blackgravel

function! s:SetColorGroup(group, fg, ...)
  let hi_cmd = 'highlight ' . a:group

  if strlen(a:fg)
    let hi_cmd .= ' ctermfg=' . a:fg
  endif
  if a:0 >= 1 && strlen(a:1)
    let hi_cmd .= ' ctermbg=' . a:1
  endif
  if a:0 >= 2 && strlen(a:2)
    let hi_cmd .= ' cterm=' . a:2
  endif

  execute hi_cmd
endfunction

set background=dark

" General/UI {{{
call s:SetColorGroup('Normal', s:bwc_plain, s:bwc_blackgravel)
call s:SetColorGroup('Folded', s:bwc_mediumgravel, 'bg', 'none')
call s:SetColorGroup('VertSplit', s:bwc_lightgravel, 'bg', 'none')
call s:SetColorGroup('CursorLine', '', s:bwc_darkgravel, 'none')
call s:SetColorGroup('CursorColumn', '', s:bwc_darkgravel)
call s:SetColorGroup('ColorColumn', '', s:bwc_darkgravel)
call s:SetColorGroup('TabLine', s:bwc_plain, s:bwc_tabline, 'none')
call s:SetColorGroup('TabLineFill', s:bwc_plain, s:bwc_tabline, 'none')
call s:SetColorGroup('TabLineSel', s:bwc_coal, s:bwc_tardis, 'none')
call s:SetColorGroup('MatchParen', s:bwc_dalespale, s:bwc_darkgravel, 'bold')
call s:SetColorGroup('NonText', s:bwc_deepgravel, 'bg')
call s:SetColorGroup('SpecialKey', s:bwc_deepgravel, 'bg')
call s:SetColorGroup('Visual', '', s:bwc_deepgravel)
call s:SetColorGroup('VisualNOS', '', s:bwc_deepgravel)
call s:SetColorGroup('Search', s:bwc_coal, s:bwc_dalespale, 'bold')
call s:SetColorGroup('IncSearch', s:bwc_coal, s:bwc_tardis, 'bold')
call s:SetColorGroup('Underlined', 'fg', '', 'underline')
call s:SetColorGroup('StatusLine', s:bwc_coal, s:bwc_tardis, 'bold')
call s:SetColorGroup('StatusLineNC', s:bwc_snow, s:bwc_deepgravel, 'bold')
call s:SetColorGroup('Directory', s:bwc_dirtyblonde, '', 'bold')
call s:SetColorGroup('Title', s:bwc_lime)
call s:SetColorGroup('ErrorMsg', s:bwc_taffy, 'bg', 'bold')
call s:SetColorGroup('MoreMsg', s:bwc_dalespale, '', 'bold')
call s:SetColorGroup('ModeMsg', s:bwc_dirtyblonde, '', 'bold')
call s:SetColorGroup('Question', s:bwc_dirtyblonde, '', 'bold')
call s:SetColorGroup('WarningMsg', s:bwc_dress, '', 'bold')
call s:SetColorGroup('Tag', '', '', 'bold')
" }}}

" Gutter {{{
call s:SetColorGroup('LineNr', s:bwc_mediumgravel, s:bwc_gutter)
call s:SetColorGroup('SignColumn', '', s:bwc_gutter)
call s:SetColorGroup('FoldColumn', s:bwc_mediumgravel, s:bwc_gutter)
" }}}

" Cursor {{{
call s:SetColorGroup('Cursor', s:bwc_coal, s:bwc_tardis, 'bold')
call s:SetColorGroup('vCursor', s:bwc_coal, s:bwc_tardis, 'bold')
call s:SetColorGroup('iCursor', s:bwc_coal, s:bwc_tardis, 'none')
" }}}

" Syntax highlighting {{{
call s:SetColorGroup('Special', s:bwc_plain)
call s:SetColorGroup('Comment', s:bwc_gravel)
call s:SetColorGroup('Todo', s:bwc_snow, 'bg', 'bold')
call s:SetColorGroup('SpecialComment', s:bwc_snow, 'bg', 'bold')
call s:SetColorGroup('String', s:bwc_dirtyblonde)
call s:SetColorGroup('Statement', s:bwc_taffy, '', 'bold')
call s:SetColorGroup('Keyword', s:bwc_taffy, '', 'bold')
call s:SetColorGroup('Conditional', s:bwc_taffy, '', 'bold')
call s:SetColorGroup('Operator', s:bwc_taffy, '', 'none')
call s:SetColorGroup('Label', s:bwc_taffy, '', 'none')
call s:SetColorGroup('Repeat', s:bwc_taffy, '', 'none')
call s:SetColorGroup('Identifier', s:bwc_orange, '', 'none')
call s:SetColorGroup('Function', s:bwc_orange, '', 'none')
call s:SetColorGroup('PreProc', s:bwc_lime, '', 'none')
call s:SetColorGroup('Macro', s:bwc_lime, '', 'none')
call s:SetColorGroup('Define', s:bwc_lime, '', 'none')
call s:SetColorGroup('PreCondit', s:bwc_lime, '', 'bold')
call s:SetColorGroup('Constant', s:bwc_toffee, '', 'bold')
call s:SetColorGroup('Character', s:bwc_toffee, '', 'bold')
call s:SetColorGroup('Boolean', s:bwc_toffee, '', 'bold')
call s:SetColorGroup('Number', s:bwc_toffee, '', 'bold')
call s:SetColorGroup('Float', s:bwc_toffee, '', 'bold')
call s:SetColorGroup('SpecialChar', s:bwc_dress, '', 'bold')
call s:SetColorGroup('Type', s:bwc_dress, '', 'none')
call s:SetColorGroup('StorageClass', s:bwc_taffy, '', 'none')
call s:SetColorGroup('Structure', s:bwc_taffy, '', 'none')
call s:SetColorGroup('Typedef', s:bwc_taffy, '', 'bold')
call s:SetColorGroup('Exception', s:bwc_lime, '', 'bold')
call s:SetColorGroup('Error', s:bwc_snow, s:bwc_taffy, 'bold')
call s:SetColorGroup('Debug', s:bwc_snow, '', 'bold')
call s:SetColorGroup('Ignore', s:bwc_gravel, '', '')
" }}}

" Completion Menu {{{
call s:SetColorGroup('Pmenu', s:bwc_plain, s:bwc_deepergravel)
call s:SetColorGroup('PmenuSel', s:bwc_coal, s:bwc_tardis, 'bold')
call s:SetColorGroup('PmenuSbar', '', s:bwc_deepergravel)
call s:SetColorGroup('PmenuThumb', s:bwc_brightgravel)
" }}}

" Diffs {{{
call s:SetColorGroup('DiffDelete', s:bwc_coal, s:bwc_coal)
call s:SetColorGroup('DiffAdd', '', s:bwc_deepergravel)
call s:SetColorGroup('DiffChange', '', s:bwc_darkgravel)
call s:SetColorGroup('DiffText', s:bwc_snow, s:bwc_deepergravel, 'bold')
" }}}

" Spelling {{{
call s:SetColorGroup('SpellCap', s:bwc_dalespale, 'bg', 'undercurl,bold')
call s:SetColorGroup('SpellBad', '', 'bg', 'undercurl')
call s:SetColorGroup('SpellLocal', '', '', 'undercurl')
call s:SetColorGroup('SpellRare', '', '', 'undercurl')
" }}}

syntax on

" Visual Elements
set number relativenumber cursorline colorcolumn=81

"
" Mappings
"

" Leader
let mapleader = ' '

" Normal mode
inoremap ii <C-o>:stopinsert<CR>
vnoremap ii <Esc>

" Navigate splits
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Edit .vimrc
nnoremap <silent> <Leader>ev :vsplit $MYVIMRC<CR>

" Save and source current file
nnoremap <silent> <Leader>ss :w<CR>
  \ :source %<CR>
  \ :echo 'Sourced ' . bufname('%')<CR>

" Trim trailing whitespace
nnoremap <Leader>tw :%s/\s\+$//gc<CR>

