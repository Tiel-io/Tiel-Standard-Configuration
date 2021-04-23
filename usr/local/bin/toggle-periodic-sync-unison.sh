#!/usr/bin/env bash

## Update the synchronization value being tracked by Tiel.
set-tiel-standard-config.sh PERIODIC_SYNC $2

## TODO: depending on the value of $2, start or stop a polling task.
