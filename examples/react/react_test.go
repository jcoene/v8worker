package react

import (
	"fmt"
	"io/ioutil"
	"testing"

	"github.com/jcoene/v8worker"
)

func TestReact(t *testing.T) {
	got := make(chan string)
	recv := func(s string) {
		got <- s
	}

	sync := func(s string) string {
		return s
	}

	code, err := ioutil.ReadFile("bundle.js")
	if err != nil {
		panic(err)
	}

	w := v8worker.New(recv, sync)
	if err := w.Load("bundle.js", string(code)); err != nil {
		panic(err)
	}

	go func() {
		w.Send(`{"props": {"name": "everything", "timestamp": "now"}}`)
		w.Send(`{"props": {"name": "everything", "timestamp": "now"}}`)
	}()

	n := 0
	for {
		s := <-got
		fmt.Println("got", s)
		n++

		if n == 2 {
			break
		}
	}
}
