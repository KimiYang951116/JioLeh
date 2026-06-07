-- When a new user signs up, create their profile row.
-- Give them a random 8-character username (letters + numbers),
-- unless they chose their own username during sign up.

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
as $$
declare
  letters text := 'abcdefghijklmnopqrstuvwxyz0123456789';
  code    text;
  i       int;
begin
  loop
    -- Build a random 8-character code, one character at a time.
    code := '';
    for i in 1..8 loop
      code := code || substr(letters, floor(random() * length(letters))::int + 1, 1);
    end loop;

    begin
      insert into public.profiles (id, username, display_name)
      values (
        new.id,
        coalesce(new.raw_user_meta_data->>'username', code),
        new.raw_user_meta_data->>'display_name'
      );
      return new;  -- insert worked, we are done

    exception when unique_violation then
      -- The username was already taken.
      -- If the user picked it themselves, report the error.
      -- Otherwise, loop again and try a different random code.
      if new.raw_user_meta_data->>'username' is not null then
        raise;
      end if;
    end;
  end loop;
end;
$$;


drop policy "Users can view own profile" on "public"."profiles";


create policy "Authenticated users can view all profiles"
  on "public"."profiles"
  as permissive
  for select
  to authenticated
using (true);
