import React from 'react';
import { Wallet, Heart, Zap, Shield, Lightbulb, Check } from 'lucide-react';

const FEATURE_TAGS = [
  "Bantu Pindahan Kos",
  "Jaga Stand Bazar",
  "Tour Guide Lokal",
  "Teman Olahraga",
  "Input Data Excel",
  "Jasa Ketik",
  "Desain Canva",
  "Foto Produk UMKM",
  "Surveyor Kuesioner"
];

export const Features: React.FC = () => {
  return (
    <div className="py-12 sm:py-16 lg:py-20 bg-white">
      <div className="mx-auto max-w-7xl px-6 lg:px-8">
        <div className="mx-auto max-w-2xl lg:text-center">
          <h2 className="text-base font-semibold leading-7 text-indigo-600">Kenapa TalentaHub?</h2>
          <p className="mt-2 text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
            Solusi Tepat, Harga Hemat
          </p>
          <p className="mt-6 text-lg leading-8 text-gray-600">
            Platform marketplace pertama yang fokus memberdayakan mahasiswa untuk mandiri dan berkarya.
          </p>
        </div>
        <div className="mx-auto mt-16 max-w-2xl sm:mt-20 lg:mt-24 lg:max-w-4xl">
          <dl className="grid max-w-xl grid-cols-1 gap-x-8 gap-y-10 lg:max-w-none lg:grid-cols-2 lg:gap-y-16">
            <div className="relative pl-16">
              <dt className="text-base font-semibold leading-7 text-gray-900">
                <div className="absolute left-0 top-0 flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600">
                  <Wallet className="h-6 w-6 text-white" aria-hidden="true" />
                </div>
                Harga Mahasiswa
              </dt>
              <dd className="mt-2 text-base leading-7 text-gray-600">
                Jasa dengan harga yang sangat bersahabat (budget friendly), cocok untuk UMKM, startup, dan kebutuhan personal.
              </dd>
            </div>
            <div className="relative pl-16">
              <dt className="text-base font-semibold leading-7 text-gray-900">
                <div className="absolute left-0 top-0 flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600">
                  <Heart className="h-6 w-6 text-white" aria-hidden="true" />
                </div>
                Bantu Pendidikan
              </dt>
              <dd className="mt-2 text-base leading-7 text-gray-600">
                Setiap pekerjaan yang Anda berikan membantu mahasiswa membayar uang kuliah dan menambah uang saku mereka.
              </dd>
            </div>
            <div className="relative pl-16">
              <dt className="text-base font-semibold leading-7 text-gray-900">
                <div className="absolute left-0 top-0 flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600">
                  <Zap className="h-6 w-6 text-white" aria-hidden="true" />
                </div>
                Semangat Muda
              </dt>
              <dd className="mt-2 text-base leading-7 text-gray-600">
                Dapatkan ide-ide segar, kreatif, dan up-to-date dari mahasiswa yang melek teknologi dan tren terkini.
              </dd>
            </div>
            <div className="relative pl-16">
              <dt className="text-base font-semibold leading-7 text-gray-900">
                <div className="absolute left-0 top-0 flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600">
                  <Shield className="h-6 w-6 text-white" aria-hidden="true" />
                </div>
                Komunikasi Langsung
              </dt>
              <dd className="mt-2 text-base leading-7 text-gray-600">
                Hubungi mahasiswa langsung via WhatsApp. Diskusikan detail pekerjaan, negosiasi harga, dan sepakati sendiri dengan transparan.
              </dd>
            </div>
          </dl>
        </div>

        {/* New Section: Anything Goes with Marquee */}
        <div className="mt-20 rounded-3xl bg-gradient-to-r from-indigo-50 to-blue-50 p-8 sm:p-12 border border-indigo-100 text-center relative overflow-hidden">
          {/* Decorative Elements */}
          <div className="absolute top-0 right-0 -mr-8 -mt-8 w-32 h-32 bg-yellow-200 rounded-full blur-2xl opacity-40"></div>
          <div className="absolute bottom-0 left-0 -ml-8 -mb-8 w-32 h-32 bg-purple-200 rounded-full blur-2xl opacity-40"></div>

          <div className="relative z-10 mx-auto max-w-4xl">
            <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-white shadow-md mb-6 text-yellow-500">
              <Lightbulb size={28} />
            </div>
            <h3 className="text-2xl sm:text-3xl font-bold text-gray-900 mb-4">
              Punya Kebutuhan Unik? Tawarkan Saja!
            </h3>
            <p className="text-lg text-gray-600 leading-relaxed mb-8 max-w-2xl mx-auto">
              Jangan ragu memposting pekerjaan apapun di TalentaHub. Selama pekerjaannya <strong>legal, etis, dan layak</strong> dikerjakan mahasiswa, coba saja tawarkan! Mahasiswa kami serba bisa.
            </p>

            {/* Marquee Animation Container */}
            <div className="relative w-full overflow-hidden [mask-image:linear-gradient(to_right,transparent,white_10%,white_90%,transparent)]">
              {/* Added 'will-change-transform' and 'transform-gpu' for performance best practices */}
              <div className="flex animate-scroll whitespace-nowrap py-2 hover:[animation-play-state:paused] will-change-transform transform-gpu">
                {/* Duplicate tags to create infinite loop effect */}
                {[...FEATURE_TAGS, ...FEATURE_TAGS, ...FEATURE_TAGS].map((tag, i) => (
                  <span key={`${i}-${tag}`} className="mx-2 flex items-center gap-2 bg-white px-5 py-2.5 rounded-full shadow-sm border border-gray-100 text-sm font-medium text-gray-600 hover:scale-105 transition-transform cursor-default">
                    <Check className="text-green-500" size={16} /> {tag}
                  </span>
                ))}
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
};