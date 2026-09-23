#!/usr/bin/env bash

PORT=${1:-8080}
URL="http://localhost:$PORT/v1/models"

# Query llama.cpp server
response=$(curl -s --max-time 2 "$URL")

if [[ -z "$response" ]]; then
  echo "No model running"
  exit 0
fi

# Extract model id from JSON
model=$(echo "$response" | grep -o '"id":[[:space:]]*"[^"]*"' | head -n1 | cut -d'"' -f4)

if [[ -n "$model" ]]; then
  # Get filename only
  name=$(basename "$model")

  # Remove everything starting at -GGUF (case-insensitive)
  clean=$(echo "$name" | sed -E 's/-[Gg][Gg][Uu][Ff].*//')

  echo "Running: $clean"
else
  echo "Server running but model not detected"
fi
