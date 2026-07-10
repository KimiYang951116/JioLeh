-- Credits the OpenJio sender with points when an invitee accepts.
-- Runs as security definer because the invitee's client can't insert a
-- point_transactions row crediting someone else under the existing RLS
-- policy (user_id = auth.uid()).
create or replace function public.award_jio_points_on_accept()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  sender_id uuid;
begin
  select user_id into sender_id
  from public.open_jio_events
  where id = new.event_id;

  -- new.id is the invite_statuses row's stable primary key, so this can't
  -- double-award if the same invitee flips accepted -> declined -> accepted.
  if not exists (
    select 1 from public.point_transactions
    where reference_id = new.id
      and reason = 'jio_created'
  ) then
    insert into public.point_transactions (user_id, amount, reason, reference_id)
    values (sender_id, 5, 'jio_created', new.id);
  end if;

  return null;
end;
$$;

create trigger trg_open_jio_invite_award_points
after update on public.open_jio_invite_statuses
for each row
when (new.status = 'accepted' and old.status is distinct from 'accepted')
execute function public.award_jio_points_on_accept();
