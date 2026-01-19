-- =============================================================================
-- Audit Logging System
-- Records all significant changes for accountability and debugging
-- Execute in Supabase SQL Editor: Dashboard > SQL Editor > New Query
-- =============================================================================

-- Audit logs table
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  action TEXT NOT NULL,  -- 'INSERT', 'UPDATE', 'DELETE'
  table_name TEXT NOT NULL,
  record_id UUID NOT NULL,
  old_data JSONB,
  new_data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_audit_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_table ON audit_logs(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_record ON audit_logs(record_id);
CREATE INDEX IF NOT EXISTS idx_audit_created_at ON audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_logs(action);

-- RLS: Only admins can read, no client can insert directly
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "audit_read_admin_only" ON audit_logs;
CREATE POLICY "audit_read_admin_only" ON audit_logs 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'super_admin')
  );

DROP POLICY IF EXISTS "audit_insert_deny_client" ON audit_logs;
CREATE POLICY "audit_insert_deny_client" ON audit_logs 
  FOR INSERT WITH CHECK (false);

DROP POLICY IF EXISTS "audit_update_deny_all" ON audit_logs;
CREATE POLICY "audit_update_deny_all" ON audit_logs 
  FOR UPDATE USING (false);

DROP POLICY IF EXISTS "audit_delete_deny_all" ON audit_logs;
CREATE POLICY "audit_delete_deny_all" ON audit_logs 
  FOR DELETE USING (false);

-- =============================================================================
-- Generic audit trigger function
-- Automatically logs INSERT, UPDATE, DELETE operations
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

-- =============================================================================
-- Apply triggers to critical tables
-- =============================================================================

-- Users table
DROP TRIGGER IF EXISTS audit_users ON users;
CREATE TRIGGER audit_users
  AFTER INSERT OR UPDATE OR DELETE ON users
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

-- Jobs table
DROP TRIGGER IF EXISTS audit_jobs ON jobs;
CREATE TRIGGER audit_jobs
  AFTER INSERT OR UPDATE OR DELETE ON jobs
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

-- Applications table
DROP TRIGGER IF EXISTS audit_applications ON applications;
CREATE TRIGGER audit_applications
  AFTER INSERT OR UPDATE OR DELETE ON applications
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

-- Reviews table
DROP TRIGGER IF EXISTS audit_reviews ON reviews;
CREATE TRIGGER audit_reviews
  AFTER INSERT OR UPDATE OR DELETE ON reviews
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

-- =============================================================================
-- Verification queries (run manually to check)
-- =============================================================================
-- Check triggers exist:
-- SELECT trigger_name, event_manipulation, event_object_table 
-- FROM information_schema.triggers 
-- WHERE trigger_schema = 'public' AND trigger_name LIKE 'audit_%';

-- View recent logs:
-- SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT 10;
