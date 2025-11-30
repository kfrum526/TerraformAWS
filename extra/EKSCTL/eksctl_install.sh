#!/bin/bash

if [ "$(eksctl version)" ]; then
    echo "EKSCTL is already installed"
else
    choco install -y eksctl
fi