import React, { useState } from 'react';
import { useDocumentTitle } from '../hooks/useDocumentTitle';
import {
    CheckCircle, ShieldCheck, MessageCircle, Wallet, AlertTriangle, Download
} from 'lucide-react';
import { Button } from '../components/ui/Button';

const HowItWorks: React.FC = () => {
    useDocumentTitle('Cara Kerja & Aturan Main');
    const [activeTab, setActiveTab] = useState<'client' | 'talent'>('client');

    return (
        <div className="bg-white animate-fade-in">
            {/* Hero Section */}
            <div className="relative isolate overflow-hidden bg-gray-900 py-24 sm:py-32">
                <div className="mx-auto max-w-7xl px-6 lg:px-8 text-center">
                    <h1 className="text-4xl font-bold tracking-tight text-white sm:text-6xl">
                        Cara Kerja TalentaHub
                    </h1>
                    <p className="mt-6 text-lg leading-8 text-gray-300 max-w-2xl mx-auto">
                        Platform konektor langsung antara Klien dan Mahasiswa.
                        Tanpa perantara pembayaran, tanpa potongan biaya. Cepat dan transparan.
                    </p>
                </div>
            </div>

            {/* Steps Section */}
            <div className="py-16 sm:py-24 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-center mb-12">
                    <div className="bg-gray-100 p-1 rounded-xl inline-flex">
                        <button
                            onClick={() => setActiveTab('client')}
                            className={`px-6 py-2.5 rounded-lg text-sm font-medium transition-all ${activeTab === 'client' ? 'bg-white text-indigo-600 shadow-sm' : 'text-gray-500 hover:text-gray-900'}`}
                        >
                            Untuk Klien (Pemberi Kerja)
                        </button>
                        <button
                            onClick={() => setActiveTab('talent')}
                            className={`px-6 py-2.5 rounded-lg text-sm font-medium transition-all ${activeTab === 'talent' ? 'bg-white text-indigo-600 shadow-sm' : 'text-gray-500 hover:text-gray-900'}`}
                        >
                            Untuk Mahasiswa (Talent)
                        </button>
                    </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-4 gap-8 relative">
                    {/* Connector Line (Desktop) */}
                    <div className="hidden md:block absolute top-12 left-0 w-full h-0.5 bg-gray-200 z-0"></div>

                    {activeTab === 'client' ? (
                        <>
                            <StepCard
                                number={1}
                                title="Buat Lowongan"
                                desc="Posting detail pekerjaan, budget, dan tenggat waktu secara gratis."
                            />
                            <StepCard
                                number={2}
                                title="Pilih Mahasiswa"
                                desc="Review lamaran yang masuk atau tawarkan job langsung ke mahasiswa potensial."
                            />
                            <StepCard
                                number={3}
                                title="Diskusi via WA"
                                desc="TalentaHub menghubungkan Anda ke WhatsApp mahasiswa. Diskusikan detail kerja di sana."
                            />
                            <StepCard
                                number={4}
                                title="Bayar Langsung"
                                desc="Transfer pembayaran langsung ke rekening/E-Wallet pribadi mahasiswa. Tanpa perantara TalentaHub."
                            />
                        </>
                    ) : (
                        <>
                            <StepCard
                                number={1}
                                title="Cari & Lamar Job"
                                desc="Pilih job yang sesuai skill. Baca deskripsi dengan teliti sebelum ambil."
                            />
                            <StepCard
                                number={2}
                                title="Kerjakan & Komunikasi"
                                desc="Hubungi Klien via WA. Kerjakan tugas dan kirimkan hasil sesuai deadline."
                            />
                            <StepCard
                                number={3}
                                title="Terima Pembayaran"
                                desc="Klien akan mentransfer honor langsung ke rekeningmu. Utuh tanpa potongan."
                            />
                            <StepCard
                                number={4}
                                title="Selesai"
                                desc="Minta klien untuk menandai job sebagai 'Selesai' di TalentaHub agar ratingmu naik."
                            />
                        </>
                    )}
                </div>
            </div>

            {/* SAFETY ADVICE SECTION */}
            <div className="bg-blue-50 py-16 sm:py-24 border-y border-blue-100">
                <div className="max-w-4xl mx-auto px-6 lg:px-8 text-center">
                    <div className="inline-flex items-center justify-center w-16 h-16 bg-blue-100 text-blue-600 rounded-full mb-6">
                        <ShieldCheck size={32} />
                    </div>
                    <h2 className="text-3xl font-bold text-gray-900 mb-6">Tips Transaksi Aman</h2>
                    <p className="text-lg text-gray-600 mb-10">
                        Karena pembayaran dilakukan secara langsung (Direct Transfer), harap perhatikan hal berikut demi keamanan Anda.
                    </p>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-left">
                        <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-200">
                            <h3 className="font-bold text-gray-900 flex items-center gap-2 mb-3">
                                <Wallet className="text-blue-500" /> Sistem DP (Uang Muka)
                            </h3>
                            <p className="text-sm text-gray-600">
                                Untuk Mahasiswa, mintalah DP (Down Payment) sebelum mulai bekerja, terutama untuk proyek besar, untuk menghindari klien yang lari (hit & run).
                            </p>
                        </div>

                        <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-200">
                            <h3 className="font-bold text-gray-900 flex items-center gap-2 mb-3">
                                <MessageCircle className="text-green-500" /> Bukti Percakapan
                            </h3>
                            <p className="text-sm text-gray-600">
                                Simpan bukti chat dan kesepakatan kerja di WhatsApp. Ini berguna jika terjadi sengketa, meski TalentaHub tidak memiliki wewenang hukum atas transaksi Anda.
                            </p>
                        </div>

                        <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-200">
                            <h3 className="font-bold text-gray-900 flex items-center gap-2 mb-3">
                                <CheckCircle className="text-indigo-500" /> Verifikasi Identitas
                            </h3>
                            <p className="text-sm text-gray-600">
                                Pastikan profil pengguna terlihat meyakinkan. Klien bisa meminta foto KTM mahasiswa jika diperlukan untuk memastikan status mereka.
                            </p>
                        </div>

                        <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-200">
                            <h3 className="font-bold text-gray-900 flex items-center gap-2 mb-3">
                                <AlertTriangle className="text-amber-500" /> Waspada Penipuan
                            </h3>
                            <p className="text-sm text-gray-600">
                                Jangan pernah memberikan OTP, Password, atau data perbankan rahasia (PIN/CVV) kepada siapapun.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div className="mx-auto max-w-7xl px-6 lg:px-8 py-16 text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-6">Siap Bergabung?</h2>
                <p className="text-gray-600 mb-8 max-w-lg mx-auto">
                    Download aplikasi TalentaHub untuk mulai mencari job atau merekrut mahasiswa.
                </p>
                <a
                    href="https://github.com/Unikgati/talentahub-v.1.0.0/releases/download/TalentHub_Android_Release/TalentaHub_Android_v1.0.0_release.apk"
                    target="_blank"
                    rel="noopener noreferrer"
                >
                    <Button size="lg" icon={<Download size={18} />}>
                        Download App Sekarang
                    </Button>
                </a>
            </div>
        </div>
    );
};

const StepCard = ({ number, title, desc }: { number: number, title: string, desc: string }) => (
    <div className="bg-white relative z-10 flex flex-col items-center text-center p-6 rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow h-full">
        <div className="w-12 h-12 bg-indigo-600 text-white rounded-full flex items-center justify-center font-bold text-xl mb-6 shadow-lg shadow-indigo-200 flex-shrink-0">
            {number}
        </div>
        <h3 className="font-bold text-gray-900 mb-3 text-lg">{title}</h3>
        <p className="text-sm text-gray-500 leading-relaxed">{desc}</p>
    </div>
);

export default HowItWorks;