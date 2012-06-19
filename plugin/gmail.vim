" File: plugin/gmail.vim
" Last Modified: 2012.06.20
" Author: yuratomo (twitter @yusetomo)

if !exists('g:gmail_command')
  let g:gmail_command = 'openssl'
endif

if !exists('g:gmail_server')
  let g:gmail_server = 'imap.gmail.com:993'
endif

let s:gmail_title_prefix = 'gmail-'
let [ s:MODE_MAILBOX, s:MODE_LIST, s:MODE_VIEW ] = range(3)

command! -nargs=0 Gmail :call gmail#start()

function! gmail#start()
  call s:openWindow()
  call s:login()
  call s:mailbox()
endfunction

function! gmail#exit()
  if exists('t:sub')
    call t:sub.kill(9)
    unlet t:sub
  endif
endfunction

function! gmail#open()
  if t:gmail_mode == s:MODE_MAILBOX
    let line = line('.')
    call s:select(t:gmail_maibox[line].name)
    call s:list()
  elseif t:gmail_mode == s:MODE_LIST
    let line = split(getline('.'), ' ')
    call s:body(line[0])
  endif
endfunction

function! gmail#back()
  if t:gmail_mode == s:MODE_MAILBOX
  elseif t:gmail_mode == s:MODE_LIST
    call s:mailbox()
  elseif t:gmail_mode == s:MODE_VIEW
    call s:list()
  endif
endfunction


function! s:login()
  if !exists('g:gmail_user_name')
    let g:gmail_user_name = input('input mail address:', '@gmail.com')
  endif
  if !exists('g:gmail_user_pass')
    let g:gmail_user_pass = input('input password:')
  endif

  let cmd = [g:gmail_command, 's_client', '-connect', g:gmail_server, '-quiet']
  let t:sub = vimproc#popen3(cmd)
  let idx = 1
  while !t:sub.stdout.eof
    let line = substitute(t:sub.stdout.read(), nr2char(10), '', 'g')
    if line != ''
      call setline(idx, line)
      redraw
      let idx += 1
      if stridx(line, '* OK') >= 0
        break
      endif
    else
      sleep
    endif
  endwhile

  let res = s:request("? login " . g:gmail_user_name . " " . g:gmail_user_pass)
  call setline(idx, res)
  redraw
endfunction

function! s:logout()
  let res = s:request("? logout")
  call setline(1, res)
endfunction

function! s:mailbox()
  call s:clear()
  if !exists('t:gmail_maibox')
    let idx = 1
    let t:gmail_maibox = []
    let t:gmail_maibox_line = []
    let results = s:request('? list "" "*"')
    for line in results[ 0 : -2 ]
      let s = strridx(line, '"', len(line)-2)
      call add(t:gmail_maibox, { 'name' : line[ s+1 : -2 ] } )
      call add(t:gmail_maibox_line, s:decodeUtf7(t:gmail_maibox[idx-1].name))
      call setline(idx, t:gmail_maibox_line[idx-1])
      let idx += 1
    endfor
  else
    call setline(1, t:gmail_maibox_line)
  endif
  let t:gmail_mode = s:MODE_MAILBOX
endfunction

function! s:select(mb)
  let res = s:request("? select " . a:mb)
  call setline(1, res)
  if exists('t:gmail_list')
    unlet t:gmail_list
  endif
endfunction

function! s:list()
  if !exists('t:gmail_list')
    let res = s:request("? search all")
    let items = split(res[0], ' ')
    let t:gmail_uids = items[ 2 : -1 ]

    let res = s:request("? fetch " . items[-10] . ":" . items[-1] . " (FLAGS BODY[HEADER.FIELDS (DATE FROM SUBJECT)])")
    let mail = ''
    let t:gmail_list = []
    for r in res
      let parts = split(r, ' ')
      if stridx(r, '*') == 0
        let mail = parts[1] . ' '
      elseif r == ")"
        call insert(t:gmail_list, mail, 0)
      elseif r =~ '=?.*?='
        let mail .= s:decodeMime(r)
      else
        let parts = split(r, ': ')
        if len(parts) > 1
          let mail .= parts[1] . ' '
        endif
      endif
    endfor
  endif
  call s:clear()
  call setline(1, t:gmail_list)
  redraw
  let t:gmail_mode = s:MODE_LIST
endfunction

function! s:body(id)
  call s:clear()
  let res = s:request("? fetch " . a:id . " RFC822.TEXT")
  call setline(1, map(res[1 : -3], "iconv(v:val, 'iso-2022-jp', &enc)"))
  let t:gmail_mode = s:MODE_VIEW
endfunction

function! s:request(cmd)
  let cmd = a:cmd . "\r\n"
  let res = ''
  call t:sub.stdin.write(cmd)
  let end = 0
  while !t:sub.stdout.eof
    let line = substitute(t:sub.stdout.read(), nr2char(10), '', 'g')
    if line != ''
      let res = res . line
      for line2 in split(line, "\r")
        if stridx(line2, '? ') == 0
          let end = 1
          break
        endif
      endfor
      if end == 1
        break
      endif
    else
      sleep
    endif
  endwhile
  return split(res, "\r")
endfunction

function! s:openWindow()
  if exists('t:sub')
    return
  endif

  let winnum = winnr('$')
  for winno in range(1, winnum)
    let bufname = bufname(winbufnr(winno))
    if bufname =~ s:gmail_title_prefix
       exe winno . "wincmd w"
       return
    endif
  endfor

  let id = 1
  while buflisted(s:gmail_title_prefix . id)
    let id += 1
  endwhile
  let bufname = s:gmail_title_prefix . id
  new
  silent edit `=bufname`
  setl bt=nofile noswf nowrap hidden nolist

  augroup gmail
    au!
    exe 'au BufDelete <buffer> call gmail#exit()'
  augroup END

  nnoremap <buffer> <CR> :call gmail#open()<CR>
  nnoremap <buffer> <BS> :call gmail#back()<CR>

endfunction

function! s:decodeUtf7(str)
  let mod1 = substitute(a:str, '&', '+', '')
  let mod2 = substitute(mod1, '&-', '&', 'g')
  let mod3 = substitute(mod2, ',', '/', 'g')
  return iconv(mod3, 'UTF-7', &enc)
endfunction

function! s:decodeMime(str)
  let end   = strridx(a:str, '?=')
  let start = strridx(a:str, '?', end-1)
  if start == -1 || end == -1
    return a:str
  endif
  return iconv(s:decodeBase64(a:str[ start+1 : end-1 ]), "iso-2022-jp", &enc)
endfunction

function! s:decodeBase64(data)
  let bytes = s:b64decode(split(a:data, '\zs'), s:standard_table, '=')
  return s:bytes2str(bytes)
endfunction

let s:standard_table = [
      \ "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P",
      \ "Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f",
      \ "g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v",
      \ "w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/"]

function! s:b64decode(b64, table, pad)
  let a2i = {}
  for i in range(len(a:table))
    let a2i[a:table[i]] = i
  endfor
  let bytes = []
  for i in range(0, len(a:b64) - 1, 4)
    let n = a2i[a:b64[i]] * 0x40000
          \ + a2i[a:b64[i + 1]] * 0x1000
          \ + (a:b64[i + 2] == a:pad ? 0 : a2i[a:b64[i + 2]]) * 0x40
          \ + (a:b64[i + 3] == a:pad ? 0 : a2i[a:b64[i + 3]])
    call add(bytes, n / 0x10000)
    call add(bytes, n / 0x100 % 0x100)
    call add(bytes, n % 0x100)
  endfor
  if a:b64[-1] == a:pad
    unlet a:b64[-1]
  endif
  if a:b64[-2] == a:pad
    unlet a:b64[-1]
  endif
  return bytes
endfunction

function! s:bytes2str(bytes)
  return eval('"' . join(map(copy(a:bytes), 'printf(''\x%02x'', v:val)'), '') . '"')
endfunction

function! s:clear()
  % delete _
endfunction

