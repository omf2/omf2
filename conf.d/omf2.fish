set --query omf2_path || set --universal omf2_path $__fish_config_dir/.omf2

# Support for using Fisher to install 'omf2'.
function _omf2_install --on-event omf2_install
    test -d $omf2_path && return 1
    git clone --quiet https://github.com/oh-my-fish-2/omf2 $omf2_path
end

function _omf2_update --on-event omf2_update
    git -C $omf2_path pull --quiet
end

function _omf2_uninstall --on-event omf2_uninstall
    # TODO - maybe we want to be careful here... fisher uninstall contribs, etc.
    # rm -rf -- $omf2_path
end
