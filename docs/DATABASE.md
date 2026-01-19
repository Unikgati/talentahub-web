# TalentaHub Database Documentation

Dokumentasi lengkap semua SQL schema dan migrasi.

---

## Overview

| File | Tipe | Fungsi |
|------|------|--------|
| [supabase_schema.sql](file:///Users/ayodyachandra/Downloads/Talentahub-main%202/supabase_schema.sql) | Schema Utama | Setup awal database |
| [001_fix_notification_policy.sql](file:///Users/ayodyachandra/Downloads/Talentahub-main%202/migrations/001_fix_notification_policy.sql) | Migration | Fix security notifikasi |
| [002_google_oauth_support.sql](file:///Users/ayodyachandra/Downloads/Talentahub-main%202/migrations/002_google_oauth_support.sql) | Migration | Support Google OAuth |
| [002_add_audit_logging.sql](file:///Users/ayodyachandra/Downloads/Talentahub-main%202/migrations/002_add_audit_logging.sql) | Migration | Audit logging system |

---

## Urutan Eksekusi

```
1. supabase_schema.sql      ← Jalankan pertama (fresh database)
2. 001_fix_notification_policy.sql
3. 002_google_oauth_support.sql
4. 002_add_audit_logging.sql  ← Terakhir
```

---

## 1. supabase_schema.sql (Schema Utama)

Setup lengkap database TalentaHub.

### ENUM Types

| Type | Values | Digunakan Di |
|------|--------|--------------|
| `user_role` | `client`, `talent`, `super_admin` | users.role |
| `job_status` | `open`, `in_progress`, `under_review`, `completed`, `cancelled` | jobs.status |
| `application_status` | `pending`, `accepted`, `rejected`, `withdrawn` | applications.status |
| `notification_type` | `info`, `success`, `warning`, `error` | notifications.type |

### Tables

#### `users`
| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Dari auth.users |
| email | TEXT | Email unik |
| name | TEXT | Nama lengkap |
| whatsapp | TEXT | Nomor WA (opsional) |
| role | user_role | client/talent/super_admin |
| avatar | TEXT | URL foto profil |
| bio | TEXT | Deskripsi diri |
| skills | TEXT[] | Array skills |
| location | TEXT | Lokasi |
| gopay_number | TEXT | Untuk pembayaran |
| socials | JSONB | {instagram, linkedin, dll} |
| rating | DECIMAL | Rating rata-rata |
| review_count | INT | Jumlah review |
| banned | BOOLEAN | Status banned |
| created_at, updated_at | TIMESTAMPTZ | Timestamps |

#### `jobs`
| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| client_id | UUID (FK→users) | Pembuat job |
| client_name | TEXT | Denormalized |
| title | TEXT | Judul pekerjaan |
| description | TEXT | Deskripsi lengkap |
| budget | INT | Budget dalam Rupiah |
| category | TEXT | Kategori job |
| deadline | DATE | Deadline pengerjaan |
| status | job_status | Status job |
| talent_id | UUID (FK→users) | Talent yang dipilih |
| is_featured | BOOLEAN | Job unggulan |
| has_client_reviewed | BOOLEAN | Flag review |
| has_talent_reviewed | BOOLEAN | Flag review |

#### `applications`
| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| job_id | UUID (FK→jobs) | Job yang dilamar |
| talent_id | UUID (FK→users) | Pelamar |
| talent_name, talent_avatar | TEXT | Denormalized |
| message | TEXT | Pesan lamaran |
| status | application_status | Status lamaran |

**Constraint:** `UNIQUE (job_id, talent_id)` - 1 talent hanya bisa lamar 1x per job.

#### `reviews`
| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| job_id | UUID (FK→jobs) | Job terkait |
| reviewer_id | UUID (FK→users) | Pemberi review |
| reviewer_name | TEXT | Denormalized |
| reviewee_id | UUID (FK→users) | Penerima review |
| rating | INT | 1-5 bintang |
| comment | TEXT | Komentar opsional |

#### `notifications`
| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| user_id | UUID (FK→users) | Penerima notif |
| title | TEXT | Judul notifikasi |
| message | TEXT | Isi pesan |
| type | notification_type | Jenis notif |
| link | TEXT | Deep link |
| read | BOOLEAN | Status dibaca |

#### `fcm_tokens`
| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| user_id | UUID (FK→users) | User pemilik |
| token | TEXT | FCM device token |
| device_info | TEXT | Info device |

#### `system_config`
| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Singleton row |
| maintenance_mode | BOOLEAN | Mode maintenance |
| app_version | TEXT | Versi terbaru |
| announcement | TEXT | Pengumuman global |

### Functions

| Function | Purpose |
|----------|---------|
| `update_updated_at_column()` | Auto-update timestamp |
| `handle_new_user()` | Buat profile saat signup |
| `enforce_user_role()` | Block perubahan role ke admin |
| `notify_new_application()` | Notif ke client saat ada lamaran |
| `notify_application_status_change()` | Notif ke talent saat status berubah |
| `notify_new_review()` | Notif saat dapat review |
| `notify_job_status_change()` | Notif saat status job berubah |
| `accept_application(p_application_id, p_client_id)` | **Atomic** terima lamaran |
| `create_notification(...)` | Insert notifikasi dengan validasi |

### RLS Policies Summary

| Table | SELECT | INSERT | UPDATE | DELETE |
|-------|--------|--------|--------|--------|
| users | Non-banned only | ❌ | Self only | ❌ (false) |
| jobs | All | Client only | Owner only | Owner only |
| applications | Involved parties | Talent only | Talent/Client | Talent only |
| reviews | Public | Involved only | ❌ | ❌ |
| notifications | Self only | ❌ (blocked) | Self read only | Self only |
| fcm_tokens | Self only | Self only | Self only | Self only |
| system_config | All | ❌ | ❌ | ❌ |
| audit_logs | Admin only | ❌ | ❌ | ❌ |

### RLS Policies Detail

#### `users` Policies
```sql
-- Hanya tampilkan user yang tidak banned
users_select_public: SELECT WHERE banned = false

-- Tidak ada yang bisa INSERT langsung (via trigger saja)
users_insert_none: INSERT WITH CHECK (false)

-- Hanya bisa update profil sendiri
users_update_self: UPDATE USING (auth.uid() = id)

-- Tidak ada yang bisa DELETE
users_delete_none: DELETE USING (false)
```

#### `jobs` Policies
```sql
-- Semua bisa lihat jobs
jobs_select_all: SELECT USING (true)

-- Hanya client yang bisa buat job, dan harus pakai ID sendiri
jobs_insert_client: INSERT WITH CHECK (
  auth.uid() = client_id AND 
  EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'client')
)

-- Hanya owner yang bisa update
jobs_update_owner: UPDATE USING (auth.uid() = client_id)

-- Hanya owner yang bisa delete
jobs_delete_owner: DELETE USING (auth.uid() = client_id)
```

#### `applications` Policies
```sql
-- Talent lihat lamaran sendiri, Client lihat lamaran di job-nya
applications_select_relevant: SELECT USING (
  auth.uid() = talent_id OR 
  auth.uid() IN (SELECT client_id FROM jobs WHERE id = job_id)
)

-- Hanya talent yang bisa apply
applications_insert_talent: INSERT WITH CHECK (
  auth.uid() = talent_id AND
  EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'talent')
)

-- Talent bisa withdraw, Client bisa accept/reject
applications_update_relevant: UPDATE USING (
  auth.uid() = talent_id OR 
  auth.uid() IN (SELECT client_id FROM jobs WHERE id = job_id)
)

-- Hanya talent yang bisa hapus lamarannya
applications_delete_talent: DELETE USING (auth.uid() = talent_id)
```

#### `reviews` Policies
```sql
-- Semua bisa lihat review
reviews_select_all: SELECT USING (true)

-- Hanya bisa review jika terlibat di job tersebut
reviews_insert_involved: INSERT WITH CHECK (
  auth.uid() = reviewer_id AND
  EXISTS (
    SELECT 1 FROM jobs 
    WHERE id = job_id AND (client_id = auth.uid() OR talent_id = auth.uid())
  )
)

-- Tidak bisa edit review
reviews_update_none: UPDATE USING (false)

-- Tidak bisa hapus review  
reviews_delete_none: DELETE USING (false)
```

#### `notifications` Policies (UPDATED by Migration 001)
```sql
-- Hanya bisa lihat notifikasi sendiri
notifications_select_self: SELECT USING (auth.uid() = user_id)

-- ⚠️ BLOCKED: Client tidak bisa INSERT langsung
-- Notifikasi dibuat via trigger atau RPC create_job_notification()
notifications_insert_deny_client: INSERT WITH CHECK (false)

-- Hanya bisa update read status notifikasi sendiri
notifications_update_self: UPDATE USING (auth.uid() = user_id)

-- Bisa hapus notifikasi sendiri
notifications_delete_self: DELETE USING (auth.uid() = user_id)
```

#### `fcm_tokens` Policies
```sql
-- Hanya bisa lihat token sendiri
fcm_select_self: SELECT USING (auth.uid() = user_id)

-- Hanya bisa register token sendiri
fcm_insert_self: INSERT WITH CHECK (auth.uid() = user_id)

-- Hanya bisa update token sendiri
fcm_update_self: UPDATE USING (auth.uid() = user_id)

-- Hanya bisa hapus token sendiri
fcm_delete_self: DELETE USING (auth.uid() = user_id)
```

#### `system_config` Policies
```sql
-- Semua bisa baca config
config_select_all: SELECT USING (true)

-- Tidak ada yang bisa ubah via client (hanya via Supabase Dashboard)
config_update_none: UPDATE USING (false)
```

#### `audit_logs` Policies (Migration 002_add_audit_logging)
```sql
-- Hanya admin yang bisa baca
audit_read_admin_only: SELECT USING (
  EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'super_admin')
)

-- Tidak ada yang bisa INSERT/UPDATE/DELETE via client
audit_insert_deny_client: INSERT WITH CHECK (false)
audit_update_deny_all: UPDATE USING (false)
audit_delete_deny_all: DELETE USING (false)
```

---

## 2. 001_fix_notification_policy.sql

**Problem:** Policy `notifications_insert_system` dengan `WITH CHECK (true)` memungkinkan siapapun insert notifikasi ke siapapun.

**Solution:**
```sql
-- Block semua client INSERT
CREATE POLICY "notifications_insert_deny_client" ON notifications 
  FOR INSERT WITH CHECK (false);

-- RPC function dengan validasi
CREATE FUNCTION create_job_notification(
  p_recipient_id UUID,
  p_job_id UUID,
  p_title TEXT,
  p_message TEXT,
  p_type notification_type
) RETURNS void
```

**Validasi:**
1. Job harus ada
2. Caller harus client atau talent dari job tersebut
3. Tidak boleh kirim ke diri sendiri
4. Recipient harus terlibat di job

---

## 3. 002_google_oauth_support.sql

**Problem:** Trigger `handle_new_user` tidak extract data dari Google OAuth.

**Solution:** Update function untuk:
- Extract `full_name` atau `name` dari metadata
- Extract `picture` atau `avatar_url` untuk avatar
- Handle phone dengan proper NULL conversion
- Idempotent dengan `ON CONFLICT DO UPDATE`

**Data Mapping:**
| Google OAuth | Users Table |
|--------------|-------------|
| `full_name` / `name` | name |
| `picture` / `avatar_url` | avatar |
| email | email |
| (metadata) role | role (default: client) |

---

## 4. 002_add_audit_logging.sql

**Purpose:** Mencatat semua perubahan data untuk akuntabilitas.

**Creates:**
```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY,
  user_id UUID,        -- Siapa
  action TEXT,         -- INSERT/UPDATE/DELETE
  table_name TEXT,     -- Tabel apa
  record_id UUID,      -- Record mana
  old_data JSONB,      -- Data sebelum
  new_data JSONB,      -- Data sesudah
  created_at TIMESTAMPTZ
);
```

**Triggers Applied To:**
- `users`
- `jobs`
- `applications`
- `reviews`

**RLS:** Hanya `super_admin` bisa baca, tidak ada yang bisa INSERT/UPDATE/DELETE via client.

---

## Quick Reference: Status Flow

### Job Status
```
open → in_progress → under_review → completed
  ↓
cancelled
```

### Application Status
```
pending → accepted
    ↓
rejected / withdrawn
```

---

## Verification Queries

```sql
-- Check all tables
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- Check all policies
SELECT tablename, policyname, cmd FROM pg_policies 
WHERE schemaname = 'public';

-- Check all triggers
SELECT trigger_name, event_object_table 
FROM information_schema.triggers 
WHERE trigger_schema = 'public';

-- Check audit logs (admin only)
SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT 10;
```
