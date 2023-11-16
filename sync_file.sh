#!/bin/bash

echo "-------------- env --------------"
file=$(aws s3 ls s3://elonniu)
echo $file
echo "-------------- env --------------"
