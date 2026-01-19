import React, { Suspense } from 'react';
import { HashRouter as Router, Routes, Route } from 'react-router-dom';
import { Layout } from './components/Layout';
import ScrollToTop from './components/ScrollToTop';
import { LoadingScreen } from './components/Loading';
import { ErrorBoundary } from './components/ErrorBoundary';

// LAZY LOADING (Code Splitting) - Static Pages Only
const Landing = React.lazy(() => import('./pages/Landing').then(module => ({ default: module.Landing })));
const HowItWorks = React.lazy(() => import('./pages/HowItWorks'));
const Help = React.lazy(() => import('./pages/Help'));
const Privacy = React.lazy(() => import('./pages/Privacy'));
const NotFound = React.lazy(() => import('./pages/NotFound'));

const App: React.FC = () => {
  return (
    <ErrorBoundary>
      <Router>
        <ScrollToTop />
        <Suspense fallback={<LoadingScreen />}>
          <Routes>
            {/* All routes use standard Layout */}
            <Route element={<Layout />}>
              <Route path="/" element={<Landing />} />
              <Route path="/how-it-works" element={<HowItWorks />} />
              <Route path="/help" element={<Help />} />
              <Route path="/privacy" element={<Privacy />} />
              <Route path="*" element={<NotFound />} />
            </Route>
          </Routes>
        </Suspense>
      </Router>
    </ErrorBoundary>
  );
};

export default App;