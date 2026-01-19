import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

console.log('TalentaHub App Initializing...');

try {
  const rootElement = document.getElementById('root');
  if (!rootElement) {
    throw new Error("Could not find root element to mount to");
  }

  const root = ReactDOM.createRoot(rootElement);
  root.render(
    <React.StrictMode>
      <App />
    </React.StrictMode>
  );
} catch (error) {
  console.error("Application crashed during mount:", error);
  // Show error on screen instead of blank white page
  document.body.innerHTML = `
    <div style="padding: 20px; font-family: sans-serif; color: #b91c1c; background: #fef2f2; height: 100vh; display: flex; flex-direction: column; justify-content: center; items-center; text-align: center;">
      <h1 style="margin-bottom: 10px;">Gagal Memuat Aplikasi</h1>
      <p style="color: #4b5563; margin-bottom: 20px;">Terjadi kesalahan saat inisialisasi. Silakan refresh halaman atau hubungi developer.</p>
      <pre style="background: #fff; padding: 15px; border-radius: 8px; border: 1px solid #fee2e2; overflow: auto; max-width: 800px; text-align: left;">${error instanceof Error ? error.message : String(error)}</pre>
    </div>
  `;
}