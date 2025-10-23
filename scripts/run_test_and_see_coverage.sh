#!/bin/bash
# chmod +x ./scripts/run_test_and_see_coverage.sh

set -e

echo "🧪 Ejecutando tests con cobertura..."
rm -rf coverage
mkdir -p coverage

# Unit tests
flutter test --coverage

# Integration tests
for test in integration_test/*.dart; do
  echo "🚀 Ejecutando $test..."
  flutter test --coverage "$test"
done

# Combinar cobertura
lcov --rc lcov_branch_coverage=1 \
  --add-tracefile coverage/lcov.info \
  --output-file coverage/lcov.info

echo "📊 Generando reporte HTML..."
genhtml coverage/lcov.info -o coverage/html

echo "✅ Reporte listo: coverage/html/index.html"
case "$OSTYPE" in
  darwin*) open coverage/html/index.html ;;
  linux*) xdg-open coverage/html/index.html ;;
  msys*) start coverage/html/index.html ;;
esac
