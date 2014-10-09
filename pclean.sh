#!/bin/sh

echo "  CLEAN   .rej"
find . -name '*.rej' -delete
echo "  CLEAN   .orig"
find . -name '*.orig' -delete
