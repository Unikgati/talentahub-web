import React from 'react';
import { Hero } from '../components/landing/Hero';
import { Features } from '../components/landing/Features';
import AppShowcase from '../components/landing/AppShowcase';
import { SupportSection } from '../components/landing/SupportSection';
import { CTA } from '../components/landing/CTA';

export const Landing: React.FC = () => {
  return (
    <div className="bg-white">
      <Hero />
      <AppShowcase />
      <Features />
      <SupportSection />
      <CTA />
    </div>
  );
};