with wp2 as (
  select
    task_id,
    no_earlier_than
  from
    way_points wp
  where
    merchant_id = 2288
    AND position = 2
    and (
      (
        "wp"."no_earlier_than" is not null
        or "wp"."no_later_than" is not null
      )
      and (
        "wp"."no_earlier_than" is null
        or "wp"."no_earlier_than" >= '2025-09-26T22:00:00.000Z'
      )
      and (
        "wp"."no_later_than" is null
        or "wp"."no_later_than" <= '2025-10-03T21:59:59.999Z'
      )
    )
    or (
      "wp"."scheduled_at" is not null
      and "wp"."no_earlier_than" is null
      and "wp"."no_later_than" is null
      and "wp"."scheduled_at" >= '2025-09-26T22:00:00.000Z'
      and "wp"."scheduled_at" <= '2025-10-03T21:59:59.999Z'
    )
),
base_tasks as (
  select
    id,
    run_id,
    team_id,
    user_id
  from
    tasks
  where
    merchant_id = 2288
    and delete_at is null
    and status in (0, 1, 2, 3, 5, 6, 9, 10)
    and team_id in (215472, 213290, 213291, 211587)
    and not ready_to_execute = true
    and service_plan_id in (1330, 1609, 1610, 1325)
    and '60288_Refrigerator Delivery Only' = any(required_skills)
    and '60274_Refrigeration Install Premium - Plumbing' = any(required_skills)
    and id in (
      select
        task_id
      from
        wp2
    )
    and (
      "tasks"."group_uuid" is null
      or (
        "tasks"."group_uuid" is not null
        and "tasks"."group_leader_id" is null
      )
    )
)
select
  *,
  "id" as "sort_value",
  "team_name" as "main_group_sort_value"
from
  (
    select
      "tasks"."id",
      "tasks"."user_id",
      "teams"."name" as "team_name",
      "teams"."id" as "team_id",
      "tasks"."run_id" as "route_id"
    from
      base_tasks as "tasks"
      left join "teams" on "teams"."id" = "tasks"."team_id"
      and teams.merchant_id = 2288
    order by
      "id" asc
    limit
      100
  ) as "tasks";
