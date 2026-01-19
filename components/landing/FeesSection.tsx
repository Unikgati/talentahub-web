import React from 'react';
import { CheckCircle, Heart } from 'lucide-react';

export const FeesSection: React.FC = () => {
  return (
    <div className="bg-slate-50 py-24 sm:py-32">
      <div className="mx-auto max-w-7xl px-6 lg:px-8">
        <div className="mx-auto max-w-2xl text-center mb-16">
          <h2 className="text-base font-semibold leading-7 text-indigo-600">Transparansi</h2>
          <p className="mt-2 text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
            100% Gratis Tanpa Potongan
          </p>
          <p className="mt-6 text-lg leading-8 text-gray-600">
            TalentaHub berkomitmen menjadi platform non-profit. Semua hasil kerja keras mahasiswa adalah milik mereka sepenuhnya.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-16 items-start max-w-5xl mx-auto">
          {/* Card Klien */}
          <div className="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden relative h-full flex flex-col hover:shadow-xl transition-shadow duration-300">
            <div className="bg-gray-900 p-6 text-white text-center">
              <h2 className="text-2xl font-bold">Untuk Klien</h2>
              <p className="opacity-80">Pemberi Kerja / UMKM</p>
            </div>
            <div className="p-8 text-center flex-1 flex flex-col">
              <div className="text-5xl font-extrabold text-gray-900 mb-2">0%</div>
              <p className="text-gray-500 font-medium mb-6">Biaya Admin</p>
              <ul className="text-left space-y-4 mb-8 flex-1">
                <li className="flex items-center gap-3">
                  <CheckCircle className="text-green-500 flex-shrink-0" size={20} />
                  <span className="text-gray-600">Posting Lowongan Gratis</span>
                </li>
                <li className="flex items-center gap-3">
                  <CheckCircle className="text-green-500 flex-shrink-0" size={20} />
                  <span className="text-gray-600">Bayar Langsung ke Mahasiswa</span>
                </li>
              </ul>
            </div>
          </div>

          {/* Card Talent */}
          <div className="bg-white rounded-2xl shadow-lg border-2 border-indigo-100 overflow-hidden relative h-full flex flex-col hover:shadow-xl transition-shadow duration-300">
            <div className="bg-indigo-600 p-6 text-white text-center">
              <h2 className="text-2xl font-bold">Untuk Mahasiswa</h2>
              <p className="opacity-80">Talent / Freelancer</p>
            </div>
            <div className="p-8 text-center flex-1 flex flex-col">
              <div className="text-5xl font-extrabold text-indigo-600 mb-2">0%</div>
              <p className="text-gray-500 font-medium mb-6">Potongan Platform</p>
              <ul className="text-left space-y-4 mb-8 flex-1">
                <li className="flex items-center gap-3">
                  <CheckCircle className="text-indigo-500 flex-shrink-0" size={20} />
                  <span className="text-gray-600">Tanpa potongan fee sepeserpun</span>
                </li>
                <li className="flex items-center gap-3">
                  <CheckCircle className="text-indigo-500 flex-shrink-0" size={20} />
                  <span className="text-gray-600">Terima honor utuh 100%</span>
                </li>
              </ul>
            </div>
          </div>
        </div>

        {/* Inline Donation Box */}
        <div className="max-w-xl mx-auto text-center bg-gradient-to-br from-pink-50 to-rose-50 rounded-2xl p-8 border border-pink-100">
          <Heart className="mx-auto text-pink-500 mb-4" size={32} />
          <h3 className="text-lg font-bold text-gray-900 mb-2">Dukung TalentaHub</h3>
          <p className="text-sm text-gray-600 mb-4">
            Jika Anda merasa terbantu, pertimbangkan untuk donasi agar kami bisa terus mengembangkan platform ini.
          </p>
          <a
            href="https://saweria.co/talentahub"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-6 py-2.5 bg-pink-500 text-white rounded-full text-sm font-medium hover:bg-pink-600 transition-colors"
          >
            <Heart size={16} /> Donasi via Saweria
          </a>
        </div>

      </div>
    </div>
  );
};