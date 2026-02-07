with hier_data as (
    select id
         , level                  as hierarchy_level
         , connect_by_isleaf      as is_leaf
         -- Use 'orden' for the sorting path to keep the hierarchy together.
         -- Using 'level' here was causing the sort issue.
         , sys_connect_by_path(lpad(nvl(orden, 0), 5, '0'), '.') as display_seq
      from demo_hierarchical_data
     start with parent_id is null
   connect by prior id = parent_id
     order siblings by orden, nombre
)
select d.id
     , d.id                     as plugin_hierarchy
     , d.parent_id
     , d.nombre                 as label
     , h.hierarchy_level
     , h.is_leaf
     , h.display_seq
     , d.tipo
     , d.descripcion
     , d.fecha_creacion
     , d.estado
     , d.orden
     , d.creado_por
  from demo_hierarchical_data     d
inner join hier_data              h on d.id = h.id
 order by h.display_seq;