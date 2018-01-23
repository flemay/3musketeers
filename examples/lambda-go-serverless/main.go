package main

import (
	"context"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"os"
)

// handleEchoRequest returns an APIGatewayProxyResponse with the value of the environment variable ECHO_MESSAGE
func handleEchoRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return events.APIGatewayProxyResponse{
		Body:       os.Getenv("ECHO_MESSAGE"),
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(handleEchoRequest)
}
