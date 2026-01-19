import React from 'react';

interface LoadingProps {
  className?: string;
  /**
   * 'page': Untuk halaman penuh (Detail/Dashboard). Menggunakan optical centering (pb-16) agar spinner terlihat pas di tengah layar device, menyeimbangkan navbar.
   * 'section': Untuk bagian konten (List/Search). Menggunakan padding standar.
   * Default: 'page'
   */
  mode?: 'page' | 'section';
}

export const Loading: React.FC<LoadingProps> = ({ className, mode = 'page' }) => {
  // Base classes
  const baseClasses = "flex flex-col items-center justify-center w-full animate-fade-in";

  // Mode Classes
  // Page: min-h-[calc(100vh-64px)] fills the space below navbar.
  // pb-16: Adds bottom padding equivalent to navbar height. This shifts the flex center UP, 
  // making the spinner align with the true center of the viewport (Optical Center).
  const modeClasses = mode === 'page'
    ? "min-h-[calc(100vh-64px)] pb-16"
    : "py-20 min-h-[300px]";

  return (
    <div className={`${baseClasses} ${modeClasses} ${className || ''}`}>
      {/* 
         FIX: Menambahkan w-12 h-12 pada container relative.
         Sebelumnya container ini height-nya 0 karena anak-anaknya absolute,
         sehingga teks 'Memuat...' naik ke atas menimpa spinner.
      */}
      <div className="relative w-12 h-12">
        <div className="w-12 h-12 rounded-full absolute border-4 border-solid border-gray-200"></div>
        <div className="w-12 h-12 rounded-full animate-spin absolute border-4 border-solid border-indigo-600 border-t-transparent"></div>
      </div>
      <p className="mt-4 text-gray-500 font-medium text-sm animate-pulse">Memuat...</p>
    </div>
  );
};

export const LoadingScreen: React.FC = () => {
  return (
    <div className="fixed inset-0 bg-white z-[9999] flex flex-col items-center justify-center">
      <div className="relative w-16 h-16 mb-4">
        <div className="w-16 h-16 rounded-full absolute border-4 border-solid border-gray-200"></div>
        <div className="w-16 h-16 rounded-full animate-spin absolute border-4 border-solid border-indigo-600 border-t-transparent"></div>
      </div>
      <p className="text-gray-600 font-medium">Memuat TalentaHub...</p>
    </div>
  )
}