fish
function ezas --description "eza sorted by size"
    eza -la -s size --reverse --color-scale $argv
end
