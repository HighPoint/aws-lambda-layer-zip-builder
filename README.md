# aws-lambda-layer-zip-builder (Python 3.13, Amazon Linux 2023)

Build AWS Lambda Layers as `.zip` files directly in Docker.  
This image uses **Amazon Linux 2023** with **Python 3.13.x** and produces layers compatible with the AWS Lambda Python 3.13 runtime.

---

## Description

This tool builds a Lambda-compatible layer for a single Python package per run.  
It automatically installs the requested package inside the correct folder structure:

```
python/lib/python3.13/site-packages/
```

and compresses it into a zip suitable for direct upload as a Lambda Layer.

---

## Usage

Run the Docker container for any package you need:

```bash
mkdir -p out
docker run --rm --platform=linux/amd64   -v "$(pwd)/out:/package"   highpoints/aws-lambda-layer-zip-builder:py313   numpy
```

This produces a layer zip:

```
out/layers/numpy3-13.zip
```

Attach this file as a Lambda Layer (runtime **Python 3.13**).

---

## Example

**NumPy layer**
```bash
docker run --rm --platform=linux/amd64   -v "$(pwd)/out:/package"   highpoints/aws-lambda-layer-zip-builder:py313   numpy
```

Each command produces a zip named like:
```
<package>3-13.zip
```
which complies with the AWS Lambda Layer filename restriction (only one period allowed).

---

## Notes

* Base OS: **Amazon Linux 2023**  
* Python version: **3.13.x**
* Compatible Lambda runtime: `python3.13`
* Stripping of `.so` binaries has been **disabled** to ensure native library compatibility.
* Tested with:
  - **numpy**

---

## Docker Hub

Prebuilt image:  
https://hub.docker.com/repository/docker/highpoints/aws-lambda-layer-zip-builder

---

Happy Coding 🎉
