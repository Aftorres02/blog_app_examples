function render_banner(
  p_dynamic_action in apex_plugin.t_dynamic_action
, p_plugin         in apex_plugin.t_plugin
)
return apex_plugin.t_dynamic_action_render_result
is
  l_result     apex_plugin.t_dynamic_action_render_result;
  l_label_item varchar2(30  char) := p_dynamic_action.attribute_01;
  l_color_item varchar2(30  char) := p_dynamic_action.attribute_02;
  l_label      varchar2(200 char);
  l_color      varchar2(30  char);
begin
  if l_label_item is not null then
    l_label := v(l_label_item);
  end if;

  if l_color_item is not null then
    l_color := v(l_color_item);
  end if;

  -- Fallback: always return a valid no-op function so the DA framework
  -- never emits `javascriptFunction:,` (which breaks all downstream JS).
  l_result.javascript_function := 'function(){}';
  l_result.attribute_01        := l_label;
  l_result.attribute_02        := l_color;

  if l_label is null then
    return l_result;
  end if;

  apex_css.add_file(
    p_name           => 'banner'
  , p_directory      => p_plugin.file_prefix
  , p_skip_extension => false
  );

  apex_javascript.add_library(
    p_name           => 'banner'
  , p_directory      => p_plugin.file_prefix
  , p_skip_extension => false
  );

  l_result.javascript_function :=
    'function(){ master.envBanner.initialize(' ||
    apex_javascript.add_value(p_value => l_label, p_add_comma => true)  ||
    apex_javascript.add_value(p_value => l_color, p_add_comma => false) ||
    '); }';

  return l_result;
end render_banner;