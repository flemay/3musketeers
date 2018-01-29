package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
)

type configureEnvVar func()

const echoMessageEnvVarName = "ECHO_MESSAGE"

var echotests = []struct {
	configureEnvVar configureEnvVar
	expectedMessage string
}{
	{func() { os.Setenv(echoMessageEnvVarName, "Thank you for using the 3 Musketeers!") }, "Thank you for using the 3 Musketeers!"},
	{func() { os.Setenv(echoMessageEnvVarName, "") }, ""},
	{func() { os.Unsetenv(echoMessageEnvVarName) }, ""},
}

func TestHandleEchoRequest(t *testing.T) {
	for _, gt := range echotests {
		// given
		evt := events.APIGatewayProxyRequest{}
		gt.configureEnvVar()

		// when
		response, err := handleEchoRequest(nil, evt)

		// then
		assert.NoError(t, err)
		assert.Equal(t, gt.expectedMessage, response.Body)
	}
}
