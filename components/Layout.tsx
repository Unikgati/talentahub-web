import React from 'react';
import { Outlet } from 'react-router-dom';
import { Navbar } from './Navbar';
import { Footer } from './Footer';

export const Layout: React.FC<{ children?: React.ReactNode }> = ({ children }) => {
  return (
    <div className="min-h-screen flex flex-col bg-slate-50">
      <Navbar />
      <main className="flex-grow pt-16">
        {/* Render children if provided (backward compatibility), otherwise use Outlet (Router v6 standard) */}
        {children ? children : <Outlet />}
      </main>
      <Footer />
    </div>
  );
};
