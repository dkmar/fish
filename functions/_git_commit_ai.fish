# ok to get async execution we are binding a function and then asynchronously sending the bound key lol
function _git_commit_ai
    # function to generate ai commit message with `lumen draft`
    function ai_commit
        commandline --replace "git commit -m \"$(lumen draft)\""
    end
    # async invocation
    bind alt-f9 ai_commit
    sendkeys --application-name "Ghostty" -c '<c:f9:alt>' &
    # send placeholder
    echo "..."
end
