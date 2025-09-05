Ejecutar SQLcl desde macOS: Configuración y Uso
Introducción
SQLcl (SQL Command Line) es la herramienta oficial de Oracle para conectarse a bases de datos Oracle desde la línea de comandos. En este post te mostraré cómo configurar SQLcl en macOS para conectarte a Oracle Autonomous Database de manera rápida y eficiente.
Configuración del Script de Conexión
Primero, necesitamos crear un script que automatice la conexión a Oracle. El archivo oci_dev_1.sh contiene toda la configuración necesaria:
#!/bin/bash

# Oracle Database Connection Script
# Usage: ./oci_connect_simple_final.sh

# Configuration
SQLCL_PATH="/Users/angel/applications/sqlcl/bin/sql"
WALLET_PATH="/Users/angel/Oracle/wallets/Wallet_DBCS1.zip"
DB_USER="dev_1"
DB_CONNECTION="dbcs1_medium"
DB_PASSWORD='my_password'

# Validate requirements
validate_requirements() {
    if [ ! -f "$SQLCL_PATH" ]; then
        echo "Error: SQLcl not found at $SQLCL_PATH"
        exit 1
    fi
    
    if [ ! -f "$WALLET_PATH" ]; then
        echo "Error: Wallet file not found at $WALLET_PATH"
        exit 1
    fi
}

# Connect to Oracle
connect_oracle() {
    validate_requirements
    
    echo "Starting interactive SQLcl session..."
    echo ""
    
    # Create a simple connection script in home directory
    local connect_script="$HOME/.oracle_connect.sql"
    
    cat > "$connect_script" << EOF
set cloudconfig $WALLET_PATH
set define off
connect $DB_USER/$DB_PASSWORD@$DB_CONNECTION
prompt Connected to Oracle Database.
prompt
EOF
    
    # Start SQLcl with the connection script
    exec "$SQLCL_PATH" -nolog "@$connect_script"
}

# Execute connection
connect_oracle
Explicación del Script
El script hace lo siguiente:
Configuración: Define las rutas de SQLcl, wallet y credenciales de conexión
Validación: Verifica que SQLcl y el wallet existan
Conexión: Crea un script de conexión y ejecuta SQLcl en modo interactivo
Persistencia: Usa exec para mantener la sesión abierta
Pasos de Configuración en macOS
1. Editar el archivo de configuración de shell
Abre tu archivo de configuración de zsh:
nano ~/.zshrc
2. Agregar las variables de entorno de Java
Agrega estas líneas al final del archivo:
export JAVA_HOME="/Applications/SQLDeveloper.app/Contents/Resources/sqldeveloper/jdk"
export PATH="$JAVA_HOME/bin:$PATH"
3. Crear el alias para el script
Agrega esta línea para crear un alias que ejecute tu script:
alias oci_dev_1='sh ~/Oracle/connections/oci_dev_1.sh'
O usando la ruta completa:
alias oci_dev_1='sh /Users/angel.flores/Oracle/connections/oci_dev_1.sh'
4. Recargar la configuración
Después de guardar el archivo, recarga la configuración:
source ~/.zshrc
Uso
Una vez configurado, simplemente ejecuta:
oci_dev_1
Esto te conectará automáticamente a tu base de datos Oracle y mantendrá la sesión interactiva hasta que escribas exit.
Ventajas de esta configuración
✅ Conexión automática: No necesitas recordar comandos complejos
✅ Sesión interactiva: Mantiene la conexión abierta para ejecutar queries
✅ Validación automática: Verifica que todo esté configurado correctamente
✅ Fácil mantenimiento: Un solo archivo para toda la configuración
Personalización
Puedes modificar las variables en el script para conectarte a diferentes ambientes:
SQLCL_PATH: Ruta donde está instalado SQLcl
WALLET_PATH: Ruta al archivo wallet de Oracle
DB_USER: Usuario de la base de datos
DB_CONNECTION: Nombre de la conexión
DB_PASSWORD: Contraseña del usuario
Con esta configuración, tendrás SQLcl funcionando perfectamente en macOS con acceso rápido y fácil a tu base de datos Oracle.