-- =============================================================================
-- Migration: Support Google OAuth users
-- Run this in Supabase SQL Editor
-- =============================================================================

-- Update handle_new_user trigger to extract data from OAuth providers
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
BEGIN
  -- Extract and validate role from metadata
  v_role := 'client';  -- Default
  BEGIN
    IF NEW.raw_user_meta_data->>'role' IN ('client', 'talent') THEN
      v_role := (NEW.raw_user_meta_data->>'role')::user_role;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_role := 'client';
  END;
  
  -- Extract name with fallback (Google uses 'full_name' or 'name')
  v_name := COALESCE(
    NULLIF(TRIM(NEW.raw_user_meta_data->>'full_name'), ''),
    NULLIF(TRIM(NEW.raw_user_meta_data->>'name'), ''),
    'User'
  );
  
  -- Extract phone, convert empty to NULL for proper uniqueness
  v_phone := NULLIF(TRIM(COALESCE(NEW.raw_user_meta_data->>'phone', '')), '');
  
  -- Extract avatar from OAuth provider (Google uses 'avatar_url' or 'picture')
  v_avatar := COALESCE(
    NULLIF(TRIM(NEW.raw_user_meta_data->>'avatar_url'), ''),
    NULLIF(TRIM(NEW.raw_user_meta_data->>'picture'), ''),
    NULL
  );
  
  -- Insert with conflict handling (idempotent)
  INSERT INTO public.users (id, email, name, whatsapp, role, avatar, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    v_name,
    v_phone,
    v_role,
    v_avatar,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    name = COALESCE(NULLIF(users.name, 'User'), EXCLUDED.name),
    whatsapp = COALESCE(users.whatsapp, EXCLUDED.whatsapp),
    avatar = COALESCE(users.avatar, EXCLUDED.avatar),
    updated_at = NOW();
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail auth signup
    RAISE WARNING 'handle_new_user error for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recreate trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users 
  FOR EACH ROW 
  EXECUTE FUNCTION handle_new_user();
