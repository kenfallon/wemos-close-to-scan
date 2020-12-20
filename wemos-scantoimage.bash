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

image_path="/PATH/TO/YOUR/SCANS/"
server="YOUR-WEMOS-IP-ADDRESS"

check_wemos () {
  response=$( wget --quiet --timeout 5 --tries 1 http://${server}/ -O - | jq '.' )
  if [ $( echo ${response} | jq '.' | wc -l ) -eq 0 ]
  then
    echo "Webserver \"${server}\" is down"
    echo ""
    exit
  fi
  if [ $(echo ${response} | jq '.closed') == "true" ]
  then
    echo -ne "\r$(\date "+%Y-%m-%d %H:%M:%S") The scanner lid is CLOSED."
    return 1
  else
    echo -ne "\r$(\date "+%Y-%m-%d %H:%M:%S") The scanner lid is OPEN.  "
    return 0
  fi
}

while true
do
  if ! check_wemos
  then
    FILENAME="${image_path}/$(/bin/date +%Y-%m-%d_%H-%M-%S_%Z)"
    echo ""
    echo "Scanning to ${FILENAME}.jpg"
    scanimage --progress --device-name "brother4:net1;dev0" --resolution 300 --format=jpeg > ${FILENAME}.jpg
    ls -al ${FILENAME}*.jpg
    while ! check_wemos
    do
      sleep 1
    done
  fi
done
