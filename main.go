package main

import (
  "fmt"
  "net/http"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

// Example of a Handler: homeHandle
// Needs to create a struct and then add the ServeHTTP method to a function that has the struct as its parameter.
type homeHandle struct {}

func (h *homeHandle) ServeHTTP(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "text/html")
  fmt.Fprint(w, "<h1>Welcome to my beautiful site! This is Handle</h1>")
}

// Example of a HandlerFunc: home
// The function home, because it has a ResponseWriter and a Request as its parameters, is a HandlerFunc type and already has the ServeHTTP method attached to it.
func home(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "text/html")
  fmt.Fprint(w, "<h1>Welcome to my beautiful site! This is HandleFunc</h1>")
}

func contact(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "text/html")
  fmt.Fprint(w, "To get in touch, please send an email "+
    "to <a href=\"mailto:support@lenslocked.com\">"+ 
    "support@lenslocked.com</a>.")
}

func faq(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "text/html")
  fmt.Fprint(w, "<h1>This is our FAQ page</h1>")
}

func user(w http.ResponseWriter, r *http.Request) {
	userID := chi.URLParam(r, "userID")
  w.Header().Set("Content-Type", "text/html")
  fmt.Fprintf(w, "<h1>Here is the user id: %v</h1>", userID)
}


func notFound(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "text/html")
  fmt.Fprint(w, "<h1>Sorry, this page doesn't exist!</h1>")
}

var nf http.Handler = http.HandlerFunc(notFound) // This is not calling http.HandlerFunc with notFound as an argument. It is actually converting the notFound function to a http.HandlerFunc type.



// http.Handler - interface with the ServeHTTP method
// http.HandlerFunc - a function type that accepts same args ServeHTTP method. Also implements http.Handler.

// http.Handle("/", http.Handler)
// http.HandleFunc("/", home) -> where home is a http.HandlerFunc

func main() {
	// Alternate way to implement Handle instead of initializing a homeHandle with new(homeHandle)
	// access the value of pointer homeHandle (dereference) and assigns it to hh
	// var hh *homeHandle 
	// var l http.Handler = http.HandlerFunc(logger)
	// c := http.HandlerFunc(middleware.Logger(http.HandlerFunc(contact)))
  r := chi.NewRouter()
	r.Use(middleware.Logger)
  r.Get("/", home)
  // r.Handle("/homehandle", new(homeHandle))
	// Use variable hh which implements the handle interface
	// r.Handle("/homehandle", hh)
  r.Get("/contact", contact)
  r.Get("/faq", faq)
	r.Get("/users/{userID}", user)
	// r.NotFound(http.HandlerFunc(notFound))
	r.NotFound(notFound)
	
	fmt.Println("Starting server on port 3000")
  http.ListenAndServe(":3000", r)
}