# aws-lambda-layer-zip-builder:

A Dockerfile to build Python compatible AWS Lambda Layers as a zip file. This uses Amazon Linux 2 on Docker with Python 3.7.x. Use this to add a Python compatible lambda layer to your AWS Cloudformation stack. This has been successfully test on:

    opencv-python  
    numpy
    Pillow


# Docker Start:

Run this in docker for an opencv layer:

    docker run --rm -v $(pwd):/package highpoints/aws-lambda-layer-zip-builder opencv-python 
    
This produces a file, opencv-python3-7-x.zip, as the AWS Lambda Layer. The Python version number appends to the filename, so opencv-python3-7-8.zip, for example, is Python version 3.7.8. AWS Lambda Layers only allows one period in the zip filename.

For a numpy layer:

    docker run --rm -v $(pwd):/package highpoints/aws-lambda-layer-zip-builder numpy
    
For a Pillow layer:

    docker run --rm -v $(pwd):/package highpoints/aws-lambda-layer-zip-builder pillow
    
    
# Dockerfile for AWS Lambda Layer:

Docker image can be found at:

https://hub.docker.com/repository/docker/highpoints/aws-lambda-layer-zip-builder


#
Thanks to:  
http://tiivik.github.io
