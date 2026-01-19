
export const formatCurrency = (amount: number): string => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
};

export const formatDate = (dateString: string): string => {
  const options: Intl.DateTimeFormatOptions = { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  };
  return new Date(dateString).toLocaleDateString('id-ID', options);
};

export const timeAgo = (dateString: string): string => {
  const date = new Date(dateString);
  const now = new Date();
  const seconds = Math.floor((now.getTime() - date.getTime()) / 1000);

  let interval = seconds / 31536000;
  if (interval > 1) return Math.floor(interval) + " tahun lalu";
  interval = seconds / 2592000;
  if (interval > 1) return Math.floor(interval) + " bulan lalu";
  interval = seconds / 86400;
  if (interval > 1) return Math.floor(interval) + " hari lalu";
  interval = seconds / 3600;
  if (interval > 1) return Math.floor(interval) + " jam lalu";
  interval = seconds / 60;
  if (interval > 1) return Math.floor(interval) + " menit lalu";
  return "Baru saja";
};

export const getRelativeDeadline = (dateString: string): string => {
  const target = new Date(dateString);
  const now = new Date();
  
  // Reset jam ke 00:00:00 agar perhitungan murni berdasarkan tanggal kalender
  target.setHours(0, 0, 0, 0);
  now.setHours(0, 0, 0, 0);

  const diffTime = target.getTime() - now.getTime();
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

  if (diffDays < 0) return 'Sudah lewat';
  if (diffDays === 0) return 'Hari ini';
  if (diffDays === 1) return 'Besok';
  return `${diffDays} hari lagi`;
};

export const formatPhoneNumber = (num: string) => {
  let clean = num.replace(/\D/g, ''); // Remove non-digits
  if (clean.startsWith('08')) {
      clean = '62' + clean.substring(1);
  } else if (clean.startsWith('8')) {
      clean = '62' + clean;
  }
  return clean.startsWith('62') ? '+' + clean : '+' + clean; // Ensure + prefix
};
