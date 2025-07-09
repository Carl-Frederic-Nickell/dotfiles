fish
function ezaf --description "eza with fzf selection"
    set selected (eza -1 | fzf --preview 'eza -la {}')
    if test -n "$selected"
        if test -d "$selected"
            cd "$selected"
        else
            echo "Selected: $selected"
        end
    end
end
