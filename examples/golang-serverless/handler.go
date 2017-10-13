package main

import (
	"fmt"
	"github.com/eawsy/aws-lambda-go-core/service/lambda/runtime"
	"github.com/eawsy/aws-lambda-go-event/service/lambda/runtime/event/apigatewayproxyevt"
	"github.com/yunspace/serverless-golang/aws/event/apigateway"
	"net/http"
	"os"
)

const greetingMessageEnvVarName = "GREETING_MESSAGE"

func Greet(evt *apigatewayproxyevt.Event, _ *runtime.Context) (interface{}, error) {
	fmt.Printf(`GREETING_MESSAGE is set to "%v"`, os.Getenv(greetingMessageEnvVarName))
	return apigateway.NewAPIGatewayResponseWithBody(http.StatusOK, newGreetingMessage()), nil
}

type greetingMessage struct {
	Message string `json:"message"`
}

// newGreetingMessage returns a struct greetingMessage based on the env var GREETING_MESSAGE
func newGreetingMessage() *greetingMessage {
	message := fmt.Sprintf("Env var %v is empty or not set", greetingMessageEnvVarName)
	if os.Getenv(greetingMessageEnvVarName) != "" {
		message = os.Getenv(greetingMessageEnvVarName)
	}
	return &greetingMessage{
		Message: message,
	}
}
