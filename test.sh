#!/bin/bash
vim -Nu ./.test.vimrc -c 'Vader! tests/*' > /dev/null
