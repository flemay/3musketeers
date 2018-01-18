package main

import (
	"context"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"os"
)

const echoMessageEnvVarName = "ECHO_MESSAGE"

// Echo returns an APIGatewayProxyResponse with the value of the environment variable ECHO_MESSAGE
func Echo(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return events.APIGatewayProxyResponse{Body: getEchoMessage(), StatusCode: 200}, nil
}

func getEchoMessage() string {
	return os.Getenv(echoMessageEnvVarName)
}

func main() {
	lambda.Start(Echo)
}
