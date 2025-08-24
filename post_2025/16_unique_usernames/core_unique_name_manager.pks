create or replace package core_unique_name_manager as
/*
  Package: core_unique_name_manager
  Description: Generic package to manage unique names for any entity type
  Author: TaskFlow Team
  Date: 2025
*/

  -- ========================================
  -- CORE FUNCTIONS
  -- ========================================

  -- Generate unique name for any entity type
  function generate_unique_name(
    p_entity_type                    in varchar2
  , p_base_name                      in varchar2
  ) return varchar2;

  -- Generate unique username (wrapper for users)
  function generate_unique_username(
    p_first_name                     in varchar2
  , p_last_name                      in varchar2
  ) return varchar2;

end core_unique_name_manager;
/
