function render_banner(
  p_dynamic_action in apex_plugin.t_dynamic_action
, p_plugin         in apex_plugin.t_plugin
)
return apex_plugin.t_dynamic_action_render_result
is
  l_result     apex_plugin.t_dynamic_action_render_result;
  l_setup      varchar2(40  char) := upper(trim(nvl(p_dynamic_action.attribute_01, 'X')));
  l_env        varchar2(40  char) := upper(trim(nvl(p_dynamic_action.attribute_02, 'X')));
  l_label      varchar2(200 char);
  l_color      varchar2(30  char);
  l_style      varchar2(40  char);
  l_label_item varchar2(30  char) := p_dynamic_action.attribute_03;
  l_color_item varchar2(30  char) := p_dynamic_action.attribute_04;
  l_a5         varchar2(4000 char) := trim(p_dynamic_action.attribute_05);
  l_a6         varchar2(40  char)  := upper(trim(nvl(p_dynamic_action.attribute_06, 'TOP')));
  l_pos        varchar2(40  char);
begin
  l_pos := nvl(l_a6, 'TOP');
  if l_pos not in ('TOP', 'LEFT') then
    l_pos := 'TOP';
  end if;

  l_style := nvl(l_a5, 'STRIP_CLASSIC');
  l_style := trim(l_style);
  if l_style is null then
    l_style := 'STRIP_CLASSIC';
  end if;

  if l_setup = 'QUICK' then
    if l_env = 'DEV' then
      l_label := 'Development Environment';
      l_color := '#508223';
    elsif l_env = 'TEST' then
      l_label := 'Test Environment';
      l_color := '#CFA11A';
    elsif l_env = 'PROD' then
      l_label := 'Production Environment';
      l_color := '#991B1B';
    else
      l_label := null;
      l_color := null;
    end if;
  elsif l_setup = 'CUSTOM' then
    if l_label_item is not null then
      l_label := v(l_label_item);
    end if;
    if l_color_item is not null then
      l_color := v(l_color_item);
    end if;
  else
    l_label := null;
    l_color := null;
  end if;

  -- Fallback: always return a valid no-op function so the DA framework
  -- never emits `javascriptFunction:,` (which breaks all downstream JS).
  l_result.javascript_function := 'function(){}';
  l_result.attribute_01        := l_label;
  l_result.attribute_02        := l_color;
  l_result.attribute_03        := l_style;
  l_result.attribute_04        := l_pos;

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
    apex_javascript.add_value(p_value => l_color, p_add_comma => true) ||
    apex_javascript.add_value(p_value => l_style, p_add_comma => true) ||
    apex_javascript.add_value(p_value => l_pos, p_add_comma => false) ||
    '); }';

  return l_result;
end render_banner;
