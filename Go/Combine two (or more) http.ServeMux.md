```go
rootMux := http.NewServeMux()
subMux := http.NewServeMux()

// This will end up handling /top_path/sub_path
subMux.HandleFunc("/sub_path", myHandleFunc)

// Use the StripPrefix here to make sure the URL has been mapped
// to a path the subMux can read
rootMux.Handle("/top_path/", http.StripPrefix("/top_path", subMux))

http.ListenAndServe(":8000", rootMux)
```

## References

https://stackoverflow.com/a/43380025
