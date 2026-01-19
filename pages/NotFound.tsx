import React from 'react';
import { Link } from 'react-router-dom';
import { Home, ArrowLeft } from 'lucide-react';
import { Button } from '../components/ui/Button';

const NotFound: React.FC = () => {
    return (
        <div className="min-h-[80vh] flex flex-col items-center justify-center px-4 text-center">
            <h1 className="text-9xl font-extrabold text-indigo-100">404</h1>
            <div className="absolute">
                <div className="text-2xl font-bold text-gray-900 mb-2">Halaman Tidak Ditemukan</div>
            </div>
            
            <p className="text-gray-500 max-w-md mb-8 mt-4">
                Maaf, halaman yang Anda cari mungkin telah dihapus, dipindahkan, atau tidak tersedia sementara.
            </p>
            
            <div className="flex gap-4">
                <Link to="/">
                    <Button variant="outline" icon={<ArrowLeft size={18} />}>
                        Kembali
                    </Button>
                </Link>
                <Link to="/">
                    <Button icon={<Home size={18} />}>
                        Ke Beranda
                    </Button>
                </Link>
            </div>
        </div>
    );
};

export default NotFound;