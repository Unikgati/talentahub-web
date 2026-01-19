import React from 'react';
import { Link } from 'react-router-dom';
import { Download } from 'lucide-react';

export const Footer: React.FC = () => {
  return (
    <footer className="bg-white border-t border-gray-200 mt-auto">
      <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div className="col-span-1 md:col-span-2">
            <div className="mb-4">
              <span className="font-bold text-lg text-gray-900">TalentaHub</span>
            </div>
            <p className="text-gray-500 text-sm max-w-xs leading-relaxed mb-4">
              Platform kebanggaan mahasiswa Indonesia. Berdayakan mahasiswa dengan memberi mereka peluang kerja nyata dengan harga yang bersahabat.
            </p>
            <a
              href="https://github.com/Unikgati/talentahub-v.1.0.0/releases/download/TalentHub_Android_Release/TalentaHub_Android_v1.0.0_release.apk"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2 px-4 py-2 bg-gray-900 text-white text-sm font-medium rounded-lg hover:bg-gray-800 transition-colors"
            >
              <Download size={16} /> Download App
            </a>
          </div>
          <div>
            <h3 className="text-sm font-semibold text-gray-900 tracking-wider uppercase mb-4">Platform</h3>
            <ul className="space-y-3">
              <li><Link to="/how-it-works" className="text-gray-500 hover:text-indigo-600 text-sm">Cara Kerja</Link></li>
              <li><Link to="/help" className="text-gray-500 hover:text-indigo-600 text-sm">Pusat Bantuan</Link></li>
            </ul>
          </div>
          <div>
            <h3 className="text-sm font-semibold text-gray-900 tracking-wider uppercase mb-4">Legal</h3>
            <ul className="space-y-3">
              <li><Link to="/privacy" className="text-gray-500 hover:text-indigo-600 text-sm">Kebijakan & Syarat</Link></li>
            </ul>
          </div>
        </div>
        <div className="mt-8 border-t border-gray-200 pt-8">
          <p className="text-gray-400 text-sm text-center">&copy; {new Date().getFullYear()} TalentaHub - Karya Mahasiswa Indonesia.</p>
        </div>
      </div>
    </footer>
  );
};