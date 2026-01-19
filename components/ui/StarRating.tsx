
import React, { useState } from 'react';
import { Star } from 'lucide-react';

interface StarRatingProps {
  rating: number; // Current rating (0-5)
  maxRating?: number;
  onRatingChange?: (rating: number) => void;
  readonly?: boolean;
  size?: number;
  showValue?: boolean;
}

export const StarRating: React.FC<StarRatingProps> = ({
  rating,
  maxRating = 5,
  onRatingChange,
  readonly = false,
  size = 20,
  showValue = false
}) => {
  const [hoverRating, setHoverRating] = useState(0);

  const handleMouseEnter = (index: number) => {
    if (!readonly) setHoverRating(index);
  };

  const handleMouseLeave = () => {
    if (!readonly) setHoverRating(0);
  };

  const handleClick = (index: number) => {
    if (!readonly && onRatingChange) {
      onRatingChange(index);
    }
  };

  return (
    <div className="flex items-center gap-1">
      {[...Array(maxRating)].map((_, i) => {
        const starValue = i + 1;
        const isFilled = starValue <= (hoverRating || rating);
        
        return (
          <button
            key={i}
            type="button"
            className={`transition-transform ${!readonly ? 'hover:scale-110 cursor-pointer' : 'cursor-default'}`}
            onMouseEnter={() => handleMouseEnter(starValue)}
            onMouseLeave={handleMouseLeave}
            onClick={() => handleClick(starValue)}
            disabled={readonly}
          >
            <Star
              size={size}
              className={`${isFilled ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`}
            />
          </button>
        );
      })}
      {showValue && (
          <span className="ml-2 text-sm font-bold text-gray-700">{rating > 0 ? rating.toFixed(1) : '0.0'}</span>
      )}
    </div>
  );
};
