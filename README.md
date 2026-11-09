# 🚨 FireSentinel — Sistema IoT de Detección y Alerta Temprana de Incendios

**FireSentinel** es una solución IoT integral diseñada para la detección temprana de incendios y fugas de gas. El sistema monitorea en tiempo real variables ambientales mediante sensores físicos conectados a un ESP32 y distribuye alertas críticas instantáneas a través de notificaciones push (FCM) y correos electrónicos automáticos hacia una aplicación móvil desarrollada en Flutter.

---

## 🏗️ Arquitectura del Sistema

[ ESP32 + Sensores ] ──(Wi-Fi)──> [ Firebase Realtime Database ]

MQ-2 (Humo/Gas)                        │

DHT11 (Temp/Humedad)                   ▼
[ Cloud Functions (Node.js) ]
│
┌──────────────────────┴──────────────────────┐
▼                                             ▼
[ Firebase Cloud Messaging ]                [ Nodemailer (SMTP) ]
│                                             │
▼                                             ▼
📱 App Móvil (Flutter)                        📧 Correo Electrónico


---

## 🛠️ Componentes y Tecnologías

### 1. Hardware (Nodo Sensor)
* **Microcontrolador:** ESP32 Dev Module (Conectividad Wi-Fi integrada).
* **Sensor de Gas/Humo:** **MQ-2** (Monitoreo de GLP, propano, metano y humo conectado a pin analógico/ADC).
* **Sensor de Temperatura y Humedad:** **DHT11** (Conectado a pin digital).
* **Indicadores Locales:** Buzzer activo y LED de estado/emergencia.

### 2. Backend & Cloud (Firebase)
* **Realtime Database:** Almacenamiento en tiempo real del estado `/sistema/alerta` (`true`/`false`) y lecturas de sensores.
* **Cloud Functions (Node.js / v1):** Trigger reactivo asignado al nodo `/sistema/alerta` que dispara el protocolo de emergencia al detectar cambios.
* **Firebase Cloud Messaging (FCM):** Envío masivo de alertas críticas mediante suscripción al tema (Topic) `alertas_incendio`.
* **Nodemailer (SMTP Gmail):** Despacho automatizado de correos electrónicos de emergencia con soporte HTML.

### 3. Aplicación Móvil (Flutter)
* **Framework:** Flutter (Dart).
* **Autenticación:** Firebase Authentication (Email / Password).
* **Estado y Notificaciones:** Recepción de push notifications en primer plano y segundo plano con manejo de canales de alta prioridad en Android.

---

## ⚡ Flujo de Funcionamiento

1. **Lectura y Umbrales (ESP32):** El ESP32 evalúa constantemente los niveles analógicos del MQ-2 y la temperatura del DHT11.
2. **Disparo de Emergencia:** Si las lecturas superan el umbral de seguridad, el ESP32 conmuta el nodo `/sistema/alerta` a `true` en Firebase Realtime Database.
3. **Ejecución de Backend:** La Cloud Function `enviarAlertaIncendio` detecta el cambio de estado.
4. **Notificación Multicanal:**
   * Emite una notificación push a todos los dispositivos suscritos al tema `alertas_incendio`.
   * Envía un correo de alerta crítica vía SMTP a los contactos de emergencia configurados.

---

## 🚀 Guía de Instalación y Despliegue

### 📋 Prerrequisitos
* **Flutter SDK:** ^3.0.0
* **Node.js:** v20 LTS
* **Firebase CLI:** Instalado y autenticado (`npm install -g firebase-tools`).
* **Arduino IDE / PlatformIO:** Con soporte para placas ESP32 y librerías `DHT`, `FirebaseESP32` / `FirebaseClient`.

---

### 1. Configuración del Backend (Cloud Functions)

Navega a la carpeta del backend e instala las dependencias:

```bash
cd backend/functions
npm install firebase-functions@latest firebase-admin@latest nodemailer
Despliega la función a tu proyecto de Firebase:

Bash
firebase deploy --only functions
2. Configuración del Hardware (ESP32)
Conecta los sensores al ESP32:

MQ-2 (Salida Analógica A0): GPIO 34 (o pin ADC asignado).

DHT11 (Data): GPIO 4 (con resistencia pull-up de 10k Ω).

Buzzer / LED: GPIO 26.

Carga el firmware asegurando incluir tus credenciales Wi-Fi, la URL de tu Realtime Database y las credenciales de autenticación.

3. Configuración de la App Móvil (Flutter)
Clona el repositorio e instala las dependencias:

Bash
flutter pub get
Asegúrate de incluir tu archivo google-services.json en la ruta android/app/.

Ejecuta la aplicación en tu dispositivo físico o emulador:

Bash
flutter run
🔐 Configuración de Seguridad y Notificaciones
Canal de Notificaciones (Android): Asegúrate de otorgar permisos de notificaciones en el primer inicio de la app. En dispositivos con gestión agresiva de batería, deshabilita la optimización para mantener el receptor de FCM activo en segundo plano.

Credenciales SMTP: Se recomienda manejar las claves de correo en index.js mediante variables de entorno para entornos de producción.

✒️ Autor y Créditos
Proyecto desarrollado por Juan Rincón como una solución integral de IoT, backend en la nube y desarrollo móvil para la gestión de emergencias y protección de espacios.
