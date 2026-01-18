# utility/web-search.ps1
# web search feature like zsh web-search

function google {
    $query = $args -join ' '
    Start-Process "https://www.google.com/search?q=$query"
}

function duckduckgo {
    $query = $args -join ' '
    Start-Process "https://www.duckduckgo.com/search?q=$query"
}

function bing {
    $query = $args -join ' '
    Start-Process "https://www.bing.com/search?q=$query"
}

function youtube {
    $query = $args -join ' '
    Start-Process "https://www.youtube.com/results?search_query=$query"
}

function github {
    $query = $args -join ' '
    Start-Process "https://github.com/search?q=$query"
}

function so {
    $query = $args -join ' '
    Start-Process "https://stackoverflow.com/search?q=$query"
}


