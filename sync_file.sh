#!/bin/bash

echo "-------------- env --------------"
file=$(aws s3 ls s3://elonniu/files/)
echo $file
echo "-------------- env --------------"
