package main

import (
	"github.com/eawsy/aws-lambda-go-core/service/lambda/runtime"
	"github.com/eawsy/aws-lambda-go-event/service/lambda/runtime/event/apigatewayproxyevt"
	"github.com/yunspace/serverless-golang/aws/event/apigateway"
	"net/http"
)

func Greet(evt *apigatewayproxyevt.Event, _ *runtime.Context) (interface{}, error) {
	responseOk := apigateway.NewAPIGatewayResponse(http.StatusOK)
	responseOk.SetBody(greetingMessage())
	return responseOk, nil
}
