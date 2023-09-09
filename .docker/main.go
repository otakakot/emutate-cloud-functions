package main

import (
	"fmt"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"
	"strings"
)

func main() {
	functions := strings.Split(os.Getenv("FUNCTIONS"), ",")

	for _, function := range functions {
		fun := function
		http.HandleFunc(fmt.Sprintf("/%s", fun), func(w http.ResponseWriter, r *http.Request) {
			url, _ := url.Parse(fmt.Sprintf("http://%s:8080/", fun))
			proxy := httputil.NewSingleHostReverseProxy(url)
			proxy.ServeHTTP(w, r)
		})
	}

	http.ListenAndServe(":8080", nil)
}
