function aur-search
    logger 0 "Querying aur..."
    for keywords in $argv
        curl -sL "https://aur.archlinux.org/rpc/?v=5&type=search&arg=$keywords" | jq -r '.results as $data | $data[] | "\n\u001b[32maur-pacman/"+.Name+" "+.Version+"\u001b[32m","\u001b[0mDescription: "+.Description'
    end
end
