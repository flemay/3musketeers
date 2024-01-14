Output "output/demo.gif"

Require nvim
Require make
Require docker

Set Theme "OneHalfDark"
Set Padding 35
Set FontSize 22
Set Width 1300
Set Height 650
Set TypingSpeed 60ms

Hide
Type "cd src"
Enter
Ctrl+L
Show

Type "# Let's create 'Hello, World!' application in Go using \"
Sleep 500ms
Enter
Type "# the 3 Musketeers!"
Sleep 1s
Ctrl+C
Ctrl+L

# Prerequisites
Type "# [1/4] Prerequisites: first, verify the host has \"
Sleep 500ms
Enter
Type "# Make, Docker, and Compose"
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
Sleep 1s
Ctrl+L

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
#Ctrl+L
Show
Type "# Run it with Go"
Sleep 1s
Ctrl+C
Type "go run main.go"
Sleep 500ms
Enter
Sleep 3s
Type "# It failed because the host does not have Go installed"
Sleep 1s
Ctrl+C
Ctrl+L

# docker-compose.yml
Type "# [3/4] Compose: define our Go environment using an \"
Sleep 500ms
Enter
Type "# offical Go Docker image where our application will be executed"
Sleep 1s
Ctrl+C
Type "vim docker-compose.yml"
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
Ctrl+L

# Makefile
Type "# [4/4] Makefile: typing \"
Sleep 500ms
Enter
Type "# `docker compose run --rm golang go run main.go` \"
Sleep 500ms
Enter
Type "# is long and hard to remember. Makefile to the rescue"
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
Sleep 5s
