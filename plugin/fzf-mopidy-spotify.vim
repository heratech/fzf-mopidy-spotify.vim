" fzf-mopidy-spotify.vim - Music fuzzy-finder for Mopidy-Spotify
" Author:   Andrea Orru
" Version:  0.1
" License:  BSD 2-clause

function! OutHandler(job, message)
endfunction

function! ExitHandler(job, status)

endfunction

function! s:MpcAdd(line)
    let l:file = split(a:line)[0]
    silent execute "!mpc add " . l:file . " > /dev/null &"
    silent execute "!mpc play $(mpc playlist | wc -l)" . " > /dev/null &"
    execute ':redraw!'
"    let cmd = "mpc add" . l:file
"    let job = job_start(cmd, {'out_io': 'buffer', 'out_name': 'make_buffer', 'out_cb': 'OutHandler', 'exit_cb': 'ExitHandler'})
endfunction

function! s:MpcLoadPlaylist(list)
    silent execute "!mpc clear && mpc load " . a:list . " && mpc play > /dev/null &"
    execute ':redraw!'
endfunction

function! s:MpcPlay()
    silent execute "!mpc play > /dev/null &"
    execute ':redraw!'
endfunction

function! s:MpcPause()
    silent execute "!mpc pause > /dev/null &"
    execute ':redraw!'
endfunction

function! s:MpcToggle()
    silent execute "!mpc toggle > /dev/null &"
    execute ':redraw!'
endfunction


function! s:MpcNext()
    silent execute "!mpc next > /dev/null &"
    execute ':redraw!'
endfunction

function! s:MpcPrev()
    silent execute "!mpc prev > /dev/null &"
    execute ':redraw!'
endfunction

function! s:Song(title)
    call fzf#run(fzf#wrap(
    \   {'source': 'mpc search -f "%file% %artist% - %title% (%album%)" title "' . a:title . '" | grep "^spotify:track"',
    \    'sink': function('s:MpcAdd'),
    \    'options': '-m --with-nth 2..' }))
endfunction

function! s:SongByArtist(artist)
    call fzf#run(fzf#wrap(
    \   {'source': 'mpc search -f "%file% %title% (%album%)" artist "' . a:artist . '" | grep "^spotify:track"',
    \    'sink': function('s:MpcAdd'),
    \    'options': '-m --with-nth 2..' }))
endfunction

function! s:AlbumByArtist(artist)
    call fzf#run(fzf#wrap(
    \   {'source': 'mpc search -f "%file% %album%" artist "' . a:artist . '" | grep "^spotify:album"',
    \    'sink': function('s:MpcAdd'),
    \    'options': '-m --with-nth 2..' }))
endfunction

function! s:AlbumByTitle(title)
    call fzf#run(fzf#wrap(
    \   {'source': 'mpc search -f "%file% %album%" album "' . a:title . '" | grep "^spotify:album"',
    \    'sink': function('s:MpcAdd'),
    \    'options': '-m --with-nth 2..' }))
endfunction

function! s:Playlist(title)
    call fzf#run(fzf#wrap(
    \   {'source': 'mpc lsplaylists | grep ' . a:title ,
    \    'sink': function('s:MpcLoadPlaylist'),
    \    'options': '-m' }))
endfunction

command! -nargs=+ Song       call <sid>Song(<q-args>)
command! -nargs=+ ArtistSong call <sid>SongByArtist(<q-args>)
command! -nargs=+ Album      call <sid>AlbumByArtist(<q-args>)

command! -nargs=+ AlbumByTitle  call <sid>AlbumByTitle(<q-args>)
command! -nargs=+ Playlist      call <sid>Playlist(<q-args>)

command! MpcPlay    call <sid>MpcPlay()
command! MpcPause   call <sid>MpcPause()
command! MpcToggle   call <sid>MpcToggle()
command! MpcNext    call <sid>MpcNext()
command! MpcPrev    call <sid>MpcPrev()
