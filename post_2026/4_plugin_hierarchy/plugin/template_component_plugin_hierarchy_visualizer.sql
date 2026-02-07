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
,p_release=>'24.2.13'
,p_default_workspace_id=>25436533369635843805
,p_default_application_id=>32431
,p_default_id_offset=>0
,p_default_owner=>'BLOG_ANGEL'
);
end;
/
 
prompt APPLICATION 32431 - A little knowledge to share
--
-- Application Export:
--   Application:     32431
--   Name:            A little knowledge to share
--   Date and Time:   17:29 Saturday February 7, 2026
--   Exported By:     AFTORRES02@GMAIL.COM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 134725692368223913349
--   Manifest End
--   Version:         24.2.13
--   Instance ID:     63113759365424
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/template_component/hierarchy_visualizer
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(134725692368223913349)
,p_plugin_type=>'TEMPLATE COMPONENT'
,p_theme_id=>nvl(wwv_flow_application_install.get_theme_id, '')
,p_name=>'HIERARCHY_VISUALIZER'
,p_display_name=>'Hierarchy Visualizer'
,p_supported_component_types=>'PARTIAL:REPORT'
,p_css_file_urls=>'#APP_FILES#css/hierarchy_template_component#MIN#.css'
,p_partial_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{if APEX$IS_LAZY_LOADING/}',
'<div style="padding-left: calc((#HIERARCHY_LEVEL# - 1) * #INDENT_STEP#px);">',
'  ...',
'</div>',
'{else/}',
'<div',
'  class="hierarchy-item mode-#INDENT_STYLE#{if IS_LEAF/} leaf-node{else/} parent-node{endif/}"',
'>',
'  {case INDENT_STYLE/} {when LINES/}',
'  <!-- Stretch Mode: Dynamic Width Line -->',
'  <!-- Width = (Level - 1) * Step + Offset (e.g. 10px) -->',
'  <span',
'    class="line-leader"',
'    style="width: calc((#HIERARCHY_LEVEL# - 1) * #INDENT_STEP#px + 10px); background-color: #PARENT_COLOR#"',
'  >',
'  </span>',
'  {when DOTS/}',
'  <!-- Stretch Mode: Dynamic Width Dots -->',
'  <span',
'    class="dot-leader"',
'    style="width: calc((#HIERARCHY_LEVEL# - 1) * #INDENT_STEP#px + 10px); border-color: #PARENT_COLOR#"',
'  >',
'  </span>',
'  {otherwise/}',
'  <!-- Standard Indent Mode using Margin/Spacer -->',
'  <span',
'    class="indent-spacer"',
'    style="width: calc((#HIERARCHY_LEVEL# - 1) * #INDENT_STEP#px);"',
'  ></span>',
'',
'  {case INDENT_STYLE/} {when ICONS/} {if IS_LEAF/}',
'  <span',
'    class="hierarchy-icon fa fa-file-o"',
'    aria-hidden="true"',
'    style="color: #LEAF_COLOR#"',
'  ></span>',
'  {else/}',
'  <span',
'    class="hierarchy-icon fa fa-folder-o"',
'    aria-hidden="true"',
'    style="color: #PARENT_COLOR#"',
'  ></span>',
'  {endif/} {when CHEVRONS/} {if IS_LEAF/}',
'  <span',
'    class="hierarchy-icon fa fa-angle-right"',
'    aria-hidden="true"',
'    style="opacity: 0.5; color: #LEAF_COLOR#"',
'  ></span>',
'  {else/}',
'  <span',
'    class="hierarchy-icon fa fa-chevron-right"',
'    aria-hidden="true"',
'    style="color: #PARENT_COLOR#"',
'  ></span>',
'  {endif/} {when LSTEPS/}',
unistr('  <span class="ascii-icon" style="color: #PARENT_COLOR#">\2514\2500</span>'),
'  {when SPACES/}',
'  <!-- No Icon, handled by spacer -->',
'  {endcase/} {endcase/}',
'',
'  <span class="hierarchy-text">#LABEL#</span>',
'</div>',
'{endif/}'))
,p_default_escape_mode=>'HTML'
,p_translate_this_template=>false
,p_api_version=>1
,p_report_body_template=>'<ul>#APEX$ROWS#</ul>'
,p_report_row_template=>'<li #APEX$ROW_IDENTIFICATION#>#APEX$PARTIAL#</li>'
,p_report_placeholder_count=>3
,p_standard_attributes=>'ROW_SELECTION:REGION_TEMPLATE'
,p_substitute_attributes=>true
,p_version_scn=>15717305649460
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(134725692734586913364)
,p_plugin_id=>wwv_flow_imp.id(134725692368223913349)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'HIERARCHY_LEVEL'
,p_prompt=>'Hierarchy Level'
,p_attribute_type=>'SESSION STATE VALUE'
,p_is_required=>false
,p_escape_mode=>'HTML'
,p_column_data_types=>'VARCHAR2'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(134725693164623913364)
,p_plugin_id=>wwv_flow_imp.id(134725692368223913349)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>150
,p_static_id=>'INDENT_STEP'
,p_prompt=>'Indentation (px)'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'20'
,p_escape_mode=>'HTML'
,p_max_length=>100
,p_unit=>'pixels'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(134725693580526913365)
,p_plugin_id=>wwv_flow_imp.id(134725692368223913349)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'IS_LEAF'
,p_prompt=>'Is Leaf'
,p_attribute_type=>'SESSION STATE VALUE'
,p_is_required=>false
,p_escape_mode=>'HTML'
,p_column_data_types=>'VARCHAR2'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(134725693914609913365)
,p_plugin_id=>wwv_flow_imp.id(134725692368223913349)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_static_id=>'LABEL'
,p_prompt=>'Label Column'
,p_attribute_type=>'SESSION STATE VALUE'
,p_is_required=>false
,p_escape_mode=>'HTML'
,p_column_data_types=>'VARCHAR2'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(134725694369605913365)
,p_plugin_id=>wwv_flow_imp.id(134725692368223913349)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>110
,p_static_id=>'LEAF_ICON'
,p_prompt=>'Leaf Icon'
,p_attribute_type=>'ICON'
,p_is_required=>false
,p_default_value=>'fa-file-o'
,p_escape_mode=>'ATTR'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(134725694997644913366)
,p_plugin_id=>wwv_flow_imp.id(134725692368223913349)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_static_id=>'PARENT_ICON'
,p_prompt=>'Parent Icon'
,p_attribute_type=>'ICON'
,p_is_required=>false
,p_default_value=>'fa-folder-o'
,p_escape_mode=>'ATTR'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(134734698331009313624)
,p_plugin_id=>wwv_flow_imp.id(134725692368223913349)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>120
,p_static_id=>'LEAF_COLOR'
,p_prompt=>'Leaf Color'
,p_attribute_type=>'COLOR'
,p_is_required=>false
,p_default_value=>'#6f6f6f'
,p_escape_mode=>'ATTR'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(134734753609541319387)
,p_plugin_id=>wwv_flow_imp.id(134725692368223913349)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_static_id=>'PARENT_COLOR'
,p_prompt=>'Parent Color'
,p_attribute_type=>'COLOR'
,p_is_required=>false
,p_default_value=>'#ffa500'
,p_escape_mode=>'ATTR'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(134739239103515871936)
,p_plugin_id=>wwv_flow_imp.id(134725692368223913349)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>45
,p_static_id=>'INDENT_STYLE'
,p_prompt=>'Indent Style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'SPACES'
,p_escape_mode=>'HTML'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(134739247140057873865)
,p_plugin_attribute_id=>wwv_flow_imp.id(134739239103515871936)
,p_display_sequence=>10
,p_display_value=>'Spaces Only'
,p_return_value=>'SPACES'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(134739773568829880252)
,p_plugin_attribute_id=>wwv_flow_imp.id(134739239103515871936)
,p_display_sequence=>20
,p_display_value=>'Icons'
,p_return_value=>'ICONS'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(134739802481106885573)
,p_plugin_attribute_id=>wwv_flow_imp.id(134739239103515871936)
,p_display_sequence=>30
,p_display_value=>'Dotted Lines (..)'
,p_return_value=>'DOTS'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(134739907345128531713)
,p_plugin_attribute_id=>wwv_flow_imp.id(134739239103515871936)
,p_display_sequence=>40
,p_display_value=>'Chevrons'
,p_return_value=>'CHEVRONS'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(134739910436056532652)
,p_plugin_attribute_id=>wwv_flow_imp.id(134739239103515871936)
,p_display_sequence=>50
,p_display_value=>unistr('Solid Lines (\2500\2500)')
,p_return_value=>'LINES'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(134739990573948550184)
,p_plugin_attribute_id=>wwv_flow_imp.id(134739239103515871936)
,p_display_sequence=>60
,p_display_value=>unistr('L-Steps (\2514\2500')
,p_return_value=>'LSTEPS'
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
