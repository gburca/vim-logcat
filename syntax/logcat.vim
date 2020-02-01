" Vim syntax file
" Language:     Android LogCat and aplogd log file syntax
" Maintainer:   Gabriel Burca <gburca dash vim at ebixio dot com>
"
" adb logcat -v time *:V
" 06-09 14:36:00.000 V/AlarmManager( 1484): sending alarm {957ff72 type 3 *alarm*:android.intent.action.TIME_TICK}
" 06-09 10:42:06.729 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
"
" Or for aplogd logs (syntax group names end with '2'):
" 06-08 16:17:56.101   566   566 E NEW_BHD : Open /sys/class/power_supply/gb_battery
" 06-08 16:17:55.183 18677 20835 D ACDB-LOADER: ACDB -> ACDB_CMD_GET_AFE_COMMON_TABLE
" 06-08 16:17:55.183 18677 20835 D         : ACDBFILE_MGR:Read the devices count as zero, please check the acdb file

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match   lcBegin       display '^' nextgroup=lcMonotonic,lcDate
"
" Example:
" -0.123 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
" ^^^^^^^
syn match   lcMonotonic   '\s*-\?\d\+\.\d\d\d '
                                \ nextgroup=lcThread2

" Example:
" 06-09 10:42:06.729 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
" ^^^^^^
syn match   lcDate        '[0-1]\d-[0-3]\d '
                                \ nextgroup=lcTime

" Example:
" 06-09 10:42:06.729 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
"       ^^^^^^^^^^^^^
syn match   lcTime        '[0-1]\d:[0-5]\d:[0-5]\d\.\d\d\d '
                                \ nextgroup=lcTag,lcThread2

" Example:
" 06-09 10:42:06.729 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
"                    ^
syn match   lcPriority    '\<\(V\|D\|I\|W\|E\|F\)[\/ ]'me=e-1
                                \ containedin=lcTag,lcTag2

" The component may be empty in some cases
" Example:
" 06-09 10:42:06.729 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
"                      ^^^^^^
syn match   lcComponent   '\/[^[:space:](]\+'ms=s+1
                                \ containedin=lcTag

" Example:
" 06-09 10:42:06.729 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
"                    ^^^^^^^^^^
" 06-09 10:42:06.729 I/        ( 1484): Message with empty component
"                    ^^^^^^^^^^
syn match   lcTag         '\w\/[^(]*\s*'
                                \ nextgroup=lcThread contains=lcTagError,lcPriority,lcComponent,myTags

" 06-08 16:17:55.183 18677 20835 D ACDB-LOADER: ACDB -> ACDB_CMD_GET_AFE_COMMON_TABLE
"                                 ^^^^^^^^^^^^
" 06-08 16:17:55.183 18677 20835 D         : ACDBFILE_MGR:Read the devices count as zero, please check the acdb file
"                                 ^^^^^^^^^
syn match   lcTag2        '\w [^:]*\s*:'
                                \ nextgroup=lcMsgBody contains=lcPriority,lcTagError,myTags

" Must come after lcPriority and lcTag2 so it has higher match priority
syn match   lcTagError    'E\/[[:alnum:]_-]\+'
                                \ containedin=lcTag

" Example:
" 06-08 16:17:56.101   566   566 E NEW_BHD : Open /sys/class/power_supply/gb_battery
syn match   lcTagError2   'E [^:]\+:'
                                \ nextgroup=lcMsgBody

" Example:
" 06-09 10:42:06.729 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
"                              ^^^^^^^^
syn match   lcThread      '(\s*\d\+):'he=e-1
                                \ nextgroup=lcMsgBody contains=lcNumber
" Example:
" 06-08 16:17:55.183 18677 20835 D ACDB-LOADER: ACDB -> ACDB_CMD_GET_AFE_COMMON_TABLE
"                    ^^^^^^^^^^^^
syn match   lcThread2     '\s*\d\+\s\+\d\+ '
                                \ nextgroup=lcTag2,lcTagError2 contains=lcNumber

" Example:
" 06-09 10:42:06.729 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
"                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
syn match   lcMsgBody     contained ' .*'
                                \ contains=myKeywords

syn match   lcNumber      contained '0x[0-9a-fA-F]*\|\[<[0-9a-f]\+>\]\|\<\d[0-9a-fA-F]*'

hi def link lcDate        Comment
hi def link lcTime        SpecialComment
hi def link lcMonotonic   SpecialComment

hi def link lcTag         Statement
hi def link lcTag2        Statement
hi def link lcPriority    Identifier
hi def link lcTagError    Error
hi def link lcTagError2   Error
hi def link lcComponent   Normal

hi def link lcThread      Special
hi def link lcThread2     Special

hi def link lcMsgBody     Normal
hi def link lcNumber      Number

hi def link myTags        Function
hi def link myKeywords    Function

let b:current_syntax = "logcat"

let &cpo = s:cpo_save
unlet s:cpo_save
