import React from 'react';
import { Download } from 'lucide-react';

export const CTA: React.FC = () => {
  return (
    <div className="bg-indigo-700">
      <div className="max-w-2xl mx-auto text-center py-12 px-4 sm:py-16 sm:px-6 lg:px-8">
        <h2 className="text-3xl font-extrabold text-white sm:text-4xl">
          <span className="block">Dukung Mahasiswa Indonesia?</span>
          <span className="block text-indigo-200">Beri mereka peluang kerja sekarang.</span>
        </h2>
        <p className="mt-4 text-lg leading-6 text-indigo-100">
          Download aplikasi TalentaHub. Posting job Anda, dan biarkan mahasiswa berbakat menyelesaikannya dengan harga terbaik.
        </p>
        <a
          href="https://github.com/Unikgati/talentahub-v.1.0.0/releases/download/TalentHub_Android_Release/TalentaHub_Android_v1.0.0_release.apk"
          target="_blank"
          rel="noopener noreferrer"
          className="mt-8 w-full inline-flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-full text-indigo-700 bg-white hover:bg-indigo-50 sm:w-auto shadow-lg transition-transform hover:scale-105 gap-2"
        >
          <Download size={20} />
          Download App Sekarang
        </a>
      </div>
    </div>
  );
};