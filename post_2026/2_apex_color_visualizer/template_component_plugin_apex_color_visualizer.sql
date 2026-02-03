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
--   Date and Time:   00:07 Tuesday February 3, 2026
--   Exported By:     DEV_1
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 58619498927709416
--   Manifest End
--   Version:         24.2.13
--   Instance ID:     9513947256704846
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/template_component/apex_color_visualizer
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(58619498927709416)
,p_plugin_type=>'TEMPLATE COMPONENT'
,p_theme_id=>nvl(wwv_flow_application_install.get_theme_id, '')
,p_name=>'APEX_COLOR_VISUALIZER'
,p_display_name=>'APEX Color Visualizer'
,p_supported_component_types=>'PARTIAL'
,p_css_file_urls=>'#WORKSPACE_FILES#css/color_visualizer#MIN#.css'
,p_partial_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{if APEX$IS_LAZY_LOADING/}',
'  <div>#HEX_COLOR#</div>',
'   ',
'{else/}',
'',
' {if ?HEX_COLOR/}',
'',
'  {case STYLE/}',
'',
'    {when RADIO/} ',
'      <!-- Radio button style: Large circular with white border and shadow ring -->',
'      <span class="color-container color-position-#POSITION#">',
'        <span class="color-radio ',
'                     color-radio-#SIZE# ',
'                     {if ?SHADOW/}',
'                       {case SHADOW/}',
'                         {when N/}color-no-shadow',
'                         {otherwise/}color-shadow-medium',
'                       {endcase/}',
'                     {endif/} ',
'                     {if ?BORDER/}',
'                       {case BORDER/}',
'                         {when N/}color-no-border',
'                         {when thin/}color-border-thin',
'                         {when thick/}color-border-thick',
'                         {otherwise/}',
'                       {endcase/}',
'                     {endif/}" ',
'              style="background-color:#HEX_COLOR#;" ',
'              title="#HEX_COLOR#">',
'        </span>',
'        {if ?SHOW_TEXT/}',
'          {case SHOW_TEXT/}',
'            {when N/}',
'            {otherwise/}',
'              <span class="color-text color-size-#SIZE#">#HEX_COLOR#</span>',
'          {endcase/}',
'        {endif/}',
'      </span>',
'',
'    {when PILL/} ',
'      <!-- Pill style: Rounded badge with color background -->',
'      <span class="color-pill ',
'                   color-pill-#SIZE# ',
'                   color-size-#SIZE# ',
'                   {if ?SHADOW/}',
'                     {case SHADOW/}',
'                       {when N/}color-no-shadow',
'                       {otherwise/}color-shadow-medium',
'                     {endcase/}',
'                   {endif/}" ',
'            style="background-color:#HEX_COLOR#;" ',
'            title="#HEX_COLOR#">',
'        #HEX_COLOR#',
'      </span>',
'',
'    {when SQUARE/} ',
'      <!-- Square style: Square color swatch -->',
'      <span class="color-container color-position-#POSITION#">',
'        <span class="color-square ',
'                     color-square-#SIZE# ',
'                     {if ?SHADOW/}',
'                       {case SHADOW/}',
'                         {when N/}color-no-shadow',
'                         {otherwise/}color-shadow-light',
'                       {endcase/}',
'                     {endif/} ',
'                     {if ?BORDER/}',
'                       {case BORDER/}',
'                         {when N/}color-no-border',
'                         {when thin/}color-border-thin',
'                         {when thick/}color-border-thick',
'                         {otherwise/}',
'                       {endcase/}',
'                     {endif/}" ',
'              style="background-color:#HEX_COLOR#;" ',
'              title="#HEX_COLOR#">',
'        </span>',
'        {if ?SHOW_TEXT/}',
'          {case SHOW_TEXT/}',
'            {when N/}',
'            {otherwise/}',
'              <span class="color-text color-size-#SIZE#">#HEX_COLOR#</span>',
'          {endcase/}',
'        {endif/}',
'      </span>',
'',
'    {when BADGE/} ',
'      <!-- Badge style: Light background with colored text and border -->',
'      <span class="color-badge ',
'                   color-badge-#SIZE# ',
'                   color-size-#SIZE# ',
'                   {if ?SHADOW/}',
'                     {case SHADOW/}',
'                       {when N/}color-no-shadow',
'                       {otherwise/}color-shadow-light',
'                     {endcase/}',
'                   {endif/} ',
'                   {if ?BORDER/}',
'                     {case BORDER/}',
'                       {when N/}color-no-border',
'                       {when thin/}color-border-thin',
'                       {when thick/}color-border-thick',
'                       {otherwise/}',
'                     {endcase/}',
'                   {endif/}" ',
'            style="color:#HEX_COLOR#;border-color:#HEX_COLOR#;" ',
'            title="#HEX_COLOR#">',
'        #HEX_COLOR#',
'      </span>',
'',
'    {when DOT/} ',
'      <!-- Dot style: Small simple dot indicator -->',
'      <span class="color-container color-position-#POSITION#">',
'        <span class="color-dot ',
'                     color-dot-#SIZE# ',
'                     {if ?SHADOW/}',
'                       {case SHADOW/}',
'                         {when N/}color-no-shadow',
'                         {otherwise/}color-shadow-light',
'                       {endcase/}',
'                     {endif/}" ',
'              style="background-color:#HEX_COLOR#;" ',
'              title="#HEX_COLOR#">',
'        </span>',
'        {if ?SHOW_TEXT/}',
'          {case SHOW_TEXT/}',
'            {when N/}',
'            {otherwise/}',
'              <span class="color-text color-size-#SIZE#">#HEX_COLOR#</span>',
'          {endcase/}',
'        {endif/}',
'      </span>',
'',
'    {otherwise/}',
'      <!-- Default fallback style -->',
'      <span class="color-default color-size-#SIZE#" ',
'            style="color:#HEX_COLOR#;">',
'        #HEX_COLOR#',
'      </span>',
'',
'  {endcase/}',
'',
'{endif/}',
'',
'{endif/}'))
,p_default_escape_mode=>'HTML'
,p_translate_this_template=>false
,p_api_version=>1
,p_standard_attributes=>'ROW_SELECTION:REGION_TEMPLATE'
,p_substitute_attributes=>true
,p_version_scn=>41745769096052
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(58619786629709451)
,p_plugin_id=>wwv_flow_imp.id(58619498927709416)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'HEX_COLOR'
,p_prompt=>'Hex Color'
,p_attribute_type=>'SESSION STATE VALUE'
,p_is_required=>false
,p_escape_mode=>'HTML'
,p_column_data_types=>'VARCHAR2'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(58948037590014977)
,p_plugin_id=>wwv_flow_imp.id(58619498927709416)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_static_id=>'STYLE'
,p_prompt=>'Style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_escape_mode=>'HTML'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58948640400023170)
,p_plugin_attribute_id=>wwv_flow_imp.id(58948037590014977)
,p_display_sequence=>10
,p_display_value=>'Radio'
,p_return_value=>'RADIO_BORDER'
,p_is_quick_pick=>true
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58949097053024967)
,p_plugin_attribute_id=>wwv_flow_imp.id(58948037590014977)
,p_display_sequence=>20
,p_display_value=>'Pill'
,p_return_value=>'PILL'
,p_is_quick_pick=>true
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58950409313057790)
,p_plugin_attribute_id=>wwv_flow_imp.id(58948037590014977)
,p_display_sequence=>30
,p_display_value=>'Square'
,p_return_value=>'SQUARE'
,p_is_quick_pick=>true
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58950804503059654)
,p_plugin_attribute_id=>wwv_flow_imp.id(58948037590014977)
,p_display_sequence=>40
,p_display_value=>'Badge'
,p_return_value=>'BADGE'
,p_is_quick_pick=>true
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58951243580063918)
,p_plugin_attribute_id=>wwv_flow_imp.id(58948037590014977)
,p_display_sequence=>50
,p_display_value=>'Dot'
,p_return_value=>'DOT'
,p_is_quick_pick=>true
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(58954530548180300)
,p_plugin_id=>wwv_flow_imp.id(58619498927709416)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'SIZE'
,p_prompt=>'Size'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'m'
,p_escape_mode=>'HTML'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Size of the color indicator'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58955008132184229)
,p_plugin_attribute_id=>wwv_flow_imp.id(58954530548180300)
,p_display_sequence=>10
,p_display_value=>'Extra Small'
,p_return_value=>'xs'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58955460196184721)
,p_plugin_attribute_id=>wwv_flow_imp.id(58954530548180300)
,p_display_sequence=>20
,p_display_value=>'Small'
,p_return_value=>'s'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58956658142190596)
,p_plugin_attribute_id=>wwv_flow_imp.id(58954530548180300)
,p_display_sequence=>30
,p_display_value=>'Medium'
,p_return_value=>'m'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58957040512191366)
,p_plugin_attribute_id=>wwv_flow_imp.id(58954530548180300)
,p_display_sequence=>40
,p_display_value=>'Large'
,p_return_value=>'l'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58957459581192672)
,p_plugin_attribute_id=>wwv_flow_imp.id(58954530548180300)
,p_display_sequence=>50
,p_display_value=>'Extra Large'
,p_return_value=>'xl'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(58958463878204241)
,p_plugin_id=>wwv_flow_imp.id(58619498927709416)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_static_id=>'SHOW_TEXT'
,p_prompt=>'Show Text'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_escape_mode=>'HTML'
,p_is_translatable=>false
,p_help_text=>'Show/hide hex color text'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(58959247254212706)
,p_plugin_id=>wwv_flow_imp.id(58619498927709416)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_static_id=>'SHADOW'
,p_prompt=>'Shadow'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_escape_mode=>'HTML'
,p_is_translatable=>false
,p_help_text=>'Shadow effect'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(58959893251215894)
,p_plugin_id=>wwv_flow_imp.id(58619498927709416)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_static_id=>'BORDER'
,p_prompt=>'Border'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'Y'
,p_escape_mode=>'HTML'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Border style (applies to RADIO, SQUARE, BADGE)'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58960451383217087)
,p_plugin_attribute_id=>wwv_flow_imp.id(58959893251215894)
,p_display_sequence=>10
,p_display_value=>'Yes'
,p_return_value=>'Y'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58960831189217902)
,p_plugin_attribute_id=>wwv_flow_imp.id(58959893251215894)
,p_display_sequence=>20
,p_display_value=>'No'
,p_return_value=>'N'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58961280368221005)
,p_plugin_attribute_id=>wwv_flow_imp.id(58959893251215894)
,p_display_sequence=>30
,p_display_value=>'Thin border'
,p_return_value=>'thin'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58961628082222466)
,p_plugin_attribute_id=>wwv_flow_imp.id(58959893251215894)
,p_display_sequence=>40
,p_display_value=>'Thick border'
,p_return_value=>'thick'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(58962212431226278)
,p_plugin_id=>wwv_flow_imp.id(58619498927709416)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_static_id=>'POSITION'
,p_prompt=>'Position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'left'
,p_escape_mode=>'HTML'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Text position relative to color indicator (applies to RADIO, SQUARE, DOT)'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58962863776228207)
,p_plugin_attribute_id=>wwv_flow_imp.id(58962212431226278)
,p_display_sequence=>10
,p_display_value=>'Left'
,p_return_value=>'left'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58963223533229800)
,p_plugin_attribute_id=>wwv_flow_imp.id(58962212431226278)
,p_display_sequence=>20
,p_display_value=>'Right'
,p_return_value=>'right'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58963692564230860)
,p_plugin_attribute_id=>wwv_flow_imp.id(58962212431226278)
,p_display_sequence=>30
,p_display_value=>'Top'
,p_return_value=>'top'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(58964026230231878)
,p_plugin_attribute_id=>wwv_flow_imp.id(58962212431226278)
,p_display_sequence=>40
,p_display_value=>'Bottom'
,p_return_value=>'bottom'
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
