import React, { useState, useRef, useEffect } from 'react';
import { ChevronDown, Check, Eye, EyeOff } from 'lucide-react';

// Shared classes for consistency
export const inputClasses = "block w-full rounded-lg border border-gray-300 bg-white py-3 px-4 text-gray-900 shadow-sm placeholder:text-gray-400 transition-all focus:border-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-600/20 sm:text-sm disabled:bg-gray-100 disabled:text-gray-500";

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className = '', label, error, leftIcon, rightIcon, type = 'text', ...props }, ref) => {
    const [isPasswordVisible, setIsPasswordVisible] = useState(false);
    const isPasswordType = type === 'password';

    const inputType = isPasswordType ? (isPasswordVisible ? 'text' : 'password') : type;

    return (
      <div className="w-full">
        {label && (
          <label htmlFor={props.id} className="block text-sm font-medium text-gray-700 mb-1.5">
            {label}
          </label>
        )}
        <div className="relative">
            {leftIcon && (
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400">
                    {leftIcon}
                </div>
            )}
            
            <input
              ref={ref}
              type={inputType}
              className={`${inputClasses} ${leftIcon ? 'pl-10' : ''} ${rightIcon || isPasswordType ? 'pr-10' : ''} ${error ? 'border-red-300 text-red-900 placeholder-red-300 focus:border-red-500 focus:ring-red-500' : ''} ${className}`}
              {...props}
            />
            
            {/* Handle Right Icon OR Password Toggle */}
            {(rightIcon || isPasswordType) && (
                 <div className="absolute inset-y-0 right-0 pr-3 flex items-center">
                    {isPasswordType ? (
                        <button
                            type="button"
                            onClick={() => setIsPasswordVisible(!isPasswordVisible)}
                            className="text-gray-400 hover:text-gray-600 focus:outline-none cursor-pointer"
                            tabIndex={-1} // Skip tab focus
                        >
                            {isPasswordVisible ? <EyeOff size={18} /> : <Eye size={18} />}
                        </button>
                    ) : (
                        <div className="pointer-events-none text-gray-400">
                            {rightIcon}
                        </div>
                    )}
                </div>
            )}
        </div>
        {error && <p className="mt-1 text-sm text-red-600">{error}</p>}
      </div>
    );
  }
);
Input.displayName = 'Input';

interface TextAreaProps extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {
  label?: string;
  error?: string;
}

export const TextArea = React.forwardRef<HTMLTextAreaElement, TextAreaProps>(
  ({ className = '', label, error, ...props }, ref) => {
    return (
      <div className="w-full">
        {label && (
          <label htmlFor={props.id} className="block text-sm font-medium text-gray-700 mb-1.5">
            {label}
          </label>
        )}
        <textarea
          ref={ref}
          className={`${inputClasses} ${error ? 'border-red-300 text-red-900 placeholder-red-300 focus:border-red-500 focus:ring-red-500' : ''} ${className}`}
          {...props}
        />
        {error && <p className="mt-1 text-sm text-red-600">{error}</p>}
      </div>
    );
  }
);
TextArea.displayName = 'TextArea';

// --- CUSTOM SELECT COMPONENT ---

interface SelectOption {
  value: string;
  label: string;
}

interface SelectProps {
  label?: string;
  error?: string;
  options: SelectOption[];
  value: string;
  onChange: (value: string) => void; // Custom Select returns value directly
  placeholder?: string;
  leftIcon?: React.ReactNode;
  className?: string;
  id?: string;
}

export const Select: React.FC<SelectProps> = ({ 
  label, 
  error, 
  options, 
  value, 
  onChange, 
  placeholder = "Pilih opsi...", 
  leftIcon, 
  className = '',
  id
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  const selectedOption = options.find(opt => opt.value === value);

  const handleSelect = (optionValue: string) => {
    onChange(optionValue);
    setIsOpen(false);
  };

  return (
    <div className={`w-full ${className}`} ref={containerRef}>
      {label && (
        <label htmlFor={id} className="block text-sm font-medium text-gray-700 mb-1.5">
          {label}
        </label>
      )}
      <div className="relative">
        <button
          type="button"
          onClick={() => setIsOpen(!isOpen)}
          className={`
            ${inputClasses} 
            flex items-center justify-between text-left cursor-pointer
            ${leftIcon ? 'pl-10' : ''}
            ${error ? 'border-red-300 text-red-900 focus:border-red-500 focus:ring-red-500' : ''}
            ${!selectedOption ? 'text-gray-500' : ''}
          `}
        >
          {leftIcon && (
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-gray-400">
              {leftIcon}
            </div>
          )}
          
          <span className="truncate">
            {selectedOption ? selectedOption.label : placeholder}
          </span>
          
          <ChevronDown 
            size={18} 
            className={`text-gray-400 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} 
          />
        </button>

        {isOpen && (
          <div className="absolute z-50 mt-1 w-full bg-white rounded-lg shadow-lg border border-gray-100 py-1 animate-fade-in max-h-60 overflow-auto">
             {placeholder && !value && (
                <div className="px-4 py-2 text-sm text-gray-400 italic border-b border-gray-50">
                  {placeholder}
                </div>
             )}
             {options.map((option) => (
               <div
                 key={option.value}
                 onClick={() => handleSelect(option.value)}
                 className={`
                   px-4 py-2.5 text-sm cursor-pointer flex items-center justify-between transition-colors
                   ${value === option.value ? 'bg-indigo-50 text-indigo-700 font-medium' : 'text-gray-700 hover:bg-gray-50'}
                 `}
               >
                 {option.label}
                 {value === option.value && <Check size={16} className="text-indigo-600" />}
               </div>
             ))}
             {options.length === 0 && (
               <div className="px-4 py-3 text-sm text-gray-500 text-center">
                 Tidak ada opsi.
               </div>
             )}
          </div>
        )}
      </div>
      {error && <p className="mt-1 text-sm text-red-600">{error}</p>}
    </div>
  );
};