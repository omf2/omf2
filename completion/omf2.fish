complete -c omf2 -s h -l help -d 'Print Oh-My-Fish-2 help'
complete -c omf2 -s v -l version -d 'Print Oh-My-Fish-2 version'

function __set_omf_command_completions
    set --local commands (omf2 --get-commands)
    set --local cmd
    set --local func_details

    for cmd in $commands
        set func_details (functions -vD _omf2cmd__$cmd)
        complete -c omf2 -x -n __fish_use_subcommand -a $cmd -d $func_details[-1]
    end
end
__set_omf_command_completions
