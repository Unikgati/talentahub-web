-- =============================================================================
-- Security Fix: Restrict Notification INSERT Policy
-- Execute in Supabase SQL Editor: Dashboard > SQL Editor > New Query
-- =============================================================================

-- Drop the overly permissive policy
DROP POLICY IF EXISTS "notifications_insert_system" ON notifications;

-- =============================================================================
-- APPROACH: Only server-side functions can create notifications
-- =============================================================================
-- SECURITY DEFINER functions (like our triggers) bypass RLS entirely.
-- So we can set INSERT to deny all, and all existing triggers still work.
-- For any client-side notification needs, use the RPC function below.

CREATE POLICY "notifications_insert_deny_client" ON notifications 
  FOR INSERT 
  WITH CHECK (false);

-- =============================================================================
-- RPC Function for safe notification creation from client-side
-- This validates that the caller has permission to notify the target user
-- =============================================================================

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
-- Verification
-- =============================================================================
-- Run this to verify the policy was created:
-- SELECT policyname, cmd, qual FROM pg_policies WHERE tablename = 'notifications';
