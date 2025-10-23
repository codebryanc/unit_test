# Unit Testing en Flutter

Una guía práctica para implementar y entender las pruebas unitarias y pruebas de integración.

## Clase Base: Mobile version code

Dentro del código encontraras bases para entender como mostrar y validar la versión de una aplicación

## 🚀 Comandos Rápidos

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Ejecutar un archivo específico de tests
flutter test test/calculator_test.dart

# Ejecutar tests en modo watch
flutter test --watch
```

## 📁 Estructura del Proyecto

```
test/
├── widget_test.dart      # Tests de widgets
├── calculator_test.dart  # Tests de la clase Calculator
└── models/
    └── user_test.dart   # Tests de modelos
```

## 🎯 Objetivos de Aprendizaje

Al completar esta guía de 10 minutos, serás capaz de:
- ✅ Entender qué son las pruebas unitarias
- ✅ Escribir tests básicos