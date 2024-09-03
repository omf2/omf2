set --query omf2_path || set -gx omf2_path $__fish_config_dir/.omf2

# Support for using Fisher to install the 'omf2' utility.
function _omf2_install --on-event omf2_install
    test "$__omf2_fisher_events_disabled" != true || return 0
    if test -d $omf2_path
        rm -rf -- $omf2_path
    end
    git clone --quiet https://github.com/oh-my-fish-2/omf2 $omf2_path
end

function _omf2_update --on-event omf2_update
    test "$__omf2_fisher_events_disabled" != true || return 0
    git -C $omf2_path pull --quiet
end

function _omf2_uninstall --on-event omf2_uninstall
    test "$__omf2_fisher_events_disabled" != true || return 0
    rm -rf -- $omf2_path
end
