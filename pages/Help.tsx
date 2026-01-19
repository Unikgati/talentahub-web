
import React from 'react';
import { useDocumentTitle } from '../hooks/useDocumentTitle';
import { HelpCircle, ChevronDown } from 'lucide-react';
import { Button } from '../components/ui/Button';
import { WhatsAppIcon } from '../components/ui/WhatsappIcon';

const Help: React.FC = () => {
  useDocumentTitle('Pusat Bantuan');

  const faqs = [
    {
      category: "Umum",
      items: [
        { q: "Apa itu TalentaHub Marketplace?", a: "TalentaHub adalah platform konektor yang menghubungkan Klien dengan Mahasiswa berbakat untuk menyelesaikan berbagai tugas freelance." },
        { q: "Apakah aplikasi ini berbayar?", a: "Tidak. TalentaHub 100% Gratis. Tidak ada biaya pendaftaran, tidak ada biaya posting job, dan tidak ada potongan fee dari hasil kerja mahasiswa." },
      ]
    },
    {
      category: "Untuk Klien (Pemberi Kerja)",
      items: [
        { q: "Bagaimana cara membayar mahasiswa?", a: "Pembayaran dilakukan secara langsung (Direct Transfer) ke rekening atau e-wallet mahasiswa yang bersangkutan. TalentaHub tidak menampung dana Anda." },
        { q: "Apakah aman bertransaksi langsung?", a: "Kami menyarankan Anda untuk meminta bukti identitas jika ragu, dan lakukan pembayaran bertahap (DP) untuk proyek besar." },
      ]
    },
    {
      category: "Untuk Mahasiswa (Talent)",
      items: [
        { q: "Bagaimana saya menerima pembayaran?", a: "Pembayaran dilakukan secara langsung antara Anda dan Klien. Silakan diskusikan metode pembayaran (Transfer Bank/E-Wallet) yang disepakati melalui WhatsApp. TalentaHub tidak menyimpan data rekening Anda." },
        { q: "Apakah ada potongan biaya admin?", a: "Tidak ada. Anda menerima 100% dari honor yang disepakati dengan Klien." },
      ]
    }
  ];

  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12 animate-fade-in">
      <div className="text-center mb-12">
        <div className="inline-flex items-center justify-center w-16 h-16 bg-indigo-100 text-indigo-600 rounded-full mb-4">
          <HelpCircle size={32} />
        </div>
        <h1 className="text-3xl font-bold text-gray-900">Pusat Bantuan</h1>
        <p className="mt-4 text-gray-500">Temukan jawaban atas pertanyaan yang sering diajukan.</p>
      </div>

      <div className="space-y-8">
        {faqs.map((section, idx) => (
          <div key={idx} className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="bg-gray-50 px-6 py-4 border-b border-gray-200">
              <h2 className="font-bold text-gray-900">{section.category}</h2>
            </div>
            <div className="divide-y divide-gray-100">
              {section.items.map((item, i) => (
                <details key={i} className="group p-6 cursor-pointer">
                  <summary className="flex justify-between items-center font-medium text-gray-900 list-none focus:outline-none">
                    <span>{item.q}</span>
                    <span className="transition group-open:rotate-180">
                      <ChevronDown size={20} className="text-gray-400" />
                    </span>
                  </summary>
                  <p className="text-gray-600 mt-3 leading-relaxed animate-fade-in">
                    {item.a}
                  </p>
                </details>
              ))}
            </div>
          </div>
        ))}
      </div>

      <div className="mt-12 bg-indigo-600 rounded-xl p-8 text-center text-white">
        <h3 className="text-xl font-bold mb-2">Masih butuh bantuan?</h3>
        <p className="text-indigo-100 mb-6">Tim support kami siap membantu Anda 24/7 melalui WhatsApp.</p>
        <Button variant="secondary" icon={<WhatsAppIcon size={18} />} onClick={() => window.open('https://wa.me/6285961462361?text=Halo%20Admin%20TalentaHub,%20saya%20butuh%20bantuan%20terkait...', '_blank')}>
          Chat Admin Support
        </Button>
      </div>
    </div>
  );
};

export default Help;
