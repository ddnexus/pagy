#!/usr/bin/env bash

google-chrome --headless=new \
              --remote-debugging-port=9222 \
              --log-level=3 \
              --no-first-run \
              --no-default-browser-check \
              --disable-gpu
