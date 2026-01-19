import React from 'react';

interface AvatarProps {
  src?: string;
  name: string;
  size?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '3xl';
  className?: string;
}

const sizeClasses = {
  sm: 'w-8 h-8 text-xs',
  md: 'w-10 h-10 text-sm',
  lg: 'w-14 h-14 text-lg',
  xl: 'w-16 h-16 text-xl',
  '2xl': 'w-24 h-24 text-3xl',
  '3xl': 'w-32 h-32 text-4xl',
};

export const Avatar: React.FC<AvatarProps> = ({ src, name, size = 'md', className = '' }) => {
  // If no name is provided, use 'User' to prevent crash on charAt
  const safeName = name || 'User';
  const initial = safeName.charAt(0).toUpperCase();

  return (
    <div className={`relative inline-block rounded-full overflow-hidden flex-shrink-0 ${sizeClasses[size]} ${className}`}>
      {src ? (
        <img 
          src={src} 
          alt={safeName} 
          className="w-full h-full object-cover"
          onError={(e) => {
            // Fallback if image fails to load: hide image and show background
            e.currentTarget.style.display = 'none';
            e.currentTarget.parentElement?.classList.add('bg-indigo-100');
          }}
        />
      ) : null}
      
      {/* Fallback Initials (Visible if no src, or if img is hidden via CSS/JS) */}
      <div className={`absolute inset-0 flex items-center justify-center font-bold bg-indigo-100 text-indigo-600 ${src ? '-z-10' : ''}`}>
        {initial}
      </div>
    </div>
  );
};
