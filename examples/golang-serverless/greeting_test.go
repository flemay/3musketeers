package main

import (
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
)

const greetingMessageEnvVarName = "GREETING_MESSAGE"

func TestGreet_toReturnGREETING_MESSAGEValueIfSetAndNotEmpty(t *testing.T) {
	// given
	const expectedMessage = "The Three Musketeers welcome you!"
	os.Setenv(greetingMessageEnvVarName, expectedMessage)

	// when
	message := greetingMessage()

	// then
	assert.Equal(t, expectedMessage, message)
}

func TestGreet_toReturnDefaultMessageIfGREETING_MESSAGEValueIsNotSet(t *testing.T) {
	// given
	os.Unsetenv(greetingMessageEnvVarName)

	// when
	message := greetingMessage()

	// then
	const expectedMessage = "Env var GREETING_MESSAGE is empty or not set"
	assert.Equal(t, expectedMessage, message)
}

func TestGreet_toReturnDefaultMessageIfGREETING_MESSAGEValueIsEmpty(t *testing.T) {
	// given
	os.Setenv(greetingMessageEnvVarName, "")

	// when
	message := greetingMessage()

	// then
	const expectedMessage = "Env var GREETING_MESSAGE is empty or not set"
	assert.Equal(t, expectedMessage, message)
}
