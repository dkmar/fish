# ok to get async execution we are binding a function and then asynchronously sending the bound key lol
function _git_commit_ai
    # function to generate ai commit message with `lumen draft`
    function ai_commit
        commandline --replace "git commit -m \"$(lumen draft)\""
    end
    # async invocation
    bind f9 ai_commit
    sendkeys -d 0 -i 0 -c '<c:f9>' &
    # send placeholder
    echo "..."
end
