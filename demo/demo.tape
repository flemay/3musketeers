Output "output/demo.gif"

Require nvim
Require make
Require docker

Set Theme "OneHalfDark"
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
Type "# [1/10] Let's create 'Hello, World!' app in Go using 3 Musketeers!"
Sleep 1s
Ctrl+U
Type "# [2/10] But first, verify the host has Make, Docker, and Compose"
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
Type "# [3/10] Time to define our Go application"
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
Type "# [4/10] Run it with Go"
Sleep 1s
Ctrl+U
Type "go run main.go"
Sleep 500ms
Enter
Sleep 2s
Ctrl+L
Type "# [5/10] It failed because the host does not have Go installed"
Sleep 1s
Ctrl+U

# docker-compose.yml
Type "# [6/10] Define our Go environment using an official Go Docker image where our application will be executed"
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
Type "# [7/10] Run it with Compose"
Sleep 1s
Ctrl+U
Type "docker compose run --rm golang go run main.go"
Sleep 500ms
Enter
Sleep 4s
Ctrl+L

# Makefile
Type "# [8/10] Typing `docker compose run --rm golang go run main.go` is long and hard to remember"
Sleep 1s
Ctrl+U
Type "# [9/10] Makefile to the rescue"
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
Type "# [10/10] Run it with Make"
Sleep 1s
Ctrl+U
Type "make run"
Sleep 500ms
Enter
Sleep 4s
