import React from 'react';
import { Heart, Coffee } from 'lucide-react';

export const SupportSection: React.FC = () => {
    return (
        <section className="py-12 sm:py-16 bg-gradient-to-br from-pink-50 to-orange-50">
            <div className="mx-auto max-w-4xl px-6 lg:px-8 text-center">
                {/* Icon */}
                <div className="inline-flex items-center justify-center w-16 h-16 bg-white rounded-full shadow-md mb-6">
                    <Coffee className="w-8 h-8 text-orange-500" />
                </div>

                {/* Heading */}
                <h2 className="text-2xl sm:text-3xl font-bold text-gray-900 mb-4">
                    Dukung TalentaHub Tetap Gratis
                </h2>

                {/* Description */}
                <p className="text-gray-600 text-lg max-w-2xl mx-auto mb-8">
                    TalentaHub adalah platform gratis tanpa biaya administrasi.
                    Bantu kami tetap eksis dan terus memberikan manfaat untuk mahasiswa Indonesia.
                </p>

                {/* Saweria Button */}
                <a
                    href="https://saweria.co/talentahub"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-3 px-8 py-4 bg-gradient-to-r from-orange-500 to-pink-500 text-white font-semibold rounded-full shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105"
                >
                    <Heart className="w-5 h-5" />
                    Traktir Kopi via Saweria
                </a>

                {/* Small text */}
                <p className="mt-6 text-sm text-gray-500">
                    Setiap dukungan sangat berarti bagi keberlanjutan platform ini ❤️
                </p>
            </div>
        </section>
    );
};
