# RespiraCheck Pro

RespiraCheck Pro es una aplicación desarrollada en Flutter como evidencia individual para la actividad de desarrollo de apps. Su objetivo es orientar de manera educativa al usuario a partir de síntomas respiratorios comunes, temperatura corporal, días de evolución y factores de riesgo.

La aplicación no emite diagnósticos médicos definitivos. Su función es mostrar una preclasificación orientativa y una recomendación básica de seguimiento.

## Objetivo de la app

Desarrollar una aplicación sencilla en Flutter que permita capturar datos básicos del usuario y síntomas respiratorios para generar una orientación inicial de salud de forma visual, clara e interactiva.

## Funcionalidades principales

- Registro de edad y sexo del usuario.
- Selección de temperatura corporal mediante control deslizante.
- Registro de días con síntomas.
- Selección de síntomas respiratorios.
- Selección de factores de riesgo.
- Evaluación automática mediante lógica condicional.
- Resultado orientativo con color, ícono y recomendación.
- Interfaz visual responsiva y centrada.
- Aviso de uso educativo y no diagnóstico.

## Variables utilizadas

### Datos demográficos

- Edad
- Sexo

### Variable fisiológica

- Temperatura corporal

### Datos clínicos orientativos

- Días con síntomas
- Tos
- Fiebre
- Congestión nasal
- Dolor de garganta
- Estornudos frecuentes
- Ojos llorosos o comezón
- Dolor de cuerpo
- Fatiga
- Pérdida de olfato o gusto
- Dificultad para respirar

### Factores de riesgo

- Asma o enfermedad respiratoria
- Tabaquismo
- Defensas bajas

## Resultados orientativos posibles

La aplicación puede clasificar los datos ingresados en diferentes resultados orientativos, como:

- Compatible con alergia respiratoria
- Compatible con resfriado común
- Posible cuadro infeccioso respiratorio
- Signos de alerta respiratoria
- Síntomas leves o poco específicos

## Casos de prueba utilizados

Se realizaron pruebas funcionales con tres escenarios clínicos simulados:

### Caso 1: Alergia respiratoria

Usuario joven, sin fiebre, con congestión nasal, estornudos frecuentes y ojos llorosos.  
Resultado esperado: compatible con alergia respiratoria.

### Caso 2: Posible cuadro infeccioso respiratorio

Usuario joven con fiebre, tos, dolor de garganta, dolor de cuerpo, fatiga y tabaquismo como factor de riesgo.  
Resultado esperado: posible cuadro infeccioso respiratorio.

### Caso 3: Signos de alerta respiratoria

Usuario adulto mayor con fiebre alta, dificultad para respirar, dolor de cuerpo, fatiga y factores de riesgo respiratorios.  
Resultado esperado: signos de alerta respiratoria.

## Tecnologías utilizadas

- Flutter
- Dart
- Visual Studio Code
- Git
- GitHub

## Cómo ejecutar el proyecto

Para correr la aplicación localmente:

```bash
flutter pub get
flutter run -d chrome