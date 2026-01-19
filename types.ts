
export type UserRole = 'client' | 'talent' | 'super_admin';

export interface User {
  id: string;
  email?: string; // New: Required for Supabase Auth
  name: string;
  whatsapp: string;
  role: UserRole;
  avatar?: string;
  bio?: string;
  skills?: string[];
  location?: string;
  gopayNumber?: string; // New field for Payment
  socials?: {
    instagram?: string;
    linkedin?: string;
    website?: string;
    x?: string;       // Twitter/X
    tiktok?: string;
    facebook?: string;
    reddit?: string;
    youtube?: string;
    github?: string;
  };
  rating?: number; // Average Rating (1-5)
  reviewCount?: number; // Total Reviews received
  banned?: boolean;
  createdAt: string;
}

export type JobStatus = 'open' | 'in_progress' | 'under_review' | 'completed' | 'cancelled' | 'disputed' | 'closed';

export interface Job {
  id: string;
  clientId: string;
  clientName: string;
  title: string;
  description: string;
  category: string;
  budget: number;
  deadline: string;
  status: JobStatus;
  talentId?: string;
  createdAt: string;
  isFeatured?: boolean;
  attachmentUrl?: string;
  tags: string[];
  hasClientReviewed?: boolean; // Has client reviewed the talent?
  hasTalentReviewed?: boolean; // Has talent reviewed the client?
}

export interface Application {
  id: string;
  jobId: string;
  talentId: string;
  talentName: string;
  talentAvatar?: string;
  message: string; // Pitching message
  status: 'pending' | 'accepted' | 'rejected';
  createdAt: string;
}

export interface Review {
  id: string;
  jobId: string;
  reviewerId: string;
  reviewerName: string;
  revieweeId: string; // The person being rated
  rating: number; // 1-5
  comment: string;
  createdAt: string;
}

export interface PlatformStats {
  totalUsers: number;
  activeTalent: number;
  totalJobs: number;
  totalRevenue: number;
  activeDisputes: number;
  recentTransactions: Transaction[];
}

export interface Transaction {
  id: string;
  amount: number;
  type: 'payout' | 'payment';
  status: 'pending' | 'completed';
  date: string;
  userId: string;
}

export interface SystemConfig {
  maxTalentQuota: number;
  maintenanceMode: boolean;
  landingHeroTitle: string;
  donationNumber: string; 
  supportWhatsApp: string; // Admin Support Number
}

export interface Notification {
  id: string;
  userId: string; // Who receives this
  title: string;
  message: string;
  type: 'info' | 'success' | 'warning' | 'error';
  isRead: boolean;
  link?: string; // Redirect URL when clicked
  createdAt: string;
}
