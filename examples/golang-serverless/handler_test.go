package main

import (
	"fmt"
	"github.com/eawsy/aws-lambda-go-core/service/lambda/runtime"
	"github.com/eawsy/aws-lambda-go-event/service/lambda/runtime/event/apigatewayproxyevt"
	"github.com/stretchr/testify/assert"
	"github.com/yunspace/serverless-golang/aws/event/apigateway"

	"os"
	"testing"
)

type configureEnvVar func()

var greettests = []struct {
	configureEnvVar configureEnvVar
	expectedMessage string
}{
	{func() { os.Setenv(greetingMessageEnvVarName, "The Three Musketeers welcome you!") }, "The Three Musketeers welcome you!"},
	{func() { os.Setenv(greetingMessageEnvVarName, "") }, "Env var GREETING_MESSAGE is empty or not set"},
	{func() { os.Unsetenv(greetingMessageEnvVarName) }, "Env var GREETING_MESSAGE is empty or not set"},
}

func TestGreet(t *testing.T) {
	for _, gt := range greettests {
		// given
		evt := &apigatewayproxyevt.Event{}
		ctx := &runtime.Context{}
		gt.configureEnvVar()

		// when
		response, err := Greet(evt, ctx)

		// then
		assert.NoError(t, err)
		expectedMessage := fmt.Sprintf(`{"message":"%v"}`, gt.expectedMessage)
		body := response.(*apigateway.APIGatewayResponse).Body.(string)
		assert.Equal(t, expectedMessage, body)
	}
}
