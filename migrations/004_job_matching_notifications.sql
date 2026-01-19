-- =============================================================================
-- Migration 004: Job Matching Notifications (FIXED)
-- =============================================================================
-- Creates trigger to notify talents when new jobs match their preferences
-- NOTE: In-app notifications will work immediately
-- Push notifications are OPTIONAL and require pg_net extension + URL config

-- Index for faster category matching queries
CREATE INDEX IF NOT EXISTS idx_user_preferences_categories 
  ON user_preferences USING GIN (preferred_categories);

-- Drop existing function and trigger to replace
DROP TRIGGER IF EXISTS on_job_created_notify_talents ON jobs;
DROP FUNCTION IF EXISTS notify_matching_talents();

-- Function to notify matching talents when a new job is created
-- This creates IN-APP notifications (always works)
-- Push notifications are attempted but won't block job creation if they fail
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
        AND u.id != NEW.client_id  -- Don't notify the client who created the job
    LOOP
      -- Create in-app notification (this always works)
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
    
    -- Log notification count
    RAISE NOTICE 'Job matching in-app notifications created: % for job %', notification_count, NEW.id;
    
    -- NOTE: Push notifications are handled separately by the app
    -- when it syncs notifications. This is more reliable than calling
    -- Edge Function from trigger which requires pg_net + URL config.
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new jobs
CREATE TRIGGER on_job_created_notify_talents
  AFTER INSERT ON jobs
  FOR EACH ROW EXECUTE FUNCTION notify_matching_talents();
