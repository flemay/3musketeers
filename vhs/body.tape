# main.go
Type "# Time to define our Go application"
Sleep 500ms
Ctrl+U
Type "vim main.go"
Sleep 500ms
Enter
Sleep 2s
Hide
Type ":wq"
Enter
Ctrl+L
Show
Type "# Run it with Go"
Sleep 500ms
Ctrl+U
Type "go run main.go"
Sleep 500ms
Enter
Sleep 2s
Ctrl+L
Type "# It failed because the host does not have Go installed"
Sleep 500ms
Ctrl+U

# docker-compose.yml
Type "# Let's define our Go environment using an official Go Docker image where our application will be executed"
Sleep 500ms
Ctrl+U
Type "vim docker-compose.yml"
Sleep 500ms
Enter
Sleep 2s
Hide
Type ":wq"
Enter
Ctrl+L
Show
Type "# Run it with Compose"
Sleep 500ms
Ctrl+U
Type "docker compose run --rm golang go run main.go"
Sleep 500ms
Enter
Sleep 4s
Ctrl+L

# Makefile
Type "# Typing `docker compose run --rm golang go run main.go` may be hard to remember"
Sleep 500ms
Ctrl+U
Type "# Let's encapsulate it with a Makefile"
Sleep 500ms
Ctrl+U
Type "vim Makefile"
Sleep 500ms
Enter
Sleep 2s
Hide
Type ":wq"
Enter
Ctrl+L
Show
Type "# Run it with Make"
Sleep 500ms
Ctrl+U
Type "make run"
Sleep 500ms
Enter
Sleep 4s
Ctrl+L
