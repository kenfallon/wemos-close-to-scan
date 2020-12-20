#!/bin/bash
# MIT License
# 
# Copyright (c) 2020 Ken Fallon
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

image_path="/home/me/documents/scans/"

clear
while true
do
    FILENAME="${image_path}/$(/bin/date +%Y-%m-%d_%H-%M-%S_%Z)"
    echo ""
    echo "Scanning to ${FILENAME}.jpg"
    scanimage --progress --device-name "brother4:net1;dev0" --resolution 300 --format=jpeg > ${FILENAME}.jpg
    ls -al ${FILENAME}*.jpg
    gwenview "${FILENAME}.jpg"
    echo "Press any key for the next file"
    read x
done
