# main.go
Type "# Let's define our Go application"
Sleep 2s
Ctrl+C
Type "nvim main.go"
Sleep 2s
Enter
Sleep 4s
Type ":wq"
Enter
Type "# Now try and run it"
Sleep 2s
Ctrl+C
Type "go run main.go"
Sleep 1s
Enter
Sleep 2s
Type "# It fails because the host does not have Go installed"
Sleep 2s
Ctrl+C
Ctrl+L

# docker-compose.yml
Type "# Let's define our Go environment using an official Go Docker image where our Go application will be executed"
Sleep 2s
Ctrl+C
Type "nvim docker-compose.yml"
Sleep 2s
Enter
Sleep 4s
Type ":wq"
Enter
Type "# Now try and run it with Compose"
Sleep 2s
Ctrl+C
Type "docker compose run --rm golang go run main.go"
Sleep 1s
Enter
Sleep 5s
Ctrl+L
