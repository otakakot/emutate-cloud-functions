package e2e_test

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"reflect"
	"testing"
)

func TestBar(t *testing.T) {
	t.Parallel()

	endpoint := os.Getenv("ENDPOINT")

	if endpoint == "" {
		endpoint = "http://localhost:8080"
	}

	t.Run("bar", func(t *testing.T) {
		t.Parallel()

		req, err := http.NewRequest("GET", fmt.Sprintf("%s/bar", endpoint), nil)
		if err != nil {
			t.Fatalf("failed to create request: %v", err)
		}

		res, err := http.DefaultClient.Do(req)
		if err != nil {
			t.Fatalf("failed to send request: %v", err)
		}

		defer res.Body.Close()

		body, err := io.ReadAll(res.Body)
		if err != nil {
			t.Fatalf("failed to read body: %v", err)
		}

		if !reflect.DeepEqual(body, []byte("Hello, World From Bar!")) {
			t.Errorf("failed to get expected response: %s", string(body))
		}
	})

	t.Run("bar?name=otakakot", func(t *testing.T) {
		t.Parallel()

		req, err := http.NewRequest("GET", fmt.Sprintf("%s/bar?name=otakakot", endpoint), nil)
		if err != nil {
			t.Fatalf("failed to create request: %v", err)
		}

		res, err := http.DefaultClient.Do(req)
		if err != nil {
			t.Fatalf("failed to send request: %v", err)
		}

		defer res.Body.Close()

		body, err := io.ReadAll(res.Body)
		if err != nil {
			t.Fatalf("failed to read body: %v", err)
		}

		if !reflect.DeepEqual(body, []byte("Hello, otakakot From Bar!")) {
			t.Errorf("failed to get expected response: %s", string(body))
		}
	})
}
