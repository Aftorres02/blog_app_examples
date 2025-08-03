-- TaskFlow Navigation Menu View
-- Version: 1.0
-- Description: Dynamic navigation menu view for APEX


create or replace view core_navigation_menu_vw as
with w_params as (
    select (select v('APP_ID') from dual) as app_id
         , (select v('APP_PAGE_ID') from dual) as page_id
  from dual
)
select 
    nm.menu_level as menu_level -- Hierarchical level (1=root, 2=submenu, etc.)
  , nm.menu_label as menu_label -- Text displayed in the navigation menu
  , apex_page.get_url (
        p_application => nm.app_id
      , p_page        => nm.target_page
    ) as target_url
  , case when p.app_id = nm.app_id
          and p.page_id = nm.target_page 
         then 'YES' 
         else null
     end is_current_list_entry -- YES=always current, NO=never current, NULL=dynamic detection
  , nm.icon_class as icon_image -- CSS icon class (e.g., fa-home, fa-user) or Image file name
  , nm.image_attributes as image_attributes -- width, height, etc.
  , nm.image_alt_text as image_alt_text -- Alt text for accessibility
  , nm.sort_order -- Display order within the same level
  , nm.active_yn -- Indicates if the menu item is active (Y) or not (N)
from core_navigation_menu nm
cross join w_params p
where nm.active_yn = 'Y'
start with nm.parent_id is null
connect by prior nm.id = nm.parent_id
order siblings by nm.sort_order, nm.menu_label
/

-- view comment
begin
  execute immediate 'comment on table core_navigation_menu_vw is ''Dynamic navigation menu view for TaskFlow system.''';
end;
/