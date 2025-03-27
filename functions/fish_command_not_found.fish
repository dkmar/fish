function fish_command_not_found --on-event fish_command_not_found
    eval $(_PR_LAST_COMMAND="$argv" _PR_SHELL="fish" _PR_ALIAS="$(alias)" _PR_MODE="cnf" "pay-respects")
end
