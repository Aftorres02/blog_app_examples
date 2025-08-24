create or replace package body core_unique_name_manager as

  -- ========================================
  -- HELPER FUNCTIONS
  -- ========================================

  function clean_name(
    p_name                           in varchar2
  ) return varchar2
  is
    l_clean_name                     varchar2(100);
  begin
    l_clean_name := trim(p_name);

    if l_clean_name is null then
      return null;
    end if;

    -- Clean the name (remove special chars, convert to lowercase)
    l_clean_name := regexp_replace(l_clean_name, '\s+', '_');
    l_clean_name := regexp_replace(l_clean_name, '[^a-zA-Z0-9._-]', '');
    l_clean_name := regexp_replace(l_clean_name, '^[._-]+|[._-]+$', '');
    l_clean_name := lower(l_clean_name);

    return l_clean_name;
  end clean_name;


  -- ========================================
  -- CORE FUNCTIONS
  -- ========================================

  function generate_unique_name(
    p_entity_type                    in varchar2
  , p_base_name                      in varchar2
  ) return varchar2
  is
    l_counter                        number;
    l_unique_name                    varchar2(100);
    l_clean_name                     varchar2(100);
  begin
    -- Clean and validate base name
    l_clean_name := clean_name(p_base_name);

    if l_clean_name is null then
      raise_application_error(-20001, 'Base name cannot be null or empty');
    end if;

    if length(l_clean_name) < 2 then
      raise_application_error(-20002, 'Generated name is too short');
    end if;

    -- Get or create counter for this base name
    begin
      select counter + 1
        into l_counter
        from core_unique_names
       where entity_type = p_entity_type
         and base_name = l_clean_name
         and active_yn = 'Y'
         for update;

      -- Update counter
      update core_unique_names
         set counter = l_counter
           , last_used = localtimestamp
       where entity_type = p_entity_type
         and base_name = l_clean_name
         and active_yn = 'Y';

    exception
      when no_data_found then
        -- First occurrence, create counter record
        l_counter := 0;
        insert into core_unique_names (
          entity_type
        , base_name
        , counter
        ) values (
          p_entity_type
        , l_clean_name
        , 1
        );
    end;

    -- Generate unique name
    if l_counter = 0 then
      l_unique_name := l_clean_name;
    else
      l_unique_name := l_clean_name || '_' || l_counter;
    end if;

    return l_unique_name;
  end generate_unique_name;

  -- ========================================
  -- USERNAME SPECIFIC FUNCTIONS
  -- ========================================

  function generate_unique_username(
    p_first_name                     in varchar2
  , p_last_name                      in varchar2
  ) return varchar2
  is
    l_base_name                      varchar2(100);
    l_clean_first                    varchar2(100);
    l_clean_last                     varchar2(100);
  begin
    -- Validate required parameters
    if trim(p_first_name) is null or trim(p_last_name) is null then
      raise_application_error(-20001, 'First name and last name cannot be null');
    end if;

    -- Clean first and last names
    l_clean_first := clean_name(p_first_name);
    l_clean_last := clean_name(p_last_name);

    -- Generate base username: first_name.last_name
    l_base_name := l_clean_first || '.' || l_clean_last;

    return generate_unique_name('USER', l_base_name);
  end generate_unique_username;

end core_unique_name_manager;
/
