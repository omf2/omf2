# omf2 - Oh-My-Fish-2 manager

function _omf2_get_commands --description "Get the names of commands"
    # The 'omf2' command structure is represented by functions named:
    # _omf2cmd__foo__bar__baz. This function finds those command functions and parses
    # them into their command structure.
    set --local prefix _omf2cmd__(string join '__' $argv '')
    string split ',' (functions -a) \
        | string match -gr '^'$prefix'(.+)$' \
        | string split __ -f1 \
        | uniq
end

function _omf2_usage
    set --local commands (_omf2_get_commands)
    set --local cmd
    set --local func_details

    echo "Usage:"
    echo "  omf2 <command> [<flags...>] <arguments...>"
    echo "  omf2 [-h | --help] [-v | --version]"
    echo
    echo "Commands:"
    for cmd in $commands
        set func_details (functions -vD _omf2cmd__$cmd)
        printf "  %-15s %s\n" $cmd $func_details[-1]
    end
    echo
    echo "Flags:"
    echo "  -h, --help     Print this help message"
    echo "  -v, --version  Print version"
end

#region: omf2 <command>

function _omf2cmd__contrib --description "Manage OMF2 contribs"
    if functions --query _omf2cmd__contrib__$argv[1]
        _omf2cmd__contrib__$argv[1] $argv[2..]
    else
        echo >&2 "omf2 contrib: unknown command '$argv[1]'"
        return 1
    end
end

function _omf2cmd__prompt --description "View and pick OMF2 prompts"
    # Temp HACK!
    if test "$argv[1]" = choose
        _omf2cmd__prompt__choose $argv[2..]
    else if test "$argv[1]" = list
        _omf2cmd__prompt__list $argv[2..]
    else
        echo "omf2 prompt: TODO - implement this!"
    end
end

function _omf2cmd__plugin --description "View and pick OMF2 plugins"
    echo "omf2 plugin: TODO!!"
end

function _omf2cmd__theme --description "View and pick OMF2 themes"
    echo "omf2 theme: TODO!!"
end

#endregion

#region omf2 contrib <command>

function _omf2cmd__contrib__install --description "Install external contribs"
    echo "omf2 contrib: TODO!!"
end

function _omf2cmd__contrib__remove --description "Remove contrib"
    echo "omf2 contrib: TODO!!"
end

function _omf2cmd__contrib__list --description "List contribs"
    set --local dotgit
    set --local contrib
    for dotgit in $omf2_path/plugins/*/*/.git
        set contrib (path resolve $dotgit/..)
        echo (path dirname $contrib | path basename)/(path basename $contrib)
    end
end

function _omf2cmd__contrib__update --description "Update contribs"
    set --local contrib_dir
    set --local oldsha
    set --local newsha
    for contrib in (_omf2cmd__contrib__list)
        set contrib_dir $omf2_path/plugins/$contrib
        set oldsha (command git -C $contrib_dir rev-parse --short HEAD)
        command git -C $contrib_dir pull --quiet --ff --depth 1 --rebase --autostash
        set newsha (command git -C $contrib_dir rev-parse --short HEAD)
        if test $oldsha != $newsha
            echo "Plugin updated: $contrib ($oldsha->$newsha)"
        end
    end
    echo "Contrib updates complete."
end

#endregion

#region omf2 plugin <command>

## TODO: ???

#endregion

#region omf2 prompt <command>

function _omf2cmd__prompt__choose --description "Pick a OMF2 prompt"
    # if not type -q starship
    #     echo >&2 "OMF2: Starship not found. Install starship from htts://starship.rs"
    #     return 1
    # end

    # starship init fish | source

    # set --local contrib
    # set --local starship_config
    # if test -n "$prompt"
    #     for contrib in omz_starship_prompts
    #         if test -r $__ohmyfish2/contribs/$contrib/prompts/$prompt.toml
    #             set starship_config $__ohmyfish2/contribs/$contrib/prompts/$prompt.toml
    #             break
    #         end
    #     end

    #     if test -n "$starship_config"
    #         set -gx STARSHIP_CONFIG $starship_config
    #     else
    #         echo >&2 "OMF2: prompt not found! List prompts with 'omf2 prompts --list'"
    #         return 1
    #     end
    # end
end

function _omf2cmd__prompt__list --description "List OMF2 prompts"
    # for contrib in omz_starship_prompts
    #     path basename $__ohmyfish2/contribs/$contrib/prompts/*.toml | path change-extension ''
    # end
    echo "omf2 prompt list: TODO!! Implement me"
end

#endregion

#region omf2 theme <command>

## TODO: ???

#endregion

function omf2 --description "The Oh-My-Fish-2 config manager"
    set --query omf2_path || set -Ux omf2_path $__fish_config_dir/.omf2
    set --local omf2_version 0.0.1

    argparse --name omf2 --ignore-unknown h/help v/version get-commands -- $argv

    if test -n "$_flag_help"
        _omf2_usage
    else if test -n "$_flag_version"
        echo "omf2, version $omf2_version"
    else if test -n "$_flag_get_commands"
        _omf2_get_commands $argv
    else if test (count $argv) -eq 0
        _omf2_usage
    else if functions --query _omf2cmd__$argv[1]
        _omf2cmd__$argv[1] $argv[2..]
    else
        echo >&2 "omf2: unknown command '$argv[1]'"
        return 1
    end
end
