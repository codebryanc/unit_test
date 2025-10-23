#!/bin/bash
# chmod +x ./scripts/run_test_and_see_coverage.sh

set -e

echo "🧪 Ejecutando tests con cobertura..."
rm -rf coverage
mkdir -p coverage/temp

# Unit tests
echo "📝 Ejecutando unit tests..."
flutter test --coverage
if [ -f coverage/lcov.info ]; then
  mv coverage/lcov.info coverage/temp/unit_tests.info
  echo "✅ Unit tests completados"
else
  echo "⚠️  No se generó cobertura para unit tests"
fi

# Integration tests
INTEGRATION_COUNT=0
if [ -d integration_test ]; then
  for test in integration_test/*.dart; do
    if [ -f "$test" ]; then
      echo "🚀 Ejecutando $test..."
      flutter test --coverage "$test"

      if [ -f coverage/lcov.info ]; then
        TEST_NAME=$(basename "$test" .dart)
        mv coverage/lcov.info "coverage/temp/integration_${TEST_NAME}.info"
        INTEGRATION_COUNT=$((INTEGRATION_COUNT + 1))
        echo "✅ Test completado: $TEST_NAME"
      fi
    fi
  done
fi

# Combinar todos los archivos de cobertura
echo "📊 Combinando archivos de cobertura..."
COVERAGE_FILES=$(find coverage/temp -name "*.info" -type f)

if [ -z "$COVERAGE_FILES" ]; then
  echo "❌ No se encontraron archivos de cobertura"
  exit 1
fi

# Construir comando lcov para combinar todos los archivos
LCOV_CMD="lcov --rc lcov_branch_coverage=1"
for file in $COVERAGE_FILES; do
  LCOV_CMD="$LCOV_CMD --add-tracefile $file"
done
LCOV_CMD="$LCOV_CMD --output-file coverage/lcov.info"

# Ejecutar combinación
eval $LCOV_CMD

echo "✅ Archivos combinados: $(echo $COVERAGE_FILES | wc -w | tr -d ' ') archivos"

# Generar reporte HTML
echo "📊 Generando reporte HTML..."
genhtml coverage/lcov.info -o coverage/html --branch-coverage

# Limpiar archivos temporales
rm -rf coverage/temp

# Mostrar estadísticas
echo ""
echo "📈 Resumen de cobertura:"
lcov --summary coverage/lcov.info

echo ""
echo "✅ Reporte listo: coverage/html/index.html"
case "$OSTYPE" in
  darwin*) open coverage/html/index.html ;;
  linux*) xdg-open coverage/html/index.html ;;
  msys*) start coverage/html/index.html ;;
esac
