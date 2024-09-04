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

function _omf2cmd__contrib --argument-names cmd --description "Manage OMF2 contribs"
    switch $cmd
        case list
            for dotgit in $omf2_path/contribs/*/*/.git
                set --local contrib (path resolve $dotgit/..)
                echo (path dirname $contrib | path basename)/(path basename $contrib)
            end

        case install remove update
            isatty || read --local --null --array stdin && set --append argv $stdin

            set --local argv_contribs $argv[2..]
            if test (count $argv_contribs) -eq 0 && test $cmd != update
                echo >&2 "omf2: Not enough arguments for command: $cmd" && return 1
            end

            set --local contribs
            set --local shas
            for contrib in $argv_contribs
                set --local parts (string split '/' $contrib | count)
                if test $parts -ne 2
                    test $parts -eq 3 && test $cmd = install
                    or begin
                        echo >&2 "omf2: Invalid contrib name: $contrib"
                        return 1
                    end
                end
                if test $cmd = install
                    test $parts -eq 2
                    and set --append contribs github.com/$contrib
                    or set --append contribs $contrib
                else if test -d $omf2_path/contribs/$contrib
                    set --append contribs $contrib
                else
                    echo >&2 "omf2: Contrib not installed: $contrib" && return 1
                end
            end

            # Update with no params means update all
            if test $cmd = update && test (count $argv_contribs) -eq 0
                set contribs (omf2 contrib list)
            end

            # If we made it here, we have good enough contribs to move forward
            echo (set_color --bold)"omf2 contrib $cmd version $omf2_version"(set_color normal)
            set --local shas
            for contrib in $contribs
                set --local contrib_dir $omf2_path/contribs/(string match -r '[^/]+\/[^/]+$' $contrib)
                switch $cmd
                    case install
                        echo "Cloning "(set_color --bold green)$contrib(set_color normal)
                        test -d $contrib_dir && rm -rf -- $contrib_dir
                        command git clone --quiet --depth 1 --recursive --shallow-submodules \
                            https://$contrib $contrib_dir &
                    case remove
                        echo "Removing "(set_color --bold red)$contrib(set_color normal)
                        rm -rf -- $contrib_dir
                    case update
                        echo "Updating "(set_color --bold blue)$contrib(set_color normal)
                        set --append shas (command git -C $contrib_dir rev-parse --short HEAD)
                        command git -C $contrib_dir pull --quiet --ff --depth 1 --rebase --autostash &
                end
            end
            wait
            echo (count $contribs)" Contrib(s) affected."

        case '*'
            echo >&2 "omf2: Invalid contrib command: $argv[1]" && return 1
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
    # echo "omf2 plugin: TODO!!"
    # if functions --query _omf2cmd__plugin__$argv[1]
    #     _omf2cmd__contrib__$argv[1] $argv[2..]
    # else
    #     echo >&2 "omf2 contrib: unknown command '$argv[1]'"
    #     return 1
    # end
end

function _omf2cmd__theme --description "View and pick OMF2 themes"
    echo "omf2 theme: TODO!!"
end

#endregion

#region omf2 contrib <command>

# function _omf2cmd__contrib__install --description "Install external contribs"
#     echo (set_color --bold)"omf2 contrib install version $omf2_version"(set_color normal)
#     set --local giturl
#     for contrib in $argv
#         switch "$contrib"
#             case '*/*/*'
#                 set giturl https://$contrib
#             case '*/*'
#                 set giturl https://github.com/$contrib
#             case '*'
#                 echo >&2 "omf2: Invalid contrib name: $contrib" && return 1
#         end
#         set --local contrib_dir $omf2_path/contribs/(string match -r '[^/]+\/[^/]+$' $contrib)
#         if not test -d $contrib_dir
#             echo "Cloning $giturl"
#             command git clone --quiet --depth 1 --recursive --shallow-submodules \
#                 https://github.com/$repo $contrib_dir &
#         end
#     end
#     wait
#     echo "Installed "(count $argv)" plugin(s)"
# end

# function _omf2cmd__contrib__remove --description "Remove contrib"
#     set --local counter 0
#     for contrib in $argv
#         set --local contrib_dir $omf2_path/contribs/$repo
#         if not test -d $contrib_dir
#             echo >&2 "omf2 contrib remove: Contrib not installed: $contrib"
#             continue
#         else
#             echo "Removing "
#             rm -rf -- $contrib_dir
#         end

#     end
#     wait
# end

# function _omf2cmd__contrib__list --description "List contribs"
#     set --local dotgit
#     set --local contrib
#     for dotgit in $omf2_path/contribs/*/*/.git
#         set contrib (path resolve $dotgit/..)
#         echo (path dirname $contrib | path basename)/(path basename $contrib)
#     end
# end

function _omf2cmd__contrib__update --description "Update contribs"
    set --local contrib_dir
    set --local oldsha
    set --local newsha
    for contrib in (_omf2cmd__contrib__list)
        set contrib_dir $omf2_path/contribs/$contrib
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
    set --global omf2_version 0.0.1

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
