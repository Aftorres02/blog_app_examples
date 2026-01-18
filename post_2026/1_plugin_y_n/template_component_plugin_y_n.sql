prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>30950913295044589
,p_default_application_id=>40100
,p_default_id_offset=>0
,p_default_owner=>'TASK_FLOW'
);
end;
/
 
prompt APPLICATION 40100 - Task Flow
--
-- Application Export:
--   Application:     40100
--   Name:            Task Flow
--   Date and Time:   04:03 Sunday January 18, 2026
--   Exported By:     DEV_1
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 96793654458468808
--   Manifest End
--   Version:         24.2.11
--   Instance ID:     9513947256704846
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/template_component/y_n
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(96793654458468808)
,p_plugin_type=>'TEMPLATE COMPONENT'
,p_theme_id=>nvl(wwv_flow_application_install.get_theme_id, '')
,p_name=>'Y_N'
,p_display_name=>'Y_N'
,p_supported_component_types=>'PARTIAL'
,p_css_file_urls=>'#WORKSPACE_FILES#css/y_n#MIN#.css'
,p_partial_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{if APEX$IS_LAZY_LOADING/}',
'  <div>#VALUE#</div>',
'   ',
'{else/}',
' ',
'  {if ?VALUE/}',
'',
'      {case VALUE/}',
unistr('        {when Y/} <span class="icon-check" title="#VALUE#">\2713</span>'),
'',
unistr('        {when N/} <span class="icon-x">\2717</span>'),
'        {otherwise/}',
'      {endcase/}',
'    ',
'  {endif/}',
' ',
'',
'{endif/}'))
,p_default_escape_mode=>'HTML'
,p_translate_this_template=>false
,p_api_version=>1
,p_standard_attributes=>'ROW_SELECTION:REGION_TEMPLATE'
,p_substitute_attributes=>true
,p_version_scn=>41738715778337
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(96952730018974720)
,p_plugin_id=>wwv_flow_imp.id(96793654458468808)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'VALUE'
,p_prompt=>'Value'
,p_attribute_type=>'SESSION STATE VALUE'
,p_is_required=>true
,p_escape_mode=>'HTML'
,p_column_data_types=>'VARCHAR2'
,p_is_translatable=>false
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
