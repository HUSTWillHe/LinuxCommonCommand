#!/bin/bash

cd $(dirname $0)

cat ./BasicCommand.md > LinuxCommonCommand.md
sed -n "5,$ p" AdvanceCommand.md >> LinuxCommonCommand.md
sed -n "5,$ p" ExtendCommand.md >> LinuxCommonCommand.md
