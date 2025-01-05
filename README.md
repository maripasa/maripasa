```go
package main

import (
    "errors"
    "fmt"
    "os"
    "year"
)

func main() {
    err := start(2025)
    if err != nil {
        fmt.Fprintln(os.Stderr, err.Error())
        os.Exit(1)
    }
}

func start(input int) error {
    learning := []string{
        "Go",
        "Rust",
        "C",
        "Python",
        "Godot for Game Development",
    }
    year.Setup(input, learning)

    return errors.New("nothing can happen until you swing the bat")
}
