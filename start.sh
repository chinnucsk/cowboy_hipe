#!/bin/sh
erl -pa ebin deps/*/ebin -s hello_world -eval "hello_world:demo()"
