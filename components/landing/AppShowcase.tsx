import React from 'react';
import { Briefcase, Search, CheckCircle, Shield } from 'lucide-react';

export default function AppShowcase() {
    return (
        <section className="py-12 sm:py-16 lg:py-20 bg-white">
            <div className="mx-auto max-w-7xl px-6 lg:px-8">
                {/* Section Header */}
                <div className="text-center mb-10 sm:mb-16">
                    <h2 className="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
                        Satu Aplikasi, Dua Sisi
                    </h2>
                    <p className="mt-4 text-lg text-gray-600">
                        Didesain untuk memudahkan mahasiswa dan pemberi kerja
                    </p>
                </div>

                {/* Talent Section */}
                <div className="grid lg:grid-cols-2 gap-16 items-center mb-24">
                    {/* Phone Mockup */}
                    <div className="flex justify-center lg:order-1">
                        <div className="relative">
                            <img
                                src="/images/talent-dashboard.png"
                                alt="Talent Dashboard"
                                className="w-[280px]"
                            />
                            {/* Decorative gradient blob */}
                            <div className="absolute -z-10 -top-10 -left-10 w-72 h-72 bg-indigo-200 rounded-full blur-3xl opacity-50"></div>
                        </div>
                    </div>

                    {/* Content */}
                    <div className="lg:order-2">
                        <div className="inline-flex items-center px-4 py-2 rounded-full bg-indigo-100 text-indigo-700 font-medium text-sm mb-6">
                            <Search size={16} className="mr-2" />
                            Untuk Mahasiswa
                        </div>
                        <h3 className="text-2xl sm:text-3xl font-bold text-gray-900 mb-6">
                            Cari & Lamar Pekerjaan dengan Mudah
                        </h3>
                        <p className="text-gray-600 text-lg mb-8">
                            Temukan berbagai pekerjaan yang sesuai dengan keahlian dan jadwal kuliah Anda.
                            Dari tugas digital hingga pekerjaan fisik, semua ada di sini.
                        </p>
                        <ul className="space-y-4">
                            <li className="flex items-start">
                                <CheckCircle className="text-green-500 mt-1 mr-3 flex-shrink-0" size={20} />
                                <span className="text-gray-700">Jelajahi lowongan dari berbagai kategori</span>
                            </li>
                            <li className="flex items-start">
                                <CheckCircle className="text-green-500 mt-1 mr-3 flex-shrink-0" size={20} />
                                <span className="text-gray-700">Lamar langsung dengan satu klik</span>
                            </li>
                            <li className="flex items-start">
                                <CheckCircle className="text-green-500 mt-1 mr-3 flex-shrink-0" size={20} />
                                <span className="text-gray-700">Bangun portofolio dan dapatkan review</span>
                            </li>
                        </ul>
                    </div>
                </div>

                {/* Client Section */}
                <div className="grid lg:grid-cols-2 gap-16 items-center">
                    {/* Content */}
                    <div className="lg:order-1">
                        <div className="inline-flex items-center px-4 py-2 rounded-full bg-teal-100 text-teal-700 font-medium text-sm mb-6">
                            <Briefcase size={16} className="mr-2" />
                            Untuk Pemberi Kerja
                        </div>
                        <h3 className="text-2xl sm:text-3xl font-bold text-gray-900 mb-6">
                            Tawarkan Pekerjaan Apapun
                        </h3>
                        <p className="text-gray-600 text-lg mb-8">
                            Butuh bantuan untuk tugas-tugas kecil maupun besar? Posting lowongan
                            dan temukan mahasiswa yang siap membantu dengan harga terjangkau.
                        </p>
                        <ul className="space-y-4">
                            <li className="flex items-start">
                                <CheckCircle className="text-green-500 mt-1 mr-3 flex-shrink-0" size={20} />
                                <span className="text-gray-700">Pekerjaan halal, legal, dan etis</span>
                            </li>
                            <li className="flex items-start">
                                <CheckCircle className="text-green-500 mt-1 mr-3 flex-shrink-0" size={20} />
                                <span className="text-gray-700">Pilih kandidat terbaik dari pelamar</span>
                            </li>
                            <li className="flex items-start">
                                <CheckCircle className="text-green-500 mt-1 mr-3 flex-shrink-0" size={20} />
                                <span className="text-gray-700">Hubungi langsung via WhatsApp</span>
                            </li>
                        </ul>
                    </div>

                    {/* Phone Mockup */}
                    <div className="flex justify-center lg:order-2">
                        <div className="relative">
                            <img
                                src="/images/client-dashboard.png"
                                alt="Client Dashboard"
                                className="w-[280px]"
                            />
                            {/* Decorative gradient blob */}
                            <div className="absolute -z-10 -top-10 -right-10 w-72 h-72 bg-teal-200 rounded-full blur-3xl opacity-50"></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    );
}
