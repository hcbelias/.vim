" OmniSharp won't work without this setting
filetype plugin on

"This is the default value, setting it isn't actually necessary
let g:OmniSharp_host = "http://localhost:2000"

"Set the type lookup function to use the preview window instead of the status line
"let g:OmniSharp_typeLookupInPreview = 1

"Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 1

"Showmatch significantly slows down omnicomplete
"when the first match contains parentheses.
set noshowmatch

"Super tab settings - uncomment the next 4 lines
"let g:SuperTabDefaultCompletionType = 'context'
"let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
"let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
"let g:SuperTabClosePreviewOnPopupClose = 1

"don't autoselect first item in omnicomplete, show if only one item (for preview)
"remove preview if you don't want to see any documentation whatsoever.
set completeopt=longest,menuone,preview
" Fetch full documentation during omnicomplete requests. 
" There is a performance penalty with this (especially on Mono)
" By default, only Type/Method signatures are fetched. Full documentation can still be fetched when
" you need it with the :OmniSharpDocumentation command.
" let g:omnicomplete_fetch_documentation=1

"Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
"You might also want to look at the echodoc plugin
set splitbelow

" Get Code Issues and syntax errors
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']

augroup omnisharp_commands
    autocmd!

    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    "autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

    " Synchronous build (blocks Vim)
    "autocmd FileType cs nnoremap <buffer> <F5> :wa!<cr>:OmniSharpBuild<cr>
    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <buffer> <leader>gb :wa!<cr>:OmniSharpBuildAsync<cr>
    " automatic syntax check on events (TextChanged requires Vim 7.4)
    "autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    "The following commands are contextual, based on the current cursor position.

    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<cr>
    autocmd FileType cs nnoremap <buffer> <leader>fi :OmniSharpFindImplementations<cr>
    autocmd FileType cs nnoremap <buffer> <leader>ft :OmniSharpFindType<cr>
    autocmd FileType cs nnoremap <buffer> <leader>fs :OmniSharpFindSymbol<cr>
    autocmd FileType cs nnoremap <buffer> <leader>fu :OmniSharpFindUsages<cr>
    "finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <leader>fm :OmniSharpFindMembers<cr>
    " cursor can be anywhere on the line containing an issue 
    autocmd FileType cs nnoremap <buffer> <leader>x  :OmniSharpFixIssue<cr>  
    autocmd FileType cs nnoremap <buffer> <leader>fx :OmniSharpFixUsings<cr>
    autocmd FileType cs nnoremap <buffer> <leader>tt :OmniSharpTypeLookup<cr>
    autocmd FileType cs nnoremap <buffer> <leader>dc :OmniSharpDocumentation<cr>
    "navigate up by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-K> :OmniSharpNavigateUp<cr>
    autocmd FileType cs onoremap <buffer> <C-K> :OmniSharpNavigateUp<cr>
    autocmd FileType cs vnoremap <buffer> <C-K> :OmniSharpNavigateUp<cr>
    "navigate down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-J> :OmniSharpNavigateDown<cr>
    autocmd FileType cs onoremap <buffer> <C-J> :OmniSharpNavigateDown<cr>
    autocmd FileType cs vnoremap <buffer> <C-J> :OmniSharpNavigateDown<cr>

    autocmd BufEnter *.cs setlocal cmdheight=2
    autocmd BufLeave *.cs setlocal cmdheight=1


    " this setting controls how long to wait (in ms) before fetching type / symbol information.
    autocmd FileType cs set updatetime=500
    " Remove 'Press Enter to continue' message when type information is longer than one line.

    " Contextual code actions (requires CtrlP)
    autocmd FileType cs nnoremap <buffer> <leader><space> :OmniSharpGetCodeActions<cr>
    " Run code actions with text selected in visual mode to extract method
    autocmd FileType cs vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

    " rename with dialog
    autocmd FileType cs nnoremap <buffer> <leader>nm :OmniSharpRename<cr>
    autocmd FileType cs nnoremap <buffer> <F2> :OmniSharpRename<cr>      
    " rename without dialog - with cursor on the symbol to rename... ':Rename newname'
    autocmd FileType cs command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

    " Force OmniSharp to reload the solution. Useful when switching branches etc.
    autocmd FileType cs nnoremap <buffer> <leader>rl :OmniSharpReloadSolution<cr>
    autocmd FileType cs nnoremap <buffer> <leader>cf :OmniSharpCodeFormat<cr>
    " Load the current .cs file to the nearest project
    autocmd FileType cs nnoremap <buffer> <leader>tp :OmniSharpAddToProject<cr>

    " (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
    " Add syntax highlighting for types and interfaces
    autocmd FileType cs nnoremap <buffer> <leader>th :OmniSharpHighlightTypes<cr>
augroup END

nnoremap <buffer> <leader>ss :OmniSharpStartServer<cr>
nnoremap <buffer> <leader>sp :OmniSharpStopServer<cr>

"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden
