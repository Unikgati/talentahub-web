import React, { useState, useEffect } from 'react';
import { Download, ArrowRight } from 'lucide-react';
import { Link } from 'react-router-dom';

const typingTexts = [
  'Mahasiswa Siap Membantu',
  'Solusi Cepat & Terjangkau',
  'Dari Kampus untuk Anda',
];

export const Hero: React.FC = () => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [displayText, setDisplayText] = useState('');
  const [isDeleting, setIsDeleting] = useState(false);

  useEffect(() => {
    const currentText = typingTexts[currentIndex];
    const typingSpeed = isDeleting ? 30 : 80;

    if (!isDeleting && displayText === currentText) {
      // Pause at full text
      const pauseTimeout = setTimeout(() => setIsDeleting(true), 2000);
      return () => clearTimeout(pauseTimeout);
    }

    if (isDeleting && displayText === '') {
      // Move to next text
      setIsDeleting(false);
      setCurrentIndex((prev) => (prev + 1) % typingTexts.length);
      return;
    }

    const timeout = setTimeout(() => {
      setDisplayText((prev) =>
        isDeleting
          ? prev.slice(0, -1)
          : currentText.slice(0, prev.length + 1)
      );
    }, typingSpeed);

    return () => clearTimeout(timeout);
  }, [displayText, isDeleting, currentIndex]);

  return (
    <div className="relative isolate pt-14">
      {/* Background Gradient Blob Top */}
      <div
        className="absolute inset-x-0 -top-40 -z-10 transform-gpu overflow-hidden blur-3xl sm:-top-80"
        aria-hidden="true"
      >
        <div
          className="relative left-[calc(50%-11rem)] aspect-[1155/678] w-[36.125rem] -translate-x-1/2 rotate-[30deg] bg-gradient-to-tr from-[#ff80b5] to-[#9089fc] opacity-20 sm:left-[calc(50%-30rem)] sm:w-[72.1875rem]"
          style={{
            clipPath:
              'polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)',
          }}
        />
      </div>

      <div className="mx-auto max-w-5xl px-6 py-16 lg:px-8 lg:py-24 text-center">
        {/* Badge */}
        <div className="mb-8 inline-flex items-center rounded-full px-4 py-1.5 text-sm font-medium text-indigo-600 ring-1 ring-inset ring-indigo-200 bg-indigo-50">
          <span className="flex h-2 w-2 rounded-full bg-indigo-600 mr-2 animate-pulse"></span>
          Platform Freelance Khusus Mahasiswa #1
        </div>

        {/* Main Heading with Typing Effect */}
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl lg:text-7xl leading-tight relative">
          Butuh Bantuan?{' '}
          <span className="block relative">
            {/* Invisible placeholder to reserve height */}
            <span className="invisible" aria-hidden="true">Solusi Cepat & Terjangkau</span>

            {/* Typing text absolutely positioned */}
            <span className="text-indigo-600 absolute top-0 left-0 w-full">
              {displayText}
              <span className="animate-pulse">|</span>
            </span>
          </span>
        </h1>

        {/* Subheading */}
        <p className="mt-6 text-lg sm:text-xl leading-8 text-gray-600 max-w-2xl mx-auto">
          Apapun kebutuhannya, mahasiswa siap membantu dengan harga bersahabat.
          Bantu mereka mandiri secara finansial.
        </p>

        {/* CTA Buttons */}
        <div className="mt-10 flex flex-col sm:flex-row items-center justify-center gap-4">
          <a
            href="https://github.com/Unikgati/talentahub-v.1.0.0/releases/download/TalentHub_Android_Release/TalentaHub_Android_v1.0.0_release.apk"
            target="_blank"
            rel="noopener noreferrer"
            className="rounded-full bg-indigo-600 px-8 py-4 text-base font-semibold text-white shadow-lg hover:bg-indigo-500 transition-all transform hover:-translate-y-1 hover:shadow-xl flex items-center gap-2"
          >
            <Download size={20} />
            Download App Gratis
          </a>

          <Link
            to="/how-it-works"
            className="text-base font-semibold leading-6 text-gray-900 flex items-center gap-2 group px-6 py-4 rounded-full hover:bg-gray-100 transition-colors"
          >
            Pelajari Cara Kerja
            <ArrowRight size={18} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </div>
      </div>

      {/* Background Gradient Blob Bottom */}
      <div
        className="absolute inset-x-0 top-[calc(100%-13rem)] -z-10 transform-gpu overflow-hidden blur-3xl sm:top-[calc(100%-30rem)]"
        aria-hidden="true"
      >
        <div
          className="relative left-[calc(50%+3rem)] aspect-[1155/678] w-[36.125rem] -translate-x-1/2 bg-gradient-to-tr from-[#ff80b5] to-[#9089fc] opacity-20 sm:left-[calc(50%+36rem)] sm:w-[72.1875rem]"
          style={{
            clipPath:
              'polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)',
          }}
        />
      </div>
    </div>
  );
};