package main

import (
  "fmt"
  "net/http"
	"github.com/gorilla/mux"
)

func home(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "text/html")
  fmt.Fprint(w, "<h1>Welcome to my awesome site!</h1>")
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

func notFound(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "text/html")
  fmt.Fprint(w, "<h1>Sorry, this page doesn't exist!</h1>")
}

var nf http.Handler = http.HandlerFunc(notFound)

func main() {
  r := mux.NewRouter()
  r.HandleFunc("/", home)
  r.HandleFunc("/contact", contact)
  r.HandleFunc("/faq", faq)
	r.NotFoundHandler = nf
	fmt.Println("Starting server on port 3000")
  http.ListenAndServe(":3000", r)
}