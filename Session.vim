let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/code/projects/projects2020/side-projects/originals/goodgames
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
argglobal
%argdel
$argadd ~/code/projects/projects2020/side-projects/originals/goodgames
edit app/controllers/games_controller.rb
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
wincmd =
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 49 - ((21 * winheight(0) + 21) / 43)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
49
normal! 03|
wincmd w
argglobal
if bufexists("app/views/games/index.html.erb") | buffer app/views/games/index.html.erb | else | edit app/views/games/index.html.erb | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 23 - ((22 * winheight(0) + 22) / 44)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
23
normal! 0
wincmd w
2wincmd w
wincmd =
tabnext 1
badd +1 ~/code/projects/projects2020/side-projects/originals/goodgames
badd +8 app/controllers/games_controller.rb
badd +23 app/views/games/index.html.erb
badd +31 app/javascript/packs/application.js
badd +4 app/javascript/packs/server_rendering.js
badd +5 app/javascript/channels/index.js
badd +16 config/application.rb
badd +3 app/views/games/_games.html.erb
badd +8 app/javascript/controllers/index.js
badd +10 app/javascript/controllers/game_card_controller.ts
badd +1 tsconfig.json
badd +14 app/assets/stylesheets/application.scss
badd +10 app/controllers/application_controller.rb
badd +145 ~/.vimrc
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOS
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
nohlsearch
let g:this_session = v:this_session
let g:this_obsession = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
