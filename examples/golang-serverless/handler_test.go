package main

import (
	"github.com/eawsy/aws-lambda-go-core/service/lambda/runtime"
	"github.com/eawsy/aws-lambda-go-event/service/lambda/runtime/event/apigatewayproxyevt"
	"github.com/stretchr/testify/assert"
	"github.com/yunspace/serverless-golang/aws/event/apigateway"

	"os"
	"testing"
)

func TestGreet_toReturnGREETING_MESSAGEValueIfSetAndNotEmpty(t *testing.T) {
	// given
	evt := &apigatewayproxyevt.Event{}
	ctx := &runtime.Context{}
	const greetingMessage = "The Three Musketeers welcome you!"
	os.Setenv(greetingMessageEnvVarName, greetingMessage)

	// when
	response, err := Greet(evt, ctx)

	// then
	assert.NoError(t, err)
	const expectedMessage = `{"message":"The Three Musketeers welcome you!"}`
	body := response.(*apigateway.APIGatewayResponse).Body.(string)
	assert.Equal(t, expectedMessage, body)
}

func TestGreet_toReturnDefaultMessageIfGREETING_MESSAGEValueIsNotSet(t *testing.T) {
	// given
	os.Unsetenv(greetingMessageEnvVarName)
	evt := &apigatewayproxyevt.Event{}
	ctx := &runtime.Context{}

	// when
	response, err := Greet(evt, ctx)

	// then
	assert.NoError(t, err)
	const expectedMessage = `{"message":"Env var GREETING_MESSAGE is empty or not set"}`
	body := response.(*apigateway.APIGatewayResponse).Body.(string)
	assert.Equal(t, expectedMessage, body)
}

func TestGreet_toReturnDefaultMessageIfGREETING_MESSAGEValueIsEmpty(t *testing.T) {
	// given
	os.Setenv(greetingMessageEnvVarName, "")
	evt := &apigatewayproxyevt.Event{}
	ctx := &runtime.Context{}

	// when
	response, err := Greet(evt, ctx)

	// then
	assert.NoError(t, err)
	const expectedMessage = `{"message":"Env var GREETING_MESSAGE is empty or not set"}`
	body := response.(*apigateway.APIGatewayResponse).Body.(string)
	assert.Equal(t, expectedMessage, body)
}
