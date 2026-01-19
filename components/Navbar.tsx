import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Menu, X, HelpCircle, BookOpen, Download, Shield } from 'lucide-react';

export const Navbar: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const location = useLocation();

  const closeMenu = () => setIsMenuOpen(false);

  const isActive = (path: string) => location.pathname === path;

  // Prevent body scroll when drawer is open
  useEffect(() => {
    if (isMenuOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'unset';
    }
    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [isMenuOpen]);

  const NavLink = ({ to, children, icon }: { to: string; children: React.ReactNode; icon?: React.ReactNode }) => (
    <Link
      to={to}
      onClick={closeMenu}
      className={`flex items-center gap-2 px-3 py-2 text-sm font-medium transition-colors ${isActive(to)
        ? 'text-indigo-600'
        : 'text-gray-500 hover:text-indigo-600'
        }`}
    >
      {icon}
      {children}
    </Link>
  );

  return (
    <>
      <nav className="bg-white/80 backdrop-blur-md border-b border-gray-100 fixed w-full top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            {/* Logo */}
            <div className="flex items-center">
              <Link to="/" className="flex-shrink-0 flex items-center" onClick={closeMenu}>
                <span className="font-bold text-xl tracking-tight text-gray-900">TalentaHub</span>
              </Link>

              {/* Desktop Navigation */}
              <div className="hidden md:ml-10 md:flex md:space-x-4">
                <NavLink to="/how-it-works" icon={<BookOpen size={16} />}>Cara Kerja</NavLink>
                <NavLink to="/help" icon={<HelpCircle size={16} />}>Bantuan</NavLink>
                <NavLink to="/privacy" icon={<Shield size={16} />}>Kebijakan</NavLink>
              </div>
            </div>

            {/* Desktop CTA */}
            <div className="hidden md:flex items-center">
              <a
                href="https://github.com/Unikgati/talentahub-v.1.0.0/releases/download/TalentHub_Android_Release/TalentaHub_Android_v1.0.0_release.apk"
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-2 bg-gray-900 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-gray-800 transition shadow-sm"
              >
                <Download size={16} />
                Download App
              </a>
            </div>

            {/* Mobile Menu Button */}
            <div className="flex items-center md:hidden">
              <button
                onClick={() => setIsMenuOpen(!isMenuOpen)}
                className="text-gray-500 hover:text-gray-900 focus:outline-none p-2"
              >
                {isMenuOpen ? <X size={24} /> : <Menu size={24} />}
              </button>
            </div>
          </div>
        </div>
      </nav>

      {/* Mobile Drawer Overlay */}
      <div
        className={`fixed inset-0 bg-black/50 z-40 md:hidden transition-opacity duration-300 ${isMenuOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'
          }`}
        onClick={closeMenu}
      />

      {/* Mobile Drawer */}
      <div
        className={`fixed top-0 right-0 h-full w-72 bg-white z-50 shadow-2xl md:hidden transform transition-transform duration-300 ease-out ${isMenuOpen ? 'translate-x-0' : 'translate-x-full'
          }`}
      >
        {/* Drawer Header */}
        <div className="flex items-center justify-between px-4 h-16 border-b border-gray-100">
          <span className="font-bold text-lg text-gray-900">Menu</span>
          <button
            onClick={closeMenu}
            className="p-2 text-gray-500 hover:text-gray-900"
          >
            <X size={24} />
          </button>
        </div>

        {/* Drawer Content */}
        <div className="px-4 py-6 space-y-2">
          <Link
            to="/how-it-works"
            onClick={closeMenu}
            className={`flex items-center gap-3 px-4 py-3 rounded-lg text-base font-medium transition-colors ${isActive('/how-it-works')
              ? 'bg-indigo-50 text-indigo-600'
              : 'text-gray-700 hover:bg-gray-50'
              }`}
          >
            <BookOpen size={20} className={isActive('/how-it-works') ? 'text-indigo-600' : 'text-gray-400'} />
            Cara Kerja
          </Link>

          <Link
            to="/help"
            onClick={closeMenu}
            className={`flex items-center gap-3 px-4 py-3 rounded-lg text-base font-medium transition-colors ${isActive('/help')
              ? 'bg-indigo-50 text-indigo-600'
              : 'text-gray-700 hover:bg-gray-50'
              }`}
          >
            <HelpCircle size={20} className={isActive('/help') ? 'text-indigo-600' : 'text-gray-400'} />
            Pusat Bantuan
          </Link>

          <Link
            to="/privacy"
            onClick={closeMenu}
            className={`flex items-center gap-3 px-4 py-3 rounded-lg text-base font-medium transition-colors ${isActive('/privacy')
              ? 'bg-indigo-50 text-indigo-600'
              : 'text-gray-700 hover:bg-gray-50'
              }`}
          >
            <Shield size={20} className={isActive('/privacy') ? 'text-indigo-600' : 'text-gray-400'} />
            Kebijakan Privasi
          </Link>

          <div className="border-t border-gray-100 my-4 pt-4">
            <a
              href="https://play.google.com/store/apps/details?id=com.talentahub.app"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center justify-center gap-2 w-full px-4 py-3 rounded-lg text-base font-medium bg-indigo-600 text-white hover:bg-indigo-700 transition-colors"
            >
              <Download size={18} />
              Download App
            </a>
          </div>
        </div>
      </div>
    </>
  );
};