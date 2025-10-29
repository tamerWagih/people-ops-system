'use client';

import React, { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import Cookies from 'js-cookie';
import { toast } from 'react-hot-toast';
import { authAPI } from '../lib/api';
import { AuthContextType, User, LoginRequest, TOKEN_KEY, REFRESH_TOKEN_KEY, USER_KEY } from '../types/auth';

const AuthContext = createContext<AuthContextType | undefined>(undefined);

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const isAuthenticated = !!user;

  // Initialize auth state
  useEffect(() => {
    const initializeAuth = async () => {
      try {
        const token = Cookies.get(TOKEN_KEY);
        const userData = Cookies.get(USER_KEY);

        if (token && userData) {
          try {
            // Parse stored user data as fallback
            const storedUser = JSON.parse(userData);
            
            // Debug: Log stored user data
            console.log('Stored user data on init:', storedUser);
            
            // First, set the stored user data immediately to avoid loading states
            setUser(storedUser);
            
            // Then try to validate token with backend in the background
            try {
              const response = await authAPI.validateToken();
              if (response.valid && response.user) {
                // Update with fresh data from backend
                console.log('Token validation successful, updating with fresh data:', response.user);
                setUser(response.user);
                // Update stored data with fresh data
                Cookies.set(USER_KEY, JSON.stringify(response.user), { 
                  expires: 30 // 30 days
                });
              } else {
                // Token invalid, keep using stored data
                console.log('Token validation failed, using stored user data');
              }
            } catch (error) {
              // Backend validation failed, keep using stored data
              console.log('Backend validation failed, using stored user data:', error);
            }
          } catch (error) {
            // Stored data is invalid, clear everything
            console.log('Stored user data is invalid, clearing auth data:', error);
            clearAuthData();
          }
        } else {
          // No token or user data, clear everything
          console.log('No token or user data found, clearing auth data');
          clearAuthData();
        }
      } catch (error) {
        console.error('Auth initialization error:', error);
        clearAuthData();
      } finally {
        setIsLoading(false);
      }
    };

    initializeAuth();
  }, []);

  const clearAuthData = () => {
    Cookies.remove(TOKEN_KEY);
    Cookies.remove(REFRESH_TOKEN_KEY);
    Cookies.remove(USER_KEY);
    setUser(null);
  };

  const login = async (credentials: LoginRequest) => {
    try {
      setIsLoading(true);
      const response = await authAPI.login(credentials);

      // Ensure user data has all required fields
      const userData = {
        id: response.user.id,
        email: response.user.email,
        firstName: response.user.firstName,
        lastName: response.user.lastName,
        roles: response.user.roles || [],
      };

      // Debug: Log the user data being stored
      console.log('Storing user data:', userData);

      // Store tokens and user data with proper cookie settings
      const cookieOptions = {
        expires: credentials.rememberMe ? 30 : 1, // 30 days or 1 day
        path: '/',
        sameSite: 'lax' as const,
        secure: typeof window !== 'undefined' && (window as any).location.protocol === 'https:',
      };

      Cookies.set(TOKEN_KEY, response.accessToken, cookieOptions);
      Cookies.set(REFRESH_TOKEN_KEY, response.refreshToken, cookieOptions);
      Cookies.set(USER_KEY, JSON.stringify(userData), cookieOptions);

      setUser(userData);
      toast.success(`Welcome back, ${userData.firstName}!`);
    } catch (error: any) {
      const errorMessage = error.response?.data?.message || 'Login failed';
      toast.error(errorMessage);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const logout = async () => {
    try {
      await authAPI.logout();
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      clearAuthData();
      toast.success('Logged out successfully');
    }
  };

  const refreshToken = async () => {
    try {
      const refreshTokenValue = Cookies.get(REFRESH_TOKEN_KEY);
      if (!refreshTokenValue) {
        throw new Error('No refresh token available');
      }

      const response = await authAPI.refreshToken(refreshTokenValue);
      Cookies.set(TOKEN_KEY, response.accessToken);
    } catch (error) {
      console.error('Token refresh error:', error);
      clearAuthData();
      throw error;
    }
  };

  const value: AuthContextType = {
    user,
    isAuthenticated,
    isLoading,
    login,
    logout,
    refreshToken,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
