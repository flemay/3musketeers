Output "output/demo.mp4"

Require nvim
Require make
Require docker

Set Theme "Solarized Darcula"
Set Margin 30
Set MarginFill "#73ABFE"
Set FontSize 20
Set Width 1200
Set Height 600
Set TypingSpeed 40ms

Hide
Type "cd src"
Enter
Ctrl+L
Show

Source intro.tape
Source body.tape
Source conclusion.tape
