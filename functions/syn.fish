function syn --description "Display synonyms for a given word"
   set response (curl -s "https://api.datamuse.com/words?rel_syn=$argv[1]")
   set_color green
   echo $response | jq -r 'map(.word // empty) | sort_by(length) | .[]' | column -c 72
end
