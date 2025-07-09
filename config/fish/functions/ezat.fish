fish
function ezat --description "eza tree with custom level"
    if count $argv > /dev/null
        eza -T --level=$argv[1]
    else
        eza -T --level=2
    end
end
