status is-interactive || exit

# Sponge version
# set -g sponge_version 1.1.0

# Set global variables with defaults
set -g sponge_delay 3
set -g sponge_purge_only_on_exit false
set -g sponge_filters sponge_filter_failed # sponge_filter_matched
set -g sponge_allow_previously_successful false
set -g sponge_successful_exit_codes 0
set -g sponge_regex_patterns

# Verify event handlers are available
functions --query \
    _sponge_on_prompt \
    _sponge_on_preexec \
    _sponge_on_postexec \
    _sponge_on_exit

# Initialize state on install
function _sponge_install --on-event sponge_install
    set -g _sponge_current_command ''
    set -g _sponge_current_command_exit_code 0
    set -g _sponge_current_command_previously_in_history false
end

# Clean up on uninstall
function _sponge_uninstall --on-event sponge_uninstall
    _sponge_clear_state
    # set --erase sponge_version
end
