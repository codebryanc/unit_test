#!/bin/bash

# Script para ejecutar pruebas unitarias y de integración con reporte de cobertura
# Autor: Claude Code
# Fecha: 2024-10-22

set -e  # Detener si hay algún error

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Test Runner con Cobertura Combinada  ${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Limpiar cobertura anterior
echo -e "${YELLOW}📦 Limpiando reportes anteriores...${NC}"
rm -rf coverage/
mkdir -p coverage

# Ejecutar pruebas unitarias con cobertura
echo -e "\n${BLUE}🧪 Ejecutando pruebas unitarias...${NC}"
flutter test --coverage || {
    echo -e "${RED}❌ Error en pruebas unitarias${NC}"
    exit 1
}

echo -e "${GREEN}✅ Pruebas unitarias completadas${NC}"

# Verificar si existe lcov.info
if [ ! -f "coverage/lcov.info" ]; then
    echo -e "${RED}❌ Error: No se generó el archivo coverage/lcov.info${NC}"
    exit 1
fi

# Verificar si genhtml está instalado
if ! command -v genhtml &> /dev/null; then
    echo -e "${YELLOW}⚠️  genhtml no está instalado${NC}"
    echo -e "${YELLOW}   En macOS, instálalo con: brew install lcov${NC}"
    echo -e "${YELLOW}   En Linux, instálalo con: sudo apt-get install lcov${NC}"

    # Intentar mostrar resumen de cobertura sin genhtml
    echo -e "\n${BLUE}📊 Resumen de cobertura:${NC}"
    if command -v lcov &> /dev/null; then
        lcov --summary coverage/lcov.info
    else
        echo -e "${YELLOW}Archivo de cobertura generado en: coverage/lcov.info${NC}"
    fi
    exit 1
fi

# Generar reporte HTML
echo -e "\n${BLUE}📊 Generando reporte HTML de cobertura...${NC}"
genhtml coverage/lcov.info -o coverage/html --quiet || {
    echo -e "${RED}❌ Error al generar reporte HTML${NC}"
    exit 1
}

echo -e "${GREEN}✅ Reporte HTML generado en: coverage/html/${NC}"

# Mostrar resumen de cobertura
echo -e "\n${BLUE}📈 Resumen de cobertura:${NC}"
lcov --summary coverage/lcov.info 2>&1 | grep -E "lines\.\.\.|functions\.\.\."

# Abrir reporte en el navegador
echo -e "\n${BLUE}🌐 Abriendo reporte en el navegador...${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open coverage/html/index.html
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v xdg-open &> /dev/null; then
        xdg-open coverage/html/index.html
    else
        echo -e "${YELLOW}Abre manualmente: coverage/html/index.html${NC}"
    fi
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows
    start coverage/html/index.html
else
    echo -e "${YELLOW}Abre manualmente: coverage/html/index.html${NC}"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}  ✅ Todas las pruebas completadas!    ${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${BLUE}📁 Archivos generados:${NC}"
echo -e "   - coverage/lcov.info (datos de cobertura)"
echo -e "   - coverage/html/index.html (reporte visual)"
echo -e "\n${BLUE}💡 Tip: Para ver solo el reporte:${NC}"
echo -e "   open coverage/html/index.html\n"
