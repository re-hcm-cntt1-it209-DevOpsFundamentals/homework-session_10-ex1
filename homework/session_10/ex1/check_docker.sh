#!/usr/bin/env bash

echo "[INFO] Checking docker version..."
docker version

echo ""
echo "[INFO] Checking docker info and cgroup settings..."
docker info

echo ""
echo "[INFO] Filtering cgroup information..."
docker info | grep -i cgroup

echo ""
echo "[INFO] Verification completed successfully!"
