-- =============================================================================
-- TalentaHub SEED DATA (Demo Data)
-- =============================================================================
-- Data dummy realistis untuk demo. Jalankan setelah setup schema.
-- 
-- PERINGATAN: Jangan jalankan di production dengan user asli!
-- =============================================================================

-- =============================================================================
-- CARA PAKAI:
-- 1. Buat 5 akun Client dan 5 akun Talent via app (total 10 akun)
-- 2. Ambil UUID dari Supabase Table Editor → users → copy id
-- 3. Ganti placeholder UUID di bawah dengan UUID asli
-- 4. Jalankan SQL ini di Supabase SQL Editor
-- =============================================================================

DO $$
DECLARE
  -- ==========================================================================
  -- GANTI UUID INI DENGAN UUID ASLI DARI AKUN YANG SUDAH DIBUAT
  -- ==========================================================================
  
  -- CLIENTS (5 akun)
  client_1_id UUID := '87135490-12df-4a20-8861-89dd54141de0'; -- PT Maju Bersama (startup)
  client_2_id UUID := 'd1c775de-a8f8-4635-9cef-e4c039582dd6'; -- Toko Fashion Online
  client_3_id UUID := '8bb126ab-9d5a-4134-ab3a-58a708025794'; -- CV Kuliner Nusantara
  client_4_id UUID := '49297b30-d488-4aba-a979-4c23954ae6c9'; -- Klinik Sehat Sejahtera
  client_5_id UUID := '0cd5efac-79d0-406f-b220-220e13223b78'; -- Agency Digital Kreatif
  
  -- TALENTS (5 akun)
  talent_1_id UUID := '102a3c0b-ad44-4404-86b7-89f8aad14058'; -- Web Developer
  talent_2_id UUID := 'c0686cb3-f20d-4325-93f6-a06322843911'; -- Graphic Designer
  talent_3_id UUID := '3a50bd23-0b92-42df-8ae1-1a0dedeb8865'; -- Content Writer
  talent_4_id UUID := '8e80b79d-78fb-4f35-8392-3573ded2965c'; -- Video Editor
  talent_5_id UUID := '51f320c6-5695-45f2-8108-e0b0b131eccd'; -- Social Media Manager
  
  -- Job IDs (auto-generated)
  job_1_id UUID; job_2_id UUID; job_3_id UUID; job_4_id UUID; job_5_id UUID;
  job_6_id UUID; job_7_id UUID; job_8_id UUID; job_9_id UUID; job_10_id UUID;
  
BEGIN

  -- ==========================================================================
  -- JOBS (10 lowongan dari berbagai client)
  -- ==========================================================================
  
  -- ===== CLIENT 1: PT Maju Bersama (Startup Fintech) =====
  
  -- Job 1: Desain Logo (OPEN)
  job_1_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, created_at)
  VALUES (
    job_1_id, client_1_id, 'PT Maju Bersama',
    'Desain Logo Startup Fintech',
    '## Deskripsi
Kami mencari desainer untuk membuat logo modern untuk aplikasi fintech kami.

## Requirements
- Pengalaman 1+ tahun graphic design
- Mahir Adobe Illustrator
- Portfolio yang solid

## Deliverables
- 3 konsep awal → 2x revisi
- File AI, PNG, SVG',
    'Desain Grafis', 750000, NOW() + INTERVAL '14 days', 'open', NOW() - INTERVAL '2 days'
  );

  -- Job 2: Landing Page (IN_PROGRESS dengan Talent 1)
  job_2_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, talent_id, created_at)
  VALUES (
    job_2_id, client_1_id, 'PT Maju Bersama',
    'Pembuatan Landing Page Company Profile',
    '## Deskripsi
Butuh developer untuk membuat landing page responsive dengan animasi modern.

## Tech Stack
- React atau Next.js
- Tailwind CSS
- Framer Motion untuk animasi

## Fitur
- Hero section dengan animasi
- About, Services, Contact
- WhatsApp integration',
    'Pengembangan Web', 2500000, NOW() + INTERVAL '21 days', 'in_progress', talent_1_id, NOW() - INTERVAL '7 days'
  );

  -- ===== CLIENT 2: Toko Fashion Online =====
  
  -- Job 3: Content Writing (OPEN)
  job_3_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, created_at)
  VALUES (
    job_3_id, client_2_id, 'Toko Fashion Online',
    'Penulisan 15 Artikel SEO Fashion',
    '## Deskripsi
Butuh content writer untuk 15 artikel SEO-friendly untuk blog fashion.

## Topics
- Fashion tips & trends 2024
- Outfit inspiration
- Product reviews

## Requirements
- Minimal 1000 kata per artikel
- Original, no plagiarism
- Include meta description',
    'Penulisan Konten', 1200000, NOW() + INTERVAL '14 days', 'open', NOW() - INTERVAL '1 day'
  );

  -- Job 4: Video Promosi (COMPLETED)
  job_4_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, talent_id, created_at)
  VALUES (
    job_4_id, client_2_id, 'Toko Fashion Online',
    'Edit 10 Video Reels Fashion',
    '## Deskripsi
Edit 10 video promosi untuk Instagram Reels (15-30 detik).

## Style
- Trendy, eye-catching
- Music sync
- Text overlay modern

## Deliverables
- Format MP4 (1080x1920)',
    'Video & Animasi', 1000000, NOW() - INTERVAL '5 days', 'completed', talent_4_id, NOW() - INTERVAL '20 days'
  );

  -- ===== CLIENT 3: CV Kuliner Nusantara =====
  
  -- Job 5: Social Media (OPEN)
  job_5_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, created_at)
  VALUES (
    job_5_id, client_3_id, 'CV Kuliner Nusantara',
    'Kelola Instagram & TikTok 1 Bulan',
    '## Scope of Work
- Content plan bulanan
- 30 feed posts + 60 stories
- Caption + hashtag research
- Engagement management

## Requirements
- Pengalaman social media F&B
- Kreatif dan up-to-date',
    'Pemasaran Digital', 3000000, NOW() + INTERVAL '30 days', 'open', NOW() - INTERVAL '6 hours'
  );

  -- Job 6: Menu Design (COMPLETED)
  job_6_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, talent_id, created_at)
  VALUES (
    job_6_id, client_3_id, 'CV Kuliner Nusantara',
    'Desain Menu Digital & Cetak',
    '## Brief
Desain menu restoran untuk versi digital (QR) dan cetak.

## Deliverables
- Menu digital (PDF interaktif)
- Menu cetak A4 landscape
- Source file (AI/PSD)',
    'Desain Grafis', 600000, NOW() - INTERVAL '10 days', 'completed', talent_2_id, NOW() - INTERVAL '25 days'
  );

  -- ===== CLIENT 4: Klinik Sehat Sejahtera =====
  
  -- Job 7: Website Klinik (OPEN)
  job_7_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, created_at)
  VALUES (
    job_7_id, client_4_id, 'Klinik Sehat Sejahtera',
    'Website Booking Appointment Klinik',
    '## Deskripsi
Website untuk booking jadwal appointment dokter dengan calendar.

## Fitur
- Landing page profil klinik
- List dokter + jadwal
- Form booking dengan WhatsApp notif
- Admin dashboard sederhana

## Tech
- Frontend bebas (React/Vue)
- Backend Supabase',
    'Pengembangan Web', 5000000, NOW() + INTERVAL '45 days', 'open', NOW() - INTERVAL '3 days'
  );

  -- Job 8: Konten Edukasi (IN_PROGRESS dengan Talent 3)
  job_8_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, talent_id, created_at)
  VALUES (
    job_8_id, client_4_id, 'Klinik Sehat Sejahtera',
    'Penulisan 20 Artikel Kesehatan',
    '## Brief
Artikel edukasi kesehatan untuk website dan social media.

## Topics
- Tips menjaga kesehatan
- Penjelasan penyakit umum
- FAQ medis

## Requirements
- Riset akurat
- Bahasa mudah dipahami',
    'Penulisan Konten', 1500000, NOW() + INTERVAL '30 days', 'in_progress', talent_3_id, NOW() - INTERVAL '5 days'
  );

  -- ===== CLIENT 5: Agency Digital Kreatif =====
  
  -- Job 9: Motion Graphics (OPEN)
  job_9_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, created_at)
  VALUES (
    job_9_id, client_5_id, 'Agency Digital Kreatif',
    'Motion Graphics untuk Company Profile',
    '## Brief
Video motion graphics 60-90 detik untuk company profile agency.

## Style
- Modern, corporate tapi tidak boring
- Smooth transitions
- Background music

## Deliverables
- Video MP4 1080p + 4K
- Source file After Effects',
    'Video & Animasi', 3500000, NOW() + INTERVAL '21 days', 'open', NOW() - INTERVAL '12 hours'
  );

  -- Job 10: UI/UX Design (IN_PROGRESS dengan Talent 2)
  job_10_id := gen_random_uuid();
  INSERT INTO jobs (id, client_id, client_name, title, description, category, budget, deadline, status, talent_id, created_at)
  VALUES (
    job_10_id, client_5_id, 'Agency Digital Kreatif',
    'UI/UX Design Mobile App E-Commerce',
    '## Scope
Desain UI/UX lengkap untuk aplikasi e-commerce client kami.

## Deliverables
- User flow & wireframes
- High-fidelity mockups (30+ screens)
- Prototype interaktif Figma
- Design system',
    'Desain Grafis', 8000000, NOW() + INTERVAL '30 days', 'in_progress', talent_2_id, NOW() - INTERVAL '10 days'
  );

  -- ==========================================================================
  -- APPLICATIONS (Lamaran ke berbagai job)
  -- ==========================================================================
  
  -- Job 1 (Logo) - 3 applicants
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_1_id, talent_2_id, 'Saya graphic designer dengan 4 tahun pengalaman di branding startup. Portfolio: dribbble.com/example', 'pending', NOW() - INTERVAL '1 day'),
    (job_1_id, talent_4_id, 'Saya juga bisa desain logo selain video editing. Lihat portfolio saya!', 'pending', NOW() - INTERVAL '18 hours'),
    (job_1_id, talent_5_id, 'Tertarik dengan project ini! Saya punya pengalaman desain untuk social media branding.', 'pending', NOW() - INTERVAL '6 hours');

  -- Job 2 (Landing Page) - Talent 1 accepted
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_2_id, talent_1_id, 'Web developer fullstack dengan React/Next.js expertise. Check github.com/example', 'accepted', NOW() - INTERVAL '6 days');

  -- Job 3 (Content) - 2 applicants
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_3_id, talent_3_id, 'Content writer dengan SEO specialty. 100+ artikel sudah dipublish. Portfolio: medium.com/example', 'pending', NOW() - INTERVAL '20 hours'),
    (job_3_id, talent_5_id, 'Saya bisa bantu untuk content writing juga! Pengalaman menulis caption dan blog post.', 'pending', NOW() - INTERVAL '12 hours');

  -- Job 4 (Video Reels) - Talent 4 completed
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_4_id, talent_4_id, 'Video editor profesional dengan 3 tahun pengalaman di social media content.', 'accepted', NOW() - INTERVAL '18 days');

  -- Job 5 (Social Media) - 2 applicants  
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_5_id, talent_5_id, 'Social media manager dengan pengalaman handle 10+ brand. Specialist di F&B!', 'pending', NOW() - INTERVAL '4 hours'),
    (job_5_id, talent_3_id, 'Saya bisa bantu content creation dan copywriting untuk social media.', 'pending', NOW() - INTERVAL '2 hours');

  -- Job 6 (Menu Design) - Talent 2 completed
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_6_id, talent_2_id, 'Desainer dengan pengalaman di branding F&B. Portfolio: behance.net/example', 'accepted', NOW() - INTERVAL '23 days');

  -- Job 7 (Website Klinik) - 2 applicants
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_7_id, talent_1_id, 'Saya bisa handle full-stack dengan Supabase. Sudah pernah buat sistem booking.', 'pending', NOW() - INTERVAL '2 days'),
    (job_7_id, talent_4_id, 'Saya juga bisa web development selain video editing. Tertarik project ini!', 'pending', NOW() - INTERVAL '1 day');

  -- Job 8 (Artikel Kesehatan) - Talent 3 accepted
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_8_id, talent_3_id, 'Content writer dengan background riset. Sudah biasa menulis artikel yang butuh akurasi tinggi.', 'accepted', NOW() - INTERVAL '4 days');

  -- Job 9 (Motion Graphics) - 1 applicant
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_9_id, talent_4_id, 'Motion graphics adalah specialty saya! Portofolio: vimeo.com/example', 'pending', NOW() - INTERVAL '10 hours');

  -- Job 10 (UI/UX) - Talent 2 accepted
  INSERT INTO applications (job_id, talent_id, message, status, created_at) VALUES 
    (job_10_id, talent_2_id, 'UI/UX designer dengan 5 tahun pengalaman. Specialized di e-commerce. Figma expert!', 'accepted', NOW() - INTERVAL '9 days');

  -- ==========================================================================
  -- REVIEWS (Ulasan untuk job yang sudah selesai)
  -- ==========================================================================
  
  -- Job 4 Reviews (Video Reels - Client 2 & Talent 4)
  INSERT INTO reviews (job_id, reviewer_id, reviewee_id, rating, comment, created_at) VALUES 
    (job_4_id, client_2_id, talent_4_id, 5, 
     'Excellent work! Video yang dihasilkan sangat kreatif dan sesuai brief. Komunikasi lancar, deadline on time. Highly recommended!',
     NOW() - INTERVAL '4 days'),
    (job_4_id, talent_4_id, client_2_id, 5, 
     'Client yang sangat kooperatif! Brief jelas, feedback konstruktif, dan pembayaran tepat waktu. Senang bisa kerja sama!',
     NOW() - INTERVAL '4 days');

  -- Job 6 Reviews (Menu Design - Client 3 & Talent 2)
  INSERT INTO reviews (job_id, reviewer_id, reviewee_id, rating, comment, created_at) VALUES 
    (job_6_id, client_3_id, talent_2_id, 5, 
     'Desain menu sangat bagus! Estetik, clean, dan memudahkan customer. Hasil print juga oke. Terima kasih!',
     NOW() - INTERVAL '8 days'),
    (job_6_id, talent_2_id, client_3_id, 4, 
     'Good client! Brief cukup jelas, meskipun ada beberapa revisi di luar scope awal. Overall pengalaman positif.',
     NOW() - INTERVAL '8 days');

  -- Additional review (past job simulation)
  -- Simulasi review lama untuk talent_1
  INSERT INTO reviews (job_id, reviewer_id, reviewee_id, rating, comment, created_at) VALUES 
    (job_2_id, client_1_id, talent_1_id, 5, 
     'Progress sangat bagus! Semoga project ini bisa selesai dengan baik. So far komunikasinya excellent!',
     NOW() - INTERVAL '2 days');

  RAISE NOTICE '========================================';
  RAISE NOTICE 'SEED DATA BERHASIL DIBUAT!';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'Jobs: 10 (5 open, 3 in_progress, 2 completed)';
  RAISE NOTICE 'Applications: 17';
  RAISE NOTICE 'Reviews: 5';
  RAISE NOTICE '========================================';
  
END $$;

-- =============================================================================
-- VERIFY DATA (Optional - uncomment to check)
-- =============================================================================
-- SELECT status, COUNT(*) FROM jobs GROUP BY status;
-- SELECT status, COUNT(*) FROM applications GROUP BY status;
-- SELECT COUNT(*) as total_reviews FROM reviews;
