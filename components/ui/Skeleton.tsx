import React from 'react';

// 1. Base Skeleton Primitive
interface SkeletonProps extends React.HTMLAttributes<HTMLDivElement> {
  className?: string;
}

export const Skeleton: React.FC<SkeletonProps> = ({ className, ...props }) => {
  return (
    <div 
      className={`animate-pulse bg-gray-200 rounded-md ${className || ''}`} 
      {...props} 
    />
  );
};

// 2. Job List Item Skeleton
export const JobCardSkeleton = () => {
    return (
        <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100 mb-4">
            <div className="flex flex-col md:flex-row justify-between gap-4">
                <div className="flex-1 space-y-3">
                    {/* Badge */}
                    <Skeleton className="h-5 w-20 rounded-full" />
                    {/* Title */}
                    <Skeleton className="h-7 w-3/4" />
                    {/* Client Name */}
                    <Skeleton className="h-4 w-1/3" />
                    {/* Description */}
                    <div className="space-y-2 pt-2">
                        <Skeleton className="h-4 w-full" />
                        <Skeleton className="h-4 w-5/6" />
                    </div>
                    {/* Tags */}
                    <div className="flex gap-2 pt-2">
                        <Skeleton className="h-6 w-16 rounded-md" />
                        <Skeleton className="h-6 w-16 rounded-md" />
                    </div>
                </div>
                <div className="flex flex-col items-start md:items-end justify-between min-w-[140px] gap-4">
                    <div className="w-full md:text-right space-y-2">
                        <Skeleton className="h-8 w-32 md:ml-auto" />
                        <Skeleton className="h-3 w-20 md:ml-auto" />
                    </div>
                    <Skeleton className="h-10 w-full md:w-32 rounded-lg" />
                </div>
            </div>
        </div>
    );
};

export const JobListSkeleton = () => (
    <div className="space-y-4">
        {[1, 2, 3].map((i) => <JobCardSkeleton key={i} />)}
    </div>
);

// 3. Talent Card Skeleton
export const TalentCardSkeleton = () => {
    return (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 flex flex-col h-full">
            <div className="flex items-center gap-4 mb-4">
                {/* Avatar */}
                <Skeleton className="w-16 h-16 rounded-full flex-shrink-0" />
                <div className="flex-1 space-y-2">
                    <Skeleton className="h-5 w-3/4" />
                    <Skeleton className="h-4 w-1/2" />
                    <Skeleton className="h-3 w-1/3" />
                </div>
            </div>
            
            <div className="flex-grow space-y-2 mb-4">
                <Skeleton className="h-4 w-full" />
                <Skeleton className="h-4 w-full" />
                <Skeleton className="h-4 w-2/3" />
            </div>

            <div className="flex gap-2 mb-4">
                <Skeleton className="h-6 w-14 rounded-md" />
                <Skeleton className="h-6 w-14 rounded-md" />
            </div>

            <Skeleton className="h-10 w-full rounded-lg mt-auto" />
        </div>
    );
};

export const TalentListSkeleton = () => (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {[1, 2, 3, 4, 5, 6].map((i) => <TalentCardSkeleton key={i} />)}
    </div>
);

// 4. Detail Page Skeleton (Shared for JobDetail & TalentDetail)
export const DetailSkeleton = () => {
    return (
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12 animate-fade-in">
            {/* Header Area */}
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 h-48 mb-8 p-8 flex flex-col justify-center space-y-4">
                <Skeleton className="h-8 w-1/2" />
                <div className="flex gap-4">
                    <Skeleton className="h-5 w-24 rounded-full" />
                    <Skeleton className="h-5 w-32" />
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                {/* Main Content */}
                <div className="md:col-span-2 space-y-8">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 space-y-4">
                        <Skeleton className="h-6 w-1/4 mb-4" />
                        <Skeleton className="h-4 w-full" />
                        <Skeleton className="h-4 w-full" />
                        <Skeleton className="h-4 w-5/6" />
                        <Skeleton className="h-4 w-full" />
                    </div>
                     <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 space-y-4">
                        <Skeleton className="h-6 w-1/3 mb-4" />
                        <div className="space-y-4">
                             {[1, 2].map(i => (
                                 <div key={i} className="flex gap-4">
                                     <Skeleton className="w-10 h-10 rounded-full" />
                                     <div className="flex-1 space-y-2">
                                         <Skeleton className="h-4 w-1/4" />
                                         <Skeleton className="h-3 w-full" />
                                     </div>
                                 </div>
                             ))}
                        </div>
                    </div>
                </div>

                {/* Sidebar */}
                <div className="md:col-span-1 space-y-6">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 space-y-4">
                        <Skeleton className="h-6 w-1/2" />
                        <Skeleton className="h-10 w-full rounded-lg" />
                        <Skeleton className="h-10 w-full rounded-lg" />
                    </div>
                </div>
            </div>
        </div>
    );
};