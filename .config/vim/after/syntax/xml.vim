" syn-include embedded syntaxes

let b:current_syntax = ''
unlet b:current_syntax

syntax include @cdataPython syntax/python.vim
syntax region rcdataPython start="code.*python" end="/code" contains=@cdataPython
"syntax region rcdataPython start="code.*python" end="/code" contains=@cdataPython containedin=xmlCdataStart

let b:current_syntax = 'xml'
