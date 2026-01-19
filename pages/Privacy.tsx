import React from 'react';
import { Shield, Lock, Eye, AlertTriangle, FileText, Scale, Ban, UserX, RefreshCw } from 'lucide-react';
import { useDocumentTitle } from '../hooks/useDocumentTitle';

const Privacy: React.FC = () => {
  useDocumentTitle('Kebijakan Privasi & Syarat Ketentuan');

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12 animate-fade-in">
      <div className="text-center mb-12">
        <h1 className="text-3xl font-bold text-gray-900">Kebijakan Privasi & Syarat Ketentuan</h1>
        <p className="mt-4 text-gray-500">Terakhir diperbarui: 16 Januari 2026</p>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-8 space-y-10">

        {/* Section 1: Komitmen */}
        <section>
          <div className="flex items-center gap-3 mb-4">
            <div className="bg-indigo-100 p-2 rounded-lg text-indigo-600">
              <Shield size={24} />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Komitmen Kami</h2>
          </div>
          <p className="text-gray-600 leading-relaxed">
            Di TalentaHub Marketplace, privasi dan keamanan Anda adalah prioritas utama. Dokumen ini menjelaskan bagaimana data Anda dikelola serta batasan tanggung jawab platform dalam memfasilitasi interaksi antara Mahasiswa (Talent) dan Pemberi Kerja (Klien).
          </p>
        </section>

        {/* Section 2: Terms of Service */}
        <section className="bg-indigo-50 rounded-xl p-6 border border-indigo-200">
          <div className="flex items-center gap-3 mb-4">
            <div className="bg-indigo-100 p-2 rounded-lg text-indigo-600">
              <Scale size={24} />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Syarat Penggunaan Platform</h2>
          </div>
          <div className="space-y-4 text-gray-700">
            <p>Dengan menggunakan aplikasi TalentaHub, Anda menyetujui ketentuan berikut:</p>
            <ul className="space-y-3">
              <li className="flex gap-3 items-start">
                <span className="font-bold text-indigo-600 mt-1">1.</span>
                <span>
                  <strong>Kelayakan:</strong> Anda berusia minimal 17 tahun atau memiliki izin dari orang tua/wali. Untuk mendaftar sebagai Talent, Anda harus berstatus mahasiswa aktif di perguruan tinggi Indonesia.
                </span>
              </li>
              <li className="flex gap-3 items-start">
                <span className="font-bold text-indigo-600 mt-1">2.</span>
                <span>
                  <strong>Akun:</strong> Satu pengguna hanya boleh memiliki satu akun. Anda bertanggung jawab menjaga kerahasiaan kredensial login Anda.
                </span>
              </li>
              <li className="flex gap-3 items-start">
                <span className="font-bold text-indigo-600 mt-1">3.</span>
                <span>
                  <strong>Informasi Akurat:</strong> Semua informasi yang Anda masukkan harus benar dan terkini. Profil palsu dapat mengakibatkan pemblokiran akun.
                </span>
              </li>
              <li className="flex gap-3 items-start">
                <span className="font-bold text-indigo-600 mt-1">4.</span>
                <span>
                  <strong>Penggunaan yang Sah:</strong> Platform hanya boleh digunakan untuk mencari atau menawarkan pekerjaan freelance yang legal dan etis.
                </span>
              </li>
            </ul>
          </div>
        </section>

        {/* Section 3: Disclaimer (CRITICAL) */}
        <section className="bg-amber-50 rounded-xl p-6 border border-amber-200">
          <div className="flex items-center gap-3 mb-4">
            <div className="bg-amber-100 p-2 rounded-lg text-amber-600">
              <AlertTriangle size={24} />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Batasan Tanggung Jawab (Disclaimer)</h2>
          </div>
          <div className="space-y-4 text-gray-700">
            <p className="font-medium">Harap perhatikan hal-hal berikut sebelum bertransaksi:</p>
            <ul className="space-y-3">
              <li className="flex gap-3 items-start">
                <span className="font-bold text-amber-600 mt-1">•</span>
                <span>
                  <strong>Peran Platform:</strong> TalentaHub hanya bertindak sebagai konektor (penghubung) antara pengguna. TalentaHub <strong>TIDAK</strong> menjadi perantara pembayaran (Escrow) dan tidak memotong biaya apapun.
                </span>
              </li>
              <li className="flex gap-3 items-start">
                <span className="font-bold text-red-600 mt-1">•</span>
                <span>
                  <strong>Transaksi Langsung:</strong> Segala bentuk transaksi keuangan dilakukan langsung antara Klien dan Mahasiswa (Direct Transfer).
                  <br /><span className="text-sm text-red-600 italic mt-1 block">Kami TIDAK bertanggung jawab atas perselisihan pembayaran, penipuan, atau kegagalan kerja yang terjadi akibat transaksi antar pengguna.</span>
                </span>
              </li>
              <li className="flex gap-3 items-start">
                <span className="font-bold text-amber-600 mt-1">•</span>
                <span>
                  <strong>Verifikasi Pengguna:</strong> Meskipun kami berusaha memverifikasi pengguna, kami tidak menjamin kebenaran mutlak dari identitas atau klaim yang dibuat pengguna di profil mereka. Harap selalu waspada.
                </span>
              </li>
            </ul>
          </div>
        </section>

        {/* Section 4: Prohibited Activities */}
        <section className="bg-red-50 rounded-xl p-6 border border-red-200">
          <div className="flex items-center gap-3 mb-4">
            <div className="bg-red-100 p-2 rounded-lg text-red-600">
              <Ban size={24} />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Aktivitas yang Dilarang</h2>
          </div>
          <div className="space-y-3 text-gray-700">
            <p>Pengguna dilarang keras melakukan:</p>
            <ul className="grid grid-cols-1 md:grid-cols-2 gap-2">
              <li className="flex items-center gap-2 text-sm">
                <span className="text-red-500">✕</span> Penipuan dalam bentuk apapun
              </li>
              <li className="flex items-center gap-2 text-sm">
                <span className="text-red-500">✕</span> Spam atau promosi berlebihan
              </li>
              <li className="flex items-center gap-2 text-sm">
                <span className="text-red-500">✕</span> Konten SARA, pornografi, atau kekerasan
              </li>
              <li className="flex items-center gap-2 text-sm">
                <span className="text-red-500">✕</span> Pekerjaan ilegal (narkoba, judi, dll)
              </li>
              <li className="flex items-center gap-2 text-sm">
                <span className="text-red-500">✕</span> Meminta data sensitif (PIN, OTP, password)
              </li>
              <li className="flex items-center gap-2 text-sm">
                <span className="text-red-500">✕</span> Plagiarisme atau pelanggaran hak cipta
              </li>
              <li className="flex items-center gap-2 text-sm">
                <span className="text-red-500">✕</span> Pelecehan atau intimidasi pengguna lain
              </li>
              <li className="flex items-center gap-2 text-sm">
                <span className="text-red-500">✕</span> Membuat akun palsu atau ganda
              </li>
            </ul>
          </div>
        </section>

        {/* Section 5: Account Termination */}
        <section>
          <div className="flex items-center gap-3 mb-4">
            <div className="bg-gray-100 p-2 rounded-lg text-gray-600">
              <UserX size={24} />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Penghentian Akun</h2>
          </div>
          <div className="text-gray-600 space-y-2">
            <p>TalentaHub berhak menonaktifkan atau menghapus akun Anda tanpa pemberitahuan jika:</p>
            <ul className="list-disc pl-5 space-y-1">
              <li>Terbukti melanggar Syarat Ketentuan ini</li>
              <li>Menerima laporan valid dari pengguna lain</li>
              <li>Terindikasi melakukan aktivitas mencurigakan atau penipuan</li>
              <li>Tidak aktif lebih dari 12 bulan</li>
            </ul>
          </div>
        </section>

        {/* Section 6: Data Collection */}
        <section>
          <div className="flex items-center gap-3 mb-4">
            <div className="bg-blue-100 p-2 rounded-lg text-blue-600">
              <FileText size={24} />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Pengumpulan & Penggunaan Data</h2>
          </div>
          <div className="space-y-4">
            <div>
              <h3 className="font-bold text-gray-900 mb-2">1. Data yang Kami Kumpulkan</h3>
              <ul className="list-disc pl-5 space-y-1 text-gray-600">
                <li><strong>Informasi Akun:</strong> Nama, email, nomor WhatsApp, dan peran (role).</li>
                <li><strong>Profil Profesional:</strong> Keahlian (skills), lokasi, biografi, dan portofolio.</li>
                <li><strong>Data Aktivitas:</strong> Riwayat job, lamaran, dan ulasan.</li>
              </ul>
            </div>
            <div>
              <h3 className="font-bold text-gray-900 mb-2">2. Penggunaan Data</h3>
              <p className="text-gray-600">Kami menggunakan data Anda untuk menghubungkan Klien dengan Mahasiswa, memfasilitasi komunikasi, dan meningkatkan kualitas layanan platform.</p>
            </div>
          </div>
        </section>

        {/* Section 7: Contact Transparency */}
        <section>
          <div className="flex items-center gap-3 mb-4">
            <div className="bg-indigo-100 p-2 rounded-lg text-indigo-600">
              <Eye size={24} />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Transparansi Kontak Publik</h2>
          </div>
          <p className="text-gray-600 leading-relaxed">
            Karena fitur utama TalentaHub adalah kecepatan komunikasi, dengan mendaftar, Anda menyetujui bahwa <strong>nomor WhatsApp Anda dapat dilihat</strong> oleh pengguna terdaftar lain (Klien/Talent) untuk keperluan penawaran kerja.
          </p>
        </section>

        {/* Section 8: Security */}
        <section>
          <div className="flex items-center gap-3 mb-4">
            <div className="bg-green-100 p-2 rounded-lg text-green-600">
              <Lock size={24} />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Keamanan Data</h2>
          </div>
          <p className="text-gray-600 leading-relaxed">
            Kami tidak pernah menjual data pribadi Anda kepada pihak ketiga untuk tujuan pemasaran (spam). Kami menggunakan protokol keamanan standar industri untuk melindungi database kami.
          </p>
        </section>

        {/* Section 9: Changes */}
        <section>
          <div className="flex items-center gap-3 mb-4">
            <div className="bg-purple-100 p-2 rounded-lg text-purple-600">
              <RefreshCw size={24} />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Perubahan Ketentuan</h2>
          </div>
          <p className="text-gray-600 leading-relaxed">
            TalentaHub berhak mengubah Syarat & Ketentuan ini sewaktu-waktu. Perubahan signifikan akan diumumkan melalui notifikasi dalam aplikasi. Dengan terus menggunakan layanan setelah perubahan, Anda dianggap menyetujui ketentuan baru.
          </p>
        </section>

        {/* Contact */}
        <div className="bg-gray-50 rounded-xl p-6 text-center border border-gray-200">
          <p className="text-gray-600 mb-2">Pertanyaan tentang kebijakan ini?</p>
          <a
            href="https://wa.me/6285961462361?text=Halo%20Admin%20TalentaHub,%20saya%20butuh%20bantuan%20terkait..."
            target="_blank"
            rel="noopener noreferrer"
            className="text-indigo-600 font-medium hover:text-indigo-800"
          >
            Hubungi Tim Support →
          </a>
        </div>

      </div>
    </div>
  );
};

export default Privacy;
