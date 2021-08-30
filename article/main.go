package main

import (
  "fmt"
  "net/http"
  "github.com/gorilla/mux"
)

type handlePage struct {}

func (h handlePage) ServeHTTP(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "text/html")
  fmt.Fprint(w, "<h1>Welcome to the handle page!</h1>")
}

func main() {
  r := mux.NewRouter()
  r.Handle("/handlepage", new(handlePage))
  http.ListenAndServe(":3000", r)
}