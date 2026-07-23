#!/bin/bash
# Genera un vídeo de prova amb un objecte en moviment, útil per validar
# el pipeline de detecció de moviment (Model 1) sense necessitar material
# real d'ocells. YOLO NO el classificarà com "bird" (és una forma sintètica),
# així que per veure el pipeline COMPLET (moviment + YOLO + crop + API)
# canvia BIRD_CLASS_NAME a "person" al docker-compose.yml i posa't tu
# mateix davant la webcam, o fes servir un vídeo real d'ocells/persones.
#
# Ús: ./generate_test_video.sh
# Requereix ffmpeg instal·lat al host.

set -e

OUTPUT_DIR="$(dirname "$0")/../../apps/edge/media"
mkdir -p "$OUTPUT_DIR"

ffmpeg -y \
  -f lavfi -i "testsrc2=size=1280x720:rate=25" \
  -f lavfi -i "life=size=100x100:rate=25:mold=10" \
  -filter_complex "[1:v]scale=80:80[obj];[0:v][obj]overlay=x='mod(t*150\,1280)':y=300" \
  -t 60 \
  -c:v libx264 -pix_fmt yuv420p \
  "$OUTPUT_DIR/sample.mp4"

echo "Vídeo de prova generat a $OUTPUT_DIR/sample.mp4"
