function fuck --description "Suggest fixes to the previous command"
    _PR_LAST_COMMAND="$(history | head -n 1)" _PR_SHELL="fish" _PR_ALIAS="$(alias)" pay-respects
end
