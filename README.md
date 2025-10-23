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

# ver cobertura
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Ejecutar un archivo específico de tests
flutter test test/common/environment_test.dart

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

## A futuro que podemos mejorar

A futuro podemos mejorar en inyección de dependencias, explicar lo que son las arquitecturas emergentes, los golden test y las pruebas de widgets.