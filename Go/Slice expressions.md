https://go.dev/play/p/yYK5GIID88w

```go
package main

import (
	"fmt"
)

func main() {
	hello := "hello"

	fmt.Printf("`%s`\n", hello[:0])          // ``
	fmt.Printf("`%s`\n", hello[len(hello):]) // ``
	fmt.Printf("`%c`\n", hello[len(hello)])  // panic: runtime error: index out of range [5] with length 5
}
```

## Reference

https://go.dev/ref/spec#Slice_expressions
