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
    echo "Type 'exit' to disconnect from Oracle."
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