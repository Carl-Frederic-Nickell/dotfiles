fish
function ezag --description "eza with git status"
    eza -la --git --group-directories-first $argv
end
