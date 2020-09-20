package main

import (
	"html/template"
	"io"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

// Define a basic HTML template
const html = `<HTML>
	<head><title>{{.Title}}</title></head>
	<body>
	<h1>{{.Title}}</h1>
	{{.Body}}
	</body>
	</HTML>`

// This is a basic struct to hold basic page data variables
type PageData struct {
	Title string
	Body  string
}

// Index is the "index" handler
func Index(w http.ResponseWriter, r *http.Request) {
	// Fill out page data for index
	pd := PageData{
		Title: "Index Page",
		Body:  "This is the body of the page.",
	}

	// Render the template to the page
	err := render(w, pd)

	// If we got an error, write it out
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
	}
}

func render(w io.Writer, data interface{}) error {
	// Parse the template
	tmpl, err := template.New("index").Parse(html)
	if err != nil {
		return err
	}

	// Render the template with the data we passed in
	if err := tmpl.Execute(w, data); err != nil {
		return err
	}

	// Success
	return nil
}

func main() {
	// We need to create a router
	rt := mux.NewRouter().StrictSlash(true)

	// Add the "index" or root path
	rt.HandleFunc("/", Index)

	// Fire up the server
	log.Println("Starting server on http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", rt))
}
