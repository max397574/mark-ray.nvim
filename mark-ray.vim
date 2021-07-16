"prevent loading the file twice
if exists("g:loaded_markray")
    finish
endif

lua require("mark-ray").init()

let g:loaded_markray = 1
