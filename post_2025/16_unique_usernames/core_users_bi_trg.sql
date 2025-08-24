-- Trigger to automatically generate unique username on user creation
create or replace trigger core_users_bi_trg
before insert
on core_users
referencing old as old new as new
for each row
begin
  -- Generate unique username automatically
  :new.username := core_unique_name_manager.generate_unique_username(
    :new.first_name
  , :new.last_name
  );

end;
/