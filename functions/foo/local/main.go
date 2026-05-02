package main

import (
	"log"

	_ "github.com/otakakot/emutate-cloud-functions/functions/foo"

	// Blank-import the function package so the init() runs
	"github.com/GoogleCloudPlatform/functions-framework-go/funcframework"
)

func main() {
	if err := funcframework.Start("8080"); err != nil {
		log.Panicf("funcframework.Start: %v\n", err)
	}
}
