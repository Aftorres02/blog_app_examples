-- TaskFlow Navigation Menu Merge Examples
-- Version: 1.0
-- Description: Merge statements for navigation menu with application IDs
-- Application IDs: Core (10000), TaskFlow (10200), Projects (10300)

truncate table core_navigation_menu;

-- MERGE 1: Insert Parent Menus (Level 1)
merge into core_navigation_menu target
using (
  select 'CORE_MULTI_TENANCY' as menu_name
       , 'Multi-Tenancy' as menu_label
       , 10000 as app_id -- Core App
       , null as target_page -- Parent menu
       , null as parent_id
       , 1 as menu_level
       , 10 as sort_order
       , 'fa-building' as icon_class
       , 'Gestión multi-tenant' as image_alt_text
       , null as is_current
    from dual
  union all
  select 'CORE_SECURITY' as menu_name
       , 'Security' as menu_label
       , 10000 as app_id -- Core App
       , null as target_page -- Parent menu
       , null as parent_id
       , 1 as menu_level
       , 20 as sort_order
       , 'fa-shield' as icon_class
       , 'Seguridad del sistema' as image_alt_text
       , null as is_current
    from dual
  union all
  select 'CORE_CONFIGURATION' as menu_name
       , 'Configuration' as menu_label
       , 10000 as app_id -- Core App
       , null as target_page -- Parent menu
       , null as parent_id
       , 1 as menu_level
       , 30 as sort_order
       , 'fa-cogs' as icon_class
       , 'Configuración del sistema' as image_alt_text
       , null as is_current
    from dual
  union all
  select 'PROJECTS' as menu_name
       , 'Projects' as menu_label
       , 10300 as app_id -- Projects App
       , 10 as target_page -- Projects main page
       , null as parent_id
       , 1 as menu_level
       , 50 as sort_order
       , 'fa-folder' as icon_class
       , 'Gestión de proyectos' as image_alt_text
       , null as is_current
    from dual
  union all 
  select 'TICKETS_MY' as menu_name
       , 'My Tickets' as menu_label
       , 10200 as app_id -- TaskFlow App
       , 1 as target_page -- My tickets page
       , null as parent_id
       , 1 as menu_level
       , 60 as sort_order
       , 'fa-user' as icon_class
       , 'Mis tickets' as image_alt_text
       , null as is_current
    from dual
) source
on (
  target.menu_name = source.menu_name
)
when matched then
  update set
    target.menu_label = source.menu_label
  , target.app_id = source.app_id
  , target.target_page = source.target_page
  , target.parent_id = source.parent_id
  , target.menu_level = source.menu_level
  , target.sort_order = source.sort_order
  , target.icon_class = source.icon_class
  , target.image_alt_text = source.image_alt_text
  , target.is_current = source.is_current
when not matched then
  insert (
    menu_name
  , menu_label
  , app_id
  , target_page
  , parent_id
  , menu_level
  , sort_order
  , icon_class
  , image_alt_text
  , is_current
  )
  values (
    source.menu_name
  , source.menu_label
  , source.app_id
  , source.target_page
  , source.parent_id
  , source.menu_level
  , source.sort_order
  , source.icon_class
  , source.image_alt_text
  , source.is_current
  )
/
commit
/

-- MERGE 2: Insert Child Menus (Level 2) with proper parent references
merge into core_navigation_menu target
using (
  select 'TENANTS' as menu_name
       , 'Tenants' as menu_label
       , 10000 as app_id -- Core App
       , 10 as target_page -- Tenants management page
       , (select id from core_navigation_menu where menu_name = 'CORE_MULTI_TENANCY') as parent_id
       , 2 as menu_level
       , 10 as sort_order
       , 'fa-building' as icon_class
       , 'Gestión de tenants' as image_alt_text
       , 'Y' as is_current
    from dual
  union all
  select 'USERS' as menu_name
       , 'Users' as menu_label
       , 10000 as app_id -- Core App
       , 2000 as target_page -- Users management page
       , (select id from core_navigation_menu where menu_name = 'CORE_MULTI_TENANCY') as parent_id
       , 2 as menu_level
       , 20 as sort_order
       , 'fa-users' as icon_class
       , 'Gestión de usuarios' as image_alt_text
       , 'Y' as is_current
    from dual
  union all
  select 'CORE_USER_AUTH_METHODS' as menu_name
       , 'User Auth Methods' as menu_label
       , 10000 as app_id -- Core App
       , 3000 as target_page -- User Auth Methods page
       , (select id from core_navigation_menu where menu_name = 'CORE_SECURITY') as parent_id
       , 2 as menu_level
       , 10 as sort_order
       , 'fa-key' as icon_class
       , 'Gestión de autenticación' as image_alt_text
       , 'Y' as is_current
    from dual
  union all
  select 'NAVIGATION_CONFIG' as menu_name
       , 'Navigation Config' as menu_label
       , 10000 as app_id -- Core App
       , 1000 as target_page -- Navigation Config page
       , (select id from core_navigation_menu where menu_name = 'CORE_CONFIGURATION') as parent_id
       , 2 as menu_level
       , 10 as sort_order
       , 'fa-sitemap' as icon_class
       , 'Configuración de navegación' as image_alt_text
       , 'Y' as is_current
    from dual
  ) source
  on (
    target.menu_name = source.menu_name
  )
  when matched then
    update set
      target.menu_label = source.menu_label
    , target.app_id = source.app_id
    , target.target_page = source.target_page
    , target.parent_id = source.parent_id
    , target.menu_level = source.menu_level
    , target.sort_order = source.sort_order
    , target.icon_class = source.icon_class
    , target.image_alt_text = source.image_alt_text
    , target.is_current = source.is_current
  when not matched then
    insert (
      menu_name
    , menu_label
    , app_id
    , target_page
    , parent_id
    , menu_level
    , sort_order
    , icon_class
    , image_alt_text
    , is_current
    )
    values (
      source.menu_name
    , source.menu_label
    , source.app_id
    , source.target_page
    , source.parent_id
    , source.menu_level
    , source.sort_order
    , source.icon_class
    , source.image_alt_text
    , source.is_current
    )
  /
  commit
  /
