Output "3musketeers.gif"

Require nvim
Require make
Require docker

Set FontSize 30
Set Width 1200
Set Height 600

Hide
Type "rm -fr /tmp/vhs"
Enter
Type "mkdir -p /tmp/vhs && cd /tmp/vhs"
Enter
Type "rm -fr * && clear"
Enter
Show

# docker-compose.yml
Type "nvim docker-compose.yml"
Sleep 3s
Enter
Type "i"
Type "version: '3'"
Enter
Type "services:"
Enter
Type "alpine:"
Enter
Type "image: alpine"
Escape
Sleep 3s
Type ":wq"
Enter
Sleep 500ms

# Makefile
Type "nvim Makefile"
Sleep 3s
Enter
Type "i"
Type "echo:"
Enter
Type "docker compose run --rm alpine echo 'Hello, World!'"
Escape
Sleep 3s
Type ":wq"
Enter
Sleep 500ms

Type "ls"
Enter
Sleep 3s

# Execution
Type "make echo"
Enter
Sleep 2s

Sleep 5s
