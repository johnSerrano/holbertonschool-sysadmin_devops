#!/bin/bash
sleep "$(((($1 * 10) + $2) / 10)).$(($2 % 10))"