package main

import (
	"fmt"
	"os"
)

func greetingMessage() string {
	const greetingMessageEnvVarName = "GREETING_MESSAGE"
	message := fmt.Sprintf("Env var %v is empty or not set", greetingMessageEnvVarName)
	if os.Getenv(greetingMessageEnvVarName) != "" {
		message = os.Getenv(greetingMessageEnvVarName)
	}
	fmt.Println(message)
	return message
}
