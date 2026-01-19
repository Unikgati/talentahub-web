/**
 * Input Sanitization Utilities
 * 
 * SECURITY FIX: Prevents XSS attacks by sanitizing user input
 * before storing in database or displaying in UI.
 */

import DOMPurify from 'dompurify';

/**
 * Strips ALL HTML tags from input.
 * Use for fields like: name, location, skills, etc.
 */
export const sanitizeInput = (dirty: string): string => {
    if (!dirty) return '';

    return DOMPurify.sanitize(dirty, {
        ALLOWED_TAGS: [],
        ALLOWED_ATTR: []
    }).trim();
};

/**
 * Allows limited safe HTML tags.
 * Use for fields that may contain basic formatting: bio, descriptions.
 */
export const sanitizeRichText = (dirty: string): string => {
    if (!dirty) return '';

    return DOMPurify.sanitize(dirty, {
        ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'br', 'p'],
        ALLOWED_ATTR: []
    });
};

/**
 * Sanitizes object properties recursively.
 * Use for sanitizing entire form data objects.
 */
export const sanitizeObject = <T extends Record<string, unknown>>(
    obj: T,
    richTextFields: string[] = []
): T => {
    const result: Record<string, unknown> = { ...obj };

    for (const key of Object.keys(result)) {
        const value = result[key];

        if (typeof value === 'string') {
            // Use rich text sanitization for specified fields
            if (richTextFields.includes(key)) {
                result[key] = sanitizeRichText(value);
            } else {
                result[key] = sanitizeInput(value);
            }
        } else if (Array.isArray(value)) {
            // Sanitize string arrays (like skills)
            result[key] = value.map(item =>
                typeof item === 'string' ? sanitizeInput(item) : item
            );
        }
        // Skip non-string, non-array values (numbers, booleans, objects)
    }

    return result as T;
};
