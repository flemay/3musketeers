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
Sleep 1s
Enter
Sleep 2s
Ctrl+L
Type "# It failed because the host does not have Go installed"
Sleep 1s
Ctrl+U

# docker-compose.yml
Type "# Let's define our Go environment using an official Go Docker image where our Go application will be executed"
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
Sleep 1s
Enter
Sleep 4s
Ctrl+L

# Makefile
Type "# Typing `docker compose run --rm golang go run main.go` may be hard to remember"
Sleep 1s
Ctrl+U
Type "# Let's encapsulate it with a Makefile"
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
Sleep 1s
Enter
Sleep 4s
Ctrl+L
