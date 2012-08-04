if version < 700
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

"source $VIMRUNTIME/syntax/html.vim
syn keyword gmailSearch     search
syn keyword gmailWeek       Wed Mon Mon Fri Thu Wed Tue Tue Sun
syn keyword gmailMonth      Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
syn match   gmailTime       "\d\d:\d\d:\d\d"
syn match   gmailUnseen0    "(0)"
syn match   gmailUnseenNone "(-)"
syn match   gmailUnseen     "(\d*)"
syn match   gmailUnseenMail "^\*.*$"
syn match   gmailQuote      "^>[^>].*$"
syn match   gmailQuote2     "^>>[^>].*$"
syn match   gmailQuote3     "^>>>[^>].*$"
syn match   gmailQuote4     "^>>>>[^>].*$"
syn match   gmailQuote5     "^>>>>>[^>].*$"
syn match   gmailLabel      "^\(From:\|To:\|Subject:\|Cc:\|Bcc:\)"
syn match   gmailButton1    "\[next\]"
syn match   gmailButton2    "\[send\]"
syn match   gmailButton3    "\[reply\]"
syn match   gmailButton4    "\[reply_all\]"
syn match   gmailButton5    "\[forward\]"
syn match   gmailButton6    "\[easy_html_view\]"
syn match   gmailUrl        contained "\vhttps?://[[:alnum:]][-[:alnum:]]*[[:alnum:]]?(\.[[:alnum:]][-[:alnum:]]*[[:alnum:]]?)*\.[[:alpha:]][-[:alnum:]]*[[:alpha:]]?(:\d+)?(/[^[:space:]]*)?$"
syn match   gmailUrl        "http[s]\=://\S*"
syn match   gmailBracket1   /�u\_.\{-0,30}�v/
syn match   gmailBracket2   /�w\_.\{-0,30}�x/
syn match   gmailBracket3   /�y\_.\{-0,30}�z/

hi default link gmailButton1    WildMenu
hi default link gmailButton2    WildMenu
hi default link gmailButton3    WildMenu
hi default link gmailButton4    WildMenu
hi default link gmailButton5    WildMenu
hi default link gmailButton6    WildMenu
hi default link gmailLabel      StatusLine
hi default link gmailSearch     Title
hi default link gmailWeek       Boolean
hi default link gmailMonth      Boolean
hi default link gmailTime       Number
hi default link gmailUnseen     Label
hi default link gmailUnseen0    Ignore
hi default link gmailUnseenNone Ignore
hi default link gmailQuote      Comment
hi default link gmailQuote2     Statement
hi default link gmailQuote3     Question
hi default link gmailQuote4     Function
hi default link gmailQuote5     Label
hi default link gmailSelect     PmenuSel
hi default link gmailHorizontal Underlined
hi default link gmailUrl        Comment
hi default link gmailBracket1   Macro
hi default link gmailBracket2   Macro
hi default link gmailBracket3   Macro

hi gmailBold    gui=bold
hi default link gmailUnseenMail String

let b:current_syntax = 'gmail'
