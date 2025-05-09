#!/usr/bin/env bash
set -euo pipefail

SRC=$(ls /data/pngs/*.png 2>/dev/null || true)
if [[ -z "$SRC" ]]; then
  echo "$(date +%T)  → no new PNG, skipping upload."
  exit 0
fi

BASE_NAME=${OUTPUT_NAME:-$(date +%s)}
MANIFEST_NAME=${MANIFEST_NAME:-manifest}

TS=$(date +%s)
OUT="/data/pngs/${BASE_NAME}.png"
MANIFEST="/data/pngs/${MANIFEST_NAME}.json"

magick "$SRC" \
  -rotate ${ROTATION:-0} \
  -colors ${COLORS:-16} \
  -dither ${DITHERING:-FloydSteinberg} \
  -depth 1 \
  -strip \
  png:"$OUT"

cat > "$MANIFEST" <<EOF
{
  "filename": "${TS}",
  "url": "https://${S3_BUCKET}.s3.${AWS_REGION}.amazonaws.com/${S3_PREFIX}/${BASE_NAME}.png",
  "refresh_rate": "${REFRESH_RATE}"
}
EOF

# upload both to S3
aws s3 cp "$OUT"        "s3://${S3_BUCKET}/${S3_PREFIX}/${BASE_NAME}.png"
aws s3 cp "$MANIFEST"   "s3://${S3_BUCKET}/${S3_PREFIX}/${MANIFEST_NAME}.json"

echo "$(date +%T)  → uploaded ${BASE_NAME}.png + ${MANIFEST_NAME}.json"
