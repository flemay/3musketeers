Output "output/demo.gif"

Require nvim
Require make
Require docker

# [Set GIF quality](https://github.com/charmbracelet/vhs/issues/69)
Set Theme "OneHalfDark"
Set Padding 40
Set FontFamily "JetBrains Mono"
Set FontSize 22
Set Width 1300
Set Height 650
Set TypingSpeed 45ms
#Set PlaybackSpeed 0.5

Hide
Type "cd app"
Enter
Ctrl+L
Show

Type "# Let's create 'Hello, World!' application in Go using the 3 Musketeers!"
Sleep 1s
Hide
Ctrl+C
Ctrl+L
Show

# Prerequisites
Type "# [1/4] Prerequisites: first, verify the host has Make, Docker and Compose"
Sleep 1s
Ctrl+C
Type "make --version"
Sleep 500ms
Enter
Sleep 1s
Type "docker --version"
Sleep 500ms
Enter
Sleep 1s
Type "docker compose version"
Sleep 500ms
Enter
Sleep 2s
Hide
Ctrl+L
Show

# main.go
Type "# [2/4] Time to define our Go application"
Sleep 1s
Ctrl+C
Type "vim main.go"
Sleep 1s
Enter
Sleep 3s
Hide
Type ":wq"
Enter
Show
Type "# Run it with Go"
Sleep 1s
Ctrl+C
Type "go run main.go"
Sleep 500ms
Enter
Sleep 1s
Type "# It failed because the host does not have Go installed"
Sleep 2s
Hide
Ctrl+C
Ctrl+L
Show

# compose.yml
Type "# [3/4] Compose: define our Go environment using an offical"
Sleep 500ms
Enter
Type "# Go Docker image where our application will be executed"
Sleep 1s
Ctrl+C
Type "vim compose.yml"
Sleep 1s
Enter
Sleep 3s
Hide
Type ":wq"
Enter
Show
Type "# Run it with Compose"
Sleep 1s
Ctrl+C
Type "docker compose run --rm golang go run main.go"
Sleep 500ms
Enter
Sleep 4s
Hide
Ctrl+L
Show

# Makefile
Type "# [4/4] Make: Typing `docker compose run --rm golang go run main.go` \"
Sleep 500ms
Enter
Type "# is long and hard to remember."
Sleep 500ms
Type " Make to the rescue!"
Sleep 1s
Ctrl+C
Type "vim Makefile"
Sleep 1s
Enter
Sleep 3s
Hide
Type ":wq"
Enter
Show
Type "# Run it with Make"
Sleep 1s
Ctrl+C
Type "make run"
Sleep 500ms
Enter
Sleep 4s
