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
          // Validate token with backend
          try {
            const response = await authAPI.validateToken();
            if (response.valid) {
              setUser(response.user);
            } else {
              // Token invalid, clear cookies
              clearAuthData();
            }
          } catch {
            // Token validation failed, clear cookies
            clearAuthData();
          }
        }
    } catch {
      console.error('Auth initialization error');
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

      // Store tokens and user data
      Cookies.set(TOKEN_KEY, response.accessToken, { 
        expires: credentials.rememberMe ? 30 : 1 // 30 days or 1 day
      });
      Cookies.set(REFRESH_TOKEN_KEY, response.refreshToken, { 
        expires: 7 // 7 days
      });
      Cookies.set(USER_KEY, JSON.stringify(response.user), { 
        expires: credentials.rememberMe ? 30 : 1
      });

      setUser(response.user);
      toast.success(`Welcome back, ${response.user.firstName}!`);
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
