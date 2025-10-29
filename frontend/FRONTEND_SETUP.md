# Frontend Setup Guide

## Prerequisites
- Node.js 18+ 
- npm or yarn

## Installation

1. Install dependencies:
```bash
cd people-ops-system/frontend
npm install
```

2. Create environment file:
```bash
cp .env.example .env.local
```

3. Update `.env.local` with your configuration:
```
NEXT_PUBLIC_API_URL=http://localhost:4000
```

## Development

Start the development server:
```bash
npm run dev
```

The application will be available at `http://localhost:3000`

## Features Implemented

### Authentication System
- ✅ Login page with form validation
- ✅ Logout functionality
- ✅ Protected route wrapper
- ✅ Role-based UI rendering
- ✅ Unauthorized access page
- ✅ Password reset flow (basic)
- ✅ Authentication context and hooks
- ✅ Loading states and error handling

### UI Components
- ✅ Responsive design with Tailwind CSS
- ✅ Toast notifications
- ✅ Form validation with react-hook-form
- ✅ Loading spinners and states

### API Integration
- ✅ Axios client with interceptors
- ✅ Automatic token refresh
- ✅ Error handling
- ✅ Request/response logging

## Testing

The frontend integrates with the backend authentication system. Make sure the backend is running on port 4000 before testing the frontend.

### Test Credentials
- Email: `admin@example.com`
- Password: `password123`

## Next Steps

1. Install dependencies: `npm install`
2. Start development server: `npm run dev`
3. Test authentication flow
4. Implement additional business features
