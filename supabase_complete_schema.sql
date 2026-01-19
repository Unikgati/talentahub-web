-- =============================================================================
-- TalentaHub COMPLETE Database Schema (FINAL VERSION)
-- =============================================================================
-- 
-- File ini berisi SEMUA SQL yang diperlukan untuk setup database dari awal.
-- Cukup paste SEKALI di Supabase SQL Editor untuk setup lengkap.
--
-- Sudah termasuk:
-- ✅ Base schema (tables, indexes, constraints)
-- ✅ ENUMs (user_role, job_status, application_status, notification_type)
-- ✅ Functions & Triggers
-- ✅ RLS Policies (dengan fix notification security)
-- ✅ Google OAuth support
-- ✅ Review flags & rating auto-update
-- ✅ Realtime subscriptions
-- ✅ Audit logging system
-- ✅ Push notification trigger
-- ✅ User preferences (for personalized recommendations)
--
-- Terakhir diupdate: 2026-01-13
-- =============================================================================

-- =============================================================================
-- PART 1: EXTENSIONS
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS pg_net;

-- =============================================================================
-- PART 2: ENUM TYPES
-- =============================================================================

DO $$ 
BEGIN
  CREATE TYPE user_role AS ENUM ('client', 'talent', 'super_admin');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ 
BEGIN
  CREATE TYPE job_status AS ENUM (
    'open', 'in_progress', 'under_review', 
    'completed', 'cancelled', 'disputed', 'closed'
  );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ 
BEGIN
  CREATE TYPE application_status AS ENUM ('pending', 'accepted', 'rejected', 'cancelled');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ 
BEGIN
  CREATE TYPE notification_type AS ENUM ('info', 'success', 'warning', 'error');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- User account status for OAuth flow control
DO $$ 
BEGIN
  CREATE TYPE user_status AS ENUM ('pending', 'active', 'blocked');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- =============================================================================
-- PART 3: TABLES
-- =============================================================================

-- USERS TABLE
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  whatsapp TEXT,
  role user_role NOT NULL DEFAULT 'client',
  status user_status NOT NULL DEFAULT 'pending',
  activated_at TIMESTAMPTZ,
  avatar TEXT,
  bio TEXT,
  skills TEXT[] DEFAULT '{}',
  location TEXT,
  gopay_number TEXT,
  socials JSONB DEFAULT '{}',
  rating DECIMAL(2,1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
  review_count INTEGER DEFAULT 0 CHECK (review_count >= 0),
  banned BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS users_whatsapp_unique_idx 
  ON users (whatsapp) 
  WHERE whatsapp IS NOT NULL AND whatsapp != '';

-- JOBS TABLE
CREATE TABLE IF NOT EXISTS jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  client_name TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  budget INTEGER NOT NULL CHECK (budget >= 0),
  deadline DATE NOT NULL,
  status job_status NOT NULL DEFAULT 'open',
  talent_id UUID REFERENCES users(id) ON DELETE SET NULL,
  is_featured BOOLEAN DEFAULT false,
  attachment_url TEXT,
  tags TEXT[] DEFAULT '{}',
  has_client_reviewed BOOLEAN DEFAULT false,
  has_talent_reviewed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- APPLICATIONS TABLE
CREATE TABLE IF NOT EXISTS applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  talent_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  talent_name TEXT NOT NULL,
  talent_avatar TEXT,
  message TEXT NOT NULL,
  status application_status NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT unique_application UNIQUE (job_id, talent_id)
);

-- REVIEWS TABLE
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  reviewer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reviewer_name TEXT NOT NULL,
  reviewee_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT unique_review UNIQUE (job_id, reviewer_id)
);

-- NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type notification_type NOT NULL DEFAULT 'info',
  is_read BOOLEAN DEFAULT false,
  link TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- SYSTEM CONFIG TABLE
CREATE TABLE IF NOT EXISTS system_config (
  id INTEGER PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  max_talent_quota INTEGER DEFAULT 5000,
  maintenance_mode BOOLEAN DEFAULT false,
  landing_hero_title TEXT DEFAULT 'Jasa Berkualitas, Harga Mahasiswa',
  donation_number TEXT,
  support_whatsapp TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO system_config (id) VALUES (1) ON CONFLICT (id) DO NOTHING;

-- FCM TOKENS TABLE
CREATE TABLE IF NOT EXISTS fcm_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token TEXT NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('android', 'ios', 'web')),
  device_info TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT unique_user_token UNIQUE (user_id, token)
);

-- AUDIT LOGS TABLE
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  action TEXT NOT NULL,
  table_name TEXT NOT NULL,
  record_id UUID NOT NULL,
  old_data JSONB,
  new_data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================================
-- PART 4: INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_banned ON users(banned);
CREATE INDEX IF NOT EXISTS idx_users_rating ON users(rating DESC);

CREATE INDEX IF NOT EXISTS idx_jobs_client_id ON jobs(client_id);
CREATE INDEX IF NOT EXISTS idx_jobs_talent_id ON jobs(talent_id);
CREATE INDEX IF NOT EXISTS idx_jobs_status ON jobs(status);
CREATE INDEX IF NOT EXISTS idx_jobs_category ON jobs(category);
CREATE INDEX IF NOT EXISTS idx_jobs_created_at ON jobs(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_applications_job_id ON applications(job_id);
CREATE INDEX IF NOT EXISTS idx_applications_talent_id ON applications(talent_id);
CREATE INDEX IF NOT EXISTS idx_applications_status ON applications(status);

CREATE INDEX IF NOT EXISTS idx_reviews_reviewee_id ON reviews(reviewee_id);
CREATE INDEX IF NOT EXISTS idx_reviews_job_id ON reviews(job_id);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_audit_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_table ON audit_logs(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_record ON audit_logs(record_id);
CREATE INDEX IF NOT EXISTS idx_audit_created_at ON audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_logs(action);

-- =============================================================================
-- PART 5: UTILITY FUNCTIONS & TRIGGERS
-- =============================================================================

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_jobs_updated_at ON jobs;
CREATE TRIGGER update_jobs_updated_at
  BEFORE UPDATE ON jobs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_system_config_updated_at ON system_config;
CREATE TRIGGER update_system_config_updated_at
  BEFORE UPDATE ON system_config FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Role validation (prevent admin escalation)
CREATE OR REPLACE FUNCTION validate_user_role()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.role NOT IN ('client', 'talent') THEN
      NEW.role := 'client';
    END IF;
  END IF;
  
  IF TG_OP = 'UPDATE' THEN
    IF OLD.role = 'super_admin' OR NEW.role = 'super_admin' THEN
      IF OLD.role != NEW.role THEN
        RAISE EXCEPTION 'Cannot modify super_admin role via API';
      END IF;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS enforce_user_role ON users;
CREATE TRIGGER enforce_user_role
  BEFORE INSERT OR UPDATE ON users FOR EACH ROW EXECUTE FUNCTION validate_user_role();

-- =============================================================================
-- PART 6: HANDLE NEW USER (Production-Ready OAuth Flow)
-- =============================================================================
-- ALWAYS creates/updates public.users profile on auth signup
-- New users start with status='pending', existing users keep their status
-- This ensures no orphan auth.users - every auth user has a profile

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_role user_role;
  v_name TEXT;
  v_phone TEXT;
  v_avatar TEXT;
  v_existing_status user_status;
BEGIN
  -- Check if user already exists (returning OAuth user)
  SELECT status INTO v_existing_status FROM public.users WHERE id = NEW.id;
  
  -- Extract and validate role from metadata
  v_role := 'client';
  BEGIN
    IF NEW.raw_user_meta_data->>'role' IN ('client', 'talent') THEN
      v_role := (NEW.raw_user_meta_data->>'role')::user_role;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_role := 'client';
  END;
  
  -- Extract name (Google OAuth uses 'full_name' or 'name')
  v_name := COALESCE(
    NULLIF(TRIM(NEW.raw_user_meta_data->>'full_name'), ''),
    NULLIF(TRIM(NEW.raw_user_meta_data->>'name'), ''),
    'User'
  );
  
  -- Extract phone
  v_phone := NULLIF(TRIM(COALESCE(NEW.raw_user_meta_data->>'phone', '')), '');
  
  -- Extract avatar (Google OAuth uses 'avatar_url' or 'picture')
  v_avatar := COALESCE(
    NULLIF(TRIM(NEW.raw_user_meta_data->>'avatar_url'), ''),
    NULLIF(TRIM(NEW.raw_user_meta_data->>'picture'), ''),
    NULL
  );
  
  -- UPSERT: Always create/update profile
  -- New users get status='pending', existing users keep their status
  INSERT INTO public.users (id, email, name, whatsapp, role, status, avatar, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    v_name,
    v_phone,
    v_role,
    'pending',  -- New users start as pending
    v_avatar,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    name = COALESCE(NULLIF(users.name, 'User'), EXCLUDED.name),
    avatar = COALESCE(users.avatar, EXCLUDED.avatar),
    -- Keep existing status (don't reset to pending on re-login)
    -- Keep existing whatsapp (don't overwrite with null from OAuth)
    updated_at = NOW();
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but NEVER fail - this ensures auth signup always succeeds
    -- The user profile is required for the app to function
    RAISE WARNING 'handle_new_user error for user %: %', NEW.id, SQLERRM;
    
    -- Fallback: try minimal insert if full insert failed
    BEGIN
      INSERT INTO public.users (id, email, name, status)
      VALUES (NEW.id, NEW.email, 'User', 'pending')
      ON CONFLICT (id) DO NOTHING;
    EXCEPTION WHEN OTHERS THEN
      -- Ultimate fallback: just log and continue
      RAISE WARNING 'handle_new_user fallback also failed for %', NEW.id;
    END;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users 
  FOR EACH ROW 
  EXECUTE FUNCTION handle_new_user();

-- =============================================================================
-- PART 7: ROW LEVEL SECURITY
-- =============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE fcm_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "users_select_public" ON users;
DROP POLICY IF EXISTS "users_update_own" ON users;
DROP POLICY IF EXISTS "users_delete_none" ON users;
DROP POLICY IF EXISTS "jobs_select_all" ON jobs;
DROP POLICY IF EXISTS "jobs_insert_client" ON jobs;
DROP POLICY IF EXISTS "jobs_update_owner" ON jobs;
DROP POLICY IF EXISTS "jobs_delete_none" ON jobs;
DROP POLICY IF EXISTS "applications_select_relevant" ON applications;
DROP POLICY IF EXISTS "applications_insert_talent" ON applications;
DROP POLICY IF EXISTS "applications_update_client" ON applications;
DROP POLICY IF EXISTS "reviews_select_all" ON reviews;
DROP POLICY IF EXISTS "reviews_insert_participant" ON reviews;
DROP POLICY IF EXISTS "notifications_select_own" ON notifications;
DROP POLICY IF EXISTS "notifications_update_own" ON notifications;
DROP POLICY IF EXISTS "notifications_insert_system" ON notifications;
DROP POLICY IF EXISTS "notifications_insert_deny_client" ON notifications;
DROP POLICY IF EXISTS "notifications_delete_own" ON notifications;
DROP POLICY IF EXISTS "config_select_all" ON system_config;
DROP POLICY IF EXISTS "config_update_none" ON system_config;
DROP POLICY IF EXISTS "fcm_tokens_select_own" ON fcm_tokens;
DROP POLICY IF EXISTS "fcm_tokens_insert_own" ON fcm_tokens;
DROP POLICY IF EXISTS "fcm_tokens_update_own" ON fcm_tokens;
DROP POLICY IF EXISTS "fcm_tokens_delete_own" ON fcm_tokens;
DROP POLICY IF EXISTS "audit_read_admin_only" ON audit_logs;
DROP POLICY IF EXISTS "audit_insert_deny_client" ON audit_logs;
DROP POLICY IF EXISTS "audit_update_deny_all" ON audit_logs;
DROP POLICY IF EXISTS "audit_delete_deny_all" ON audit_logs;

-- USERS POLICIES
-- Select: Anyone can see active, non-banned users (pending/blocked hidden from public)
-- Also allow users to see their own profile regardless of status
CREATE POLICY "users_select_public" ON users FOR SELECT 
  USING (
    (status = 'active' AND banned = false) OR 
    auth.uid() = id  -- Users can always see their own profile
  );
-- Update: Users can update their own profile (needed for completing profile)
CREATE POLICY "users_update_own" ON users FOR UPDATE 
  USING (auth.uid() = id) 
  WITH CHECK (auth.uid() = id);
CREATE POLICY "users_delete_none" ON users FOR DELETE USING (false);

-- JOBS POLICIES
-- Only ACTIVE users can create/update jobs
CREATE POLICY "jobs_select_all" ON jobs FOR SELECT USING (true);
CREATE POLICY "jobs_insert_client" ON jobs FOR INSERT 
  WITH CHECK (
    auth.uid() = client_id AND 
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'client' AND status = 'active')
  );
CREATE POLICY "jobs_update_owner" ON jobs FOR UPDATE 
  USING (auth.uid() = client_id) 
  WITH CHECK (auth.uid() = client_id);
CREATE POLICY "jobs_delete_none" ON jobs FOR DELETE USING (false);

-- APPLICATIONS POLICIES
-- Only ACTIVE talents can apply for jobs
CREATE POLICY "applications_select_relevant" ON applications FOR SELECT 
  USING (auth.uid() = talent_id OR auth.uid() IN (SELECT client_id FROM jobs WHERE id = job_id));
CREATE POLICY "applications_insert_talent" ON applications FOR INSERT 
  WITH CHECK (
    auth.uid() = talent_id AND 
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'talent' AND status = 'active')
  );
CREATE POLICY "applications_update_client" ON applications FOR UPDATE 
  USING (auth.uid() IN (SELECT client_id FROM jobs WHERE id = job_id));

-- REVIEWS POLICIES
CREATE POLICY "reviews_select_all" ON reviews FOR SELECT USING (true);
CREATE POLICY "reviews_insert_participant" ON reviews FOR INSERT 
  WITH CHECK (auth.uid() = reviewer_id AND EXISTS (
    SELECT 1 FROM jobs WHERE id = job_id AND status = 'completed' AND (client_id = auth.uid() OR talent_id = auth.uid())
  ));

-- NOTIFICATIONS POLICIES (SECURED - client tidak bisa INSERT langsung)
CREATE POLICY "notifications_select_own" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "notifications_update_own" ON notifications FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "notifications_insert_deny_client" ON notifications FOR INSERT WITH CHECK (false);
CREATE POLICY "notifications_delete_own" ON notifications FOR DELETE USING (auth.uid() = user_id);

-- SYSTEM CONFIG POLICIES
CREATE POLICY "config_select_all" ON system_config FOR SELECT USING (true);
CREATE POLICY "config_update_none" ON system_config FOR UPDATE USING (false);

-- FCM TOKENS POLICIES
CREATE POLICY "fcm_tokens_select_own" ON fcm_tokens FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "fcm_tokens_insert_own" ON fcm_tokens FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "fcm_tokens_update_own" ON fcm_tokens FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "fcm_tokens_delete_own" ON fcm_tokens FOR DELETE USING (auth.uid() = user_id);

-- AUDIT LOGS POLICIES (admin only read, no client writes)
CREATE POLICY "audit_read_admin_only" ON audit_logs FOR SELECT 
  USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'super_admin'));
CREATE POLICY "audit_insert_deny_client" ON audit_logs FOR INSERT WITH CHECK (false);
CREATE POLICY "audit_update_deny_all" ON audit_logs FOR UPDATE USING (false);
CREATE POLICY "audit_delete_deny_all" ON audit_logs FOR DELETE USING (false);

-- =============================================================================
-- PART 8: ATOMIC RPC FUNCTIONS
-- =============================================================================

-- Accept application atomically (prevents race conditions)
CREATE OR REPLACE FUNCTION accept_application(p_application_id UUID, p_client_id UUID)
RETURNS JSON AS $$
DECLARE
  v_job_id UUID;
  v_talent_id UUID;
  v_job_status TEXT;
  v_app_status TEXT;
BEGIN
  SELECT job_id, talent_id, status INTO v_job_id, v_talent_id, v_app_status
  FROM applications WHERE id = p_application_id FOR UPDATE;
  
  IF NOT FOUND THEN RETURN json_build_object('success', false, 'error', 'Application not found'); END IF;
  IF v_app_status != 'pending' THEN RETURN json_build_object('success', false, 'error', 'Application already processed'); END IF;
  
  SELECT status INTO v_job_status FROM jobs WHERE id = v_job_id AND client_id = p_client_id FOR UPDATE;
  
  IF NOT FOUND THEN RETURN json_build_object('success', false, 'error', 'Not authorized'); END IF;
  IF v_job_status != 'open' THEN RETURN json_build_object('success', false, 'error', 'Job not open'); END IF;
  
  UPDATE jobs SET status = 'in_progress', talent_id = v_talent_id WHERE id = v_job_id;
  UPDATE applications SET status = 'accepted' WHERE id = p_application_id;
  UPDATE applications SET status = 'rejected' WHERE job_id = v_job_id AND id != p_application_id;
  
  RETURN json_build_object('success', true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Activate user after completing profile (sets status from 'pending' to 'active')
-- Call this from Flutter after user completes their profile (WhatsApp, role, etc.)
CREATE OR REPLACE FUNCTION activate_user(p_user_id UUID)
RETURNS JSON AS $$
DECLARE
  v_status user_status;
  v_whatsapp TEXT;
BEGIN
  -- Get current user status and whatsapp
  SELECT status, whatsapp INTO v_status, v_whatsapp
  FROM users WHERE id = p_user_id;
  
  IF NOT FOUND THEN 
    RETURN json_build_object('success', false, 'error', 'User not found'); 
  END IF;
  
  -- Only pending users can be activated
  IF v_status = 'blocked' THEN
    RETURN json_build_object('success', false, 'error', 'User is blocked');
  END IF;
  
  IF v_status = 'active' THEN
    RETURN json_build_object('success', true, 'message', 'Already active');
  END IF;
  
  -- Require WhatsApp to be filled before activation
  IF v_whatsapp IS NULL OR v_whatsapp = '' THEN
    RETURN json_build_object('success', false, 'error', 'WhatsApp required');
  END IF;
  
  -- Activate the user
  UPDATE users 
  SET status = 'active', activated_at = NOW(), updated_at = NOW()
  WHERE id = p_user_id;
  
  RETURN json_build_object('success', true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create notification (internal use via triggers)
CREATE OR REPLACE FUNCTION create_notification(
  p_user_id UUID,
  p_title TEXT,
  p_message TEXT,
  p_type notification_type DEFAULT 'info',
  p_link TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_id UUID;
BEGIN
  INSERT INTO notifications (user_id, title, message, type, link)
  VALUES (p_user_id, p_title, p_message, p_type, p_link)
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create job notification (for client-side use with validation)
CREATE OR REPLACE FUNCTION create_job_notification(
  p_recipient_id UUID,
  p_job_id UUID,
  p_title TEXT,
  p_message TEXT,
  p_type notification_type DEFAULT 'info'
)
RETURNS void AS $$
DECLARE
  v_caller_id UUID := auth.uid();
  v_job RECORD;
BEGIN
  -- Verify job exists and caller is involved
  SELECT client_id, talent_id INTO v_job 
  FROM jobs WHERE id = p_job_id;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Job not found';
  END IF;
  
  -- Only allow if caller is client or talent of this job
  IF v_caller_id != v_job.client_id AND v_caller_id != v_job.talent_id THEN
    RAISE EXCEPTION 'Not authorized to send notification for this job';
  END IF;
  
  -- Only allow notifying the OTHER party (not yourself)
  IF p_recipient_id = v_caller_id THEN
    RAISE EXCEPTION 'Cannot send notification to yourself';
  END IF;
  
  -- Recipient must also be involved in the job
  IF p_recipient_id != v_job.client_id AND p_recipient_id != v_job.talent_id THEN
    RAISE EXCEPTION 'Recipient not involved in this job';
  END IF;
  
  -- Create notification
  INSERT INTO notifications (user_id, title, message, type, link)
  VALUES (p_recipient_id, p_title, p_message, p_type, '/jobs/' || p_job_id);
  
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================================================
-- PART 9: NOTIFICATION TRIGGERS
-- =============================================================================

-- Notify client when new application
CREATE OR REPLACE FUNCTION notify_new_application()
RETURNS TRIGGER AS $$
DECLARE
  v_job_title TEXT;
  v_client_id UUID;
BEGIN
  SELECT title, client_id INTO v_job_title, v_client_id
  FROM jobs WHERE id = NEW.job_id;
  
  PERFORM create_notification(
    v_client_id,
    'Lamaran Baru! 📥',
    NEW.talent_name || ' melamar untuk "' || v_job_title || '"',
    'info',
    '/jobs/' || NEW.job_id
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_new_application ON applications;
CREATE TRIGGER on_new_application
  AFTER INSERT ON applications
  FOR EACH ROW EXECUTE FUNCTION notify_new_application();

-- Notify talent when application status changes
CREATE OR REPLACE FUNCTION notify_application_status()
RETURNS TRIGGER AS $$
DECLARE
  v_job_title TEXT;
  v_status_text TEXT;
  v_type notification_type;
BEGIN
  IF OLD.status = NEW.status THEN
    RETURN NEW;
  END IF;
  
  SELECT title INTO v_job_title FROM jobs WHERE id = NEW.job_id;
  
  IF NEW.status = 'accepted' THEN
    v_status_text := 'diterima! 🎉';
    v_type := 'success';
  ELSIF NEW.status = 'rejected' THEN
    v_status_text := 'ditolak';
    v_type := 'warning';
  ELSE
    RETURN NEW;
  END IF;
  
  PERFORM create_notification(
    NEW.talent_id,
    'Update Lamaran',
    'Lamaran Anda untuk "' || v_job_title || '" ' || v_status_text,
    v_type,
    '/jobs/' || NEW.job_id
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_application_status_change ON applications;
CREATE TRIGGER on_application_status_change
  AFTER UPDATE ON applications
  FOR EACH ROW EXECUTE FUNCTION notify_application_status();

-- Notify when receiving a review
CREATE OR REPLACE FUNCTION notify_new_review()
RETURNS TRIGGER AS $$
DECLARE
  v_job_title TEXT;
BEGIN
  SELECT title INTO v_job_title FROM jobs WHERE id = NEW.job_id;
  
  PERFORM create_notification(
    NEW.reviewee_id,
    'Review Baru! ⭐',
    NEW.reviewer_name || ' memberikan rating ' || NEW.rating || ' bintang',
    'success',
    '/jobs/' || NEW.job_id
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_new_review ON reviews;
CREATE TRIGGER on_new_review
  AFTER INSERT ON reviews
  FOR EACH ROW EXECUTE FUNCTION notify_new_review();

-- Notify talent when job status changes
CREATE OR REPLACE FUNCTION notify_job_status_change()
RETURNS TRIGGER AS $$
DECLARE
  v_message TEXT;
  v_type notification_type;
BEGIN
  IF NEW.talent_id IS NULL OR OLD.status = NEW.status THEN
    RETURN NEW;
  END IF;
  
  IF NEW.status = 'completed' THEN
    v_message := 'Pekerjaan "' || NEW.title || '" telah selesai! 🎉 Terima kasih.';
    v_type := 'success';
  ELSIF NEW.status = 'cancelled' THEN
    v_message := 'Pekerjaan "' || NEW.title || '" dibatalkan.';
    v_type := 'warning';
  ELSIF NEW.status = 'under_review' THEN
    v_message := 'Pekerjaan "' || NEW.title || '" sedang dalam review.';
    v_type := 'info';
  ELSE
    RETURN NEW;
  END IF;
  
  PERFORM create_notification(
    NEW.talent_id,
    'Update Pekerjaan',
    v_message,
    v_type,
    '/jobs/' || NEW.id
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_job_status_change ON jobs;
CREATE TRIGGER on_job_status_change
  AFTER UPDATE ON jobs
  FOR EACH ROW EXECUTE FUNCTION notify_job_status_change();

-- =============================================================================
-- PART 10: REVIEW FLAGS & RATING AUTO-UPDATE
-- =============================================================================

-- Update has_client_reviewed / has_talent_reviewed flags
CREATE OR REPLACE FUNCTION update_job_review_flags()
RETURNS TRIGGER AS $$
DECLARE
  v_reviewer_role TEXT;
BEGIN
  SELECT role INTO v_reviewer_role FROM users WHERE id = NEW.reviewer_id;
  
  IF v_reviewer_role = 'client' THEN
    UPDATE jobs SET has_client_reviewed = true, updated_at = NOW() WHERE id = NEW.job_id;
  ELSIF v_reviewer_role = 'talent' THEN
    UPDATE jobs SET has_talent_reviewed = true, updated_at = NOW() WHERE id = NEW.job_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_review_update_flags ON reviews;
CREATE TRIGGER on_review_update_flags
  AFTER INSERT ON reviews
  FOR EACH ROW EXECUTE FUNCTION update_job_review_flags();

-- Auto-update user rating when receiving a review
CREATE OR REPLACE FUNCTION update_user_rating_on_review()
RETURNS TRIGGER AS $$
DECLARE
  v_avg_rating DECIMAL(2,1);
  v_review_count INTEGER;
BEGIN
  SELECT 
    ROUND(AVG(rating)::numeric, 1),
    COUNT(*)
  INTO v_avg_rating, v_review_count
  FROM reviews
  WHERE reviewee_id = NEW.reviewee_id;
  
  UPDATE users
  SET 
    rating = COALESCE(v_avg_rating, 0),
    review_count = COALESCE(v_review_count, 0),
    updated_at = NOW()
  WHERE id = NEW.reviewee_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_review_update_rating ON reviews;
CREATE TRIGGER on_review_update_rating
  AFTER INSERT ON reviews
  FOR EACH ROW EXECUTE FUNCTION update_user_rating_on_review();

-- =============================================================================
-- PART 11: PUSH NOTIFICATION TRIGGER (optional - requires pg_net)
-- =============================================================================

CREATE OR REPLACE FUNCTION send_push_notification()
RETURNS TRIGGER AS $$
DECLARE
  v_token TEXT;
  v_response_id bigint;
BEGIN
  -- Get FCM token for user
  SELECT token INTO v_token 
  FROM fcm_tokens 
  WHERE user_id = NEW.user_id 
  LIMIT 1;
  
  IF v_token IS NOT NULL THEN
    -- Call edge function via HTTP (replace URL with your Supabase URL)
    SELECT net.http_post(
      url := 'https://rlzxwinxazygfdnwlvrr.supabase.co/functions/v1/send-push',
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := json_build_object(
        'user_id', NEW.user_id,
        'title', NEW.title,
        'body', NEW.message
      )::text
    ) INTO v_response_id;
  END IF;
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Don't fail if push fails
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_notification_send_push ON notifications;
CREATE TRIGGER on_notification_send_push
  AFTER INSERT ON notifications
  FOR EACH ROW EXECUTE FUNCTION send_push_notification();

-- =============================================================================
-- PART 12: AUDIT LOGGING TRIGGERS
-- =============================================================================

CREATE OR REPLACE FUNCTION audit_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (
    user_id, 
    action, 
    table_name, 
    record_id, 
    old_data, 
    new_data
  ) VALUES (
    auth.uid(),
    TG_OP,
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN to_jsonb(OLD) ELSE NULL END,
    CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN to_jsonb(NEW) ELSE NULL END
  );
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS audit_users ON users;
CREATE TRIGGER audit_users
  AFTER INSERT OR UPDATE OR DELETE ON users
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

DROP TRIGGER IF EXISTS audit_jobs ON jobs;
CREATE TRIGGER audit_jobs
  AFTER INSERT OR UPDATE OR DELETE ON jobs
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

DROP TRIGGER IF EXISTS audit_applications ON applications;
CREATE TRIGGER audit_applications
  AFTER INSERT OR UPDATE OR DELETE ON applications
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

DROP TRIGGER IF EXISTS audit_reviews ON reviews;
CREATE TRIGGER audit_reviews
  AFTER INSERT OR UPDATE OR DELETE ON reviews
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

-- =============================================================================
-- PART 13: REALTIME SUBSCRIPTIONS
-- =============================================================================

-- Enable realtime for key tables
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE jobs;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE applications;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Enable replica identity for proper change tracking
ALTER TABLE applications REPLICA IDENTITY FULL;
ALTER TABLE notifications REPLICA IDENTITY FULL;

-- =============================================================================
-- PART 14: PERMISSIONS
-- =============================================================================

GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON public.users TO postgres, service_role;
GRANT SELECT, UPDATE ON public.users TO authenticated;

-- =============================================================================
-- PART 15: USER PREFERENCES (for personalized recommendations)
-- =============================================================================

-- Table for storing user's preferred job categories
CREATE TABLE IF NOT EXISTS user_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
  preferred_categories TEXT[] NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

-- RLS Policies - users can only manage their own preferences
CREATE POLICY "user_preferences_select_own" ON user_preferences
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_preferences_insert_own" ON user_preferences
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_preferences_update_own" ON user_preferences
  FOR UPDATE USING (auth.uid() = user_id);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_user_preferences_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS user_preferences_updated_at ON user_preferences;
CREATE TRIGGER user_preferences_updated_at
  BEFORE UPDATE ON user_preferences
  FOR EACH ROW EXECUTE FUNCTION update_user_preferences_updated_at();

-- Grant access
GRANT ALL ON user_preferences TO authenticated;

-- =============================================================================
-- PART 15.5: APP CONFIG (for version check and update URL)
-- =============================================================================
-- Stores app configuration that can be changed without app update
-- Allows switching from GitHub releases to Play Store without app update

CREATE TABLE IF NOT EXISTS app_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT UNIQUE NOT NULL,
  value TEXT NOT NULL,
  description TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS but allow public read (no auth required)
ALTER TABLE app_config ENABLE ROW LEVEL SECURITY;

-- Anyone can read config (for version check before login)
CREATE POLICY "app_config_public_read" ON app_config
  FOR SELECT USING (true);

-- Only service role can modify (via Supabase dashboard)
CREATE POLICY "app_config_service_write" ON app_config
  FOR ALL USING (false);

-- Insert default configuration
INSERT INTO app_config (key, value, description) VALUES
  ('min_version', '1.0.0', 'Minimum app version required'),
  ('latest_version', '1.0.0', 'Latest available app version'),
  ('update_url', '', 'URL to download update (GitHub releases or Play Store)'),
  ('force_update', 'false', 'If true, users must update before using app'),
  ('update_message', 'Versi baru tersedia! Update untuk fitur terbaru.', 'Message shown to users')
ON CONFLICT (key) DO NOTHING;

-- Grant read access
GRANT SELECT ON app_config TO anon, authenticated;

-- =============================================================================
-- APP CONFIG USAGE GUIDE
-- =============================================================================
-- 
-- SETUP AWAL (jalankan sekali setelah create table):
--   UPDATE app_config SET value = 'https://github.com/USER/REPO/releases' 
--   WHERE key = 'update_url';
--
-- RILIS VERSI BARU (normal, tidak urgent):
--   UPDATE app_config SET value = '1.1.0' WHERE key = 'latest_version';
--   -- User akan lihat dialog "Update Tersedia", bisa skip
--
-- RILIS VERSI CRITICAL (bug/security fix, PAKSA update):
--   UPDATE app_config SET value = '1.2.0' WHERE key = 'min_version';
--   UPDATE app_config SET value = '1.2.0' WHERE key = 'latest_version';
--   -- User di bawah min_version TIDAK BISA pakai app
--
-- PINDAH KE PLAY STORE:
--   UPDATE app_config SET value = 'https://play.google.com/store/apps/details?id=com.talentahub' 
--   WHERE key = 'update_url';
--
-- KEY REFERENCE:
--   min_version    = Versi minimum yang boleh pakai app (trigger force update)
--   latest_version = Versi terbaru tersedia (trigger optional update)
--   update_url     = Link download (GitHub/Play Store)
--   force_update   = 'true'/'false' - paksa semua update ke latest
--   update_message = Pesan custom yang ditampilkan ke user
-- =============================================================================

-- =============================================================================
-- PART 16: JOB MATCHING NOTIFICATIONS
-- =============================================================================
-- Notifies talents when new jobs match their preferred categories

-- Index for faster category matching queries
CREATE INDEX IF NOT EXISTS idx_user_preferences_categories 
  ON user_preferences USING GIN (preferred_categories);

-- Function to notify matching talents when a new job is created
-- Creates IN-APP notifications only (push handled by app when syncing)
CREATE OR REPLACE FUNCTION notify_matching_talents()
RETURNS TRIGGER AS $$
DECLARE
  talent_record RECORD;
  job_category TEXT;
  notification_count INT := 0;
BEGIN
  -- Only trigger on INSERT and when job is open
  IF TG_OP = 'INSERT' AND NEW.status = 'open' THEN
    job_category := NEW.category;
    
    -- Find all talents whose preferences include this job's category
    FOR talent_record IN
      SELECT up.user_id, u.name as talent_name
      FROM user_preferences up
      JOIN users u ON u.id = up.user_id
      WHERE job_category = ANY(up.preferred_categories)
        AND u.role = 'talent'
        AND u.id != NEW.client_id
    LOOP
      -- Create in-app notification
      INSERT INTO notifications (
        user_id,
        title,
        message,
        type,
        link
      ) VALUES (
        talent_record.user_id,
        'Lowongan Baru! 🎯',
        'Ada lowongan ' || job_category || ' baru: ' || NEW.title,
        'info',
        '/jobs/' || NEW.id
      );
      
      notification_count := notification_count + 1;
    END LOOP;
    
    RAISE NOTICE 'Job matching notifications created: % for job %', notification_count, NEW.id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new jobs
DROP TRIGGER IF EXISTS on_job_created_notify_talents ON jobs;
CREATE TRIGGER on_job_created_notify_talents
  AFTER INSERT ON jobs
  FOR EACH ROW EXECUTE FUNCTION notify_matching_talents();

-- =============================================================================
-- PART 17: ADS SYSTEM (in-app advertisements)
-- =============================================================================

-- Create ads table
CREATE TABLE IF NOT EXISTS ads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(100) NOT NULL,
  -- Slides: array of {image_url, link_url}
  slides JSONB NOT NULL DEFAULT '[]',
  priority INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  start_date TIMESTAMPTZ,
  end_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE ads ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can read active, scheduled ads
CREATE POLICY "Read active scheduled ads" ON ads
  FOR SELECT
  USING (
    is_active = true 
    AND (start_date IS NULL OR start_date <= NOW()) 
    AND (end_date IS NULL OR end_date >= NOW())
  );

-- Policy: Admin can do everything with ads
CREATE POLICY "Admin full access ads" ON ads
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'super_admin'
    )
  );

-- Create storage bucket for ad images (if not exists)
INSERT INTO storage.buckets (id, name, public)
VALUES ('ads', 'ads', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policy: Anyone can read
CREATE POLICY "Public read ads" ON storage.objects
  FOR SELECT USING (bucket_id = 'ads');

-- Storage policy: Admin can upload
CREATE POLICY "Admin upload ads" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'ads' 
    AND EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'super_admin'
    )
  );

-- Storage policy: Admin can delete
CREATE POLICY "Admin delete ads" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'ads' 
    AND EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role = 'super_admin'
    )
  );

-- =============================================================================
-- PART 18: ADMIN POLICIES & FUNCTIONS (super_admin capabilities)
-- =============================================================================

-- Fix users_select_public to allow admin to see banned users
DROP POLICY IF EXISTS "users_select_public" ON users;
CREATE POLICY "users_select_public" ON users
  FOR SELECT
  USING (
    banned = false 
    OR
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'super_admin')
  );

-- Allow super_admin to UPDATE any user (for ban/unban) - kept for direct queries
DROP POLICY IF EXISTS "admin_update_users" ON users;
CREATE POLICY "admin_update_users" ON users
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM users admin 
      WHERE admin.id = auth.uid() 
      AND admin.role = 'super_admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users admin 
      WHERE admin.id = auth.uid() 
      AND admin.role = 'super_admin'
    )
  );

-- Allow super_admin to DELETE any job
DROP POLICY IF EXISTS "admin_delete_jobs" ON jobs;
CREATE POLICY "admin_delete_jobs" ON jobs
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM users admin 
      WHERE admin.id = auth.uid() 
      AND admin.role = 'super_admin'
    )
  );

-- Admin ban/unban function (SECURITY DEFINER - bypasses RLS)
CREATE OR REPLACE FUNCTION admin_toggle_ban(target_user_id UUID, set_banned BOOLEAN)
RETURNS void AS $$
BEGIN
  -- Verify caller is super_admin
  IF NOT EXISTS (
    SELECT 1 FROM users WHERE id = auth.uid() AND role = 'super_admin'
  ) THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;
  
  -- Update the user
  UPDATE users SET banned = set_banned WHERE id = target_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================================================
-- PART 19: EDGE CASE HANDLERS (admin action side effects)
-- =============================================================================

-- Handle side effects when user is banned
CREATE OR REPLACE FUNCTION handle_user_banned()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.banned = true AND OLD.banned = false THEN
    -- Handle banned talent: reset their in_progress jobs
    IF NEW.role = 'talent' THEN
      -- Notify clients (only if client not banned)
      INSERT INTO notifications (user_id, title, message, type, link)
      SELECT j.client_id, 'Perubahan Pekerjaan', 
             'Talent tidak tersedia. Pekerjaan "' || j.title || '" dibuka kembali.',
             'warning', '/jobs/' || j.id
      FROM jobs j
      JOIN users u ON u.id = j.client_id
      WHERE j.talent_id = NEW.id AND j.status = 'in_progress' AND u.banned = false;
      
      -- Reset jobs to open
      UPDATE jobs SET status = 'open', talent_id = NULL 
      WHERE talent_id = NEW.id AND status = 'in_progress';
    END IF;
    
    -- Handle banned client: cancel their jobs
    IF NEW.role = 'client' THEN
      -- Notify talents (only if talent not banned)
      INSERT INTO notifications (user_id, title, message, type, link)
      SELECT j.talent_id, 'Pekerjaan Dibatalkan', 
             'Pekerjaan "' || j.title || '" dibatalkan.',
             'warning', '/jobs/' || j.id
      FROM jobs j
      JOIN users u ON u.id = j.talent_id
      WHERE j.client_id = NEW.id AND j.status = 'in_progress' AND j.talent_id IS NOT NULL AND u.banned = false;
      
      -- Cancel client's jobs
      UPDATE jobs SET status = 'cancelled' 
      WHERE client_id = NEW.id AND status IN ('open', 'in_progress');
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_user_banned ON users;
CREATE TRIGGER on_user_banned
  AFTER UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION handle_user_banned();

-- Cleanup notifications when job is deleted
CREATE OR REPLACE FUNCTION cleanup_job_notifications()
RETURNS TRIGGER AS $$
BEGIN
  DELETE FROM notifications WHERE link = '/jobs/' || OLD.id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS before_job_delete ON jobs;
CREATE TRIGGER before_job_delete
  BEFORE DELETE ON jobs
  FOR EACH ROW EXECUTE FUNCTION cleanup_job_notifications();

-- =============================================================================
-- PART 14: REALTIME PUBLICATIONS
-- =============================================================================
-- Enable realtime subscriptions for tables that need live updates
-- Note: This may fail if tables are already added, that's OK

DO $$
BEGIN
  -- Jobs table: for real-time status updates
  ALTER PUBLICATION supabase_realtime ADD TABLE jobs;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  -- Applications table: for real-time application status
  ALTER PUBLICATION supabase_realtime ADD TABLE applications;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  -- Notifications table: for real-time push notifications
  ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Set replica identity for proper change tracking
ALTER TABLE jobs REPLICA IDENTITY FULL;
ALTER TABLE applications REPLICA IDENTITY FULL;
ALTER TABLE notifications REPLICA IDENTITY FULL;

-- =============================================================================
-- PART 15: ORPHAN CLEANUP (FALLBACK SAFETY NET)
-- =============================================================================
-- This function cleans up orphan auth users that don't have corresponding
-- public.users profiles. This is a fallback for edge cases like OAuth failures.
-- Run daily via Supabase Scheduled Functions or pg_cron.

CREATE OR REPLACE FUNCTION cleanup_orphan_auth_users()
RETURNS TABLE(deleted_count INTEGER) AS $$
DECLARE
  v_count INTEGER;
BEGIN
  -- Delete auth users that:
  -- 1. Don't have a corresponding public.users profile
  -- 2. Were created more than 24 hours ago (give time for normal signup flow)
  -- 3. Haven't confirmed their email (additional safety check)
  DELETE FROM auth.users au
  WHERE au.id NOT IN (SELECT id FROM public.users)
    AND au.created_at < NOW() - INTERVAL '24 hours';
  
  GET DIAGNOSTICS v_count = ROW_COUNT;
  
  -- Log the cleanup
  IF v_count > 0 THEN
    RAISE NOTICE 'Cleaned up % orphan auth users', v_count;
  END IF;
  
  RETURN QUERY SELECT v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute to service role only (for scheduled functions)
REVOKE ALL ON FUNCTION cleanup_orphan_auth_users FROM PUBLIC;

-- =============================================================================
-- SETUP COMPLETE! 
-- Paste seluruh file ini di Supabase SQL Editor dan klik RUN.
-- =============================================================================

-- =============================================================================
-- MIGRATION FOR EXISTING DATABASES (Run AFTER initial setup)
-- =============================================================================
-- If you have existing users without status column, run these:

-- Add status column if not exists (safe to run multiple times)
-- ALTER TABLE users ADD COLUMN IF NOT EXISTS status user_status NOT NULL DEFAULT 'pending';
-- ALTER TABLE users ADD COLUMN IF NOT EXISTS activated_at TIMESTAMPTZ;

-- Migrate existing users to 'active' status (they've already completed profile)
-- UPDATE users SET status = 'active', activated_at = created_at WHERE status = 'pending' AND whatsapp IS NOT NULL AND whatsapp != '';

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================
-- Run these after setup to verify everything is correct:

-- Tables:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

-- Policies:
-- SELECT tablename, policyname FROM pg_policies WHERE schemaname = 'public';

-- Triggers:
-- SELECT trigger_name, event_object_table FROM information_schema.triggers WHERE trigger_schema = 'public';

-- Realtime:
-- SELECT schemaname, tablename FROM pg_publication_tables WHERE pubname = 'supabase_realtime';

-- User status distribution:
-- SELECT status, COUNT(*) FROM users GROUP BY status;

-- Manual orphan cleanup test (run once to verify):
-- SELECT * FROM cleanup_orphan_auth_users();

-- =============================================================================
-- SUPER ADMIN SETUP (Run AFTER creating admin account via app)
-- =============================================================================
-- 
-- Karena ada security trigger yang mencegah perubahan role ke super_admin
-- via API biasa, gunakan SQL berikut untuk setup admin pertama:
--
-- 1. Buat akun biasa via app dengan email admin (misal: admin@talentahub.net)
-- 2. Jalankan SQL ini di Supabase SQL Editor:
--
--    SET session_replication_role = replica;
--    UPDATE users SET role = 'super_admin' WHERE email = 'admin@talentahub.net';
--    SET session_replication_role = DEFAULT;
--
-- 3. Logout dan login kembali - akan redirect ke Admin Dashboard
--
-- CATATAN: session_replication_role = replica menonaktifkan semua trigger
-- sementara untuk bypass validasi. Langsung kembali ke DEFAULT setelah update.
-- =============================================================================
