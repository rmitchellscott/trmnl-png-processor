# trmnl-png-processor

This project provides a Dockerized utility that processes PNG images from a specified directory, applies transformations using ImageMagick, generates a manifest file, and uploads both the processed image and manifest to an Amazon S3 bucket. Designed for use with [TRMNL](https://usetrmnl.com/)'s [Redirect Plugin](https://help.usetrmnl.com/en/articles/11035846-redirect-plugin).

## Features

- Converts PNGs using ImageMagick with configurable settings (rotation, color depth, dithering).
- Generates a JSON manifest with metadata for downstream use.
- Uploads the processed image and manifest to AWS S3.
- Skips execution if no PNG files are present.
- Lightweight Alpine-based image with AWS CLI.

## Usage

### Docker Image

Pull or build the image using:

```shell
docker run ghcr.io/rmitchellscott/trmnl-png-processor .
```

### Directory Structure

The container expects PNG images in the `/data/pngs` directory. Mount a volume to provide these images:

```shell
-v /your/local/path:/data/pngs
```

### Environment Variables

| Variable       | Description                                                                 | Default          |
|----------------|-----------------------------------------------------------------------------|------------------|
| `OUTPUT_NAME`  | Base name for the output image (without extension)                          | Timestamp        |
| `MANIFEST_NAME`| Name of the JSON manifest file (without extension)                          | `manifest`       |
| `ROTATION`     | Rotation angle applied to the image                                         | `0`              |
| `COLORS`       | Number of colors used for dithering (resulting image is always monochrome)  | `16`             |
| `DITHERING`    | Dithering method used by ImageMagick                                        | `FloydSteinberg` |
| `S3_BUCKET`    | Target S3 bucket                                                            | _Required_       |
| `S3_PREFIX`    | Prefix path (folder) in the S3 bucket for uploads                           | _Required_       |
| `AWS_REGION`   | AWS region of the target S3 bucket                                          | _Required_       |
| `REFRESH_RATE` | Refresh rate metadata for the manifest file, in seconds                     | _Required_       |

### Example

```shell
docker run --rm \
  -e S3_BUCKET=my-bucket \
  -e S3_PREFIX=processed-images \
  -e AWS_REGION=us-east-1 \
  -e REFRESH_RATE=300 \
  -v $(pwd)/pngs:/data/pngs \
  ghcr.io/rmitchellscott/trmnl-png-processor
```

## Output

- Processed PNG saved as `/data/pngs/<output_name>.png`
- Manifest JSON saved as `/data/pngs/<manifest_name>.json`
- Both uploaded to the specified S3 location.

## Requirements

- AWS credentials must be available in the container via environment variables or volume-mounted config.

## License

MIT
