-- Migration: Create ads table for in-app advertisements
-- Run this in Supabase SQL Editor

-- Create ads table
CREATE TABLE ads (
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

-- Policy: Admin can do everything
CREATE POLICY "Admin full access" ON ads
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
