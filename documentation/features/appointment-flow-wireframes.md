# Appointment Flow - UI Wireframes & Visual Guide

## Overview
This document provides visual wireframes and UI flow for the Create Appointment feature, complementing the detailed feature documentation. The design follows a light, minimal aesthetic with clear visual hierarchy.

## Screen Flow Progression

### 1. Service Selection → 2. Staff Selection → 3. Date/Time → 4. Customer Info → 5. Summary → 6. Payment → 7. Confirmation

---

## Wireframe Specifications

### Visual Design Principles
- **Minimalist Layout**: Clean backgrounds with focused content areas
- **Consistent Spacing**: 16px base unit for margins and padding
- **Typography Hierarchy**: Clear distinction between headers, body, and actions
- **Color Usage**: Subtle orange accent (#FF8C42) for primary actions
- **Card Design**: Elevated cards with subtle shadows for content grouping

### Screen Dimensions
- **Mobile**: 375x812 (iPhone standard)
- **Safe Areas**: Respect notch and home indicator
- **Touch Targets**: Minimum 44pt for all interactive elements
- **Content Width**: Max 343px with 16px side margins

---

## Key UI Patterns

### Navigation Pattern
```
┌─────────────────────────────────┐
│ [← Back]      Step Title      ● │  ← Progress indicator
│                                 │
│                                 │
│          Main Content           │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│           [Primary CTA]         │  ← Always visible primary action
└─────────────────────────────────┘
```

### Card Component Pattern
```
┌─────────────────────────────────┐
│ ┌─────────────────────────────┐ │
│ │ 🖼️  Title               ⭐ │ │  ← Image/Icon + Title + Rating
│ │     Subtitle/Description    │ │
│ │     $Price • Duration       │ │  ← Price and time info
│ │                    [Action] │ │  ← Right-aligned action
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

### Form Field Pattern
```
┌─────────────────────────────────┐
│ Field Label                     │
│ ┌─────────────────────────────┐ │
│ │ [User Input Here         ] │ │  ← Input field with placeholder
│ └─────────────────────────────┘ │
│ ℹ️ Helper text or validation    │  ← Optional helper/error text
└─────────────────────────────────┘
```

---

## Screen-by-Screen Breakdown

### Service Selection Screen
**Purpose**: Choose service type and view pricing

**Key Elements**:
- Categorized service listing
- Price and duration display
- Popular service indicators
- Search functionality
- Clear selection states

**Visual Hierarchy**:
1. Navigation header with back button
2. Search bar (if many services)
3. Service categories/filters
4. Service cards with clear pricing
5. Selection buttons

### Staff Selection Screen
**Purpose**: Choose preferred specialist or any available

**Key Elements**:
- "Any Available" prominent option
- Staff photos and ratings
- Availability indicators
- Specialty tags
- Quick bio preview

**Visual Hierarchy**:
1. Navigation header
2. "Any Available" hero option
3. "Our Team" section header
4. Staff cards with photos
5. Selection actions

### Date & Time Selection Screen
**Purpose**: Pick appointment date and time

**Key Elements**:
- "Next Available" quick option
- Clean calendar design
- Available time slots
- Clear selection feedback
- Unavailable dates grayed out

**Visual Hierarchy**:
1. Navigation header
2. "Next Available" hero card
3. Month/year calendar navigation
4. Calendar grid with availability
5. Time slot selection
6. Continue button

### Customer Information Screen
**Purpose**: Collect necessary booking details

**Key Elements**:
- Minimal required fields
- Smart keyboard types
- Auto-fill from profile
- Optional account creation
- Guest checkout option

**Visual Hierarchy**:
1. Navigation header
2. Form title
3. Input fields (logical order)
4. Optional fields clearly marked
5. Save preferences toggle
6. Continue button

### Booking Summary Screen
**Purpose**: Review all booking details before payment

**Key Elements**:
- Editable summary sections
- Clear pricing breakdown
- Terms and conditions
- Confidence-building elements
- Edit options for each section

**Visual Hierarchy**:
1. Navigation header
2. Provider information card
3. Service details card
4. Date/time card
5. Customer info card
6. Pricing breakdown
7. Terms agreement
8. Confirm booking button

### Payment Screen
**Purpose**: Secure payment processing

**Key Elements**:
- Multiple payment methods
- Saved payment options
- Security indicators
- Clear total amount
- Pay later options

**Visual Hierarchy**:
1. Navigation header
2. Total amount display
3. Payment method selection
4. Security badges
5. Payment button

### Confirmation Screen
**Purpose**: Confirm successful booking

**Key Elements**:
- Success indicator
- Booking reference number
- Complete appointment details
- Next steps information
- Quick actions (calendar, share)

**Visual Hierarchy**:
1. Success icon and message
2. Booking reference
3. Appointment details card
4. Quick action buttons
5. Next steps list
6. Navigation options

---

## Responsive Design Considerations

### Mobile-First Approach
- Single column layout
- Touch-friendly spacing
- Readable font sizes
- Appropriate contrast ratios

### Tablet Adaptations
- Wider content areas
- Side-by-side layouts where appropriate
- Larger touch targets
- Enhanced visual hierarchy

### Accessibility Features
- Screen reader support
- High contrast mode
- Large text compatibility
- Voice input support

---

## Animation & Transitions

### Page Transitions
- **Slide Right**: Forward navigation
- **Slide Left**: Back navigation
- **Fade**: Modal presentations
- **Scale**: Success confirmations

### Micro-Interactions
- **Button Press**: Subtle scale down (0.98)
- **Card Selection**: Gentle highlight
- **Form Focus**: Smooth border color change
- **Loading States**: Skeleton screens

### Duration Standards
- **Page Transitions**: 300ms ease-out
- **Button Feedback**: 150ms ease-in-out
- **Form Interactions**: 200ms ease-out
- **Success Animations**: 500ms ease-out

---

## Component States

### Interactive Elements
- **Default**: Normal appearance
- **Hover**: Subtle highlight (web)
- **Pressed**: Scale down slightly
- **Disabled**: Reduced opacity (0.5)
- **Loading**: Spinner or skeleton

### Form Fields
- **Default**: Light border
- **Focus**: Primary color border
- **Filled**: Slightly darker background
- **Error**: Red border with error text
- **Success**: Green border with check

### Cards
- **Default**: White background, subtle shadow
- **Selected**: Primary color border
- **Disabled**: Grayed out content
- **Loading**: Skeleton placeholder

---

## Error Handling UI

### Error States
- **Network Error**: Retry button with clear message
- **Validation Error**: Inline field-level errors
- **Payment Error**: Alternative options suggested
- **Booking Conflict**: Alternative times offered

### Success States
- **Step Completion**: Subtle check marks
- **Form Submission**: Loading indicators
- **Payment Success**: Clear confirmation
- **Booking Confirmed**: Celebration animation

---

## Design System Integration

### Spacing Scale
- **XS**: 4px
- **S**: 8px
- **M**: 16px (base unit)
- **L**: 24px
- **XL**: 32px
- **XXL**: 48px

### Border Radius
- **Small**: 4px (form fields)
- **Medium**: 8px (cards)
- **Large**: 12px (buttons)
- **Round**: 50% (profile images)

### Shadow Levels
- **Level 1**: Subtle card elevation
- **Level 2**: Modal/overlay shadows
- **Level 3**: Floating action buttons

---

## Platform-Specific Considerations

### iOS Design Patterns
- Native navigation bar styling
- iOS-style form fields
- Apple Pay integration UI
- Haptic feedback patterns

### Android Design Patterns
- Material Design components
- Android navigation patterns
- Google Pay integration
- Android-specific interactions

---

## Implementation Notes

### Flutter Widgets
- **Scaffold**: Screen structure
- **AppBar**: Navigation headers
- **Card**: Content grouping
- **TextFormField**: Form inputs
- **ElevatedButton**: Primary actions
- **OutlinedButton**: Secondary actions

### State Management
- **BlocBuilder**: UI state updates
- **StreamBuilder**: Real-time data
- **FutureBuilder**: Async operations
- **AnimatedBuilder**: Smooth transitions

---

## Testing Considerations

### UI Testing
- Widget testing for components
- Integration testing for flows
- Golden file testing for consistency
- Accessibility testing

### User Testing
- Task completion rates
- Time to completion
- Error recovery
- User satisfaction

---

This wireframe guide provides the visual foundation for implementing the Create Appointment Flow with a focus on clean, minimal design that prioritizes user experience and accessibility. 