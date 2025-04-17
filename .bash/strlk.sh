#!/bin/bash

strlk() {
  find . -type f -name "*$1" -print0 | du -h --total --files0-from=-
}
