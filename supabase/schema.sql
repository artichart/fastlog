-- FastLog · Supabase schema (โปรเจกต์เดียวกับ TradeCal · ล็อกอินบัญชีเดียวกัน)
-- วางทั้งไฟล์ใน Dashboard → SQL Editor → Run (รันซ้ำได้ ไม่ทำข้อมูลหาย)

create table if not exists public.fl_fasts (
  user_id  uuid not null default auth.uid() references auth.users on delete cascade,
  id       text not null,
  start_at timestamptz not null,
  end_at   timestamptz,               -- null = กำลังอดอยู่
  goal     numeric(5,2) not null,     -- ชั่วโมง
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.fl_weights (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  date    date not null,
  kg      numeric(5,1) not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, date)
);

create table if not exists public.fl_prefs (
  user_id   uuid primary key default auth.uid() references auth.users on delete cascade,
  goal_wd   numeric(5,2) not null default 14,   -- จ–ศ
  goal_we   numeric(5,2) not null default 12,   -- ส–อา
  target_kg numeric(5,1),
  updated_at timestamptz not null default now()
);

alter table public.fl_fasts   enable row level security;
alter table public.fl_weights enable row level security;
alter table public.fl_prefs   enable row level security;
drop policy if exists own on public.fl_fasts;
drop policy if exists own on public.fl_weights;
drop policy if exists own on public.fl_prefs;
create policy own on public.fl_fasts   for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy own on public.fl_weights for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy own on public.fl_prefs   for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
