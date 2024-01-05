# main.go
Type "# Let's define our Go application"
Sleep 2s
Ctrl+C
Type "vim main.go"
Sleep 2s
Enter
Sleep 4s
Type ":wq"
Enter
Type "# Now run it with Go!"
Sleep 2s
Ctrl+C
Type "go run main.go"
Sleep 1s
Enter
Sleep 2s
Type "# It failed because the host does not have Go installed"
Sleep 2s
Ctrl+C
Ctrl+L

# docker-compose.yml
Type "# Let's define our Go environment using an official Go Docker image where our Go application will be executed"
Sleep 2s
Ctrl+C
Type "vim docker-compose.yml"
Sleep 2s
Enter
Sleep 4s
Type ":wq"
Enter
Type "# Now run it with Compose!"
Sleep 2s
Ctrl+C
Type "docker compose run --rm golang go run main.go"
Sleep 1s
Enter
Sleep 5s
Ctrl+L

# Makefile
Type "# Typing `docker compose run --rm golang go run main.go` may be hard to remember."
Sleep 2s
Space
Type "Let's encapsulate it with a Makefile!"
Sleep 2s
Ctrl+C
Type "vim Makefile"
Sleep 2s
Enter
Sleep 4s
Type ":wq"
Enter
Type "# Now run it with Make!"
Sleep 2s
Ctrl+C
Type "make run"
Sleep 2s
Enter
Sleep 4s
