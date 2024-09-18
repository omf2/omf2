function omf2 -a cmd -d "Manage plugin packs for the Fish shell"
    set -l omf2_version 1.0.0-beta-20240918
    set -q omf2_path || set -U omf2_path $__fish_config_dir/.omf2

    switch $cmd
        case "" -h --help
            echo "omf2 - Manage plugin packs for the Fish shell"
            echo "Usage:"
            echo "  omf2 [-h | --help] [-v | --version]"
            echo "  omf2 (enable | disable) <plugin>"
            echo "  omf2 list"
        case -v --version
            echo "omf2, version $omf2_version"
        case fisher-event
            set -l eventname $argv[2]
            set -l repo $argv[3]
            set -l repo_parts (string split '/' $repo)
            test (count $repo_parts) -eq 2 && set --prepend repo_parts github.com
            set -l repodir $omf2_path/packs/(string join "__" $repo_parts[2..])

            if not string match --quiet "$HOME/*" $repodir
                echo "omf2: 'omf2_path' not set correctly." >&2 && return 1
            end

            switch $eventname
                case install
                    test -d $repodir && command rm -rf -- $repodir
                    set -l giturl "https://"(string join "/" $repo_parts)
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
            path basename $omf2_path/packs/*/plugins/* | sort | uniq
        case enable disable
            if not type -q fisher
                echo "omf2: Fisher not found. See: https://github.com/jorgebucaran/fisher" >&2 && return 1
            end

            # TODO - handle plugin name overlaps.
            set --local plugins $argv[2..]
            if test "$argv[2]" = "-a" || test "$argv[2]" = "--all"
                set plugins (omf2 list)
            end
            for plugin in $plugins
                set --local plugin_path $omf2_path/packs/*/plugins/$plugin
                if not test -d $plugin_path
                    echo "omf2: Plugin not found in plugin packs '$plugin'." >&2
                    continue
                end
                if test $cmd = enable
                    fisher install $plugin_path
                else if test $cmd = disable
                    fisher remove $plugin_path
                end
            end
        case '*'
            echo "omf2: unknown command '"$cmd"'" >&2 && return 1
    end
end
