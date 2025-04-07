# ok to get async execution we are binding a function and then asynchronously sending the bound key lol
function _git_commit_ai
    # git diff --staged | aichat -r concise -m gemini:gemini-2.0-flash summarize what we did at a high level for a commit message | pbcopy &
    if test (git diff --staged | count) -gt 0
        lumen draft | pbcopy &
        echo 'git commit -m'
    end
end
