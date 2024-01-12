Output "output/demo.mp4"

Require nvim
Require make
Require docker

Set Theme "OneHalfDark"
Set Margin 30
Set MarginFill "#73ABFE"
Set FontSize 22
Set Width 1200
Set Height 600
Set TypingSpeed 60ms

Hide
Type "cd src"
Enter
Ctrl+L
Show

# Prerequisites
Type "# Let's create 'Hello, World!' app in Go using 3 Musketeers!"
Sleep 1s
Ctrl+U
Type "# But first, verify the host has Make, Docker, and Compose"
Sleep 1s
Ctrl+U
Type "make --version"
Sleep 500ms
Enter
Sleep 1s
Ctrl+L
Type "docker --version"
Sleep 500ms
Enter
Sleep 1s
Ctrl+L
Type "docker compose version"
Sleep 500ms
Enter
Sleep 1s
Ctrl+L

# main.go
Type "# Time to define our Go application"
Sleep 1s
Ctrl+U
Type "vim main.go"
Sleep 1s
Enter
Sleep 2s
Hide
Type ":wq"
Enter
Ctrl+L
Show
Type "# Run it with Go"
Sleep 1s
Ctrl+U
Type "go run main.go"
Sleep 500ms
Enter
Sleep 2s
Ctrl+L
Type "# It failed because the host does not have Go installed"
Sleep 1s
Ctrl+U

# docker-compose.yml
Type "# Define our Go environment using an official Go Docker image where our application will be executed"
Sleep 1s
Ctrl+U
Type "vim docker-compose.yml"
Sleep 1s
Enter
Sleep 2s
Hide
Type ":wq"
Enter
Ctrl+L
Show
Type "# Run it with Compose"
Sleep 1s
Ctrl+U
Type "docker compose run --rm golang go run main.go"
Sleep 500ms
Enter
Sleep 4s
Ctrl+L

# Makefile
Type "# Typing `docker compose run --rm golang go run main.go` is long and hard to remember"
Sleep 1s
Ctrl+U
Type "# Makefile to the rescue"
Sleep 1s
Ctrl+U
Type "vim Makefile"
Sleep 1s
Enter
Sleep 2s
Hide
Type ":wq"
Enter
Ctrl+L
Show
Type "# Run it with Make"
Sleep 1s
Ctrl+U
Type "make run"
Sleep 500ms
Enter
Sleep 4s
