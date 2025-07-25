function insert_in_place
    fish -i -C 'function fish_prompt; echo -e \'-$ \'; end'
    commandline --insert (cat /tmp/t.txt)
    commandline -f repaint
end
