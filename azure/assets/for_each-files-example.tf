resource "local_file" "file-0" {
  filename = "hello.txt"
  content  = "hello"
}

resource "local_file" "file-1" {
  filename = "goodbye.txt"
  content  = "goodbye"
}
