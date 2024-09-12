function omf2 -a cmd -d "Oh-My-Fish-2 manager"
    set -l omf2_version 2.0.0-alpha
    set -q omf2_path || set -U omf2_path $__fish_config_dir/.omf2

    switch $cmd
        case "" -h --help
            echo "omf2 - The Oh-My-Fish-2 management utility"
            echo "Usage:"
            echo "  omf2 enable <contrib>      Use an OMF2 contrib"
            echo "  omf2 disable <contrib>     Stop using an OMF2 contrib"
            echo "  omf2 fisher-event <event>  Run handler for Fisher event"
            echo "  omf2 [-h | --help]         Show this help"
            echo "  omf2 [-v | --version]      Show version"
        case -v --version
            echo "omf2, version $omf2_version"
        case fisher-event
            set -l eventname $argv[2]
            set -l repo $argv[3]
            set -l repo_parts (string split '/' $repo)
            if test (count $repo) -eq 2
                set --prepend repo github.com
            end
            set -l repodir $omf2_path/contribs/(string join "/" $argv[2..])

            if not string match --quiet "$HOME/*" $repodir
                echo "omf2: 'omf2_path' not set correctly." >&2 && return 1
            end

            switch $eventname
                case install
                    test -d $repodir && command rm -rf -- $repodir
                    set -l giturl "https://"(string join "/" $repo)
                    command git clone --quiet --depth 1 --recursive --shallow-submodules -- $giturl $repodir
                    if test $status -ne 0
                        echo "omf2: git clone failed for repo '$repo'." >&2 && return 1
                    end
                case update
                    if not test -d $repodir
                        echo "omf2: Repo not installed '$repo'." >&2 && return 1
                    end
                    command git -C $repodir pull --quiet --ff --depth 1 --rebase --autostash
                    if test $status -ne 0
                        echo "omf2: git pull failed for repo '$repo'." >&2 && return 1
                    end
                case uninstall
                    test -d $repodir && command rm -rf -- $repodir
            end
        case list
            path basename $omf2_path/contribs/*/*/plugins/* | sort | uniq
        case enable disable
            if not type -q fisher
                echo "omf2: Fisher not installed. See: https://github.com/jorgebucaran/fisher" >&2 && return 1
            end

            # TODO - handle plugin name overlaps.
            set -l plugin_path $omf2_path/contribs/*/*/plugins/$argv[2]
            if test $cmd = enable
                fisher install $plugin_path
            else if test $cmd = disable
                fisher remove $plugin_path
            end
        case '*'
            echo "omf2: unknown command '"$cmd"'" >&2 && return 1
    end
end
