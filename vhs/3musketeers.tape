Output "3musketeers.gif"

Require make
Require vim
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
Type "vim docker-compose.yml"
Sleep 3s
Enter
Type "i"
Type "version: '3'"
Enter
Type "services:"
Enter
Type "  alpine:"
Enter
Type "    image: alpine"
Enter
Sleep 3s
Escape
Type ":wq"
Enter
Sleep 500ms

# Makefile
Type "vim Makefile"
Sleep 3s
Enter
Type "i"
Type "echo:"
Enter
Type "	docker compose run --rm alpine echo 'Hello, World!'"
Enter
Sleep 3s
Escape
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
