SELECT
    SYS_CONTEXT('USERENV', 'SESSION_USER')       AS session_user,
    SYS_CONTEXT('USERENV', 'CURRENT_USER')       AS current_user,
    SYS_CONTEXT('USERENV', 'OS_USER')            AS os_user,
    SYS_CONTEXT('USERENV', 'IP_ADDRESS')         AS ip_address,
    SYS_CONTEXT('USERENV', 'HOST')               AS host
FROM dual;