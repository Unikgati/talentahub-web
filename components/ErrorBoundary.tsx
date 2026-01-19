import React, { Component, ErrorInfo, ReactNode } from 'react';
import { AlertTriangle, RefreshCw } from 'lucide-react';
import { Button } from './ui/Button';

interface ErrorBoundaryProps {
  children?: ReactNode;
}

interface ErrorBoundaryState {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<ErrorBoundaryProps, ErrorBoundaryState> {
  public readonly props: Readonly<ErrorBoundaryProps>;

  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.props = props;
    this.state = {
      hasError: false,
      error: null
    };
  }

  public state: ErrorBoundaryState;

  public static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Uncaught error:', error, errorInfo);
  }

  private handleReload = () => {
    window.location.reload();
  };

  public render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen flex items-center justify-center bg-gray-50 px-4">
          <div className="max-w-md w-full bg-white rounded-xl shadow-lg p-8 text-center border border-gray-100">
            <div className="w-16 h-16 bg-red-100 text-red-600 rounded-full flex items-center justify-center mx-auto mb-6">
              <AlertTriangle size={32} />
            </div>
            <h1 className="text-2xl font-bold text-gray-900 mb-2">Terjadi Kesalahan</h1>
            <p className="text-gray-500 mb-6">
              Maaf, aplikasi mengalami kendala teknis. Tim kami telah dinotifikasi. Silakan coba muat ulang halaman.
            </p>
            <div className="bg-gray-50 p-3 rounded-lg text-left text-xs font-mono text-gray-600 mb-6 overflow-auto max-h-32">
                {this.state.error?.message}
            </div>
            <Button onClick={this.handleReload} icon={<RefreshCw size={18} />} className="w-full">
              Muat Ulang Aplikasi
            </Button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}