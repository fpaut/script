#!/bin/bash
CMD="git log --follow $@"; echo $CMD; $CMD
